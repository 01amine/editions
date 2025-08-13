from fastapi import APIRouter, HTTPException
from bson.errors import InvalidId
from app.services.appointement import appointemntService
from app.deps.auth import role_required
from app.models.appointemnt import Appointment, AppointmentCreate
from app.models.user import Role, User
from app.services.user import UserService
from app.services.Order import orderService


router = APIRouter(prefix="/appointements")

@router.get("/")
async def get_appointements(user: User = role_required(Role.ADMIN, Role.Super_Admin), skip: int = 0, limit: int = 10)-> list[Appointment]:
    appo =  await appointemntService.get_all_appointement( skip, limit)
    return appo

@router.get("/my")
async def get_my_appointements(user: User = role_required(Role.USER, Role.ADMIN, Role.Super_Admin)):
    return await appointemntService.get_appointements_by_user(str(user.id))

@router.post("/")
async def create_appointement(
    appontCreate: AppointmentCreate, 
    user: User = role_required(Role.ADMIN, Role.Super_Admin)
):
    try:
        student = await UserService.get_user_by_id(appontCreate.student_id)
    except InvalidId:
        raise HTTPException(status_code=400, detail="Invalid student_id format")
    
    if not student:
        raise HTTPException(status_code=404, detail="User not found")

    try:
        order = await orderService.get_order_by_id(appontCreate.order_id)
    except InvalidId:
        raise HTTPException(status_code=400, detail="Invalid order_id format")
    
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    
    appointement: Appointment = await appointemntService.create_appointement(
        admin=user,
        student=student,
        order=order,
        scheduled_at=appontCreate.scheduled_at,
        location=appontCreate.location
    )

    return {"apppoitement_id": str(appointement.id)}
    


@router.patch("/{appointement_id}")
async def update_appointement(appointement_id: str, data: dict, user: User = role_required(Role.ADMIN, Role.Super_Admin)):
    return await appointemntService.update_appointement(appointement_id, data)

@router.delete("/{appointement_id}")
async def delete_appointement(appointement_id: str, user: User = role_required(Role.ADMIN, Role.Super_Admin)):
    return await appointemntService.delete_appointement(appointement_id)