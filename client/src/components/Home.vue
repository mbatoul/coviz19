<template>
  <div class="section">
    <div class="container is-fluid is-marginless">
      <div class="columns is-desktop">
        <div class="column left-side" v-bind:class='leftColumnClass()'>
          <div class="map-wrapper">
            <div class="categories-wrapper">
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
              ref='theMap'
            />
          </div>
          <div class="chevron-wrapper" v-bind:class='chevronClass()' v-on:click='toggleMapExpanded'>
            <font-awesome-icon
              v-bind:icon="['fas', 'chevron-right']"
              size='3x'
            />
          </div>
        </div>

        <div class="column" v-bind:class='rightColumnClass()'>
          <div class="trajectories-button-container">
            <b-button
              type="is-warning"
              tag="router-link" v-bind:to="{ path: '/coronavirus-trajectories' }"
            >
              See countries' trajectories
            </b-button>
          </div>
          <div class="box">
            <label class="label">Category</label>
            <b-field style='flex-wrap: wrap;'>
              <b-radio-button v-model="currentCategory"
                native-value="active"
                type="is-warning"
                style='flex-basis: 25%;'>
                <span>Active</span>
              </b-radio-button>

              <b-radio-button v-model="currentCategory"
                native-value="confirmed"
                type="is-primary"
                style='flex-basis: 25%;'>
                <span>Confirmed</span>
              </b-radio-button>

              <b-radio-button v-model="currentCategory"
                native-value="death"
                type="is-danger"
                style='flex-basis: 25%;'>
                <span>Deaths</span>
              </b-radio-button>

              <b-radio-button v-model="currentCategory"
                native-value="recovered"
                type="is-success"
                style='flex-basis: 25%;'>
                <span>Recovered</span>
              </b-radio-button>
            </b-field>
            <p class='has-text-grey-light category-explanation'>{{ categoryExplanationMessage }}</p>
            <div class="field time-period">
              <label class="label">Time period</label>
              <DatePicker
                v-bind:mode="'range'"
                v-bind:columns='datePickerColumnsNumber()'
                v-bind:min-date='minDate'
                v-bind:max-date='maxDate'
                v-model='dates'
                v-bind:transition="'fade'"
              />
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
                v-on:click='updateDates({ start: minDate, end: maxDate })'
              >
                Full period
              </button>
            </div>
            <div class="options-section">
              <div class='field multiselect-zones'>
                <label class="label">Zones</label>
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
                <b-field style='width: 100%;'>
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
          
          <LineChart
            v-bind:data='activeChartData'
            v-bind:options="chartOptions('Active')"
            v-bind:key='activeChartKey'
          />
          <LineChart
            v-bind:data='confirmedChartData'
            v-bind:options="chartOptions('Confirmed')"
            v-bind:key='confirmedChartKey'
          />
          <LineChart
            v-bind:data='deathChartData'
            v-bind:options="chartOptions('Deaths')"
            v-bind:key='deathChartKey'
          />
          <LineChart
            v-bind:data='recoveredChartData'
            v-bind:options="chartOptions('Recovered')"
            v-bind:key='recoveredChartKey'
          />
          <div class="media-container" style='padding: 10px;'>
            <div class="media-header" style='display: flex; align-items: center; padding: 10px;'>
              <font-awesome-icon
                v-bind:icon="['fas', 'newspaper']"
                size='2x'
              />
              <p class="subtitle has-text-weight-bold is-5">Latest news</p>
            </div>
            <div class='scrollable'>
              <NewsList
                v-bind:zoneName='zoneForMedia'
              />
            </div>
          </div>
          <div class="media-container" style='padding: 10px;'>
            <div class="media-header" style='display: flex; align-items: center; padding: 10px;'>
              <font-awesome-icon
                v-bind:icon="['fab', 'twitter-square']"
                size='2x'
              />
              <p class="subtitle has-text-weight-bold is-5">Latest tweets</p>
            </div>
            <div class='scrollable'>
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
import Multiselect from 'vue-multiselect';
import DatePicker from 'v-calendar/lib/components/date-picker.umd'
import TheMap from './TheMap.vue';
import NewsList from './NewsList.vue';
import TweetsList from './TweetsList.vue';
import LineChart from './LineChart.vue';
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
    DatePicker,
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
      dates: {},
      minDate: new Date(2020, 0, 22),
      maxDate: new Date(),
      zones: {},
      selectedZonesNames: [],
      ceilings: {},
      isMultipleSelectionActive: true,
      deathChartData: {},
      activeChartData: {},
      confirmedChartData: {},
      recoveredChartData: {},
      confirmedChartKey: 0,
      activeChartKey: 1,
      deathChartKey: 2,
      recoveredChartKey: 3,
      windowWidth: 0,
      lastUpdateDate: null,
      maximumZonesSelected: 10,
      categoryExplanationMessages: {
        'active': 'Current number of active cases',
        'confirmed': 'Total number of cases since the beginning of the pandemic',
        'death': 'Total number of deaths since the beginning of the pandemic',
        'recovered': 'Total number of recoveries since the beginning of the pandemic',
      },
      isMapExpanded: false,
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
      return {
        start: oneWeekAgo,
        end: new Date()
      };
    },
    pastMonthDates: function () {
      const oneMonthAgo = new Date();
      oneMonthAgo.setDate(oneMonthAgo.getDate() - 30);
      return {
        start: oneMonthAgo,
        end: new Date()
      };
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

  methods: {
    toggleMapExpanded: function () {
      this.isMapExpanded = !this.isMapExpanded;
      this.deathChartKey += this.deathChartKey + 1;
      this.activeChartKey += this.activeChartKey + 1;
      this.confirmedChartKey += this.confirmedChartKey + 1;
      this.recoveredChartKey += this.recoveredChartKey + 1;
      console.log(this.$refs.theMap.$refs.leafletMap.mapObject)
      this.$nextTick(() => {
        this.$refs.theMap.$refs.leafletMap.mapObject.invalidateSize();
      })
    },
    chevronClass: function () {
      if (this.isMapExpanded) {
        return 'towards-left';
      } else {
        return '';
      }
    },
    leftColumnClass: function () {
      if (this.isMapExpanded) {
      return 'is-two-thirds-desktop';
      } else {
      return 'is-half-desktop';
      }
    },
    rightColumnClass: function () {
      if (this.isMapExpanded) {
      return 'is-one-third-desktop';
      } else {
      return 'is-half-desktop';
      }
    },
    datePickerColumnsNumber: function () {
      return window.innerWidth > 1024 ? 2 : 1;
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
              start_date: this.dates.start,
              end_date: this.dates.end,
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
  
</style>

<style>
  .scrollable {
    height: 500px;
    overflow-y: scroll;
    padding: 10px;
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

  .map-wrapper {
    position: relative;
    height: 100%;
  }

  .categories-wrapper {
    position: absolute;
    top: 10px;
    z-index: 1000;
    width: 100%;
    padding: 6px;
  }

  @media(max-width: 1024px) {
    .categories-wrapper {
      display: none;
    }
  }

  .trajectories-button-container {
    padding: 0px 0px 25px 0px;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  @media(min-width: 1024px) {
    .trajectories-button-container {
      display: none;
    }
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


  .left-side {
    height: calc(80vh - 100px);
    top: 55px;
    padding-top: 0 !important;
  }

  @media(min-width: 1024px) {
    .left-side {
      position: sticky;
      height: calc(100vh - 100px);
      top: 100px;
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

  .columns {
    margin: 0;
  }

  @media screen and (min-width: 768px) {
    .columns {
      margin-left: -2rem;
      margin-right: -2rem;
      margin-top: -2rem;
    }
  }

  .section {
    padding: 1em !important;
  }

  .chevron-wrapper {
    position: absolute;
    top: 50%;
    z-index: 1000;
    color: white;
    right: 20px;
    cursor: pointer;
  }

  .chevron-wrapper.towards-left {
    transform: rotateY(180deg);
    
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