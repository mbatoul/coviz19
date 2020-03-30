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
  {
    path: '*', redirect: '/coronavirus-map'
  },
  {
    path: '/coronavirus-map',
    component: Home,
    meta: {
      title: 'Coviz19 | Visualization dashboard for coronavirus pandemic',
      metaTags: [
        {
          name: 'description',
          content: 'Coviz19 is a full-fledged visualization dashboard for coronavirus pandemic spread. Compare countries\'s trends and follow the latest updates.'
        },
        {
          property: 'og:url',
          content: 'https://www.coviz19.com/coronavirus-map'
        },
        {
          property: 'og:type',
          content: 'website'
        },
        {
          property: 'og:title',
          content: 'Coviz19 | Visualization dashboard for coronavirus pandemic'
        },
        {
          property: 'og:description',
          content: 'Coviz19 is a full-fledged visualization dashboard for coronavirus pandemic spread. Compare countries\'s trends and follow the latest updates.'
        },
        {
          property: 'og:image',
          content: 'https://coviz-19-bucket.s3.eu-west-3.amazonaws.com/coviz-dashboard.png'
        },
        {
          name: 'twitter:card',
          content: 'summary_large_image'
        },
        {
          name: 'twitter:title',
          content: 'Coviz19 | Visualization dashboard for coronavirus pandemic'
        },
        {
          name: 'twitter:description',
          content: 'Coviz19 is a full-fledged visualization dashboard for coronavirus pandemic spread. Compare countries\'s trends and follow the latest updates.'
        },
        {
          name: 'twitter:image',
          content: 'https://coviz-19-bucket.s3.eu-west-3.amazonaws.com/coviz-dashboard.png'
        },
      ]
    }
  },
  {
    path: '/about',
    component: About,
    meta: {
      title: 'Coviz19 | About | Learn about Coviz19',
      metaTags: [
        {
          name: 'description',
          content: 'Learn about Coviz19 and see how you can help. Coviz 19 is visualization dashboard for coronavirus pandemic spread.'
        },
        {
          property: 'og:url',
          content: 'https://www.coviz19.com/coronavirus-map'
        },
        {
          property: 'og:type',
          content: 'website'
        },
        {
          property: 'og:title',
          content: 'Coviz19 | About | Learn about Coviz19'
        },
        {
          property: 'og:description',
          content: 'Learn about Coviz19 and see how you can help. Coviz 19 is visualization dashboard for coronavirus pandemic spread.'
        },
        {
          property: 'og:image',
          content: 'https://coviz-19-bucket.s3.eu-west-3.amazonaws.com/coviz-dashboard.png'
        },
        {
          name: 'twitter:card',
          content: 'summary_large_image'
        },
        {
          name: 'twitter:title',
          content: 'Coviz19 | About | Learn about Coviz19'
        },
        {
          name: 'twitter:description',
          content: 'Learn about Coviz19 and see how you can help. Coviz 19 is visualization dashboard for coronavirus pandemic spread.'
        },
        {
          name: 'twitter:image',
          content: 'https://coviz-19-bucket.s3.eu-west-3.amazonaws.com/coviz-dashboard.png'
        },
      ]
    }
  },
  {
    path: '/coronavirus-trajectories',
    component: Trajectories,
    meta: {
      title: 'Coviz19 | Trajectories | Compare coronavirus spread among countries',
      metaTags: [
        {
          name: 'description',
          content: 'Up-to-date coronavirus map and charts to compare trends around the world.'
        },
        {
          property: 'og:url',
          content: 'https://www.coviz19.com/coronavirus-trajectories'
        },
        {
          property: 'og:type',
          content: 'website'
        },
        {
          property: 'og:title',
          content: 'Coviz19 | Trajectories | Compare coronavirus spread among countries'
        },
        {
          property: 'og:description',
          content: 'Up-to-date coronavirus map and charts to compare trends around the world.'
        },
        {
          property: 'og:image',
          content: 'https://coviz-19-bucket.s3.eu-west-3.amazonaws.com/coviz-trajectories.png'
        },
        {
          name: 'twitter:card',
          content: 'summary_large_image'
        },
        {
          name: 'twitter:title',
          content: 'Coviz19 | Trajectories | Compare coronavirus spread among countries'
        },
        {
          name: 'twitter:description',
          content: 'Up-to-date coronavirus map and charts to compare trends around the world.'
        },
        {
          name: 'twitter:image',
          content: 'https://coviz-19-bucket.s3.eu-west-3.amazonaws.com/coviz-trajectories.png'
        },
      ]
    }
  },
  {
    path: '/coronavirus-data/countries',
    component: RawDataList, props: { nature: 'countries'},
    meta: {
      title: 'Coviz19 | Countries | Access up-to-date coronavirus data around the world',
      metaTags: [
        {
          name: 'description',
          content: 'All the coronavirus data you need country by country'
        },
        {
          property: 'og:url',
          content: 'https://www.coviz19.com/coronavirus-data/countries'
        },
        {
          property: 'og:type',
          content: 'website'
        },
        {
          property: 'og:title',
          content: 'Coviz19 | Countries | Access up-to-date coronavirus data around the world'
        },
        {
          property: 'og:description',
          content: 'All the coronavirus data you need country by country.'
        },
        {
          property: 'og:image',
          content: 'https://coviz-19-bucket.s3.eu-west-3.amazonaws.com/coviz-dashboard.png'
        },
        {
          name: 'twitter:card',
          content: 'summary_large_image'
        },
        {
          name: 'twitter:title',
          content: 'Coviz19 | Countries | Access up-to-date coronavirus data around the world'
        },
        {
          name: 'twitter:description',
          content: 'All the coronavirus data you need country by country.'
        },
        {
          name: 'twitter:image',
          content: 'https://coviz-19-bucket.s3.eu-west-3.amazonaws.com/coviz-dashboard.png'
        },
      ]
    }
  },
  {
    path: '/coronavirus-data/regions',
    component: RawDataList, props: { nature: 'regions'},
    meta: {
      title: 'Coviz19 | Regions | Access up-to-date coronavirus data around the world',
      metaTags: [
        {
          name: 'description',
          content: 'All the coronavirus data you need region by region'
        },
        {
          property: 'og:url',
          content: 'https://www.coviz19.com/coronavirus-data/regions'
        },
        {
          property: 'og:type',
          content: 'website'
        },
        {
          property: 'og:title',
          content: 'Coviz19 | Regions | Access up-to-date coronavirus data around the world'
        },
        {
          property: 'og:description',
          content: 'All the coronavirus data you need region by region.'
        },
        {
          property: 'og:image',
          content: 'https://coviz-19-bucket.s3.eu-west-3.amazonaws.com/coviz-dashboard.png'
        },
        {
          name: 'twitter:card',
          content: 'summary_large_image'
        },
        {
          name: 'twitter:title',
          content: 'Coviz19 | Regions | Access up-to-date coronavirus data around the world'
        },
        {
          name: 'twitter:description',
          content: 'All the coronavirus data you need region by region.'
        },
        {
          name: 'twitter:image',
          content: 'https://coviz-19-bucket.s3.eu-west-3.amazonaws.com/coviz-dashboard.png'
        },
      ]
    }
  },
]

