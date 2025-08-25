from fastapi import APIRouter, HTTPException
from datetime import datetime, date
from collections import defaultdict
from app.models.analytics import DashboardAnalytics, MaterialTypePercentage, MonthlyOrder, MonthlyRevenue, OrderStatusPercentage
from beanie import Document
from app.deps.auth import role_required
from app.models.user import Role, User
from app.models.order import Order, OrderStatus
from app.models.material import Material
from app.services.user import UserService
from app.services.Order import orderService
from app.services.material import materialService
from app.services.appointement import appointemntService
from app.models.appointemnt import Appointment


router = APIRouter(prefix="/dashboard", tags=["Dashboard"])

async def count_documents(model: Document) -> int:
    """Helper function to count all documents in a collection."""
    return await model.find_all().count()


@router.get("/analytics", response_model=DashboardAnalytics)
async def get_dashboard_analytics(
    user: User = role_required(Role.ADMIN, Role.Super_Admin)
) -> DashboardAnalytics:
    try:
        total_users = await count_documents(User)
        all_materials = await materialService.get_all_materials()
        all_orders = await orderService.get_all_orders()
        all_appointments = await appointemntService.get_all_appointement(skip=0, limit=1000)

        total_available_materials = len(all_materials)
        pending_orders = await orderService.get_all_orders(status=OrderStatus.PENDING)
        total_pending_orders = len(pending_orders)

        today = date.today()
        today_appointments = [
            a for a in all_appointments
            if a.scheduled_at and a.scheduled_at.date() == today
        ]
        total_today_appointments = len(today_appointments)

        order_status_counts = defaultdict(int)
        for order in all_orders:
            order_status_counts[order.status.value] += 1

        total_orders = len(all_orders)
        order_status_percentages = [
            OrderStatusPercentage(
                status=status,
                percentage=round((count / total_orders) * 100) if total_orders > 0 else 0
            )
            for status, count in order_status_counts.items()
        ]

        material_type_counts = defaultdict(int)
        for material in all_materials:
            if material.material_type in ["polycopie", "book"]:
                material_type_counts[material.material_type] += 1

        total_materials_for_chart = sum(material_type_counts.values())
        material_type_percentages = [
            MaterialTypePercentage(
                material_type=mat_type,
                percentage=round((count / total_materials_for_chart) * 100)
                if total_materials_for_chart > 0 else 0
            )
            for mat_type, count in material_type_counts.items()
        ]

        monthly_orders_map = defaultdict(int)
        monthly_revenue_map = defaultdict(float)

        current_year = datetime.now().year
        for order in all_orders:
            if order.created_at and order.created_at.year == current_year:
                month_name = order.created_at.strftime("%b")
                monthly_orders_map[month_name] += 1

                order_revenue = 0
                for material_link, quantity in order.item:
                    if material_link:
                        order_revenue += material_link.price_dzd * quantity
                monthly_revenue_map[month_name] += order_revenue

        monthly_orders = [
            MonthlyOrder(month=month, count=count)
            for month, count in monthly_orders_map.items()
        ]
        monthly_revenue = [
            MonthlyRevenue(month=month, revenue=revenue)
            for month, revenue in monthly_revenue_map.items()
        ]

        return DashboardAnalytics(
            total_users=total_users,
            total_available_materials=total_available_materials,
            total_pending_orders=total_pending_orders,
            total_today_appointments=total_today_appointments,
            order_status_percentages=order_status_percentages,
            material_type_percentages=material_type_percentages,
            monthly_orders=monthly_orders,
            monthly_revenue=monthly_revenue,
        )

    except Exception as e:
        print(f"An error occurred while generating dashboard analytics: {e}")
        raise HTTPException(
            status_code=500,
            detail="An error occurred while fetching dashboard analytics."
        )
