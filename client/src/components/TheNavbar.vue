<template>
  <b-navbar
    spaced
    v-bind:fixed-top='true'
  >
    <template slot="brand">
      <b-navbar-item tag="router-link" v-bind:to="{ path: '/coronavirus-map' }">
        <img
          src="../assets/logo.png"
          alt="Data visualization dashboard of COVID-19 spread"
          width='100'
        >
      </b-navbar-item>
    </template>
    
    <template slot="end">
      <b-navbar-dropdown label="Coronavirus data">
        <b-navbar-item tag="router-link" v-bind:to="{ path: '/coronavirus-data/countries' }">
          By countries
        </b-navbar-item>
        <b-navbar-item tag="router-link" v-bind:to="{ path: '/coronavirus-data/regions' }">
          By regions
        </b-navbar-item>
      </b-navbar-dropdown>

      <b-navbar-dropdown label="Share">
        <b-navbar-item href="https://www.facebook.com/sharer/sharer.php?u=#url" target="_blank">
          <font-awesome-icon
            v-bind:icon="['fab', 'facebook-square']"
            size='2x'
            style='margin-right: 15px;'
          />
          Facebook
        </b-navbar-item>
        <b-navbar-item href="https://twitter.com/intent/tweet?text=https://www.coviz19.com" target="_blank">
          
          <font-awesome-icon
            v-bind:icon="['fab', 'twitter-square']"
            size='2x'
            style='margin-right: 15px;'
          />
          Twitter
        </b-navbar-item>
        <b-navbar-item href='https://www.linkedin.com/sharing/share-offsite/?url=https%3A%2F%2Fwww.coviz19.com' target="_blank">
          <font-awesome-icon
            v-bind:icon="['fab', 'linkedin']"
            size='2x'
            style='margin-right: 15px;'
          />
          LinkedIn
        </b-navbar-item>
      </b-navbar-dropdown>

      <b-navbar-item tag="router-link" v-bind:to="{ path: '/about' }">
        About
      </b-navbar-item>
      <b-navbar-item tag="router-link" v-bind:to="{ path: '/contact' }">
        Contact
      </b-navbar-item>
    </template>
  </b-navbar>
</template>

<script>
export default {
  props: {
    lastUpdateDate: {
      type: String,
    }
  }
}
</script>

<style>
  .navbar {
    z-index: 10000 !important;
    border-bottom: 1px solid #EAEAEA;
  }

  .navbar-item .fa-facebook-square {
    color: #3b5998;
  }

  .navbar-item .fa-linkedin {
    color: #0072b1;
  }
</style>