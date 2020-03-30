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
    
    <template slot="start">
      <b-navbar-item tag="router-link" v-bind:to="{ path: '/coronavirus-map' }">
        Home
      </b-navbar-item>
      <b-navbar-dropdown label="Raw data">
        <b-navbar-item tag="router-link" v-bind:to="{ path: '/coronavirus-data/countries' }">
          Countries
        </b-navbar-item>
        <b-navbar-item tag="router-link" v-bind:to="{ path: '/coronavirus-data/regions' }">
          Regions
        </b-navbar-item>
      </b-navbar-dropdown>
      <b-navbar-item tag="router-link" v-bind:to="{ path: '/about' }">
        About
      </b-navbar-item>
      <b-navbar-item href="https://github.com/mbatoul/coviz19" target='_blank'>
        Source code
      </b-navbar-item>
    </template>

    <template slot='end'>
      <b-button
        type="is-warning"
        tag="router-link" v-bind:to="{ path: '/coronavirus-trajectories' }"
      >
        See countries' trajectories
      </b-button>
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