from datetime import datetime
from typing import List
from backend.app.models.notification import notification
from backend.app.models.user import User


class notificationService:
    @staticmethod
    async def delete_notification(notification_id: str):
        return await notification.delete(notification_id)
    @staticmethod
    async def create_notification(user: User, message: str) -> notification:
        notif = notification(
            user=user,
            message=message,
            created_at=datetime.utcnow()
        )
        await notif.insert()
        return notif
    
    @staticmethod
    async def get_notifications(user: User) -> List[notification]:
        return await notification.find(notification.user_id == user.id and not  notification.issent).sort("-created_at").to_list()
    
    @staticmethod
    async def get_all_notifications() -> List[notification]:
        return await notification.find_all().sort("-created_at").to_list()