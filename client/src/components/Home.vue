<template>
  <div class="container is-fluid is-marginless">
    <div class="columns is-desktop is-marginless">
      <div
        class="column is-paddingless left-side"
        v-bind:class='leftSideColumnClass'
      > 
        <div class="column-inner">
          <div class="categories-container desktop">
            <CategoriesBar
              v-bind:currentCategory='currentCategory'
              v-bind:totalActive='totalActive'
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
            v-on:zoneSelected='onZoneSelected'
            v-on:zoneRemoved='onZoneRemoved'
          />
        </div>
        <div class="trajectories-button-container mobile">
          <b-button
            type="is-warning"
            tag="router-link" v-bind:to="{ path: '/coronavirus-trajectories' }"
          >
            See countries' trajectories
          </b-button>
        </div>
      </div>

      <div class="column has-padding-large">
        <div class="columns is-desktop is-multiline">
          <!-- options -->
          <div
            class='column is-full'
          >
            <div class="box options">
              <div class="information-section">
                <div class="content">
                  <label class="label">
                    Instructions
                  </label>
                  <ul>
                    <li>
                      Select up to {{ maximumZonesSelected }} zones, using the field below or the multiple selection mode on the map
                    </li>
                    <li>
                      Choose a time period between January 22, 2020 and today
                    </li>
                  </ul>
                </div>

              </div>
              <div class="options-section">
                <label class="label">Category</label>
                <b-field style='flex-wrap: wrap;'>
                  <b-radio-button v-model="currentCategory"
                    native-value="active"
                    type="is-warning">
                    <span>Active</span>
                  </b-radio-button>

                  <b-radio-button v-model="currentCategory"
                    native-value="confirmed"
                    type="is-primary">
                    <span>Confirmed</span>
                  </b-radio-button>

                  <b-radio-button v-model="currentCategory"
                    native-value="death"
                    type="is-danger">
                    <span>Deaths</span>
                  </b-radio-button>

                  <b-radio-button v-model="currentCategory"
                    native-value="recovered"
                    type="is-success">
                    <span>Recovered</span>
                  </b-radio-button>
                </b-field>
                <p class='has-text-grey-light category-explanation'>{{ categoryExplanationMessage }}</p>
                <div class="field time-period">
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
                          v-bind:mobile-native='true'
                          range>
                        </b-datepicker>
                      </b-field>
                    </div>
                  </div>
                </div>
                <div class="buttons">
                  <button
                    class="button is-outlined"
                    v-on:click='updateDates(pastWeekDates)'
                  >
                    Past week
                  </button>
                  <button
                    class="button is-outlined"
                    v-on:click='updateDates(pastMonthDates)'
                  >
                    Past month
                  </button>
                  <button
                    class="button is-outlined"
                    v-on:click='updateDates([minDate, maxDate])'
                  >
                    Full period
                  </button>
                </div>
                <div
                  class='field multiselect-zones'
                >
                  <label class="label">Zones</label>
                  <div style='display: flex; flex-wrap: wrap;'>
                    <b-field>
                      <b-checkbox
                        v-model='isMultipleSelectionActive'
                        type="is-primary"
                        style='margin-right: 20px;'
                      >
                        <span>Select multiple zones on the map</span>
                      </b-checkbox>
                    </b-field>
                    <b-field>
                      <b-checkbox
                        v-model='isWorldSelected'
                        type="is-primary"
                        v-if="this.selectedZonesNames.length < this.maximumZonesSelected"
                      >
                        <span>Compare to world</span>
                      </b-checkbox>
                    </b-field>

                  </div>
                  <div class="field-body">
                    <div class="field multiselect-field">
                      <b-field>
                        <Multiselect
                          placeholder="Select one or multiple zones..."
                          label='name'
                          track-by='kebab_name'
                          v-on:select='onZoneSelected'
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
                </div>
                
              </div>
            </div>

          </div>
          <!-- active -->
          <div
            class='column'
          >
            <div
              class='loading small'
              v-if='isLoading'>
            </div>
            <div class="chart-container" v-else>
              <div style='width: 100%;'>
                <LineChart
                  v-bind:data='activeChartData'
                  v-bind:options="chartOptions('Active')"
                  v-bind:key='chartActiveKey'
                />
              </div>
            </div>
          </div>
            <!-- confirmed -->
          <div
            class='column'
          >
            <div
              class='loading small'
              v-if='isLoading'>
            </div>
            <div class="chart-container" v-else>
              <div style='width: 100%;'>
                <LineChart
                  v-bind:data='confirmedChartData'
                  v-bind:options="chartOptions('Confirmed')"
                  v-bind:key='chartConfirmedKey'
                />
              </div>
            </div>
          </div>
          <!-- deaths -->
          <div
            class='column'
          >
            <div class="chart-container">
              <div
                class='loading small'
                v-if='isLoading'>
              </div>
              <div style='width: 100%;' v-else>
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
            class='column'
          >
            <div class="chart-container">
              <div
                class='loading small'
                v-if='isLoading'>
              </div>
              <div style='width: 100%;' v-else>
                <LineChart
                  v-bind:data='recoveredChartData'
                  v-bind:options="chartOptions('Recovered')"
                  v-bind:key='chartRecoveredKey'
                />
              </div>
            </div>
          </div>
          <!-- news -->
          <div class="column is-full">
            <div class="media-header flexbox">
              <font-awesome-icon
                v-bind:icon="['fas', 'newspaper']"
                size='2x'
              />
              <p class="subtitle has-text-weight-bold is-5">Latest news</p>
            </div>
            <div class="news-container scrollable">
              <NewsList
                v-bind:zoneName='zoneForMedia'
              />
            </div>
          </div>
          <!-- tweets -->
          <div class="column is-full">
            <div class="media-header flexbox">
              <font-awesome-icon
                v-bind:icon="['fab', 'twitter-square']"
                size='2x'
              />
              <p class="subtitle has-text-weight-bold is-5">Tweets</p>
            </div>
            <div class="tweets-container scrollable">
              <TweetsList
                v-bind:zoneName='zoneForMedia'
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import CategoriesBar from './CategoriesBar.vue';
import TheMap from './TheMap.vue';
import NewsList from './NewsList.vue';
import TweetsList from './TweetsList.vue';
import LineChart from './LineChart.vue';
import Multiselect from 'vue-multiselect';
import StringFormatter from '../mixins/string-formatter.js';
import 'vue-multiselect/dist/vue-multiselect.min.css';

