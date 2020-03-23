import Vue from 'vue'
import Home from './Home.vue'
import VueRouter from 'vue-router'
import Buefy from 'buefy';
import { library } from '@fortawesome/fontawesome-svg-core'
import { fab } from '@fortawesome/free-brands-svg-icons'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import baseApi from './plugins/base-api.js';
import 'buefy/dist/buefy.css';

library.add(fas)
library.add(fab)
Vue.component('font-awesome-icon', FontAwesomeIcon)

Vue.config.productionTip = false
Vue.use(VueRouter)
Vue.use(Buefy);
Vue.prototype.$http = baseApi;

const routes = [
  { path: '*', redirect: '/map' },
  { path: '/', redirect: '/map' },
  {
    path: '/map',
    component: {
      template: '<Home />',
      components: { Home }
    }
  }
]

const router = new VueRouter({
  mode: 'history',
  routes
})

new Vue({
  render: h => h(Home),
  router
}).$mount('#app')