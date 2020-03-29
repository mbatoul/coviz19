<template>
  <div class="section">
    <div class="container is-fluid">
      <div class="columns is-centered">
        <div class="column is-two-thirds">
          <div class="content">
            <div class="title">
              COVID trajectories
              <div
                class="loading small"
                v-show='isLoading'
              >
              </div>
            </div>
            <div class="subtitle">
              Cumulative number of cases, by number of days since 100th case
            </div>
          </div>
          <transition name='fade'>
            <div class="charts-container" v-if='!isLoading'>
              <div class='chart-container'>
                <LineChart
                  v-bind:data='confirmedData'
                  v-bind:options="chartOptions('confirmed')"
                />
              </div>
              <div class='chart-container'>
                <LineChart
                  v-bind:data='deathData'
                  v-bind:options="chartOptions('death')"
                />
              </div>
              <div class='chart-container'>
                <LineChart
                  v-bind:data='recoveredData'
                  v-bind:options="chartOptions('recovered')"
                />
              </div>
            </div>
          </transition>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import LineChart from './LineChart.vue';

export default {
    components: {
      LineChart
    },

  data () {
    return {
      deathData: {},
      confirmedData: {},
      recoveredData: {},
      deathThreshold: null,
      confirmedThreshold: null,
      recoveredThreshold: null,
      isLoading: false
    }
  },

  mounted () {
    this.getData();
  },

  methods: {
    getData: async function () {
      this.isLoading = true;
      this.deathData = {};
      this.confirmedData = {};
      this.recoveredData = {};
      try {
        const response = await this.$http.get('/zones/trajectories_data.json')
        this.deathData = response.data.death_data;
        this.confirmedData = response.data.confirmed_data;
        this.recoveredData = response.data.recovered_data;

        this.deathThreshold = response.data.death_threshold;
        this.confirmedThreshold = response.data.confirmed_threshold;
        this.recoveredThreshold = response.data.recovered_threshold;
        this.isLoading = false;
      } catch (error) {
        console.error(error);
      }
    },
    chartTitle: function (category) {
      switch (category) {
        case 'confirmed': return `Cumulative number of confirmed cases, by number of days since ${this.confirmedThreshold}th confirmed case`;
        case 'death': return `Cumulative number of deaths cases, by number of days since ${this.deathThreshold}th death`;
        case 'recovered': return `Cumulative number of recovered cases, by number of days since ${this.recoveredThreshold}th recovery`;
      }
    },
    xAxesTitle: function (category) {
      switch (category) {
        case 'confirmed': return `Number of days since the ${this.confirmedThreshold}th confirmed case`;
        case 'death': return `Number of days since the ${this.deathThreshold}th death`;
        case 'recovered': return `Number of days since the ${this.recoveredThreshold}th recovery`;
      }
    },
    chartOptions: function (category) {
      return {
        responsive: true,
        maintainAspectRatio: false,
        scaleBeginAtZero: true,
        legend: {
          display: true,
          position: 'right',
          labels: {
            filter: function (item) {
              return item.fillStyle !== '#BCBCBC';
            }
          }
        },
        title: {
          display: true,
          text: this.chartTitle(category),
          fontSize: 28,
          position: 'top'
        },
        tooltips: {
					mode: 'nearest',
					intersect: false,
				},
				hover: {
          enabled: false,
					mode: 'nearest',
					intersect: true
				},
        scales: {
          xAxes: [{
            scaleLabel: {
              display: true,
              labelString: this.xAxesTitle(category),
              fontSize: 20
            },
            type: "linear",
            gridLines: {
              drawOnChartArea:false
            }
          }],
          yAxes: [
            {
              ticks: {
                precision: 0,
                beginAtZero: true,
                position: 'left'
              },
              gridLines: {
                drawOnChartArea:false
              }
            },
          ],
        }
      }
    },
  }

}
</script>

<style scoped>
  .container.is-fluid{
    min-height: 100vh;
  }

  .loading.small {
    display: inline-block;
    position: absolute;
    right: -50px;
  }

  .title {
    display: inline-block;
    position: relative;
  }

  .chart-container {
    height: 80vh;
    width: 100%;
    flex-grow: 1;
    min-height: 0;
    overflow-y: scroll;
  }

  .chart-container > div {
    min-width: 800px;
    position: relative;
    height: 100%;
    width: 100%;
  }
</style>