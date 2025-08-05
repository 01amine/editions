from datetime import datetime
from beanie import Document, Link
from app.models.user import User


class notification (Document):
    issent: bool = False
    message : str 
    user_id : Link[User]
    created_at : datetime
    
    class Settings:
        name = "notifications"