from fastapi import APIRouter

from app.services.appointement import appointemntService
from backend.app.deps.auth import role_required
from backend.app.models.user import Role, User


router = APIRouter(prefix="/appointements")

@router.get("/")
async def get_appointements(user: User = role_required(Role.ADMIN, Role.Super_Admin), skip: int = 0, limit: int = 10):
    return appointemntService.get_all_appointement( skip, limit)

@router.get("/my")
async def get_my_appointements(user: User = role_required(Role.USER, Role.ADMIN, Role.Super_Admin)):
    return await appointemntService.get_appointements_by_user(str(user.id))

@router.post("/")
async def create_appointement(user: User = role_required(Role.USER, Role.ADMIN, Role.Super_Admin)):
    return await appointemntService.create_appointement(user)