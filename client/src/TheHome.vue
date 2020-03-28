<template>
  <div id="app">
    <div class="container is-fluid is-marginless">
      <TheNavbar />
      <div class="columns is-desktop is-marginless">
        <div class="column is-two-fifths is-paddingless left-side">
          <div class="column-inner">
            <div class="categories-container">
              <CategoriesBar
                v-bind:currentCategory='currentCategory'
                v-bind:totalDeath='totalDeath'
                v-bind:totalConfirmed='totalConfirmed'
                v-bind:totalRecovered='totalRecovered'
                v-bind:isLoading='isLoading'
                v-on:categorySelected='updateCurrentCategory'
              />
            </div>
          
            <TheMap
              v-bind:currentCategory='currentCategory'
              v-bind:ceilings='ceilings'
              v-bind:selectedZones='selectedZones'
              v-bind:selectedZonesNames='selectedZonesNames'
              v-bind:zonesWithMarkers='zonesWithMarkers'
              v-bind:isWorldSelected='isWorldSelected'
              v-bind:isMultipleSelectionActive.sync='isMultipleSelectionActive'
              v-on:zoneSelected='onZoneSelectedFromMap'
              v-on:zoneRemoved='onZoneRemoved'
            />
            <div
              class="multiple-selection"
              v-bind:class="{ 'active': isMultipleSelectionActive}"
            >
              <div class="field">
                <b-checkbox
                  size="is-medium"
                  type='is-white'
                  v-model='isMultipleSelectionActive'
                >
                  Multiple selection
                </b-checkbox>
              </div>
            </div>
          </div>
        </div>

        <div class="column has-padding-large">
          <div class="columns is-desktop is-multiline">
            <!-- options -->
            <div
              class="column chart-column"
              v-bind:class="chartColumnClasses"
            >
              <div class="box options">
                <div class="information-section">
                  <div class="content">
                    <label class="label">
                      Instructions
                    </label>
                    <ul>
                      <li>
                        Select up to 5 zones, using the field below or the multiple selection mode on the map
                      </li>
                      <li>
                        Choose a time period between January 22, 2020 and today
                      </li>
                    </ul>
                  </div>

                </div>
                <div class="options-section">
                  <div class="field">
                    <label class="label">Change layout</label>
                    <label class="label"></label>
                      <button
                        class="button is-info"
                        v-on:click='toggleLayout'
                        v-if='fullWidthMode'
                      >
                        Grid
                      </button>
                      <button
                        class="button is-info"
                        v-on:click='toggleLayout'
                        v-else
                      >
                        Full-width
                      </button>
                  </div>
                  <div
                    class='field multiselect-zones'
                    v-bind:class="{ 'high': !fullWidthMode }"
                  >
                    <label class="label">Zones</label>
                    <div class="field-body">
                      <div class="field multiselect-field">
                        <b-field>
                          <Multiselect
                            placeholder="Select one or multiple zones..."
                            label='name'
                            track-by='kebab_name'
                            v-on:select='onZoneSelectedFromField'
                            v-on:remove='onZoneRemoved'
                            v-bind:value='arrayOfSelectedZones'
                            v-bind:options='arrayOfAllZones'
                            v-bind:multiple='true'
                            v-bind:taggable='true'
                            v-bind:close-on-select='true'
                            v-bind:loading='isLoading'
                            class='is-danger'
                          />
                        </b-field>
                      </div>
                    </div>
                    <span v-if='selectedZonesNames.length > 4' class='error has-text-danger'>Max. number of zones selected</span>
                  </div>
                  
                  <div class="field">
                    <label class="label">Time period</label>
                    
                    <div class="field-body">
                      <div class="field">
                        <b-field class='field is-horizontal'>
                          <b-datepicker
                            placeholder="Click to select..."
                            v-model="dates"
                            v-bind:min-date='minDate'
                            v-bind:max-date='maxDate'
                            class='is-small'
                            range>
                          </b-datepicker>
                        </b-field>
                      </div>
                    </div>
                  </div>
                  <div class="buttons">
                    <button
                      class="button is-info"
                      v-on:click='updateDates(pastWeekDates)'
                    >
                      Past week
                    </button>
                    <button
                      class="button is-info"
                      v-on:click='updateDates(pastMonthDates)'
                    >
                      Past month
                    </button>
                    <button
                      class="button is-success"
                      v-on:click='updateDates([minDate, maxDate])'
                    >
                      Full period
                    </button>
                  </div>
                </div>
              </div>

            </div>
             <!-- confirmed -->
            <div
              class="column chart-column"
              v-bind:class="chartColumnClasses"
            >
              <div class="chart-container">
                <div
                  class='loading small'
                  v-if='confirmedChartData === null'>
                </div>
                <LineChart
                v-else
                  v-bind:data='confirmedChartData'
                  v-bind:options="chartOptions('Confirmed')"
                  v-bind:key='chartConfirmedKey'
                />
              </div>
            </div>
            <!-- deaths -->
            <div
              class="column chart-column"
              v-bind:class="chartColumnClasses"
            >
              <div class="chart-container">
                <div
                  class='loading small'
                  v-if='deathChartData === null'>
                </div>
                <div v-else>
                  <LineChart
                    v-bind:data='deathChartData'
                    v-bind:options="chartOptions('Deaths')"
                    v-bind:key='chartDeathKey'
                  />
                </div>
              </div>
            </div>
            <!-- recovered -->
            <div
              class="column chart-column"
              v-bind:class="chartColumnClasses"
            >
              <div class="chart-container">
                <div
                  class='loading small'
                  v-if='recoveredChartData === null'>
                </div>
                <div v-else>
                  <LineChart
                    v-bind:data='recoveredChartData'
                    v-bind:options="chartOptions('Recovered')"
                    v-bind:key='chartRecoveredKey'
                  />
                </div>
              </div>
            </div>
            <!-- news -->
            <div class="column is-half">
              <div class="media-header flexbox">
                <font-awesome-icon
                  v-bind:icon="['fas', 'newspaper']"
                  size='2x'
                />
                <p class="subtitle has-text-weight-bold is-5">News</p>
              </div>
              <div class="box">
                <div class="news-container scrollable">
                  <NewsList
                    v-bind:country="''"
                  />
                </div>
              </div>

            </div>
            <!-- tweets -->
            <div class="column is-half">
              <div class="media-header flexbox">
                <font-awesome-icon
                  v-bind:icon="['fab', 'twitter-square']"
                  size='2x'
                />
                <p class="subtitle has-text-weight-bold is-5">Tweets</p>
              </div>
              <div class="box">
                <div class="tweets-container scrollable">
                  <TweetsList
                    v-bind:selectedZonesNames='selectedZonesNames'
                  />
                </div>
              </div>

            </div>
          </div>
        </div>
      </div>
    </div>
    <TheFooter />
  </div>
