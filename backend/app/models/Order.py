from datetime import datetime
from enum import Enum
from typing import List, Optional
from beanie import Document, Link
from app.models.user import User
from app.models import material

class OrderStatus(str, Enum):
    PENDING = "pending"
    PRINTING = "printing"
    READY = "ready"
    DELIVERED = "delivered"
class Order(Document):
    student: Link[User]
    materials: List[Link[material.Material]]
    status: OrderStatus = OrderStatus.PENDING 
    appointment_date: Optional[datetime]
    created_at: datetime = datetime.utcnow()
    assigned_admin: Optional[Link[User]]  

# Student Places Order -> pending
# Admin Accepts & Starts Printing -> printing
# Admin Finishes -> ready
# Student Picks It Up -> delivered