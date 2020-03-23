import axios from 'axios';

const newsApi = axios.create({
  baseURL: `${process.env.VUE_APP_NEWS_API_BASE_URL}`,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'x-rapidapi-host': process.env.VUE_APP_RAPID_API_HOST,
    'x-rapidapi-key': process.env.VUE_APP_RAPID_API_KEY
  }
});

export default newsApi;