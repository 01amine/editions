# app/services/material.py

from app.models.material import Material
from typing import List, Optional
from beanie import PydanticObjectId
from datetime import datetime


class materialService:

    @staticmethod
    async def get_material_by_id(material_id: str) -> Optional[Material]:
        return await Material.get(material_id)

    @staticmethod
    async def create_material(
        title: str,
        description: str,
        file_url: str,
        material_type: str,
        price_dzd: float,
    ) -> Material:
        material = Material(
            title=title,
            description=description,
            file_url=file_url,
            material_type=material_type,
            price_dzd=price_dzd,
        )
        await material.insert()
        return material

    @staticmethod
    async def get_all_materials() -> List[Material]:
        return await Material.find_all().sort("-created_at").to_list()

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
    async def search_materials_by_title(keyword: str) -> List[Material]:
        return await Material.find(Material.title.regex(f".*{keyword}.*", "i")).to_list()

    @staticmethod
    async def get_materials_by_type(material_type: str) -> List[Material]:
        return await Material.find(Material.material_type == material_type).to_list()

    @staticmethod
    async def get_materials_by_date(date: datetime) -> List[Material]:
        return await Material.find(Material.created_at == date).to_list()