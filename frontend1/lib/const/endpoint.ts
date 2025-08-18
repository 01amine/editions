
export const API_ENDPOINTS = {
  AUTH: {
    LOGIN: '/users/login',
    LOGOUT: '/users/logout',
    ME: '/users/me',
    GET_USER : (userId: string) => `/users/get-user/${userId}`,
    ALL_STUDENTS: '/users/all-students',
  },
  APPOINTMENTS: {
    ROOT: '/appointements/',
    BY_ID: (id: string) => `/appointements/${id}`,
  },
  MATERIALS: {
    ROOT: '/materials/',
      GET_IMAGE: (fileId: string) => `materials/${fileId}/get_image`,
    GET_FILE: (fileId: string) => `materials/${fileId}/get_file`,


  },
  ORDERS: {
    ROOT: '/orders',
  
    BY_ID: (id: string) => `/orders/${id}`,
  },
} as const;