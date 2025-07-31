from app.models.user import User


async def update_user_subscription_status(user_id: str, is_active: bool):
    user = await User.get(user_id)
    if not user:
        raise ValueError("User not found")
    user.subscription_active = is_active
    await user.save()
