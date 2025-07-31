from app.models.appointemnt import Appointment
from datetime import datetime
from typing import List, Optional
from app.models.user import User
from app.models.Order import Order
from beanie import PydanticObjectId


class appointemntService:
    @staticmethod
    async def get_appointement_by_id(appointement_id: str) -> Optional[Appointment]:
        return await Appointment.get(appointement_id)

    @staticmethod
    async def create_appointement(student: User, admin: User, order: Order, scheduled_at: datetime, location: str) -> Appointment:
        appointement = Appointment(
            student=student,
            admin=admin,
            order=order,
            scheduled_at=scheduled_at,
            location=location,
        )
        await appointement.insert()
        return appointement

    @staticmethod
    async def get_all_appointement() -> List[Appointment]:
        return await Appointment.find_all().to_list()

    @staticmethod
    async def update_appointement(appointement_id: str, data: dict) -> Optional[Appointment]:
        appointement = await Appointment.get(appointement_id)
        if not appointement:
            return None
        for key, value in data.items():
            setattr(appointement, key, value)
        await appointement.save()
        return appointement

    @staticmethod
    async def delete_appointement(appointement_id: str) -> bool:
        appointement = await Appointment.get(appointement_id)
        if appointement:
            await appointement.delete()
            return True
        return False

    @staticmethod
    async def get_appointements_by_user(user_id: str) -> List[Appointment]:
        return await Appointment.find(Appointment.student.id == PydanticObjectId(user_id)).to_list()

    @staticmethod
    async def get_appointements_by_order(order_id: str) -> List[Appointment]:
        return await Appointment.find(Appointment.order.id == PydanticObjectId(order_id)).to_list()

    @staticmethod
    async def get_appointements_by_date(date: datetime) -> List[Appointment]:
        return await Appointment.find(Appointment.scheduled_at == date).to_list()

    @staticmethod
    async def get_appointements_by_location(location: str) -> List[Appointment]:
        return await Appointment.find(Appointment.location == location).to_list()
