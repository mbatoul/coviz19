<template>
  <div id="app">
    <div class="section">
      <div class="container is-fluid">
        <div class="columns">
          <div class="column is-half">
            <nav class="level">
              <div class="level-item has-text-centered">
                <div
                  class='has-text-danger has-background-light box-category shadow'
                  v-on:click="setCategory('death')"
                  v-bind:class=" { 'selected': category === 'death' }"
                >
                  <p class="heading is-size-8">Total Deaths</p>
                  <div class="box-category-figure">
                    <div
                      class='loading small'
                      v-if='totalDeaths === null'>
                    </div>
                    <p
                      class="title is-size-4"
                      v-else
                    >
                      {{ numberWithCommas(totalDeaths) }}
                    </p>
                  </div>
                </div>
              </div>

              <div class="level-item has-text-centered">
                <div
                  class='has-text-info has-background-light box-category shadow'
                  v-on:click="setCategory('confirmed')"
                  v-bind:class=" { 'selected': category === 'confirmed' }"
                >
                  <p class="heading is-size-8">Total Confirmed</p>
                  <div
                    class='loading small'
                    v-if='totalConfirmed === null'>
                  </div>
                  <p
                    class="title is-size-4"
                    v-else 
                  >
                    {{ numberWithCommas(totalConfirmed) }}
                  </p>
                </div>
              </div>

              <div class="level-item has-text-centered">
                <div
                  class='has-text-success has-background-light box-category shadow'
                  v-on:click="setCategory('recovered')"
                  v-bind:class=" { 'selected': category === 'recovered' }"
                >
                  <p class="heading is-size-8">Total Recovered</p>
                  <div
                    class='loading small'
                    v-if='totalRecovered === null'>
                  </div>
                  <p
                    class="title is-size-4"
                    v-else 
                  >
                    {{ numberWithCommas(totalRecovered) }}
                  </p>
                </div>
              </div>
            </nav>
            
            <div class="is-relative" style='height: 100%;'>
              <div class="list-of-zones">
                <div
                  class='country-container flexbox'
                  v-for='(zone, id) in displayedListOfZones'
                  v-bind:key='id'
                >
                  <SvgItem
                    v-bind:folder="'flags'"
                    v-bind:name='zone.parameterized_name'
                  />
                  <h5 class="subtitle title">
                    {{ zone.name }}
                  </h5>
                </div>
              </div>
              <Map
                v-bind:category='category'
                v-bind:geojsons='geojsons'
                v-bind:zones='zones'
                v-bind:ceilings='ceilings'
                v-bind:selectedZones='selectedZones'
                v-bind:worldSelected='worldSelected'
                v-on:countrySelected='handleCountryChange'
              />
            </div>
          </div>

          <div class="column">
            <b-field grouped class='options-fields'>
              <b-field label="Zones">
                <Multiselect
                  v-model="selectedZones"
                  placeholder="Search or select one or multiple zones"
                  label="name"
                  track-by="parameterized_name"
                  v-bind:options="listOfSelectableZones"
                  v-bind:multiple="true"
                  v-bind:taggable="true"
                  v-bind:close-on-select="false"
                  v-bind:loading="isLoading"
                />
              </b-field>
              
              <b-field label="Time period">
                <b-datepicker
                    placeholder="Click to select..."
                    v-model="dates"
                    v-bind:min-date='minDate'
                    v-bind:max-date='maxDate'
                    range>
                </b-datepicker>
              </b-field>
            </b-field>

            <LineChart
              v-bind:selectedZones='selectedZones'
            />
          </div>
        </div>

        <div class="columns">
          <div class="column">
            <div class="section box">
              <div class="flexbox">
                <font-awesome-icon
                  v-bind:icon="['fab', 'twitter-square']"
                  size='3x'
                />
                <p class="subtitle is-4">Tweets</p>
              </div>
              <div class="tweets-container scrollable">
                <TweetsList
                  v-bind:country='parameterizedCountry'
                />
              </div>
            </div>
          </div>
          
          <div class="column">
            <div class="section box">
              <div class="flexbox">
                <font-awesome-icon
                  v-bind:icon="['fas', 'newspaper']"
                  size='3x'
                />
                <p class="subtitle is-4">News</p>
              </div>
              <div class="news-container scrollable">
                <NewsList
                  v-bind:country='parameterizedCountry'
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <footer class="footer">
      <div class="content has-text-centered">
        <p>
          Built with <strong>Bulma</strong>, <strong>VueJS</strong> and <strong>Ruby-On-Rails</strong> by <a href="https://github.com/mbatoul/" target='_blank'>Mathis Batoul</a>. The <a href='https://github.com/mbatoul/coviz19'>source code</a> is licensed
          <a href="http://opensource.org/licenses/mit-license.php" target='_blank'>MIT</a>.
        </p>
      </div>
    </footer>
  </div>
</template>

