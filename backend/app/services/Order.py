from fastapi import HTTPException
from app.models.Order import Order, OrderCreate, OrderStatus, Orderitem
from app.models.user import User
from app.models.material import Material
from typing import List, Optional
from datetime import datetime
from beanie import PydanticObjectId


class orderService:

    @staticmethod
    async def create_order(student: User, items: List[OrderCreate]) -> Order:
        order_items: List[Orderitem] = []

        for item in items:
            material = await Material.get(item.materiel_id)
            if not material:
                raise HTTPException(status_code=404, detail=f"Material not found: {item.materiel_id}")

            order_items.append(Orderitem(material=material, quantity=item.quantity))

        order = Order(
            student=student,
            item=order_items,  
        )
        await order.insert()
        return order

    @staticmethod
    async def get_orders_by_student(student_id: str) -> List[Order]:
        return await Order.find(Order.student == PydanticObjectId(student_id)).sort("-created_at").to_list()


    @staticmethod
    async def get_all_orders(status: Optional[OrderStatus] = None) -> List[Order]:
        if status:
            return await Order.find(Order.status == status).sort("-created_at").to_list()
        return await Order.find_all().sort("-created_at").to_list()

    @staticmethod
    async def get_orders_by_admin(admin_id: str) -> List[Order]:
        return await Order.find(Order.assigned_admin == PydanticObjectId(admin_id)).sort("-created_at").to_list()

    @staticmethod
    async def accept_order_for_printing(order_id: str, admin: User) -> Optional[Order]:
        order = await Order.get(order_id)
        if not order or order.status != OrderStatus.PENDING:
            return None
        order.status = OrderStatus.PRINTING
        order.assigned_admin = admin
        await order.save()
        return order

    @staticmethod
    async def mark_order_as_ready(order_id: str, appointment_date: datetime, admin: User) -> Optional[Order]:
        order = await Order.get(order_id)
        if not order or order.status != OrderStatus.PRINTING:
            return None
        order.status = OrderStatus.READY
        order.appointment_date = appointment_date
        order.assigned_admin = admin
        await order.save()
        return order

    @staticmethod
    async def mark_order_as_delivered(order_id: str, admin: User) -> Optional[Order]:
        order = await Order.get(order_id)
        if not order or order.status != OrderStatus.READY:
            return None
        if order.assigned_admin.id != admin.id:
            return None  # prevent cross-admin delivery
        order.status = OrderStatus.DELIVERED
        await order.save()
        return order

    @staticmethod
    async def reassign_order_admin(order_id: str, new_admin: User) -> Optional[Order]:
        order = await Order.get(order_id)
        if not order:
            return None
        order.assigned_admin = new_admin
        await order.save()
        return order

    @staticmethod
    async def delete_order(order_id: str) -> bool:
        order = await Order.get(order_id)
        if order:
            await order.delete()
            return True
        return False

    @staticmethod
    async def get_order_by_id(order_id: str) -> Optional[Order]:
        return await Order.get(order_id)
