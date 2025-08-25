export interface DashboardAnalytics {
  total_users: number;
  total_available_materials: number;
  total_pending_orders: number;
  total_today_appointments: number;

  order_status_percentages: OrderStatusPercentage[];
  material_type_percentages: MaterialTypePercentage[];
  monthly_orders: MonthlyOrder[];
  monthly_revenue: MonthlyRevenue[];
}

export interface OrderStatusPercentage {
  status: string;
  percentage: number;
}

export interface MaterialTypePercentage {
  material_type: string;
  percentage: number;
}

export interface MonthlyOrder {
  month: string;  // e.g. "Jan", "Feb"
  count: number;
}

export interface MonthlyRevenue {
  month: string;  // e.g. "Jan", "Feb"
  revenue: number;
}
