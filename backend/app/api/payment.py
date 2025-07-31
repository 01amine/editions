from fastapi import APIRouter, Request, HTTPException, Header
from app.services.payment import handle_stripe_webhook

router = APIRouter()


@router.post("/webhook")
async def stripe_webhook(
    request: Request, stripe_signature: str = Header(..., alias="stripe-signature")
):
    payload = await request.body()
    try:
        await handle_stripe_webhook(payload, stripe_signature)
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
    return {"status": "success"}
