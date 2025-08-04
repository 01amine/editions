from datetime import datetime
from enum import Enum
from typing import List, Optional
from beanie import Document, Link
from bson import ObjectId
from pydantic import BaseModel, ConfigDict
from app.models.user import User
from app.models.material import Material

class OrderStatus(str, Enum):
    PENDING = "pending"
    PRINTING = "printing"
    READY = "ready"
    DELIVERED = "delivered"
    


    

    
    
class Order(Document):
    student: Link[User]
    item : List[tuple[Link[Material], int]]
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
    

    