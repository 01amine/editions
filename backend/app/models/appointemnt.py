import datetime
from beanie import Document, Link
from pydantic import BaseModel, Field
from app.models import Order
from app.models.user import User


class Appointment(Document):
    order: Link[Order]
    student: Link[User]
    admin: Link[User]
    scheduled_at: datetime
    location: str  # "Algiers store", etc.
    created_at : datetime = Field(default_factory=datetime.utcnow)

class AppointmentCreate(BaseModel):
    order_id: str
    admin_id: str
    scheduled_at: datetime
    location: str