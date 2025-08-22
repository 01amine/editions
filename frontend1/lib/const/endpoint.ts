
export const API_ENDPOINTS = {
  AUTH: {
    LOGIN: '/users/login',
    LOGOUT: '/users/logout',
    ME: '/users/me',
    GET_USER : (userId: string) => `/users/get-user/${userId}`,
    ALL_STUDENTS: '/users/all-students',
    ALL_USERS: '/users/all-users',
    ADD_ADMIN: (userId:string)=>`/users/add-admin/${userId}`,
    REMOVE_ADMIN: (userId:string)=>`/users/remove-admin/${userId}`,
    BLOCK_USER: (userId:string)=>`/users/block/${userId}`,
    UNBLOCK_USER: (userId:string)=>`/users/unblock/${userId}`,
  },
  APPOINTMENTS: {
    ROOT: '/appointements/',
    BY_ID: (id: string) => `/appointements/${id}`,
  },
  MATERIALS: {
    ROOT: '/materials/',

    GET_IMAGE: (fileId: string) => `materials/${fileId}/get_image`,
    GET_FILE: (fileId: string) => `materials/${fileId}/get_file`,
    BY_ID : (id: string) => `/materials/${id}`,
    BY_ID_ADMIN : (id: string) => `/materials/${id}/admin`,


  },
  ORDERS: {
    ROOT: '/orders',
    GET_ADMIN_ORDERS: "orders/get_admin_orders",
    ACCEPT_ORDER: (id: string) => `/orders/admin/${id}/accept`,
    REJECT_ORDER: (id: string) => `/orders/admin/${id}/reject`,
    Deleiver_ORDER: (id: string) => `/orders/admin/${id}/delivered`,
  
    BY_ID: (id: string) => `/orders/${id}`,
  },
} as const;