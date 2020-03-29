import Vue from 'vue'
import VueRouter from 'vue-router'
import Buefy from 'buefy';
import { library } from '@fortawesome/fontawesome-svg-core'
import { fab } from '@fortawesome/free-brands-svg-icons'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import App from './App.vue'
import Home from './components/Home.vue'
import Trajectories from './components/Trajectories.vue'
import RawDataList from './components/RawDataList.vue'
import About from './components/About.vue'
import baseApi from './plugins/base-api.js';


library.add(fas)
library.add(fab)
Vue.config.productionTip = false
Vue.config.devtools = true;
Vue.prototype.$http = baseApi;
Vue.component('font-awesome-icon', FontAwesomeIcon)
Vue.use(Buefy);
Vue.use(VueRouter);

const routes = [
  { path: '*', redirect: '/' },
  { path: '/', component: Home },
  { path: '/about', component: About },
  { path: '/trajectories', component: Trajectories },
  { path: '/raw-data/countries', component: RawDataList, props: { nature: 'countries'} },
  { path: '/raw-data/regions', component: RawDataList, props: { nature: 'regions'} },
]

const router = new VueRouter({
  mode: 'history',
  routes
})

new Vue({
  render: h => h(App),
  router
}).$mount('#app')