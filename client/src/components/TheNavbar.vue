<template>
  <b-navbar
    spaced
    v-bind:fixed-top='true'
  >
    <template slot="brand">
      <b-navbar-item>
        <img
          src="../assets/logo.png"
          alt="Data visualization dashboard of COVID-19 spread"
          width='100'
        >
      </b-navbar-item>
    </template>
    
    <template slot="start">
      <b-navbar-item href="#">
        Home
      </b-navbar-item>
      <b-navbar-item href="#">
        API
      </b-navbar-item>
      <b-navbar-item href="#">
        Countries
      </b-navbar-item>
      <b-navbar-item href="#">
        Regions
      </b-navbar-item>
      <b-navbar-item href="#">
        About
      </b-navbar-item>
      <b-navbar-item href="#">
        Contact
      </b-navbar-item>
    </template>
  </b-navbar>
</template>

<style>
  .navbar {
    z-index: 10000 !important;
    border-bottom: 1px solid #EAEAEA;
  }
</style>