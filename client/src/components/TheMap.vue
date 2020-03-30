<template>
  <div class="map-container">
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

    <div class="leaflet-container">
      <LMap class="leaflet-map"
        v-bind:minZoom="minZoom"
        v-bind:maxZoom="maxZoom"
        v-bind:zoom="zoom"
        v-bind:center="mapCenter"
        v-bind:maxBoundsViscosity='maxBoundsViscosity'
        v-bind:maxBounds='maxBounds'
        v-bind:options="{ scrollWheelZoom: scrollWheelZoom, attributionControl: attributionControl }"
        ref='leafletMap'
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
    selectedZonesNames: {
      type: Array,
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
        active: '#ffdb4a',
      },
      defaultWeight: 1,
      defaultOpacity: 0.1,
      minZoom: 2,
      maxZoom: 6,
      zoom: 4,
      mapCenter: [48.8566, 2.3522],
      maxBoundsViscosity: 1.0,
      scrollWheelZoom: true,
      attributionControl: false,
      maxBounds: Leaflet.latLngBounds(Leaflet.latLng(-90, -200), Leaflet.latLng(90, 200)),
      options: {
        onEachFeature: this.onEachFeature
      }
    }
  },

  computed: {
    displayedListOfZones: function () {
      return Object.values(this.selectedZones);
    },
  },

  watch: {
    currentCategory: function () {
      this.updateGeoJsonStyle();
    },
    selectedZonesNames: function () {
      this.updateGeoJsonStyle();
    }
  },

  created () {
    this.getGeojsons();
    setTimeout(() => this.zoom = this.zoom -2, 4000);
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
      const that = this;
      this.$nextTick(() => {
        if (this.$refs.geoJson && this.$refs.geoJson.mapObject) {
          this.$refs.geoJson.mapObject.eachLayer((layer) => {
            layer.setStyle(that.layerStyle(this.selectedZonesNames.includes(layer.feature.zone_data.kebab_name)));
          });
        }
      });
    },

    layerStyle: function(isSelected) {
      const weight = isSelected ? this.defaultWeight + 1 : this.defaultWeight;
      const opacity = isSelected ? this.defaultOpacity + 0.5 : this.defaultOpacity;

      return {
        fill: true,
        color: this.defaultColors[this.currentCategory],
        weight: weight,
        fillColor: this.defaultColors[this.currentCategory],
        fillOpacity: opacity
      }
    },

    onEachFeature: function (feature, layer) {
      const that = this;
      const selectedZonesNames = this.selectedZonesNames;

      layer.setStyle(that.layerStyle(selectedZonesNames.includes(layer.feature.zone_data.kebab_name)));

      layer.bindTooltip(
        `<div>
          <p><strong>${feature.zone_data.name}</strong></p>
          <p>${that.maybePluralize(feature.zone_data.death.toLocaleString(), 'death')}</p>
          <p>${(feature.zone_data.confirmed.toLocaleString())} confirmed</p>
          <p>${feature.zone_data.recovered.toLocaleString()} recovered</p>
        </div>`,
        {
          permanent: false,
          sticky: true
        }
      );

      layer.on('mouseover', function () {
        this.setStyle({
          fillOpacity: this.options.fillOpacity + 0.2
        })
      });

      layer.on('mouseout', function () {
        this.setStyle({
          fillOpacity: this.options.fillOpacity - 0.2
        })
      });

      layer.on('click', this.onLayerClicked);
    },

    onLayerClicked: function (event) {
      const zone = event.target.feature.zone_data;

      if (this.selectedZonesNames.includes(zone.kebab_name)) {
        this.$emit('zoneRemoved', zone);
      } else {
        this.$emit('zoneSelected', zone);
      }
    },
  }
}
</script>

<style>
  .leaflet-map {
    height: 100%;
    width: 100%;
  }
  .map-container {
    flex-grow: 1;
    height: 100%;
    position: relative;
  }
  .leaflet-control-container {
    position: absolute;
    bottom: 0px;
    bottom: 100px;
  }
</style>

<style scoped>
  .leaflet-container {
    display: flex;
    flex-direction: column;
    flex-grow: 1;
    height: -moz-calc(100vh - 84px);
    height: -webkit-calc(100vh - 84px);
    height: calc(100vh - 84px);
  }

  @media(max-width: 1024px) {
    .leaflet-container {
      height: calc(100vh - 200px);
    }
  }
  
  .list-of-zones {
    position: absolute;
    z-index: 1000;
    right: 15px;
    bottom: 20px;
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