export const API_ENDPOINTS = {
  AUTH: {
    LOGIN: '/users/login',
    LOGOUT: '/users/logout',
    ME: '/users/me',
  },
  APPOINTMENTS: {
    ROOT: '/appointments/',
    BY_ID: (id: string) => `/appointments/${id}`,
  },
  MATERIALS: {
    ROOT: '/materials',
  },
} as const;