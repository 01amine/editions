"use client";

import React from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Notificationwa } from "@/lib/types/notif";
import { useNotifications } from "@/hooks/queries/usenotif";
import { Loading } from "@/components/ui/loading";
import { DataError } from "@/components/ui/error";



export default function NotificationsList() {
  const { data: hookNotifications, isLoading, isError } = useNotifications();
  const notifications =   hookNotifications ?? [];

  if (isLoading) {
    return <Loading type="spinner" className="p-8" />;
  }

  if (isError) {
    return (
      <DataError 
        error={null}
        onRetry={() => window.location.reload()}
        title="Erreur de chargement des notifications"
        message="Impossible de charger les notifications. Veuillez réessayer."
      />
    );
  }

  if (!notifications || notifications.length === 0) {
    return <div className="p-4 text-sm text-gray-500">Aucune notification.</div>;
  }

  return (
    <div className="space-y-4">
      {notifications.map((notification) => {
        const title = notification.message.split("\n")[0].slice(0, 60) || "Notification";
        const isNew = !notification.isSent; 

        return (
          <Card
            key={notification.id}
            className={`${isNew ? "border-l-4 border-l-blue-500" : ""}`}
          >
            <CardContent className="p-4">
              <div className="flex items-start justify-between">
                <div className="flex-1 pr-4">
                  <h3 className="font-semibold text-sm mb-1">{title}</h3>
                  <p className="text-sm text-gray-600 mb-2">{notification.message}</p>
                  <div className="flex items-center gap-3">
                    <p className="text-xs text-gray-400">
                      {notification.createdAt instanceof Date
                        ? notification.createdAt.toLocaleString("fr-FR")
                        : new Date(notification.createdAt).toLocaleString("fr-FR")}
                    </p>
                    <p className="text-xs text-gray-400">• user: {notification.user.id}</p>
                    <p className="text-xs text-gray-400">• {notification.user.collection}</p>
                  </div>
                </div>

                <div className="flex-shrink-0 flex flex-col items-end">
                  {isNew && <Badge variant="default" className="ml-4">Nouveau</Badge>}
                </div>
              </div>
            </CardContent>
          </Card>
        );
      })}
    </div>
  );
}
