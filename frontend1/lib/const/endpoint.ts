export const API_ENDPOINTS = {
  AUTH: {
    LOGIN: '/users/login',
    LOGOUT: '/users/logout',
    ME: '/users/me',
    GET_USER : (userId: string) => `/users/get-user/${userId}`,
  },
  APPOINTMENTS: {
    ROOT: '/appointements/',
    BY_ID: (id: string) => `/appointements/${id}`,
  },
  MATERIALS: {
    ROOT: '/materials',
  },
} as const;