<script>
import Multiselect from 'vue-multiselect';
import Map from './components/Map.vue';
import SvgItem from './components/SvgItem.vue';
import NewsList from './components/NewsList.vue';
import TweetsList from './components/TweetsList.vue';
import LineChart from './components/LineChart.vue';
import StringFormatter from './mixins/string-formatter.js';
import 'vue-multiselect/dist/vue-multiselect.min.css';

export default {
  components: {
    Multiselect,
    Map,
    SvgItem,
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
      totalDeaths: null,
      totalConfirmed: null,
      totalRecovered: null,
      category: 'confirmed',
      parameterizedCountry: 'world',
      selectedZones: [],
      dates: [new Date(2020, 0, 21), new Date()],
      minDate: new Date(2020, 0, 21),
      maxDate: new Date(),
      geojsons: [],
      zones: {},
      ceilings: {},
      worldSelected: true,
    }
  },

  computed: {
    listOfSelectableZones: function () {
      return Object.values(this.zones);
    },
    displayedListOfZones: function () {
      if (this.worldSelected) {
        return [this.zones.world];
      } else {
        return this.selectedZones;
      }
    }
  },

  watch: {
    selectedZones: function () {
      console.log(this.selectedZones)
      console.log(this.selectedZones.map(zone => zone.parameterized_name).includes('world'))
      if (this.selectedZones.map(zone => zone.parameterized_name).includes('world')) {
        this.worldSelected = true;
      } else {
        this.worldSelected = false;
      }

      this.setTotals();
    }
  },

  created () {
    this.isLoading = true;
    this.getZones();
    this.getHistoricalData();
    this.isLoading = false;
  },

  methods: {
    getZones: async function () {
      try {
        const response = await this.$http.get('/zones.json');
        this.zones = response.data.zones;
        this.selectedZones.push(this.zones.world);
        this.setTotals();
        this.ceilings = response.data.ceilings;
      } catch (error) {
        console.error(error);
      }
    },
    getHistoricalData: async function () {
      try {
        const response = await this.$http.get(
          '/zones/historical_data.json',
          {
            zones: this.selectedZones,
            start_date: this.dates[0],
            end_date: this.dates[1],
          }
        )
        console.log(response)
      } catch (error) {
        console.error(error);
      }
    },
    handleCountryChange: function (event) {
      this.selectedZones = [];
      this.selectedZones.push(this.zones[event.target.feature.zone_data.parameterized_name])
    },
    setTotals: function () {
      if (this.worldSelected) {
        this.totalDeaths = this.zones.world.values.death;
        this.totalConfirmed = this.zones.world.values.confirmed;
        this.totalRecovered = this.zones.world.values.recovered;
        return;
      }

      this.totalDeaths = 0;
      this.totalConfirmed = 0;
      this.totalRecovered = 0;
      const that = this;
      this.selectedZones.forEach((zone) => {
        that.totalDeaths = that.totalDeaths + zone.values.death
        that.totalConfirmed = that.totalConfirmed + zone.values.confirmed
        that.totalRecovered = that.totalRecovered + zone.values.recovered
      })
    },
    setCategory(category) {
      this.category = category;
    },
    numberWithCommas: function (number) {
      return number.toLocaleString();
    },
  },
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #646464;
}
.column.left .section{
  height: 50%;
  padding-top: 10px;
}
.footer {
  margin-top: 25px;
}
.box {
  box-shadow: 0 .5em 1em -.125em rgba(10,10,10,.1),0 0 0 1px rgba(10,10,10,.02) !important;
}
.box-category {
  padding: 20px;
  border-radius: 5px;
  cursor: pointer;
  border: 1px solid #EAEAEA;
  width: 160px;
  height: 100px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: column;
}
.box-category:hover {
  transform: translateY(-2px);
  transition: 0.3s ease all;
}
.box-category.selected {
  border: 1px solid #646464;
}
.box-category .box-category-figure{
  height: 30px;
}
.shadow {
  box-shadow: 0px 10px 20px 0px rgba(0,108,86,0.15);
  -moz-box-shadow: 0px 10px 20px 0px rgba(0,108,86,0.15);
  -webkit-box-shadow: 0px 10px 20px 0px rgba(0,108,86,0.15);
  -o-box-shadow: 0px 10px 20px 0px rgba(0,108,86,0.15);
}
.categories {
  margin-bottom: 25px;
}
.flexbox  {
  display: flex;
  align-items: center;;
  justify-content: end;
}
.flexbox.col {
  flex-direction: column;
}
.list-of-zones {
  position: absolute;
  z-index: 1000;
  right: 15px;
  top: 15px;
  padding: 5px;
}
.country-container h5 {
  margin: 0 !important;
  margin-left: 15px !important;
  color: white;
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
.options-fields > .field {
  width: 50%;
}
.options-fields input, .multiselect, .multiselect__select, .multiselect__tags {
  min-height: 50px;
}
.options-fields .multiselect__tags {
  border: 1px solid #e8e8e8;
  padding: 13px 40px 0 8px;
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