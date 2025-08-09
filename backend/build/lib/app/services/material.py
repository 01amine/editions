from app.models.material import Material, materialUser
from typing import List, Optional
from datetime import datetime


class materialService:
    
    @staticmethod
    async def filter_materials_user(
        title: Optional[str] = None,
        material_type: Optional[str] = None,
        min_price: Optional[float] = None,
        max_price: Optional[float] = None,
        subject: Optional[str] = None,
        annee: Optional[str] = None,
        specialite: Optional[str] = None,
        date: Optional[datetime] = None,
        skip: int = 0,
        limit: int = 10
    ) -> List[materialUser]:
        materials = await materialService.filter_materials_admin(
            title=title,
            material_type=material_type,
            min_price=min_price,
            max_price=max_price,
            subject=subject,
            annee=annee,
            specialite=specialite,
            date=date,
            skip=skip,
            limit=limit
        )
        return [materialUser(**m.model_dump()) for m in materials]
    
    
    @staticmethod
    async def filter_materials_admin(
        title: Optional[str] = None,
        material_type: Optional[str] = None,
        min_price: Optional[float] = None,
        max_price: Optional[float] = None,
        date: Optional[datetime] = None,
        subject: Optional[str] = None,
        annee: Optional[str] = None,
        specialite: Optional[str] = None,
        skip: int = 0,
        limit: int = 10
    ) -> List[Material]:
        query = {}

        if title:
            query["title"] = {"$regex": f".*{title}.*", "$options": "i"}

        if material_type:
            query["material_type"] = material_type

        if min_price is not None or max_price is not None:
            query["price_dzd"] = {}
            if min_price is not None:
                query["price_dzd"]["$gte"] = min_price
            if max_price is not None:
                query["price_dzd"]["$lte"] = max_price
        if subject:
            query["module"] = subject
        if annee:
            query["study_year"] = annee
        if specialite:
            query["specialite"] = specialite
        if date:
            query["created_at"] = date

        return await Material.find(query).sort("-created_at").skip(skip).limit(limit).to_list()
    @staticmethod
    async def get_all_material_user(skip: int = 0, limit: int = 10) -> List[materialUser]:
        material= await Material.find_all().sort("-created_at").to_list()
        return [materialUser(**m.model_dump()) for m in material]
        

    @staticmethod
    async def get_material_by_id(material_id: str) -> Optional[Material]:
        return await Material.get(material_id)

    @staticmethod
    async def create_material(
        title: str,
        description: str,
        pdf_url: str,
        image_urls: List[str],
        material_type: str,
        price_dzd: float,
    ) -> Material:
        material = Material(
            
            title=title,
            description=description,
            image_urls=image_urls,
            pdf_url=pdf_url,
            material_type=material_type,
            price_dzd=price_dzd,
        )
        await material.insert()
        return material

    @staticmethod
    async def get_all_materials( skip: int = 0, limit: int = 10) -> List[Material]:
        return await Material.find_all().sort("-created_at").to_list()
    
    @staticmethod
    async def get_materiel_for_user(skip: int = 0, limit: int = 10) -> List[materialUser]:
       materials = await Material.find_all().sort("-created_at").to_list()
       return [materialUser(**m.model_dump()) for m in materials]
   
    @staticmethod
    async def get_all_materials_by_type(material_type: str) -> List[Material]:
        return await Material.find(Material.material_type == material_type).to_list()
    

    @staticmethod
    async def update_material(material_id: str, data: dict) -> Optional[Material]:
        material = await Material.get(material_id)
        if not material:
            return None
        for key, value in data.items():
            setattr(material, key, value)
        await material.save()
        return material

    @staticmethod
    async def delete_material(material_id: str) -> bool:
        material = await Material.get(material_id)
        if material:
            await material.delete()
            return True
        return False

    @staticmethod
    async def search_materials_by_title(keyword: str) -> List[materialUser]:
        material= await Material.find(Material.title.regex(f".*{keyword}.*", "i")).to_list()
        return [materialUser(**m.model_dump()) for m in material]
    
    @staticmethod
    async def search_material_admin(keyword: str) -> List[Material]:
        return await Material.find(Material.title.regex(f".*{keyword}.*", "i")).to_list()

    @staticmethod
    async def get_materials_by_type_admin(material_type: str) -> List[Material]:
        return await Material.find(Material.material_type == material_type).to_list()
    
    @staticmethod
    async def get_materials_user(material_type: str) -> List[materialUser]:
        material= await Material.find(Material.material_type == material_type).to_list()
        return [materialUser(**m.model_dump()) for m in material]

    @staticmethod
    async def get_materials_by_date(date: datetime) -> List[Material]:
        return await Material.find(Material.created_at == date).to_list()