import "jsr:@supabase/functions-js/edge-runtime.d.ts";

Deno.serve(async (req) => {
  try {
    const url = new URL(req.url);

    const orderId = url.searchParams.get("order_id");

    if (!orderId) {
      return new Response(
        "Missing order_id",
        {
          status: 400,
          headers: {
            "Content-Type": "text/plain",
          },
        },
      );
    }

    const eventraUrl =
      `eventra://payment-result?order_id=${encodeURIComponent(orderId)}`;

    const html = `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">

  <meta
    name="viewport"
    content="width=device-width, initial-scale=1.0"
  >

  <title>Eventra Payment</title>

  <style>
    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      min-height: 100vh;

      display: flex;
      align-items: center;
      justify-content: center;

      padding: 24px;

      background: #f7f8fa;

      font-family:
        Arial,
        Helvetica,
        sans-serif;
    }

    .card {
      width: 100%;
      max-width: 420px;

      padding: 40px 28px;

      text-align: center;

      background: #ffffff;

      border-radius: 20px;

      box-shadow:
        0 10px 35px
        rgba(0, 0, 0, 0.08);
    }

    .icon {
      width: 80px;
      height: 80px;

      margin: 0 auto 24px;

      display: flex;
      align-items: center;
      justify-content: center;

      border-radius: 50%;

      background: #e9f8ef;

      color: #22a45a;

      font-size: 42px;
      font-weight: 700;
    }

    h1 {
      margin: 0 0 12px;

      color: #222222;

      font-size: 26px;
      font-weight: 800;
    }

    p {
      margin: 0 0 30px;

      color: #777777;

      font-size: 15px;

      line-height: 1.5;
    }

    .button {
      display: block;

      width: 100%;

      padding: 15px;

      border-radius: 12px;

      background: #ff751f;

      color: #ffffff;

      text-decoration: none;

      font-size: 16px;

      font-weight: 700;
    }

    .button:active {
      opacity: 0.85;
    }
  </style>
</head>

<body>

  <div class="card">

    <div class="icon">
      ✓
    </div>

    <h1>
      Payment Completed
    </h1>

    <p>
      Your payment has been processed successfully.
      Return to Eventra to view your payment result
      and ticket information.
    </p>

    <a
      class="button"
      href="${eventraUrl}"
    >
      Back to Eventra
    </a>

  </div>

</body>
</html>
`;

    return new Response(
      html,
      {
        status: 200,

        headers: {
          "Content-Type":
            "text/html; charset=utf-8",
        },
      },
    );
  } catch (error) {
    console.error(
      "payment-return error:",
      error,
    );

    return new Response(
      "Payment return error.",
      {
        status: 500,

        headers: {
          "Content-Type":
            "text/plain",
        },
      },
    );
  }
});