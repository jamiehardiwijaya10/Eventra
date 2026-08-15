import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

Deno.serve(async (req) => {

  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: corsHeaders,
    });
  }

  try {

    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const supabaseAnonKey = Deno.env.get("SUPABASE_ANON_KEY");
    const supabaseServiceRoleKey =
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    const midtransServerKey =
      Deno.env.get("MIDTRANS_SERVER_KEY");

    if (!supabaseUrl ||
        !supabaseAnonKey ||
        !supabaseServiceRoleKey) {
      throw new Error(
        "Supabase environment variables are missing.",
      );
    }

    if (!midtransServerKey) {
      throw new Error(
        "MIDTRANS_SERVER_KEY is not configured.",
      );
    }

    const authorization =
        req.headers.get("Authorization");

    if (!authorization) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Authorization header is required.",
        }),
        {
          status: 401,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    const supabaseUser = createClient(
      supabaseUrl,
      supabaseAnonKey,
      {
        global: {
          headers: {
            Authorization: authorization,
          },
        },
      },
    );

    const {
      data: { user },
      error: userError,
    } = await supabaseUser.auth.getUser();

    if (userError || !user) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Unauthorized.",
        }),
        {
          status: 401,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    const supabaseAdmin = createClient(
      supabaseUrl,
      supabaseServiceRoleKey,
    );

    const body = await req.json();

    const orderId =
      body.orderId?.toString();

    if (!orderId) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "orderId is required.",
        }),
        {
          status: 400,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    const {
      data: order,
      error: orderError,
    } = await supabaseAdmin
      .from("orders")
      .select(
        "id, user_id, event_id, order_number, total_amount, payment_status, payment_method, midtrans_order_id",
      )
      .eq("id", orderId)
      .single();

    if (orderError || !order) {
      throw new Error(
        `Order not found: ${
          orderError?.message ?? "unknown error"
        }`,
      );
    }

    if (order.user_id !== user.id) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "You do not own this order.",
        }),
        {
          status: 403,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    if (
      order.payment_status === "paid"
    ) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "This order has already been paid.",
        }),
        {
          status: 400,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    const {
      data: orderItems,
      error: itemsError,
    } = await supabaseAdmin
      .from("order_items")
      .select(
        "id, ticket_type_id, quantity, price, subtotal",
      )
      .eq("order_id", orderId);

    if (itemsError) {
      throw new Error(
        `Failed to get order items: ${itemsError.message}`,
      );
    }

    if (!orderItems ||
        orderItems.length === 0) {
      throw new Error(
        "Order has no items.",
      );
    }

    const ticketTypeIds =
      orderItems.map(
        (item) => item.ticket_type_id,
      );

    const {
      data: ticketTypes,
      error: ticketError,
    } = await supabaseAdmin
      .from("ticket_types")
      .select("id, name")
      .in("id", ticketTypeIds);

    if (ticketError) {
      throw new Error(
        `Failed to get ticket types: ${ticketError.message}`,
      );
    }

    const itemDetails =
      orderItems.map((item) => {
        const ticket =
          ticketTypes?.find(
            (t) =>
              t.id === item.ticket_type_id,
          );

        return {
          id: item.ticket_type_id,
          price: Number(item.price),
          quantity: Number(item.quantity),
          name:
            ticket?.name ??
            "Event Ticket",
        };
      });

    const grossAmount =
      Number(order.total_amount);

    if (
      !Number.isFinite(grossAmount) ||
      grossAmount <= 0
    ) {
      throw new Error(
        "Invalid order total amount.",
      );
    }

    const midtransOrderId =
      order.midtrans_order_id ??
      order.order_number ??
      order.id;

    const calculatedTotal = itemDetails.reduce(
      (sum, item) => sum + item.price * item.quantity,
      0,
    );

    if (calculatedTotal !== grossAmount) {
      throw new Error(
        `Order total mismatch. Expected ${calculatedTotal}, got ${grossAmount}.`,
      );
    }

    const paymentReturnUrl =
      `https://eventra-payment-web-2.vercel.app/?order_id=${encodeURIComponent(order.id)}`;

    const midtransPayload = {
      transaction_details: {
        order_id: midtransOrderId,
        gross_amount: grossAmount,
      },

      item_details: itemDetails,

      callbacks: {
        finish: paymentReturnUrl,
        unfinish: paymentReturnUrl,
        error: paymentReturnUrl,
      },
    };

    const authHeader =
      "Basic " +
      btoa(`${midtransServerKey}:`);

    console.log(
      "MIDTRANS PAYLOAD:",
      JSON.stringify(midtransPayload),
    );

    const midtransResponse =
      await fetch(
        "https://app.sandbox.midtrans.com/snap/v1/transactions",
        {
          method: "POST",

          headers: {
            "Content-Type":
              "application/json",

            Authorization:
              authHeader,
          },

          body:
            JSON.stringify(
              midtransPayload,
            ),
        },
      );

    const midtransData =
      await midtransResponse.json();

    if (!midtransResponse.ok) {
      console.error(
        "Midtrans response:",
        midtransData,
      );

      throw new Error(
        midtransData.status_message ??
          midtransData.error_messages?.join(
            ", ",
          ) ??
          "Failed to create Midtrans transaction.",
      );
    }

    const {
      error: updateError,
    } = await supabaseAdmin
      .from("orders")
      .update({
        payment_status: "pending",
        payment_method: "midtrans",
        midtrans_order_id:
          midtransOrderId,
        updated_at:
          new Date().toISOString(),
      })
      .eq("id", orderId);

    if (updateError) {
      throw new Error(
        `Failed to update order: ${updateError.message}`,
      );
    }

    return new Response(
      JSON.stringify({
        success: true,

        orderId: order.id,

        orderNumber:
          order.order_number,

        midtransOrderId:
          midtransOrderId,

        token:
          midtransData.token,

        redirectUrl:
          midtransData.redirect_url,
      }),
      {
        status: 200,

        headers: {
          ...corsHeaders,
          "Content-Type":
            "application/json",
        },
      },
    );
  } catch (error) {
    console.error(
      "create-midtrans-payment error:",
      error,
    );

    return new Response(
      JSON.stringify({
        success: false,

        error:
          error instanceof Error
            ? error.message
            : "Unknown error.",
      }),
      {
        status: 500,

        headers: {
          ...corsHeaders,
          "Content-Type":
            "application/json",
        },
      },
    );
  }
});
