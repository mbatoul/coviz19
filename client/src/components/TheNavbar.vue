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
</style>