from fastapi import APIRouter, HTTPException

from app.services.appointement import appointemntService
from app.deps.auth import role_required
from app.models.appointemnt import AppointmentCreate
from app.models.user import Role, User
from app.services.user import UserService
from app.services.Order import orderService


router = APIRouter(prefix="/appointements")

@router.get("/")
async def get_appointements(user: User = role_required(Role.ADMIN, Role.Super_Admin), skip: int = 0, limit: int = 10):
    return appointemntService.get_all_appointement( skip, limit)

@router.get("/my")
async def get_my_appointements(user: User = role_required(Role.USER, Role.ADMIN, Role.Super_Admin)):
    return await appointemntService.get_appointements_by_user(str(user.id))

@router.post("/")
async def create_appointement(appontCreate : AppointmentCreate, user: User = role_required( Role.ADMIN, Role.Super_Admin)):
    student = await UserService.get_user_by_id(appontCreate.student_id)
    if not student:
        raise HTTPException(status_code=404, detail="User not found")
    order = await orderService.get_order_by_id(appontCreate.order_id)
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    
    return await appointemntService.create_appointement(admin=user, student=student, order=order, scheduled_at=appontCreate.scheduled_at, location=appontCreate.location)


@router.patch("/{appointement_id}")
async def update_appointement(appointement_id: str, data: dict, user: User = role_required(Role.ADMIN, Role.Super_Admin)):
    return await appointemntService.update_appointement(appointement_id, data)

@router.delete("/{appointement_id}")
async def delete_appointement(appointement_id: str, user: User = role_required(Role.ADMIN, Role.Super_Admin)):
    return await appointemntService.delete_appointement(appointement_id)