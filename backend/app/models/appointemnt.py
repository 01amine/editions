import datetime
from beanie import Document, Link
from app.models import Order
from app.models.user import User


class Appointment(Document):
    order: Link[Order]
    student: Link[User]
    admin: Link[User]
    scheduled_at: datetime
    location: str  # "Algiers store", etc.
