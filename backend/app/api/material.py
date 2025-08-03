from datetime import datetime
from fastapi import APIRouter, UploadFile, File, Form,  HTTPException
from typing import List, Optional

from fastapi.responses import StreamingResponse
from app.services.material import materialService
from app.models.material import Material
from app.models.user import Role, User
from app.deps.auth import role_required
import uuid
from app.minio import DocumentBucket, ImageBucket

router = APIRouter(prefix="/materials", tags=["Materials"])



image_bucket = ImageBucket(file_prefix="materials/images")
document_bucket = DocumentBucket(file_prefix="materials/documents")

@router.post("/", response_model=Material)
async def create_material(
    file: UploadFile = File(...),  
    images: List[UploadFile] = File(...),  
    title: str = Form(...),
    description: str = Form(...),
    material_type: str = Form(...),
    price_dzd: float = Form(...),
    user: User = role_required(Role.ADMIN, Role.Super_Admin, Role.USER),
):
    pdf_name = f"{uuid.uuid4().hex}_{file.filename}"
    pdf_url =  await document_bucket.put(file, object_name=pdf_name)

    image_urls = []
    for image in images:
        image_name = f"{uuid.uuid4().hex}_{image.filename}"
        image_url= await image_bucket.put(image, object_name=image_name)
        image_urls.append(image_url)

    material = await materialService.create_material(
        title=title,
        description=description,
        material_type=material_type,
        price_dzd=price_dzd,
        image_urls=image_urls,
        pdf_url=pdf_url,
    )
    return material



@router.head("/{file_url}/get_file")
@router.get("/{file_url}/get_file")
async def get_document(file_url: str):
    data, filename, content_type = await document_bucket.get(file_url)
    return StreamingResponse(
        content=iter([data]),
        media_type=content_type,
        headers={"Content-Disposition": f"inline; filename={filename}"}
    )

@router.head("/{file_url}/get_image")
@router.get("/{file_url}/get_image")
async def get_image(file_url: str):
    data, filename, content_type = await image_bucket.get(file_url)
    return StreamingResponse(
        content=iter([data]),
        media_type=content_type,
        headers={"Content-Disposition": f"inline; filename={filename}"}
    )

@router.get("/", response_model=List[Material])
async def get_all_materials_admin_paginated( user: User = role_required(Role.ADMIN, Role.Super_Admin), skip: int = 0, limit: int = 10):
    return await materialService.get_all_materials(skip, limit)


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


@router.delete("/{material_id}")
async def delete_material(material_id: str, user: User = role_required(Role.ADMIN, Role.Super_Admin)):
    success = await materialService.delete_material(material_id)
    if not success:
        raise HTTPException(status_code=404, detail="Material not found")
    return {"detail": "Material deleted"}


@router.get("/search/", response_model=List[Material])
async def search_by_title(q: str, user: User = role_required(Role.ADMIN, Role.Super_Admin, Role.USER)):
    return await materialService.search_materials_by_title(q)


@router.get("/filter/type", response_model=List[Material])
async def get_by_type(type: str, user: User = role_required(Role.ADMIN, Role.Super_Admin, Role.USER)):
    return await materialService.get_materials_by_type(type)


@router.get("/filter/date", response_model=List[Material], description="ISO format: yyyy-mm-dd")
async def get_by_date(date: str, user: User = role_required(Role.ADMIN, Role.Super_Admin, Role.USER)):  # ISO format: yyyy-mm-dd
    try:
        parsed = datetime.fromisoformat(date)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid date format")
    return await materialService.get_materials_by_date(parsed)
