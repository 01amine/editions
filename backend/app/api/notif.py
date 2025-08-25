from typing import Optional
from fastapi import APIRouter, Body, HTTPException, status

from app.deps.auth import role_required
from app.models.user import Role, User
from app.services.notifction import notificationService
from beanie import PydanticObjectId
from app.models.notification import notification
from bson import ObjectId

router = APIRouter(prefix="/notifications", tags=["Notifications"])

@router.post("/", status_code=status.HTTP_201_CREATED)
async def create_notification(
    user_id: Optional[str] = Body(None),
    message: str = Body(...),
    current_user: User = role_required(Role.ADMIN, Role.Super_Admin),
):
    if user_id:
        target_user = await User.get(user_id)
        if not target_user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )

        await notificationService.create_notification(target_user, message)
        return {"message": f"Notification created for user with ID: {user_id}"}

    all_users = await User.find_all().to_list()
    if not all_users:
        return {"message": "No users found to send notifications to."}

    for user in all_users:
        await notificationService.create_notification(user, message)

    return {"message": "Notification created for all users"}

@router.get("/")
async def get_notification(user :User = role_required(Role.ADMIN, Role.Super_Admin, Role.USER)):
    return await  notificationService.get_notifications(user)

@router.get("/all")
async def get_all_notification(user :User = role_required(Role.ADMIN, Role.Super_Admin)):
    return await  notificationService.get_all_notifications()