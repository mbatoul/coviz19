<template>
  <div class="map-container">
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
</template>

<script>
import Leaflet from 'leaflet';
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
  },

  props: {
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
      defaultWeight: 0.25,
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
      const weight = isSelected ? this.defaultWeight + 0.25 : this.defaultWeight;
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
          <p>${that.maybePluralize(feature.zone_data.death.toLocaleString('en-US'), 'death')}</p>
          <p>${(feature.zone_data.confirmed.toLocaleString('en-US'))} confirmed</p>
          <p>${feature.zone_data.recovered.toLocaleString('en-US')} recovered</p>
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
        this.setStyle(that.layerStyle(selectedZonesNames.includes(this.feature.zone_data.kebab_name)))
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
  .map-container {
    position: relative;
    display: flex;
    height: 100%;
    width: 100%;
  }

  .leaflet-map {
    height: 100%;
    width: 100%;
    flex-grow: 1;
    z-index: 10;
  }

  .leaflet-control-container {
    position: absolute;
    bottom: 0px;
    bottom: 100px;
  }
</style>
