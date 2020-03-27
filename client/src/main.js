import Vue from 'vue'
import VueRouter from 'vue-router'
import Buefy from 'buefy';
import { library } from '@fortawesome/fontawesome-svg-core'
import { fab } from '@fortawesome/free-brands-svg-icons'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import baseApi from './plugins/base-api.js';
import 'buefy/dist/buefy.css';
import TheHome from './TheHome.vue'

library.add(fas)
library.add(fab)
Vue.config.productionTip = false
Vue.prototype.$http = baseApi;
Vue.component('font-awesome-icon', FontAwesomeIcon)
Vue.use(VueRouter)
Vue.use(Buefy);

const routes = [
  { path: '*', redirect: '/map' },
  { path: '/', redirect: '/map' },
  {
    path: '/map',
    component: {
      template: '<TheHome />',
      components: { TheHome }
    }
  }
]

const router = new VueRouter({
  mode: 'history',
  routes
})

new Vue({
  render: h => h(TheHome),
  router
}).$mount('#app')