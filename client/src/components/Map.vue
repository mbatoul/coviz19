<template>
  <div class="map-container">
    <LMap class="leaflet-map"
      v-bind:minZoom="minZoom"
      v-bind:maxZoom="maxZoom"
      v-bind:zoom="zoom"
      v-bind:center="mapCenter"
    >
      <LTileLayer
        v-bind:url='basemapUrl'
      />
      <LGeoJson
        v-bind:geojson="geojsons"
        v-bind:options='options'
        ref='geoJson'
      />
      <template>
        <MarkerGroup
          v-for='(zone, id) in zonesWithCoordinates'
          v-bind:key='id'
          v-bind:category='currentCategory'
          v-bind:coordinates='[zone.lat, zone.lng]'
          v-bind:values='zone.values'
          v-bind:ceilings='ceilings'
        />
      </template>
    </LMap>
  </div>
</template>

<script>
import { LMap, LTileLayer, LGeoJson } from "vue2-leaflet";
import ColorGradient from '../mixins/color-gradient.js';
import StringFormatter from '../mixins/string-formatter.js';
import MarkerGroup from './MarkerGroup.vue'
import "leaflet/dist/leaflet.css";

export default {
  components: {
    LMap,
    LTileLayer,
    LGeoJson,
    MarkerGroup
  },

  props: {
    category: {
      type: String,
      required: true
    },
    zones: {
      type: [Object, Array],
      custom: true,
      default: () => ({}),
    },
    ceilings: {
      type: Object,
      required: true
    }
  },

  mixins: [
    ColorGradient,
    StringFormatter
  ],

  data () {
    return {
      geojsons: [],
      basemapUrl: 'https://cartocdn_{s}.global.ssl.fastly.net/base-midnight/{z}/{x}/{y}.png',
      defaultColors: {
        death: '#e84545',
        confirmed: '#3f72af',
        recovered: '#00b8a9',
      },
      defaultWeight: 1,
      defaultOpacity: 0.2,
      minZoom: 2,
      maxZoom: 6,
      zoom: 4,
      mapCenter: [51.505, -0.09],
      options: {
        onEachFeature: this.onEachFeature
      }
    }
  },

  computed: {
    currentCategory: function() {
      return this.category;
    },

    zonesWithCoordinates () {
      return Object.keys(this.zones)
        .filter(key => this.zones[key].lat !== undefined && this.zones[key] !== undefined)
        .reduce((obj, key) => {
          obj[key] = this.zones[key];
          return obj;
        }, {});
    }
  },

  watch: {
    currentCategory: function () {
      this.updateGeoJsonStyle();
    }
  },

  created() {
    this.getGeojsons();
  },

  methods: {
    getGeojsons: async function () {
      try {
        const response = await this.$http.get('/geojson_features.json');
        this.geojsons = response.data.geojson_features;
        this.updateGeoJsonStyle();
      } catch (error) {
        console.error(error);
      }
    },

    updateGeoJsonStyle: function() {
      const newLayerStyle = this.layerStyle();

      this.$nextTick(() => {
        if (this.$refs.geoJson && this.$refs.geoJson.mapObject) {
          this.$refs.geoJson.mapObject.eachLayer((layer) => {
            layer.setStyle(newLayerStyle);
          });
        }
      });
    },

    layerStyle: function() {
      return {
        fill: true,
        color: this.defaultColors[this.category],
        weight: this.defaultWeight,
        fillColor: this.defaultColors[this.category],
        fillOpacity: this.defaultOpacity
      }
    },

    onEachFeature: function (feature, layer) {
      const map = this;
      layer.setStyle(this.layerStyle);
      layer.bindTooltip(
        `<div>
          <p><strong>${feature.zone_data.name}</strong></p>
          <p>${map.maybePluralize(feature.zone_data.death, 'death')}</p>
          <p>${feature.zone_data.confirmed} confirmed</p>
          <p>${feature.zone_data.recovered} recovered</p>
        </div>`,
        {
          permanent: false,
          sticky: true
        }
      );

      layer.on('mouseover', function () {
        this.setStyle({
          weight: map.defaultWeight + 1,
          fillOpacity: map.defaultOpacity + 0.2
        })
      })

      layer.on('mouseout', function () {
        this.setStyle({
          weight: map.defaultWeight,
          fillOpacity: map.defaultOpacity
        })
      })
      
      layer.on('click', this.handleClick)
    },

    handleClick: function (event) {
      this.$emit('countrySelected', event);
    },
  }
}
</script>

<style>
.map-container {
  height: 100%;
}
.leaflet-map {
  height: 100%;
  width: 100%;
}
</style>