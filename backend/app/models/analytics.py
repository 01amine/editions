
from typing import List
from pydantic import BaseModel

class OrderStatusPercentage(BaseModel):
    status: str
    percentage: int


class MaterialTypePercentage(BaseModel):
    material_type: str
    percentage: int


class MonthlyOrder(BaseModel):
    month: str
    count: int


class MonthlyRevenue(BaseModel):
    month: str
    revenue: float


class DashboardAnalytics(BaseModel):
    total_users: int
    total_available_materials: int
    total_pending_orders: int
    total_today_appointments: int

    order_status_percentages: List[OrderStatusPercentage]
    material_type_percentages: List[MaterialTypePercentage]
    monthly_orders: List[MonthlyOrder]
    monthly_revenue: List[MonthlyRevenue]