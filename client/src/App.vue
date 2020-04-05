<template>
  <div id="app">
    <TheNavbar v-on:toggle-modal='isWelcomeModalActive = true'/>
    <b-modal :active.sync="isWelcomeModalActive">
      <div class="box">
        <div class="content has-text-centered">

          <img
            src="./assets/logo.png"
            alt="Data visualization dashboard of COVID-19 spread"
            width='150'
          >
          <h1 class="subtitle is-6 has-text-grey">
            Compare countries's trends and follow the latest updates
          </h1>
        </div>
        <div class="img-container">
          <img src="https://coviz-19-bucket.s3.eu-west-3.amazonaws.com/coviz-dashboard.png" class='modal-image'>
        </div>
        <div class="content">
          <p>Coviz19 is a real-time visualization dashboard for coronavirus spread. The data we used is published by the <a href="https://github.com/CSSEGISandData/COVID-19" target='_blank'>Johns Hopkins Center for Systems Science and Engineering (CSSE)</a>.</p>
          <div class="has-text-weight-bold">Interactive map</div>
          <ul>
            <li>Select up to 10 countries or regions simultaneously <strong>directly on map</strong></li>
            <li>Choose between the 4 categories available (active cases, total confirmed, total deaths and total recovered)</li>
          </ul>
          <div class="has-text-weight-bold">Visualization options</div>
          <ul>
            <li>Use the <strong>search field</strong> to find countries and regions or toggle <strong>World only</strong> to show data at a global scale</li>
            <li>Choose between the <strong>Trajectories</strong> and <strong>Cumulative</strong> visualization modes to get different insights</li>
            <li>Use <strong>linear</strong> or <strong>logarithmic</strong> scale</li>
          </ul>
          <div class="has-text-weight-bold">News</div>
          <ul>
            <li>Get the <strong>latest news and tweets in the countries you selected</strong></li>
          </ul>
          <div class="has-text-weight-bold">Coravirus data</div>
          <ul>
            <li>Download the raw coronavirus data in a spreadsheet</li>
          </ul>
          <div class="button-container">
            <b-button class='is-primary' v-on:click='isWelcomeModalActive = false'>See dashboard</b-button>
          </div>
        </div>
      </div>
    </b-modal>
    <router-view />
    <TheFooter />
  </div>
</template>

<script>
import TheNavbar from './components/TheNavbar.vue';
import TheFooter from './components/TheFooter.vue';

export default {
  components: {
    TheNavbar,
    TheFooter
  },

  data () {
    return {
      isWelcomeModalActive: false
    }
  },

  mounted () {
    const hasSeenPopinCookie = this.$cookies.get('hasSeenPopin');
    if (hasSeenPopinCookie === null) {
      this.isWelcomeModalActive = true
      let expirationDate = new Date;
      expirationDate.setDate(expirationDate.getDate() + 7);
      this.$cookies.set('hasSeenPopin', 'true', expirationDate);
    }
  }
}
</script>

<style>
  #app {
    font-family: Helvetica, Avenir, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    color: #1c2022;
    background: #f1f4f6;
  }

  .fade-enter-active, .fade-leave-active {
    transition: opacity 1s;
  }

  .fade-enter, .fade-leave-to {
    opacity: 0;
  }

  .modal-content, .modal-card {
    max-height: calc(100vh -10px) !important;
  }
</style>

<style scoped>
  .img-container {
    max-width: 450px;
    margin: 0 auto;
    margin-bottom: 1em;
  }

  .img-container img {
    width: 100%;
    box-shadow: 0px 10px 20px 0px rgba(0,108,86,0.2);
  }

  .button-container {
    display: flex;
    justify-content: right;
  }
</style>