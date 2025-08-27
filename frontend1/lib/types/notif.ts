export interface NotificationApi {
  _id: string;
  issent: boolean;
  message: string;
  user_id: {
    id: string;
    collection: string;
  };
  created_at: string; 
}

export type NotificationsApi = NotificationApi[];

export interface Notificationwa {
  id: string;
  isSent: boolean;
  message: string;
  user: {
    id: string;
    collection: string;
  };
  createdAt: Date;
}

export type Notificationswa = Notificationwa[];
