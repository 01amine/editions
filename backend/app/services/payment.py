import stripe
from app.services.user import update_user_subscription_status
from app.config import settings

stripe.api_key = settings.STRIPE_SECRET_KEY
endpoint_secret = settings.STRIPE_WEBHOOK_SECRET


def create_checkout_session(customer_email: str, amount: int, currency: str = "usd"):
    session = stripe.checkout.Session.create(
        payment_method_types=["card"],
        mode="payment",
        customer_email=customer_email,
        line_items=[
            {
                "price_data": {
                    "currency": currency,
                    "product_data": {"name": "UFO Service Subscription"},
                    "unit_amount": amount,
                },
                "quantity": 1,
            }
        ],
        success_url="http://localhost:8000/static/success.html?session_id={CHECKOUT_SESSION_ID}",
        cancel_url="http://localhost:8000/static/cancel.html",
    )
    return session.url


async def handle_stripe_webhook(payload: bytes, sig_header: str):
    try:
        event = stripe.Webhook.construct_event(
            payload=payload, sig_header=sig_header, secret=endpoint_secret
        )
    except stripe.SignatureVerificationError as e:
        raise Exception("Invalid Stripe signature")

    if event["type"] == "checkout.session.completed":
        session = event["data"]["object"]
        user_id = session["metadata"]["user_id"]
        await update_user_subscription_status(user_id, is_active=True)

    elif event["type"] == "invoice.payment_failed":
        session = event["data"]["object"]
        user_id = session["metadata"]["user_id"]
        await update_user_subscription_status(user_id, is_active=False)