export default {
  components: {
    CategoriesBar,
    Multiselect,
    TheMap,
    NewsList,
    TweetsList,
    LineChart,
  },

  mixins: [
    StringFormatter
  ],

  data () {
    return {
      isLoading: false,
      totalDeath: null,
      totalActive: null,
      totalConfirmed: null,
      totalRecovered: null,
      currentCategory: 'active',
      dates: [],
      minDate: new Date(2020, 0, 22),
      maxDate: new Date(),
      zones: {},
      selectedZonesNames: [],
      ceilings: {},
      isMultipleSelectionActive: true,
      deathChartData: null,
      activeChartData: null,
      confirmedChartData: null,
      recoveredChartData: null,
      chartConfirmedKey: 0,
      chartActiveKey: 0,
      chartDeathKey: 0,
      chartRecoveredKey: 0,
      windowWidth: 0,
      lastUpdateDate: null,
      maximumZonesSelected: 10,
      leftSideColumnClass: 'is-two-thirds-desktop',
      categoryExplanationMessages: {
        'active': 'Current number of active cases',
        'confirmed': 'Total number of cases since the beginning of the pandemic',
        'death': 'Total number of deaths since the beginning of the pandemic',
        'recovered': 'Total number of recoveries since the beginning of the pandemic',
      }
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
    isWorldSelected: {
      get: function () {
        return this.selectedZonesNames.includes('world');
      },
      set: function (value) {
        if (value) {
          this.onZoneSelected(this.zones.world);
        } else {
          this.onZoneRemoved(this.zones.world);
        }
      }
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
    zoneForMedia: function () {
      return this.selectedZonesNames[this.selectedZonesNames.length - 1];
    },
    categoryExplanationMessage: function () {
      return this.categoryExplanationMessages[this.currentCategory];
    }
  },

  watch: {
    selectedZonesNames: function () {
      if (this.selectedZonesNames.length === 0) {
        this.selectedZonesNames.push('world');
      }

      this.updateTotals();
      if (this.selectedZonesNames.length) {
        this.getChartData();
      }
    },
    dates: function () {
      if (this.selectedZonesNames.length) {
        this.getChartData();

      }
    },
  },

  created () {
    this.isLoading = true;
    this.updateDates(this.pastMonthDates);
    this.getZones();
    this.isLoading = false;
  },

  mounted () {
    this.windowWidth = window.innerWidth;
    window.addEventListener('resize', this.onResize);
  },

  methods: {
    onResize: function () {
      this.windowWidth = window.innerWidth;
    },
    getZones: async function () {
      try {
        const response = await this.$http.get('/zones.json');
        this.zones = response.data.zones;
        this.lastUpdateDate = response.data.last_update_date;
        this.selectedZonesNames.push(...['italy', 'france', 'china', 'us', 'world']);
        this.updateTotals();
        this.ceilings = response.data.ceilings;
      } catch (error) {
        console.error(error);
      }
    },
    getChartData: async function () {
      this.deathChartData = {};
      this.confirmedChartData = {};
      this.recoveredChartData = {};
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
        this.activeChartData = response.data.active_chart_data;
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
          position: 'top'
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
              unit: 'day'
            },
            gridLines: {
              drawOnChartArea:false
            }
          }],
          yAxes: [{
            ticks: {
              precision: 0,
              beginAtZero: true,
            },
            gridLines: {
              drawOnChartArea:false
            }
          }],
        }
      }
    },
    updateTotals: function () {
      if (this.isWorldSelected) {
        this.totalActive = this.zones.world.values.active;
        this.totalDeath = this.zones.world.values.death;
        this.totalConfirmed = this.zones.world.values.confirmed;
        this.totalRecovered = this.zones.world.values.recovered;
      } else {
        let totalDeath = 0;
        let totalConfirmed = 0;
        let totalRecovered = 0;
        let totalActive = 0;

        Object.values(this.selectedZones).forEach((zone) => {
          totalDeath += zone.values.death
          totalConfirmed += zone.values.confirmed
          totalRecovered += zone.values.recovered
          totalActive += zone.values.active
        })

        this.totalDeath = totalDeath;
        this.totalActive = totalActive;
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
    onZoneSelected: function (zone) {
      if (this.isMultipleSelectionActive) {
        if (this.selectedZonesNames.length > this.maximumZonesSelected) {
          return;
        } else {
          this.selectedZonesNames.push(zone.kebab_name);
        }
      } else {
        this.selectedZonesNames = [];
        this.selectedZonesNames.push(zone.kebab_name);
      }
    },
    onZoneRemoved: function (zone) {
      this.$delete(this.selectedZonesNames, this.selectedZonesNames.indexOf(zone.kebab_name));
    },
  },
}
</script>

