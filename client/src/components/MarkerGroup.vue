<template>
  <LCircleMarker
    v-bind:lat-lng="coordinates"
    v-bind:weight='1'
    v-bind:radius='radius'
    v-bind:fill-color='fillColor'
    v-bind:color='fillColor'
    v-bind:fill-opacity='0.5'
    v-bind:pane="'mapPane'"
  />
</template>

<script>
import { LCircleMarker } from "vue2-leaflet";
import * as d3 from 'd3-scale';

export default {
  components: {
    LCircleMarker
  },

  props: {
    category: {
      type: String,
      required: true
    },
    coordinates: {
      type: Array,
      required: true
    },
    values: {
      type: Object,
      required: true
    },
    ceilings: {
      type: Object,
      required: true
    }
  },

  data () {
    return {
      colors: {
        death: '#AC3131',
        confirmed: '#3388ff',
        recovered: '#27a89d',
        active: '#ffdb4a',
      }
    }
  },

  computed: {
    radius: function () {
      var x = d3.scaleLinear()
        .domain([0, this.ceilings[this.category]])
        .range([2, 200]);
        
      return x(this.values[this.category]);
    },
    fillColor: function () {
      return this.colors[this.category]
    }
  },
}
</script>