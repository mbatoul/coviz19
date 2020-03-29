<template>
  <div id="app">
    <TheNavbar />
    <router-view />
    <TheFooter />
    <b-modal :active.sync="isWelcomeModalActive" :width="640" scroll="keep">
      <div class="modal-background"></div>
      <div class="modal-card">
        <section class="modal-card-body">
          <button class="delete is-pulled-right" aria-label="close"></button>
          <div class="content is-medium">
            <img src="./assets/logo.png" width='200'>
            <p><strong>Coviz19</strong> is a visualization dashboard for COVID19 spread worldwide.</p>
            <p>The data is sourced from John Hopkins University and updated everyday around midnight.</p>
            <div class="subtitle is-4">Main features</div>
            <ul>
              <li>
                An <strong>interactive map</strong> and a set of charts allowing comparison of COVID19 impact accross multiple time period since Jan 22, 2020 in more than 250 countries and regions.
              </li>
              <li>
                <strong>News</strong> and <strong>tweets</strong> related to COVID19 in the selected regions.
              </li>
              <li>
                Charts focusing of the propagation of the virus 
              </li>
            </ul>
          </div>
        </section>
        <footer class="modal-card-foot">
          <button class="button is-primary is-pulled-right">Got it</button>
        </footer>
      </div>
    </b-modal>
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
}
</script>

<style>
  #app {
    font-family: Avenir, Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    color: #646464;
    background: #f1f4f6;
  }
</style>