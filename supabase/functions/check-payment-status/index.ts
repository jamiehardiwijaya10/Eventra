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
        "id, user_id, payment_status, midtrans_order_id",
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

    if (order.payment_status === "paid") {
      return new Response(
        JSON.stringify({
          success: true,
          paid: true,
          status: "settlement",
        }),
        {
          status: 200,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    const midtransOrderId =
        order.midtrans_order_id;

    if (!midtransOrderId) {
      throw new Error(
        "Midtrans order ID is missing.",
      );
    }

    const authHeader =
      "Basic " +
      btoa(`${midtransServerKey}:`);

    const midtransResponse =
      await fetch(
        `https://api.sandbox.midtrans.com/v2/${encodeURIComponent(
          midtransOrderId,
        )}/status`,
        {
          method: "GET",
          headers: {
            Accept: "application/json",
            Authorization: authHeader,
          },
        },
      );

    const midtransData =
      await midtransResponse.json();

    console.log(
      "MIDTRANS STATUS:",
      JSON.stringify(midtransData),
    );

    if (!midtransResponse.ok) {
      throw new Error(
        midtransData.status_message ??
          "Failed to get Midtrans transaction status.",
      );
    }

    const transactionStatus =
      midtransData.transaction_status;

    if (transactionStatus === "settlement") {
      const {
        error: updateError,
      } = await supabaseAdmin
        .from("orders")
        .update({
          payment_status: "paid",
          updated_at: new Date().toISOString(),
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
          paid: true,
          status: "settlement",
        }),
        {
          status: 200,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    return new Response(
      JSON.stringify({
        success: true,
        paid: false,
        status: transactionStatus,
      }),
      {
        status: 200,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      },
    );
  } catch (error) {
    console.error(
      "check-payment-status error:",
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
          "Content-Type": "application/json",
        },
      },
    );
  }
});