<style>
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
    position: relative;
  }

  .chart-container {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    overflow-y: scroll;
    padding: 15px;
  }

  .is-half .chart-container {
    height: 100%;
  }

  .is-full .chart-container {
    display: block;
  }

  .categories-container.desktop {
    height: 100px;
    display: flex;
    justify-content: center;
    align-items: center;
    position: absolute;
    z-index: 10000;
    width: 100%;
  }

  .trajectories-button-container.mobile {
    padding-top: 25px;
    display: flex;
    justify-content: center;
    align-items: center;
    padding-top: 20px;
  }

  @media(max-width: 1024px) {
    .categories-container.desktop {
      display: none;
    }
  }

  @media(min-width: 1024px) {
    .trajectories-button-container.mobile {
      display: none;
    }
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

  .field {
    display: inline-block;
  }

  .field.multiselect-zones {
    position: relative;
    display: inline-block;
    width: 100%;
  }

  .news-container {
    padding-top: 12px;
  }

  @media(min-width: 1024px) {
    .left-side {
      position: sticky;
      height: calc(100vh - 84px);
      top: 84px;
    }
  }

  .field.time-period {
    width: 100%;
  }

  .field.time-period .field {
    width: 100%;
  }

  .field.multiselect-zones {
    width: 100%;
  }

  .field.multiselect-zones, .multiselect-field > .field {
    width: 100%;
  }

  .category-explanation {
    margin-bottom: 0.75em;
  }
</style>

<style lang="sass">
  @import "~bulma/sass/utilities/_all";

  $primary: #3273dc;
  $primary-invert: findColorInvert($primary);
  $warning: #ffdb4a;
  $warning-invert: findColorInvert($warning);
  $info: #3273dc;
  $info-invert: findColorInvert($info);
  $success: #35AC5E;
  $success-invert: findColorInvert($success);
  $danger: #FF3860;
  $danger-invert: findColorInvert($danger);
  $light: #EAEAEA;
  $light-invert: findColorInvert($light);

  $colors: ( "info": ($info, $info-invert), "link": ($primary, $primary-invert), "primary": ($primary, $primary-invert), "success": ($success, $success-invert), "danger": ($danger, $danger-invert), "light": ($light, $light-invert), "warning": ($warning, $warning-invert) )
  
  .multiselect__tag { background: $success; };

  @import "~bulma";
  @import "~buefy/src/scss/buefy";
</style>