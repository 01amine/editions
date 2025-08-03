from fastapi import APIRouter

from app.services.appointement import appointemntService


router = APIRouter(prefix="/appointements")

@router.get("/")
async def get_appointements():
    return appointemntService.get_all_appointement()