const router = new VueRouter({
  mode: 'history',
  routes
})

// This callback runs before every route change, including on page load.
router.beforeEach((to, from, next) => {
  // This goes through the matched routes from last to first, finding the closest route with a title.
  // eg. if we have /some/deep/nested/route and /some, /deep, and /nested have titles, nested's will be chosen.
  const nearestWithTitle = to.matched.slice().reverse().find(r => r.meta && r.meta.title);

  // Find the nearest route element with meta tags.
  const nearestWithMeta = to.matched.slice().reverse().find(r => r.meta && r.meta.metaTags);
  // const previousNearestWithMeta = from.matched.slice().reverse().find(r => r.meta && r.meta.metaTags);

  // If a route with a title was found, set the document (page) title to that value.
  if (nearestWithTitle) document.title = nearestWithTitle.meta.title;

  // Remove any stale meta tags from the document using the key attribute we set below.
  Array.from(document.querySelectorAll('[data-vue-router-controlled]')).map(el => el.parentNode.removeChild(el));

  // Skip rendering meta tags if there are none.
  if (!nearestWithMeta) return next();

  // Turn the meta tag definitions into actual elements in the head.
  nearestWithMeta.meta.metaTags.map(tagDef => {
    const tag = document.createElement('meta');

    Object.keys(tagDef).forEach(key => {
      tag.setAttribute(key, tagDef[key]);
    });

    // We use this to track which meta tags we create, so we don't interfere with other ones.
    tag.setAttribute('data-vue-router-controlled', '');

    return tag;
  })
    // Add the meta tags to the document head.
    .forEach(tag => document.head.appendChild(tag));

  next();
});

new Vue({
  render: h => h(App),
  router
}).$mount('#app')

Vue.use(VueAnalytics, {
  id: 'UA-162208244-1',
  router
});