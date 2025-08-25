"use client";

import { getNotifications } from "@/lib/api/notif";
import { NotificationApi, Notificationwa } from "@/lib/types/notif";
import { useQuery, UseQueryOptions, UseQueryResult } from "@tanstack/react-query";

const normalizeNotification = (notification: NotificationApi): Notificationwa => {
  return {
    id: notification._id,
    isSent: Boolean(notification.issent),
    message: notification.message,
    user: {
      id: notification.user_id.id,
      collection: notification.user_id.collection,
    },
    createdAt: new Date(notification.created_at),
  };
};

export function useNotifications(
  options?: Omit<UseQueryOptions<Notificationwa[], Error>, "queryKey" | "queryFn">
): UseQueryResult<Notificationwa[], Error> {
  return useQuery<Notificationwa[], Error, Notificationwa[]>({
    queryKey: ["notifications"],
    queryFn: async () => {
      const apiData = await getNotifications(); 
      if (!Array.isArray(apiData) || apiData.length === 0) return [];

      return (apiData as NotificationApi[]).map((notif) => normalizeNotification(notif));
    },
    staleTime: 1000 * 60, 
    refetchOnWindowFocus: false,
    ...options,
  });
}
