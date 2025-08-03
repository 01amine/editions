from datetime import datetime
from enum import Enum
from typing import List, Optional
from beanie import Document, Link
from pydantic import BaseModel
from app.models.user import User
from app.models import material

class OrderStatus(str, Enum):
    PENDING = "pending"
    PRINTING = "printing"
    READY = "ready"
    DELIVERED = "delivered"
    
class Orderitem(BaseModel):
    material: Link[material.Material]
    quantity: int
    
    class config:
        arbitrary_types_allowed = True
    
    
class Order(Document):
    student: Link[User]
    item : List[Orderitem]
    status: OrderStatus = OrderStatus.PENDING 
    appointment_date: Optional[datetime]
    created_at: datetime = datetime.utcnow()
    assigned_admin: Optional[Link[User]]  

# Student Places Order -> pending
# Admin Accepts & Starts Printing -> printing
# Admin Finishes -> ready
# Student Picks It Up -> delivered


class OrderCreate(BaseModel):
    materiel_id: str
    quantity: int
    

    