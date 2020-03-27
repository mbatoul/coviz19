import Vue from 'vue'
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
Vue.use(Buefy);

new Vue({
  render: h => h(TheHome),
}).$mount('#app')