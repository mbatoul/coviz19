<template>
  <b-navbar
    spaced
    v-bind:fixed-top='true'
  >
    <template slot="brand">
      <b-navbar-item tag="router-link" :to="{ path: '/map' }">
        <img
          src="../assets/logo.png"
          alt="Data visualization dashboard of COVID-19 spread"
          width='100'
        >
      </b-navbar-item>
      </template>
      <template slot="start">
        <b-navbar-item href="#">
          Documentation
        </b-navbar-item>
        <b-navbar-dropdown label="Info">
          <b-navbar-item href="#">
            About
          </b-navbar-item>
          <b-navbar-item href="#">
            Contact
          </b-navbar-item>
        </b-navbar-dropdown>
      </template>
  </b-navbar>
</template>

<style>
  .navbar {
    z-index: 10000 !important;
    border-bottom: 1px solid #EAEAEA;
  }
</style>