<template>
  <div class="map-container is-relative">
    <div
      class="list-of-zones"
    >
      <div
        class='country-container flexbox end'
        v-for='(zone, id) in displayedListOfZones'
        v-bind:key='id'
      >
        <h5 class="subtitle title">
          {{ zone.name }}
        </h5>
        <SvgItem
          v-bind:folder="'flags'"
          v-bind:name='zone.svg_flag_name'
        />
      </div>
    </div>
    <LMap class="leaflet-map"
      v-bind:minZoom="minZoom"
      v-bind:maxZoom="maxZoom"
      v-bind:zoom="zoom"
      v-bind:center="mapCenter"
      v-bind:maxBoundsViscosity='maxBoundsViscosity'
      v-bind:maxBounds='maxBounds'
    >
      <LTileLayer
        v-bind:url='basemapUrl'
      />
      <LGeoJson
        v-bind:geojson="geojsons"
        v-bind:options='options'
        ref='geoJson'
      />
      <MarkerGroup
        v-for='(zone, id) in zonesWithMarkers'
        v-bind:key='id'
        v-bind:category='currentCategory'
        v-bind:coordinates='[zone.lat, zone.lng]'
        v-bind:values='zone.values'
        v-bind:ceilings='ceilings'
      />
    </LMap>
  </div>
</template>

<script>
import Leaflet from 'leaflet';
import SvgItem from './SvgItem.vue';
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
    MarkerGroup,
    SvgItem
  },

  props: {
    isWorldSelected: {
      type: Boolean,
      required: true
    },
    selectedZones: {
      type: Object,
      required: true
    },
    zonesWithMarkers: {
      type: Object,
      required: true
    },
    currentCategory: {
      type: String,
      required: true
    },
    ceilings: {
      type: Object,
      required: true
    },
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
      zoom: 3,
      mapCenter: [51.505, -0.09],
      maxBoundsViscosity: 1.0,
      maxBounds: Leaflet.latLngBounds(Leaflet.latLng(-90, -200), Leaflet.latLng(90, 200)),
      options: {
        onEachFeature: this.onEachFeature
      }
    }
  },

  computed: {
    displayedListOfZones: function () {
      if (this.isWorldSelected) {
        return [this.selectedZones.world];
      } else {
        return Object.values(this.selectedZones);
      }
    }
  },

  watch: {
    currentCategory: function () {
      this.updateGeoJsonStyle();
    }
  },

  created () {
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
        color: this.defaultColors[this.currentCategory],
        weight: this.defaultWeight,
        fillColor: this.defaultColors[this.currentCategory],
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
      });

      layer.on('mouseout', function () {
        this.setStyle({
          weight: map.defaultWeight,
          fillOpacity: map.defaultOpacity
        })
      });
      
      layer.on('click', this.handleClick);
    },

    handleClick: function (event) {
      this.$emit('zoneSelected', event.target.feature.zone_data.kebab_name);
    },
  }
}
</script>

<style>
  .map-container {
    height: 800px;
  }

  .leaflet-map {
    height: 100%;
    width: 100%;
  }
</style>

<style scoped>
  .list-of-zones {
    position: absolute;
    z-index: 1000;
    right: 15px;
    top: 15px;
    padding: 5px;
  }

  .country-container {
    margin-bottom: 10px;
  }

  .country-container h5 {
    margin: 0 !important;
    margin-left: 15px !important;
    color: white;
  }
</style>