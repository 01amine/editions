from fastapi import APIRouter

from app.deps.auth import role_required
from app.models.user import Role, User
from app.services.notifction import notificationService


router = APIRouter(prefix="/notifications", tags=["Notifications"])

@router.get("/")
async def get_notification(user :User = role_required(Role.ADMIN, Role.Super_Admin, Role.USER)):
    return await  notificationService.get_notifications(user)

@router.get("/all")
async def get_all_notification(user :User = role_required(Role.ADMIN, Role.Super_Admin)):
    return await  notificationService.get_all_notifications()