</template>

<script>
import TheNavbar from './components/TheNavbar.vue';
import CategoriesBar from './components/CategoriesBar.vue';
import Multiselect from 'vue-multiselect';
import TheMap from './components/TheMap.vue';
import NewsList from './components/NewsList.vue';
import TweetsList from './components/TweetsList.vue';
import LineChart from './components/LineChart.vue';
import TheFooter from './components/TheFooter.vue';
import StringFormatter from './mixins/string-formatter.js';
import 'vue-multiselect/dist/vue-multiselect.min.css';

export default {
  components: {
    TheNavbar,
    CategoriesBar,
    Multiselect,
    TheMap,
    NewsList,
    TweetsList,
    LineChart,
    TheFooter,
  },

  mixins: [
    StringFormatter
  ],

  data () {
    return {
      isLoading: false,
      totalDeath: null,
      totalConfirmed: null,
      totalRecovered: null,
      currentCategory: 'confirmed',
      dates: [new Date(2020, 0, 22), new Date()],
      minDate: new Date(2020, 0, 22),
      maxDate: new Date(),
      zones: {},
      selectedZonesNames: [],
      ceilings: {},
      isMultipleSelectionActive: false,
      deathChartData: null,
      confirmedChartData: null,
      recoveredChartData: null,
      fullWidthMode: false,
      chartConfirmedKey: 0,
      chartDeathKey: 0,
      chartRecoveredKey: 0,
    }
  },

  computed: {
    selectedZones: function () {
      return Object.keys(this.zones)
        .filter(kebabName => this.selectedZonesNames.includes(kebabName))
        .reduce((selectedZones, kebabName) => {
          selectedZones[kebabName] = this.zones[kebabName];
          return selectedZones
        }, {});
    },
    arrayOfAllZones: function () {
      return Object.values(this.zones);
    },
    arrayOfSelectedZones: function () {
      return Object.values(this.selectedZones);
    },
    isWorldSelected: function () {
      return this.selectedZonesNames.includes('world');
    },
    zonesWithMarkers: function () {
      let zones;

      if (this.isWorldSelected) {
        zones = this.zones;
      } else {
        zones = this.selectedZones;
      }

      return Object.keys(zones)
        .filter(kebabName => kebabName !== 'world')
        .reduce((zonesWithMarkers, kebabName) => {
          zonesWithMarkers[kebabName] = this.zones[kebabName];
          return zonesWithMarkers;
        }, {});
    },
    pastWeekDates: function () {
      const oneWeekAgo = new Date();
      oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);
      return [oneWeekAgo, new Date()];
    },
    pastMonthDates: function () {
      const oneMonthAgo = new Date();
      oneMonthAgo.setDate(oneMonthAgo.getDate() - 30);
      return [oneMonthAgo, new Date()];
    },
    chartColumnClasses: function () {
      if (this.fullWidthMode) {
        return 'is-full';
      } else {
        return 'is-half';
      }
    }
  },

  watch: {
    selectedZonesNames: function () {
      this.updateTotals();
      this.getChartData();
    },
    dates: function () {
      this.getChartData();
    },
  },

  created () {
    this.isLoading = true;
    this.getZones();
    this.getChartData();
    this.isLoading = false;
  },

  mounted () {
    this.$buefy.snackbar.open(`This data is sourced from <a>John Hopkins University</a>. Coviz19 also offers a public API for this data. <a>See docs</a>`);
  },

  methods: {
    getZones: async function () {
      try {
        const response = await this.$http.get('/zones.json');
        this.zones = response.data.zones;
        this.selectedZonesNames.push('world');
        this.updateTotals();
        this.ceilings = response.data.ceilings;
      } catch (error) {
        console.error(error);
      }
    },
    getChartData: async function () {
      this.deathChartData = null;
      this.confirmedChartData = null;
      this.recoveredChartData = null;
      try {
        const response = await this.$http.get(
          '/zones/chart_data.json',
          {
            params: {
              zones: this.selectedZonesNames,
              start_date: this.dates[0],
              end_date: this.dates[1],
            }
          }
        )
        this.deathChartData = response.data.death_chart_data;
        this.confirmedChartData = response.data.confirmed_chart_data;
        this.recoveredChartData = response.data.recovered_chart_data;
      } catch (error) {
        console.error(error);
      }
    },
    chartOptions: function (title) {
      return {
        responsive: true,
        maintainAspectRatio: false,
        scaleBeginAtZero: true,
        title: {
          display: true,
          text: title,
          fontSize: 18,
          position: 'bottom'
        },
        tooltips: {
					mode: 'index',
					intersect: false,
				},
				hover: {
					mode: 'nearest',
					intersect: true
				},
        scales: {
          xAxes: [{
            type: "time",
            time: {
              format: 'DD/MM/YYYY',
              tooltipFormat: 'll',
              minUnit: 'day'
            },
          }],
          yAxes: [{
            ticks: {
              precision: 0,
            }
          }],
        }
      }
    },
    updateTotals: function () {
      if (this.isWorldSelected) {
        this.totalDeath = this.zones.world.values.death;
        this.totalConfirmed = this.zones.world.values.confirmed;
        this.totalRecovered = this.zones.world.values.recovered;
      } else {
        let totalDeath = 0;
        let totalConfirmed = 0;
        let totalRecovered = 0;

        Object.values(this.selectedZones).forEach((zone) => {
          totalDeath += zone.values.death
          totalConfirmed += zone.values.confirmed
          totalRecovered += zone.values.recovered
        })

        this.totalDeath = totalDeath;
        this.totalConfirmed = totalConfirmed;
        this.totalRecovered = totalRecovered;
      }
    },
    updateCurrentCategory(category) {
      this.currentCategory = category;
    },
    updateDates: function (dates) {
      this.dates = dates;
    },
    onZoneSelectedFromMap: function (zone) {
      console.log(zone)
      if (this.isMultipleSelectionActive) {
        if (this.selectedZonesNames.length > 4) {
          return;
        } else {
          this.selectedZonesNames.push(zone.kebab_name);
        }
      } else {
        this.selectedZonesNames = [];
        this.selectedZonesNames.push(zone.kebab_name);
      }
    },
    onZoneSelectedFromField: function (zone) {
      if (this.selectedZonesNames.length > 4) return;

      this.selectedZonesNames.push(zone.kebab_name);
    },
    onZoneRemoved: function (zone) {
      this.$delete(this.selectedZonesNames, this.selectedZonesNames.indexOf(zone.kebab_name));
    },
    toggleLayout: function () {
      this.fullWidthMode = !this.fullWidthMode;
      this.chartConfirmedKey = this.chartConfirmedKey + 1;
      this.chartDeathKey = this.chartDeathKey + 1;
      this.chartRecoveredKey = this.chartRecoveredKey + 1;
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

  .left-side {
    position: sticky;
    height: calc(100vh - 84px);
    top: 84px;
  }

  .column.has-padding-large {
    padding: 1.5em !important;
  }

  .column-inner {
    height: 100%;
    display: flex;
    flex-direction: column;
  }

  .multiple-selection {
    position: absolute;
    z-index: 100000;
    bottom: 20px;
    left: 55px;
    color: white;
  }

  .multiple-selection .control-label, span.check.is-white {
    color: white;
    border-color: white !important;
  }

  .multiple-selection:not(.active) .control-label:hover {
    opacity: 0.5;
  }

  .box {
    box-shadow: 0 .5em 1em -.125em rgba(10,10,10,.1),0 0 0 1px rgba(10,10,10,.02) !important;
  }

  .shadow {
    box-shadow: 0px 10px 20px 0px rgba(0,108,86,0.15);
    -moz-box-shadow: 0px 10px 20px 0px rgba(0,108,86,0.15);
    -webkit-box-shadow: 0px 10px 20px 0px rgba(0,108,86,0.15);
    -o-box-shadow: 0px 10px 20px 0px rgba(0,108,86,0.15);
  }

  .media-header {
    padding: 20px 0px;
  }

  .flexbox  {
    display: flex;
    align-items: center;
  }

  .flexbox.end {
    justify-content: flex-end;
  }

  .flexbox.col {
    flex-direction: column;
  }

  .scrollable{
    overflow-y: scroll;
    text-align: center;
    height: 500px;
  }

  .svg-inline--fa {
    margin-right: 15px;
  }

  .fa-twitter-square{
    color: rgb(59, 148, 217);
  }

  .fa-newspaper{
    color: #24b37e;;
  }

  .datepicker {
    width: 100%;
  }

  .options {
    height: 75px;
    background-color: white;
    border: 1px solid #EAEAEA;
  }

  .loading {
    display: inline-block;
    width: 50px;
    height: 50px;
  }

  .loading:after {
    content: " ";
    display: block;
    width: 30px;
    height: 30px;
    margin: 8px;
    border-radius: 50%;
    border: 2px solid #363636;
    border-color: #363636 transparent #363636 transparent;
    animation: loading 1.2s linear infinite;
  }

  .loading.white:after {
    border: 2px solid white;
    border-color: white transparent white transparent;
    animation: loading 1.2s linear infinite;
  }

  .loading.small{
    display: flex;
    width: 40px;
    height: 30px;
    justify-content: center;
    align-items: center;
  }

  .loading.small:after {
    width: 20px;
    height: 20px;
  }

  @keyframes loading {
    0% {
      transform: rotate(0deg);
    }
    100% {
      transform: rotate(360deg);
    }
  }

  .box.options {
    height: 100%;
    display: flex;
    justify-content: space-between;
    flex-direction: column;
  }

  .multiselect-field {
    height: 50px;
  }

  .chart-container {
    min-height: 400px;
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
  }

  .is-half .chart-container {
    height: 100%;
    width: 500px;
  }

  .is-full .chart-container {
    display: block;
  }

  .categories-container {
    height: 100px;
    display: flex;
    justify-content: center;
    align-items: center;
    position: absolute;
    z-index: 10000;
    width: 100%;
  }

  .categories-container .level {
    flex-grow: 1;
  }

  .information-section {
    margin-bottom: 0.75rem;
  }

  .information-section ul {
    margin-top: 0;
  }

  .field.multiselect-zones {
    position: relative;
  }

  .field.multiselect-zones.high {
    height: 120px;
  }

  .error {
    font-size: 12px;
    position: absolute;
    bottom: 12px;
  }
</style>

<style lang="sass">
  @import "~bulma/sass/utilities/_all";

  $primary: #3273dc;
  $primary-invert: findColorInvert($primary);
  $info: #3273dc;
  $info-invert: findColorInvert($info);
  $success: hsl(141, 53%, 53%);
  $success-invert: findColorInvert($success);
  $danger: hsl(348, 100%, 61%);
  $danger-invert: findColorInvert($danger);
  $light: #EAEAEA;
  $light-invert: findColorInvert($light);

  $colors: ( "info": ($info, $info-invert), "link": ($primary, $primary-invert), "primary": ($primary, $primary-invert), "success": ($success, $success-invert), "danger": ($danger, $danger-invert), "light": ($light, $light-invert) )
  
  .multiselect__tag { background: $success; };
  .multiselect__tag-icon { background: $success; }

  @import "~bulma";
  @import "~buefy/src/scss/buefy";
</style>