from datetime import datetime
from enum import Enum
from typing import List, Optional
from beanie import Document, Link
from bson import ObjectId
from pydantic import BaseModel, ConfigDict, Field
from app.models.user import User
from app.models.material import Material, materialUser



class OrderStatus(str, Enum):
    PENDING = "pending"
    PRINTING = "printing"
    READY = "ready"
    DELIVERED = "delivered"
    
      
class Order(Document):
    student: Link[User]
    item : List[tuple[Link[Material], int]]
    status: OrderStatus = OrderStatus.PENDING 
    appointment_date: Optional[datetime] = None
    created_at: datetime = datetime.utcnow()
    assigned_admin: Optional[Link[User]]  = None

# Student Places Order -> pending
# Admin Accepts & Starts Printing -> printing
# Admin Finishes -> ready
# Student Picks It Up -> delivered


class OrderCreate(BaseModel):
    materiel_id: str
    quantity: int
    


class orderResponse(BaseModel):
    id : str = Field(alias="_id")
    appointment_date : Optional[datetime]
    status : OrderStatus
    item : List[tuple[materialUser, int]]
    model_config = {
        "populate_by_name": True,  
        "from_attributes": True     
    }
    

def serialize_order(order: Order):#wrong one i jsut dont know if amine use it 
    return {
        "id": str(order.id),
        "appointment_date": order.appointment_date,
        "status": order.status,
        "item": [
            (
                {
                    "id": str(material.id),
                    "title": material.title,
                    "description": material.description,
                    "image_urls": material.image_urls,
                    "material_type": material.material_type,
                    "price_dzd": material.price_dzd,
                },
                 qty,
            )
            for material, qty in order.item
        ],
    }
    
    
def serialize_order_F(order: Order):
    return {
        "_id": str(order.id),
        "student": {
            "full_name": order.student.full_name,
            "email": order.student.email,
        },
        "item": [
            (
                {
                    "title": material.title,
                    "material_type": material.material_type,
                    "price_dzd": material.price_dzd,
                },
                qty,
            )
            for material, qty in order.item
        ],
        "status": order.status,
        "created_at": order.created_at.isoformat(),
        "appointment_date": order.appointment_date.isoformat() if order.appointment_date else None,
    }
