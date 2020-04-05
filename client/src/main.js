import Vue from 'vue'
import VueRouter from 'vue-router'
import Buefy from 'buefy';
import VueAnalytics from 'vue-analytics';
import { library } from '@fortawesome/fontawesome-svg-core'
import { fab } from '@fortawesome/free-brands-svg-icons'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import App from './App.vue'
import Home from './components/Home.vue'
import RawDataList from './components/RawDataList.vue'
import Contact from './components/Contact.vue'
import About from './components/About.vue'
import baseApi from './plugins/base-api.js';
import Vuelidate from 'vuelidate'
import JsonCSV from 'vue-json-csv'

library.add(fas)
library.add(fab)
Vue.config.productionTip = false
Vue.config.devtools = true;
Vue.prototype.$http = baseApi;
Vue.component('font-awesome-icon', FontAwesomeIcon)
Vue.component('downloadCsv', JsonCSV)
Vue.use(Buefy);
Vue.use(VueRouter);
Vue.use(Vuelidate)

const routes = [
  {
    path: '*', redirect: '/'
  },
  {
    path: '/',
    component: Home,
  },
  {
    path: '/about',
    component: About,
  },
  {
    path: '/contact',
    component: Contact,
  },
  {
    path: '/coronavirus-data/countries',
    component: RawDataList, props: { nature: 'countries'},
  },
  {
    path: '/coronavirus-data/regions',
    component: RawDataList, props: { nature: 'regions'},
  },
]

const router = new VueRouter({
  mode: 'history',
  routes
})

new Vue({
  render: h => h(App),
  router
}).$mount('#app')

Vue.use(VueAnalytics, {
  id: 'UA-162208244-1',
  router
});