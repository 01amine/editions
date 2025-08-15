import axios from 'axios';

const client = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL,
  withCredentials: true,
  timeout: 10000,
});

client.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response) {
      console.error(`HTTP ${error.response.status}:`, error.response.data);
    } else if (error.request) {
      console.error('No response from server:', error.message);
    } else {
      console.error('Axios config error:', error.message);
    }

    return Promise.reject({
      message: error?.response?.data?.message || 'Unexpected error occurred',
      status: error?.response?.status || null,
      data: error?.response?.data || null,
    });
  }
);

export default client;
