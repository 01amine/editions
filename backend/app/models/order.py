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
    OUT_FOR_DELIVERY = "out_for_delivery"
    
class DeliveryType(str, Enum):
    PICKUP = "pickup"  # Client picks up at lbureau
    DELIVERY = "delivery"  # ZR Express delivery a domicile
  
class Order(Document):
    student: Link[User]
    item : List[tuple[Link[Material], int]]
    status: OrderStatus = OrderStatus.PENDING 
    appointment_date: Optional[datetime] = None
    created_at: datetime = datetime.utcnow()
    assigned_admin: Optional[Link[User]]  = None
    delivery_type: DeliveryType = DeliveryType.PICKUP
    delivery_address: Optional[str] = None
    delivery_phone: Optional[str] = None
    zr_tracking_id: Optional[str] = None

# Student Places Order -> pending
# Admin Accepts & Starts Printing -> printing
# Admin Finishes -> ready
# Student Picks It Up -> delivered


class OrderCreate(BaseModel):
    materiel_id: str
    quantity: int
    delivery_type: DeliveryType = DeliveryType.PICKUP
    delivery_address: Optional[str] = None
    delivery_phone: Optional[str] = None
    


class orderResponse(BaseModel):
    id : str = Field(alias="_id")
    appointment_date : Optional[datetime]
    status : OrderStatus
    item : List[tuple[materialUser, int]]
    delivery_type: DeliveryType
    delivery_address: Optional[str] = None
    zr_tracking_id: Optional[str] = None
    model_config = {
        "populate_by_name": True,  
        "from_attributes": True     
    }
    

def serialize_order(order: Order):
    return {
        "id": str(order.id),
        "appointment_date": order.appointment_date,
        "status": order.status,
        "delivery_type": order.delivery_type,
        "delivery_address": order.delivery_address,
        "zr_tracking_id": order.zr_tracking_id,
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


def serialize_order_F(order: Order, user: User = None):
    return {
        "_id": str(order.id),
        "student": {
            "full_name": user.full_name if user else None,
            "email": user.email if user else None,
        },
        "item": [
            (
                {
                    "title": material.title,
                    "material_type": material.material_type,
                    "price_dzd": material.price_dzd,
                },
                int(qty),
            )
            for material, qty in order.item
        ],
        "status": order.status.value,
        "delivery_type": order.delivery_type.value,
        "delivery_address": order.delivery_address,
        "zr_tracking_id": order.zr_tracking_id,
        "created_at": order.created_at.isoformat(),
        "appointment_date": order.appointment_date.isoformat() if order.appointment_date else None,
    }
