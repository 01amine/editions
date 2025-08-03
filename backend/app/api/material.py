from datetime import datetime
from fastapi import APIRouter, UploadFile, File, Form,  HTTPException
from typing import List, Optional
from app.services.material import materialService
from app.models.material import Material
from app.models.user import Role, User
from app.deps.auth import role_required
import shutil
import uuid
import os

router = APIRouter(prefix="/materials", tags=["Materials"])

UPLOAD_DIR = "static/uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)
@router.post("/", response_model=Material)
async def create_material(
    file: UploadFile = File(...),
    title: str = Form(...),
    description: str = Form(...),
    material_type: str = Form(...),
    price_dzd: float = Form(...),
    user: User = role_required(Role.ADMIN, Role.Super_Admin, Role.USER),
):
    filename = f"{uuid.uuid4().hex}_{file.filename}"
    file_path = os.path.join(UPLOAD_DIR, filename)
    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    file_url = f"/{file_path}" 
    material = await materialService.create_material(
        title=title,
        description=description,
        file_url=file_url,
        material_type=material_type,
        price_dzd=price_dzd,
    )
    return material



@router.get("/", response_model=List[Material])
async def get_all_materials( user: User = role_required(Role.ADMIN, Role.Super_Admin, Role.USER)):
    return await materialService.get_all_materials()


@router.get("/{material_id}", response_model=Material)
async def get_material_by_id(material_id: str, user: User = role_required(Role.ADMIN, Role.Super_Admin, Role.USER)):
    material = await materialService.get_material_by_id(material_id)
    if not material:
        raise HTTPException(status_code=404, detail="Material not found")
    return material


@router.patch("/{material_id}", response_model=Material)
async def update_material(
    material_id: str,
    title: Optional[str] = Form(None),
    description: Optional[str] = Form(None),
    material_type: Optional[str] = Form(None),
    price_dzd: Optional[float] = Form(None),
    user: User = role_required(Role.ADMIN, Role.Super_Admin),
):
    updates = {}
    if title is not None:
        updates["title"] = title
    if description is not None:
        updates["description"] = description
    if material_type is not None:
        updates["material_type"] = material_type
    if price_dzd is not None:
        updates["price_dzd"] = price_dzd

    material = await materialService.update_material(material_id, updates)
    if not material:
        raise HTTPException(status_code=404, detail="Material not found")
    return material


# === Delete Material ===
@router.delete("/{material_id}")
async def delete_material(material_id: str, user: User = role_required(Role.ADMIN, Role.Super_Admin)):
    success = await materialService.delete_material(material_id)
    if not success:
        raise HTTPException(status_code=404, detail="Material not found")
    return {"detail": "Material deleted"}


# === Search by Title ===
@router.get("/search/", response_model=List[Material])
async def search_by_title(q: str, user: User = role_required(Role.ADMIN, Role.Super_Admin, Role.USER)):
    return await materialService.search_materials_by_title(q)


# === Filter by Type ===
@router.get("/filter/type", response_model=List[Material])
async def get_by_type(type: str, user: User = role_required(Role.ADMIN, Role.Super_Admin, Role.USER)):
    return await materialService.get_materials_by_type(type)


# === Filter by Date ===
@router.get("/filter/date", response_model=List[Material], description="ISO format: yyyy-mm-dd")
async def get_by_date(date: str, user: User = role_required(Role.ADMIN, Role.Super_Admin, Role.USER)):  # ISO format: yyyy-mm-dd
    try:
        parsed = datetime.fromisoformat(date)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid date format")
    return await materialService.get_materials_by_date(parsed)
