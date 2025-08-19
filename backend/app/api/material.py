from datetime import datetime
from fastapi import APIRouter, Query, UploadFile, File, Form,  HTTPException
from typing import List, Optional
from fastapi.responses import StreamingResponse
from app.services.material import materialService
from app.models.material import Material, materialUser
from app.models.user import Role, User
from app.deps.auth import role_required
import uuid
from app.minio import DocumentBucket, ImageBucket

router = APIRouter(prefix="/materials", tags=["Materials"])



image_bucket = ImageBucket(file_prefix="materials/images")
document_bucket = DocumentBucket(file_prefix="materials/documents")


@router.get("/filter/user", response_model=List[materialUser])
async def get_materials_user(
    title: Optional[str] = Query(None),
    material_type: Optional[str] = Query(None),
    min_price: Optional[float] = Query(None),
    max_price: Optional[float] = Query(None),
    date: Optional[datetime] = Query(None),
    subject: Optional[str] = Query(None),
    annee: Optional[str] = Query(None),
    specialite: Optional[str] = Query(None),
    skip: int = 0,
    limit: int = 10,
):
    return await materialService.filter_materials_user(
        title=title,
        material_type=material_type,
        min_price=min_price,
        max_price=max_price,
        date=date,
        annee=annee,
        subject=subject,
        specialite=specialite,
        skip=skip,
        limit=limit,
    )
    
