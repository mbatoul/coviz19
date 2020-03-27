<template>
  <div id="app">
    <TheNavbar />

    <div class="section" style='padding: 1.25rem;'>
      <div class="container is-fluid">
        <div class="columns">
          <div class="column is-two-fifths is-relative">
            <div class="left-column-content">
              <TheMap
                v-bind:currentCategory='currentCategory'
                v-bind:ceilings='ceilings'
                v-bind:selectedZones='selectedZones'
                v-bind:zonesWithMarkers='zonesWithMarkers'
                v-bind:isWorldSelected='isWorldSelected'
                v-bind:isMultipleSelectionActive.sync='isMultipleSelectionActive'
                v-on:zoneSelected='updateSelectedZonesNames'
              />
              <div class="selection-mode-checkbox-container">
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

          <div class="column">
            <CategoriesBar
              v-bind:currentCategory='currentCategory'
              v-bind:totalDeath='totalDeath'
              v-bind:totalConfirmed='totalConfirmed'
              v-bind:totalRecovered='totalRecovered'
              v-bind:isLoading='isLoading'
              v-on:categorySelected='updateCurrentCategory'
            />
            <div class="tile is-ancestor">
              <div class="tile is-6 is-vertical is-parent">
                <div class="tile is-child box">
                  <p class="subtitle">Options</p>
                  <div class="notification">
                    <button class="delete"></button>
                      The data is updated <strong>everyday at midnight</strong>. It may not be <i>perfectly</i> accurate at the time you visualize it.
                  </div>
                  <div class="content">
                    <p class="text">
                      Select one or multiple zones (max. 5) and a time period between January 22, 2020 and today. Check the Multiple Selection box to select zones on the map.
                    </p>
                  </div>
                  <div class='field'>
                    <label class="label">Zones</label>
                    <div class="field-body">
                      <div class="field">
                        <b-field>
                          <Multiselect
                            placeholder="Search or select one or multiple zones"
                            label='name'
                            track-by='kebab_name'
                            v-on:select='onZoneSelected'
                            v-on:remove='onZoneRemoved'
                            v-bind:value='arrayOfSelectedZones'
                            v-bind:options='arrayOfAllZones'
                            v-bind:multiple='true'
                            v-bind:taggable='true'
                            v-bind:close-on-select='false'
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
                            class='is-medium'
                            range>
                          </b-datepicker>
                        </b-field>
                      </div>
                    </div>
                  </div>
                  <div class="buttons">
                    <button
                      class="button is-info is-light"
                      v-on:click='updateDates(lastWeekDates)'
                    >
                      Last week
                    </button>
                    <button
                      class="button is-success is-light"
                      v-on:click='updateDates(lastWeekDates)'
                    >
                      Since 22/01/2020
                    </button>
                  </div>
                  
                </div>
                <div class="tile is-child box">
                  <p class="subtitle">Deaths</p>
                  <LineChart
                    v-bind:selectedZonesNames='selectedZonesNames'
                    v-bind:data='chartData'
                    v-bind:options='chartOptions'
                  />
                </div>
              </div>
              <div class="tile is-6 is-vertical is-parent">
                <div class="tile is-child box">
                  <p class="subtitle">Confirmed</p>
                  <LineChart
                    v-bind:selectedZonesNames='selectedZonesNames'
                    v-bind:data='chartData'
                    v-bind:options='chartOptions'
                  />
                </div>
                <div class="tile is-child box">
                  <p class="subtitle">Recovered</p>
                  <LineChart
                    v-bind:selectedZonesNames='selectedZonesNames'
                    v-bind:data='chartData'
                    v-bind:options='chartOptions'
                  />
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="columns">
          <div class="column is-two-thirds">
            <div class="box">
              <div class="flexbox">
                <font-awesome-icon
                  v-bind:icon="['fas', 'newspaper']"
                  size='3x'
                />
                <p class="subtitle is-4">Articles</p>
              </div>
              <div class="news-container scrollable">
                <NewsList
                  v-bind:country="''"
                />
              </div>
            </div>
          </div>
          <div class="column">
            <div class="box">
              <div class="flexbox">
                <font-awesome-icon
                  v-bind:icon="['fab', 'twitter-square']"
                  size='3x'
                />
                <p class="subtitle is-4">Tweets</p>
              </div>
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
      chartData: null,
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
    chartOptions: function () {
      return {
        responsive: true,
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
        }
      }
    },
    lastWeekDates: function () {
      const today = new Date();
      return [today.getDate() - 7, today];
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
    currentCategory: function () {
      this.getChartData();
    }
  },

  created () {
    this.isLoading = true;
    this.getZones();
    this.getChartData();
    this.isLoading = false;
  },

  mounted () {
    document.addEventListener('DOMContentLoaded', () => {
      (document.querySelectorAll('.notification .delete') || []).forEach(($delete) => {
        this.$notification = $delete.parentNode;

        $delete.addEventListener('click', () => {
          this.$notification.parentNode.removeChild(this.$notification);
        });
      });
    });

    this.$buefy.snackbar.open(`This data is sourced from <a>John Hopkins University</a>. Coviz19 also offers a public API for this data. <a>See docs</a>`);
  },

  methods: {
    getZones: async function () {
      try {
        const response = await this.$http.get('/zones.json');
        this.zones = response.data.zones;
        this.selectedZonesNames.push('france');
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
              categories: [this.currentCategory],
              start_date: this.dates[0],
              end_date: this.dates[1],
            }
          }
        )
        this.chartData = response.data.data;
      } catch (error) {
        console.error(error);
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
      this.selectedZonesNames.push(zone.kebab_name);
    },
    onZoneRemoved: function (zone) {
      this.$delete(this.selectedZonesNames, this.selectedZonesNames.indexOf(zone.kebab_name));
    }
  },
}
</script>

<style lang="scss">
  
</style>

<style>
  #app {
    font-family: Avenir, Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    color: #646464;
    background: #f1f4f6;
  }

  .left-column-content {
    display: flex;
    flex-direction: column;
    height: 100%;
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
    color: #838a89;
  }

  .selection-mode-checkbox-container .checkbox:hover {
    color: white;
  }

  .datepicker {
    width: 100%;
  }

  .selection-mode-checkbox-container {
    position: absolute;
    top: 25px;
    left: 65px;
    z-index: 1000;
    color: white;
    font-weight: bolder;
    height: 30px;
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
</style>