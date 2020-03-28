<template>
  <div id="app">
    <div class="container is-fluid is-marginless">
      <TheNavbar />
      <div class="columns is-marginless">
        <div class="column is-two-fifths is-paddingless left-side">
          <div class="column-inner">
            <TheMap
              v-bind:currentCategory='currentCategory'
              v-bind:ceilings='ceilings'
              v-bind:selectedZones='selectedZones'
              v-bind:zonesWithMarkers='zonesWithMarkers'
              v-bind:isWorldSelected='isWorldSelected'
              v-bind:isMultipleSelectionActive.sync='isMultipleSelectionActive'
              v-on:zoneSelected='updateSelectedZonesNames'
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
          <CategoriesBar
            v-bind:currentCategory='currentCategory'
            v-bind:totalDeath='totalDeath'
            v-bind:totalConfirmed='totalConfirmed'
            v-bind:totalRecovered='totalRecovered'
            v-bind:isLoading='isLoading'
            v-on:categorySelected='updateCurrentCategory'
          />

          <div class="columns is-multiline">
            <!-- options -->
            <div class="column  is-half">
              <div class="box options">
                <div class="information-section">
                  <div class="content">
                    <label class="label">
                      Instructions
                    </label>
                    <p class="text">
                      Select one or multiple zones (max. 5) and a time period between January 22, 2020 and today. Check the Multiple Selection box to select zones on the map.
                    </p>
                  </div>
                  <div class="notification">
                    <button class="delete"></button>
                      The data is updated <strong>everyday at midnight</strong>. It may not be <i>perfectly</i> accurate at the time you visualize it.
                  </div>
                </div>
                <div class="options-section">
                  <div class='field'>
                    <label class="label">Zones</label>
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
                          />
                        </b-field>
                      </div>
                    </div>
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
                      class="button is-info is-light"
                      v-on:click='updateDates(pastWeekDates)'
                    >
                      Show past week
                    </button>
                    <button
                      class="button is-success is-light"
                      v-on:click='updateDates([minDate, maxDate])'
                    >
                      Default dates
                    </button>
                  </div>
                </div>
              </div>

            </div>
             <!-- confirmed -->
            <div class="column is-half">
              <div class="">
                <LineChart
                  v-bind:selectedZonesNames='selectedZonesNames'
                  v-bind:data='confirmedChartData'
                  v-bind:options="chartOptions('Confirmed reported')"
                />
              </div>
            </div>
            <!-- deaths -->
            <div class="column is-half">
              <div class="">
                <LineChart
                  v-bind:selectedZonesNames='selectedZonesNames'
                  v-bind:data='deathChartData'
                  v-bind:options="chartOptions('Deaths')"
                />
              </div>
            </div>
            <!-- recovered -->
            <div class="column is-half">
              <div class="">
                <LineChart
                  v-bind:selectedZonesNames='selectedZonesNames'
                  v-bind:data='recoveredChartData'
                  v-bind:options="chartOptions('Recovered cases')"
                />
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
    this.$nextTick(() => {
      this.initNotification();
    })

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
        scaleBeginAtZero: true,
        title: {
          display: true,
          text: title,
          fontSize: 18,

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
    updateSelectedZonesNames: function (kebabName) {
      const isCountryAlreadySelected = this.selectedZonesNames
        .map(zone => zone.kebab_name)
        .includes(kebabName);
      
      if (this.selectedZonesNames.length > 4) return;
      
      if (this.isMultipleSelectionActive && !isCountryAlreadySelected) {
        this.selectedZonesNames.push(kebabName);
      } else if (!isCountryAlreadySelected) {
        this.selectedZonesNames = [];
        this.selectedZonesNames.push(kebabName);
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
    onZoneSelected: function (zone) {
      this.updateSelectedZonesNames(zone.kebab_name);
    },
    onZoneRemoved: function (zone) {
      this.$delete(this.selectedZonesNames, this.selectedZonesNames.indexOf(zone.kebab_name));
    },
    initNotification: function () {
      document.addEventListener('DOMContentLoaded', () => {
        (document.querySelectorAll('.notification .delete') || []).forEach(($delete) => {
          this.$notification = $delete.parentNode;

          $delete.addEventListener('click', () => {
            this.$notification.parentNode.removeChild(this.$notification);
          });
        });
      });
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
    left: 30px;
    color: white;
  }

  .multiple-selection .control-label, span.check.is-white {
    color: white;
    border-color: white !important;
  }

  .multiple-selection.active .control-label, span.check.is-white {
    color: white;
    border-color: white !important;
  }

  .multiple-selection:not(.active) .control-label:hover, span.check.is-white {
    color: #7a7a7a;
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
</style>