@router.post("/", response_model=Material)
async def create_material(
    file: UploadFile = File(...), 
    images: List[UploadFile] = File(...), 
    title: str = Form(...),
    description: str = Form(...),
    material_type: str = Form(...),
    price_dzd: float = Form(...),
    study_year: str = Form(...), 
    specialite: str = Form(...),
    module: Optional[str] = Form(None), 
    user: User = role_required(Role.ADMIN, Role.Super_Admin),
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
        study_year=study_year, 
        specialite=specialite,
        module=module,
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

@router.get("/get-all/user", response_model=List[materialUser])
async def get_all_materials_user(user: User = role_required(Role.ADMIN, Role.Super_Admin, Role.USER)):
    materials = await materialService.get_all_materials()
    if not materials:
        raise HTTPException(status_code=404, detail="Materials not found")
    return [materialUser.model_validate(m, from_attributes=True) for m in materials]



@router.get("/", response_model=List[Material])
async def get_all_materials_admin_paginated( user: User = role_required(Role.ADMIN, Role.Super_Admin), skip: int = 0, limit: int = 10):
    return await materialService.get_all_materials(skip, limit)


# @router.get("/", response_model=List[materialUser])
# async def get_all_materials_user_paginated(user: User = role_required(Role.ADMIN, Role.Super_Admin, Role.USER), skip: int = 0, limit: int = 10):
#     return await materialService.get_all_materials_user(skip, limit)







@router.get("/search/admin", response_model=List[Material])
async def search_by_title(q: str, user: User = role_required(Role.ADMIN, Role.Super_Admin, Role.USER)):
    return await materialService.search_materials_by_title(q)


@router.get("/filter/type/admin", response_model=List[Material])
async def get_by_type(type: str, user: User = role_required(Role.ADMIN, Role.Super_Admin, Role.USER)):
    return await materialService.get_materials_by_type(type)

@router.get("/filter/admin", response_model=List[Material])
async def get_materials_admin(
    title: Optional[str] = Query(None),
    material_type: Optional[str] = Query(None),
    
    min_price: Optional[float] = Query(None),
    max_price: Optional[float] = Query(None),
    date: Optional[datetime] = Query(None),
    skip: int = 0,
    limit: int = 10,
    user: User = role_required(Role.ADMIN, Role.Super_Admin),
):
    return await materialService.filter_materials_admin(
        title=title,
        material_type=material_type,
        min_price=min_price,
        max_price=max_price,
        date=date,
        skip=skip,
        limit=limit,
    )


@router.get("/filter/date/admin", response_model=List[Material], description="ISO format: yyyy-mm-dd")
async def get_by_date(date: str, user: User = role_required(Role.ADMIN, Role.Super_Admin, Role.USER)):  # ISO format: yyyy-mm-dd
    try:
        parsed = datetime.fromisoformat(date)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid date format")
    return await materialService.get_materials_by_date(parsed)


@router.delete("/{material_id}")
async def delete_material(
    material_id: str,
    user: User = role_required(Role.ADMIN, Role.Super_Admin),
):
    material = await materialService.get_material_by_id(material_id)
    if not material:
        raise HTTPException(status_code=404, detail="Material not found")

    if material.pdf_url:
        try:
            await document_bucket.delete(material.pdf_url)
        except Exception as e:
            raise HTTPException(status_code=500, detail="Failed to delete PDF")

    if material.image_urls:
        for image_url in material.image_urls:
            try:
                await image_bucket.delete(image_url)
            except Exception as e:
                raise HTTPException(status_code=500, detail="Failed to delete image")

    success = await materialService.delete_material(material_id)
    if not success:
        raise HTTPException(status_code=500, detail="Failed to delete material")

    return {"detail": "Material and associated files deleted"}


@router.patch("/{material_id}", response_model=Material)
async def update_material(
    material_id: str,
    file: Optional[UploadFile] = File(None),  
    images: Optional[List[UploadFile]] = File(None), 
    title: Optional[str] = Form(None),
    description: Optional[str] = Form(None),
    material_type: Optional[str] = Form(None),
    price_dzd: Optional[float] = Form(None),
    year_study: Optional[str] = Form(None),
    specialite: Optional[str] = Form(None),
    module: Optional[str] = Form(None),
    existing_image_urls: Optional[List[str]] = Form(None),
    remove_pdf: Optional[bool] = Form(False),
    
    user: User = role_required(Role.ADMIN, Role.Super_Admin),
):
    material_to_update = await materialService.get_material_by_id(material_id)
    if not material_to_update:
        raise HTTPException(status_code=404, detail="Material not found")
        
    updates = {}

    if title is not None:
        updates["title"] = title
    
    if description is not None:
        updates["description"] = description

    if material_type is not None:
        updates["material_type"] = material_type

    if price_dzd is not None:
        updates["price_dzd"] = price_dzd

    if year_study is not None:
        updates["study_year"] = year_study

    if specialite is not None:
        updates["specialite"] = specialite

    if module is not None:
        updates["module"] = module


    if remove_pdf:
        if material_to_update.pdf_url:
            await document_bucket.delete(material_to_update.pdf_url)
        updates["pdf_url"] = None
    elif file:
        # If a new PDF file is uploaded, delete the old one first
        if material_to_update.pdf_url:
            await document_bucket.delete_by_url(material_to_update.pdf_url)
        pdf_name = f"{uuid.uuid4().hex}_{file.filename}"
        pdf_url = await document_bucket.put(file, object_name=pdf_name)
        updates["pdf_url"] = pdf_url

    current_image_urls = material_to_update.image_urls or []
    final_image_urls = []

    if existing_image_urls is not None:
        final_image_urls = existing_image_urls
    
    removed_images = set(current_image_urls) - set(final_image_urls)
    for image_url in removed_images:
        object_name = image_url.split('/')[-1] 
        await image_bucket.delete(object_name)

    if images:
        for image in images:
            image_name = f"{uuid.uuid4().hex}_{image.filename}"
            image_url = await image_bucket.put(image, object_name=image_name)
            final_image_urls.append(image_url)

    updates["image_urls"] = final_image_urls
    material = await materialService.update_material(material_id, updates)
    
    if not material:
        raise HTTPException(status_code=404, detail="Material not found after update")
        
    return material

@router.get("/{material_id}/user", response_model=materialUser)
async def get_material_by_id_user(material_id: str, user: User = role_required(Role.ADMIN, Role.Super_Admin, Role.USER)):
    material = await materialService.get_material_by_id(material_id)
    if not material:
        raise HTTPException(status_code=404, detail="Material not found")
    return materialUser(**material.model_dump(by_alias=True))


@router.get("/{material_id}/admin", response_model=Material)
async def get_material_by_id(material_id: str, user: User = role_required(Role.ADMIN, Role.Super_Admin)):
    material = await materialService.get_material_by_id(material_id)
    if not material:
        raise HTTPException(status_code=404, detail="Material not found")
    return material
