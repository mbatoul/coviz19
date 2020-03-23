import axios from 'axios';

const baseApi = axios.create({
  baseURL: `${process.env.VUE_APP_BASE_API_BASE_URL}`
});

export default baseApi;