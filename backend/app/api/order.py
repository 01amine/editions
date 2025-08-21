from fastapi import APIRouter,  HTTPException, Body
from typing import List, Optional
from datetime import datetime
from app.services.Order import orderService
from app.models.order import Order, OrderCreate, OrderStatus, orderResponse, serialize_order, serialize_order_F
from app.models.user import User, Role
from app.deps.auth import role_required

router = APIRouter(prefix="/orders", tags=["Orders"])


@router.post("/", response_model=orderResponse)
async def create_order(
    material_ids: List[OrderCreate] = Body(...),
    user: User = role_required(Role.USER, Role.ADMIN, Role.Super_Admin)
):
    order = await orderService.create_order(user, material_ids)
    return serialize_order(order)


@router.get("/my", response_model=List[orderResponse])
async def get_my_orders(user: User = role_required(Role.USER, Role.ADMIN, Role.Super_Admin)):
    orders= await orderService.get_orders_by_student(str(user.id))
    return [serialize_order(order) for order in orders]

# @router.get("/all", response_model=List[orderResponse])
# async def get_all_orders(user: User = role_required(Role.ADMIN, Role.Super_Admin)):
#     orders= await orderService.get_all_orders()
#     return [serialize_order(order) for order in orders]

@router.get("/get_admin_orders")
async def get_admin_orders(user: User = role_required(Role.ADMIN, Role.Super_Admin)):
    area: str = user.era
    ReturnOrders = []
    orders= await orderService.get_all_orders()
    for order in orders:
        user = await order.student.fetch()
        if user.era == area:
            ReturnOrders.append(serialize_order_F(order, user))
        else :
            continue
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


@router.patch("/admin/{order_id}/ready", response_model=Order)
async def mark_order_ready(
    order_id: str,
    appointment_date: datetime = Body(...),
    admin: User = role_required(Role.ADMIN, Role.Super_Admin)
):
    order = await orderService.mark_order_as_ready(order_id, appointment_date, admin)
    if not order:
        raise HTTPException(status_code=400, detail="Order must be in 'printing' state")
    return order


@router.patch("/admin/{order_id}/delivered", response_model=Order)
async def mark_delivered(
    order_id: str,
    admin: User = role_required(Role.ADMIN, Role.Super_Admin)
):
    order = await orderService.mark_order_as_delivered(order_id, admin)
    if not order:
        raise HTTPException(status_code=400, detail="Order not in ready state or admin mismatch")
    return order


@router.get("/{user_id}", response_model=List[Order])
async def get_user_orders(
    user_id: str,
    user: User = role_required(Role.ADMIN, Role.Super_Admin)
):
    orders = await orderService.get_orders_by_student(user_id)
    if not orders:
        raise HTTPException(status_code=404, detail="No orders found for this user")
    return [serialize_order(order) for order in orders]