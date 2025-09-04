from fastapi import APIRouter, HTTPException, Body
from typing import List, Optional
from datetime import datetime
from app.services.Order import orderService
from app.models.order import Order, OrderCreate, OrderStatus, orderResponse, serialize_order, serialize_order_F, DeliveryType
from app.models.user import User, Role
from app.deps.auth import role_required

router = APIRouter(prefix="/orders", tags=["Orders"])


@router.post("/", response_model=orderResponse)
async def create_order(
    order_data: List[OrderCreate] = Body(...),
    user: User = role_required(Role.USER, Role.ADMIN, Role.Super_Admin)
):
    """
    Create a new order with delivery preference
    """
    order = await orderService.create_order(user, order_data)
    return serialize_order(order)


@router.get("/my", response_model=List[orderResponse])
async def get_my_orders(user: User = role_required(Role.USER, Role.ADMIN, Role.Super_Admin)):
    orders = await orderService.get_orders_by_student(str(user.id))
    return [serialize_order(order) for order in orders]


@router.get("/get_admin_orders")
async def get_admin_orders(user: User = role_required(Role.ADMIN, Role.Super_Admin)):
    area: str = user.era
    ReturnOrders = []
    orders = await orderService.get_all_orders()
    for order in orders:
        student = await order.student.fetch()
        if student.era == area:
            ReturnOrders.append(serialize_order_F(order, student))
        else:
            continue
    print(ReturnOrders)
    return ReturnOrders


@router.get("/admin", response_model=List[Order])
async def get_all_orders(
    status: Optional[OrderStatus] = None,
    admin: User = role_required(Role.ADMIN, Role.Super_Admin)
):
    return await orderService.get_all_orders(status)


@router.patch("/admin/{order_id}/accept", response_model=Order)
async def accept_order(
    order_id: str,
    admin: User = role_required(Role.ADMIN, Role.Super_Admin)
):
    order = await orderService.accept_order_for_printing(order_id, admin)
    if not order:
        raise HTTPException(status_code=400, detail="Order not found or already accepted")
    return order


@router.patch("/admin/{order_id}/ready")
async def mark_order_ready(
    order_id: str,
    appointment_date: datetime = Body(...),
    admin: User = role_required(Role.ADMIN, Role.Super_Admin)
):
    """
    Mark order as ready. If delivery_type is DELIVERY, automatically sends to ZR Express
    """
    order = await orderService.mark_order_as_ready(order_id, appointment_date, admin)
    if not order:
        raise HTTPException(status_code=400, detail="Order must be in 'printing' state")
    
    response_data = serialize_order(order)
    
    
    if order.delivery_type == DeliveryType.DELIVERY and order.zr_tracking_id:
        response_data["message"] = f"Order sent to ZR Express for delivery. Tracking ID: {order.zr_tracking_id}"
    elif order.delivery_type == DeliveryType.DELIVERY and not order.zr_tracking_id:
        response_data["message"] = "Order ready but delivery creation failed. Please try again or contact support."
    else:
        response_data["message"] = "Order ready for pickup"
    
    return response_data


@router.patch("/admin/{order_id}/delivered", response_model=Order)
async def mark_delivered(
    order_id: str,
    admin: User = role_required(Role.ADMIN, Role.Super_Admin)
):
    order = await orderService.mark_order_as_delivered(order_id, admin)
    if not order:
        raise HTTPException(
            status_code=400, 
            detail="Order not in valid state for delivery confirmation or admin mismatch"
        )
    return order


@router.patch("/admin/{order_id}/make_printing", response_model=Order)
async def make_printing(
    order_id: str,
    admin: User = role_required(Role.ADMIN, Role.Super_Admin)
):
    order = await orderService.reassign_order_admin(order_id, admin)
    if not order:
        raise HTTPException(status_code=400, detail="Order not found")
    return order


@router.get("/{order_id}/delivery-status")
async def get_delivery_status(
    order_id: str,
    user: User = role_required(Role.USER, Role.ADMIN, Role.Super_Admin)
):
    """
    Get ZR Express delivery status for an order
    """
    
    if user.role == Role.USER:
        order = await orderService.get_order_by_id(order_id)
        if not order or str(order.student.id) != str(user.id):
            raise HTTPException(status_code=403, detail="Access denied")
    
    status = await orderService.get_delivery_status(order_id)
    if not status:
        raise HTTPException(status_code=404, detail="Delivery status not found or order not sent for delivery")
    
    return status


@router.get("/{user_id}", response_model=List[Order])
async def get_user_orders(
    user_id: str,
    user: User = role_required(Role.ADMIN, Role.Super_Admin)
):
    orders = await orderService.get_orders_by_student(user_id)
    if not orders:
        raise HTTPException(status_code=404, detail="No orders found for this user")
    return [serialize_order(order) for order in orders]



@router.get("/delivery-types", response_model=List[str])
async def get_delivery_types():
    """
    Get available delivery types
    """
    return [delivery_type.value for delivery_type in DeliveryType]