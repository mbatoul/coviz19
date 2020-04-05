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
          <div class="box">
            <label class="label">Category</label>
            <b-radio v-model="currentCategory"
              native-value="confirmed">
              Confirmed
            </b-radio>
            <b-radio v-model="currentCategory"
              native-value="active">
              Active
            </b-radio>
            <b-radio v-model="currentCategory"
              native-value="death">
              Deaths
            </b-radio>
            <b-radio v-model="currentCategory"
              native-value="recovered">
              Recovered
            </b-radio>
            <p class='has-text-grey-dark category-explanation is-size-7'>{{ helpCategory }}</p>

            <div class='field multiselect-zones'>
              <label class="label">Countries and regions</label>
              <b-radio v-model="showWorld"
                v-bind:native-value='false'
              >
                Compare
              </b-radio>
              <b-radio v-model="showWorld"
                v-bind:native-value='true'
              >
                Show world only
              </b-radio>

              <b-field style='width: 100%;' v-show='!showWorld'>
                <Multiselect
                  placeholder="Select one or multiple countries/regions..."
                  label='name'
                  track-by='kebab_name'
                  v-on:select='onZoneSelected'
                  v-on:remove='onZoneRemoved'
                  v-bind:value='arrayOfSelectedZones'
                  v-bind:options='arrayOfAllZones'
                  v-bind:multiple='true'
                  v-bind:taggable='true'
                  v-bind:close-on-select='true'
                  class='is-danger'
                />
              </b-field>
            </div>

            <label class="label">Visualization mode</label>
            <b-radio v-model="visualizationMode"
              native-value="trajectories">
              Trajectories
            </b-radio>
            <b-radio v-model="visualizationMode"
              native-value="cumulative">
              Cumulative
            </b-radio>
            <p class='has-text-grey-dark category-explanation is-size-7'>{{ helpVisualizationMode }}</p>

            <div class="field time-period-wrapper" v-if="visualizationMode !== 'trajectories'">
              <div class="field time-period">
                <label class="label">Time period</label>
                <DatePicker
                  v-bind:mode="'range'"
                  v-bind:columns='datePickerColumnsNumber()'
                  v-bind:min-date='minDate'
                  v-bind:max-date='maxDate'
                  v-model='dates'
                  v-bind:transition="'fade'"
                  color='blue'
                />
              </div>
              <div class="buttons">
                <button
                  class="button is-outlined is-small"
                  v-on:click='updateDates(pastWeekDates)'
                >
                  Past week
                </button>
                <button
                  class="button is-outlined is-small"
                  v-on:click='updateDates(pastMonthDates)'
                >
                  Past month
                </button>
                <button
                  class="button is-outlined is-small"
                  v-on:click='updateDates({ start: minDate, end: maxDate })'
                >
                  Full period
                </button>
              </div>
            </div>
            <div class="field scale-field">
              <label class="label">Scale</label>
              <b-switch
                v-bind:rounded="false"
                v-bind:outlined="false"
                v-bind:size="'large'"
                v-bind:type="'is-primary'"
                v-model='isLogScale'
              >
                Logarithmic
              </b-switch>
            </div>
          </div>

          <div class="box">
            <div
              class='loading small'
              style='margin: 0 auto;'
              v-if='isLoading'>
            </div>
            <div class="charts" v-else>
              <div
                class="chart-container"
                v-for='(chartData, id) in chartsData'
                v-bind:key='id'
                v-show='chartData.chart_data.datasets.length > 0'
              >
                <LineChart
                  v-bind:data='chartData.chart_data'
                  v-bind:options="chartData.chart_options"
                  v-bind:key="`${chartsKey}-${id}`"
                />
              </div>
            </div>
          </div>
          
          <div class="box is-paddingless">
            <b-tabs style='height: 550px;'>
              <b-tab-item label="Tweets">
                <template slot="header">
                  <font-awesome-icon
                    v-bind:icon="['fas', 'newspaper']"
                    size='2x'
                    style='margin-right: 15px;'
                  />
                  <span> Articles</span>
                </template>
                <div class="media-container" style='padding: 10px;'>
                  <div class='scrollable'>
                    <NewsList
                      v-bind:zoneName='zoneForMedia'
                    />
                  </div>
                </div>
              </b-tab-item>
              <b-tab-item label="Tweets">
                <template slot="header">
                  <font-awesome-icon
                    v-bind:icon="['fab', 'twitter-square']"
                    size='2x'
                    style='margin-right: 15px;'
                  />
                  <span> Tweets</span>
                </template>
                <div class="media-container">
                  <div class='scrollable'>
                    <TweetsList
                      v-bind:zoneName='zoneForMedia'
                    />
                  </div>
                </div>
              </b-tab-item>
            </b-tabs>

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
      currentCategory: 'confirmed',
      visualizationMode: 'trajectories',
      dates: {},
      minDate: new Date(2020, 0, 22),
      maxDate: new Date(),
      zones: {},
      selectedZonesNames: [],
      ceilings: {},
      chartsData: [],
      maximumZonesSelected: 10,
      helpCategories: {
        'active': 'Current number of active cases',
        'confirmed': 'Total number of cases since the beginning of the pandemic',
        'death': 'Total number of deaths since the beginning of the pandemic',
        'recovered': 'Total number of recoveries since the beginning of the pandemic',
      },
      helpVisualizationModes: {
        'cumulative': 'Total day-by-day',
        'trajectories': 'Cumulative number of cases, by number of days since 100th case',
      },
      isMapExpanded: false,
      isLogScale: false,
      showWorld: false,
      chartsKey: 0
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
    zonesWithMarkers: function () {
      let zones;

      if (this.showWorld) {
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
    helpCategory: function () {
      return this.helpCategories[this.currentCategory];
    },
    helpVisualizationMode: function () {
      return this.helpVisualizationModes[this.visualizationMode];
    },
  },

  watch: {
    selectedZonesNames: function () {
      this.showWorld = this.selectedZonesNames.length === 0;

      this.updateTotals();

      if (this.selectedZonesNames.length) {
        this.getChartsData();
      }
    },
    dates: function () {
      if (this.selectedZonesNames.length) {
        this.getChartsData();
      }
    },
    isLogScale: function () {
      if (this.selectedZonesNames.length) {
        this.getChartsData();
      }
    },
    visualizationMode: function () {
      if (this.selectedZonesNames.length) {
        this.getChartsData();
      }
    },
    showWorld: function () {
      this.getChartsData();
      this.updateTotals();
    }
  },

  created () {
    this.updateDates(this.pastMonthDates);
    this.getZones();
  },

  methods: {
    toggleLogScale: function () {
      this.isLogScale = !this.isLogScale;
    },
    toggleMapExpanded: function () {
      this.isMapExpanded = !this.isMapExpanded;
      this.chartsKey += 1;
      this.$nextTick(() => {
        this.$refs.theMap.$refs.leafletMap.mapObject.invalidateSize();
      })
    },
    chevronClass: function () {
      if (window.innerWidth < 1024) {
        return 'hidden';
      }

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
      if (this.isMapExpanded) {
        return 1;
      } else {
        return window.innerWidth > 1024 ? 2 : 1;
      }
    },
    getZones: async function () {
      try {
        const response = await this.$http.get('/zones.json');
        this.zones = response.data.zones;
        this.updateTotals();
        this.selectedZonesNames.push(... ['france', 'italy', 'germany', 'china', 'us']);
        this.ceilings = response.data.ceilings;
      } catch (error) {
        console.error(error);
      }
    },
    getChartsData: async function () {
      this.isLoading = true;
      this.deathChartData = {};
      this.confirmedChartData = {};
      this.recoveredChartData = {};
      try {
        const response = await this.$http.get(
          '/zones/charts_data.json',
          {
            params: {
              zones_names: this.selectedZonesNames,
              start_date: this.dates.start,
              end_date: this.dates.end,
              is_log_scale: this.isLogScale,
              visualization_mode: this.visualizationMode,
              world_only: this.showWorld,
            }
          }
        )
        this.chartsData = [];
        this.chartsData.push(... response.data.charts_data);
        this.isLoading = false;
      } catch (error) {
        console.error(error);
      }
    },
    updateTotals: function () {
      if (this.showWorld) {
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
      if (this.selectedZonesNames.length > this.maximumZonesSelected) {
        return;
      } else {
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
    height: 450px;
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
    height: calc(100vh - 52px);
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

  .chevron-wrapper.hidden {
    display: none;
  }

  .chevron-wrapper .svg-inline--fa {
    margin: 0;
  }

  .chevron-wrapper.towards-left {
    transform: rotateY(180deg);
  }

  .switch-scale {
    position: absolute;
    right: 0;
  }

  .chart-container {
    padding: 20px 0px;
  }

  .chart-container:not(:last-child) {
    border-bottom: 1px solid #EAEAEA;
  }

  .multiselect__tag-icon:focus, .multiselect__tag-icon:hover{
    background: #8A8A8A;
    color: #646464
  }

  .multiselect__tag-icon::after {
    color: #646464;
  }

  .media-container {
    display: flex;
    justify-content: center;
  }

  .scale-field, .field.time-period-wrapper {
    display: block;
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
  $grey: #BCBCBC;
  $dark: #646464;

  $colors: ( "info": ($info, $info-invert), "link": ($primary, $primary-invert), "primary": ($primary, $primary-invert), "success": ($success, $success-invert), "danger": ($danger, $danger-invert), "light": ($light, $light-invert), "warning": ($warning, $warning-invert), 'dark': ($dark, $dark), 'grey': ($grey, $grey)  )
  
  .multiselect__tag { background: #EAEAEA; color: $dark };

  @import "~bulma";
  @import "~buefy/src/scss/buefy";
</style>