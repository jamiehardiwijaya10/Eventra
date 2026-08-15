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

  if (req.method !== "POST") {
    return new Response(
      JSON.stringify({
        success: false,
        error: "Method not allowed.",
      }),
      {
        status: 405,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      },
    );
  }

  try {

    const supabaseUrl =
      Deno.env.get("SUPABASE_URL");

    const serviceRoleKey =
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    const midtransServerKey =
      Deno.env.get("MIDTRANS_SERVER_KEY");

    if (
      !supabaseUrl ||
      !serviceRoleKey ||
      !midtransServerKey
    ) {
      throw new Error(
        "Required environment variables are missing.",
      );
    }

    const body =
      await req.json();

    console.log(
      "MIDTRANS WEBHOOK:",
      JSON.stringify(body),
    );

    const orderId =
      body.order_id?.toString();

    const transactionStatus =
      body.transaction_status?.toString();

    const fraudStatus =
      body.fraud_status?.toString();

    const paymentType =
      body.payment_type?.toString();

    const grossAmount =
      body.gross_amount?.toString();

    const statusCode =
      body.status_code?.toString();

    if (!orderId) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "order_id is missing.",
        }),
        {
          status: 400,
          headers: {
            ...corsHeaders,
            "Content-Type":
              "application/json",
          },
        },
      );
    }

    const signatureKey =
      body.signature_key?.toString();

    const rawSignature =
      await crypto.subtle.digest(
        "SHA-512",
        new TextEncoder().encode(
          `${orderId}${statusCode}${grossAmount}${midtransServerKey}`,
        ),
      );

    const expectedSignature =
      Array.from(
        new Uint8Array(rawSignature),
      )
        .map((byte) =>
          byte.toString(16).padStart(2, "0"),
        )
        .join("");

    if (
      !signatureKey ||
      signatureKey !== expectedSignature
    ) {
      console.error(
        "MIDTRANS WEBHOOK: INVALID SIGNATURE",
      );

      return new Response(
        JSON.stringify({
          success: false,
          error: "Invalid signature.",
        }),
        {
          status: 401,
          headers: {
            ...corsHeaders,
            "Content-Type":
              "application/json",
          },
        },
      );
    }

    console.log(
      "MIDTRANS WEBHOOK: SIGNATURE VALID",
    );

    const supabaseAdmin =
      createClient(
        supabaseUrl,
        serviceRoleKey,
      );

    const {
      data: order,
      error: orderError,
    } =
      await supabaseAdmin
        .from("orders")
        .select(
          `
          id,
          midtrans_order_id,
          payment_status
          `,
        )
        .or(
          `id.eq.${orderId},midtrans_order_id.eq.${orderId}`,
        )
        .maybeSingle();

    if (orderError) {
      throw new Error(
        `Failed to find order: ${orderError.message}`,
      );
    }

    if (!order) {
      console.error(
        `MIDTRANS WEBHOOK: ORDER NOT FOUND ${orderId}`,
      );

      return new Response(
        JSON.stringify({
          success: false,
          error: "Order not found.",
        }),
        {
          status: 404,
          headers: {
            ...corsHeaders,
            "Content-Type":
              "application/json",
          },
        },
      );
    }

    let paymentStatus =
      order.payment_status;

    if (
      transactionStatus === "capture"
    ) {
      if (
        fraudStatus === "accept" ||
        !fraudStatus
      ) {
        paymentStatus = "paid";
      }
    }

    if (
      transactionStatus === "settlement"
    ) {
      paymentStatus = "paid";
    }

    if (
      transactionStatus === "pending"
    ) {
      paymentStatus = "pending";
    }

    if (
      transactionStatus === "deny" ||
      transactionStatus === "cancel" ||
      transactionStatus === "expire"
    ) {
      paymentStatus = "failed";
    }

    const {
      error: updateError,
    } =
      await supabaseAdmin
        .from("orders")
        .update({
          payment_status:
            paymentStatus,

          payment_method:
            paymentType,

          updated_at:
            new Date().toISOString(),
        })
        .eq(
          "id",
          order.id,
        );

    if (updateError) {
      throw new Error(
        `Failed to update order: ${updateError.message}`,
      );
    }

    console.log(
      "MIDTRANS WEBHOOK: ORDER UPDATED",
      {
        orderId: order.id,
        transactionStatus,
        paymentStatus,
        paymentType,
      },
    );

    return new Response(
      JSON.stringify({
        success: true,
        orderId: order.id,
        paymentStatus,
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
      "MIDTRANS WEBHOOK ERROR:",
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