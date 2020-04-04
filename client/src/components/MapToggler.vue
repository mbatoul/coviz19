<template>
  <div class='circle-button' v-on:click="toggleShowMap">
    <font-awesome-icon
      v-if="showMap"
      v-bind:icon="['fas', 'map-marked-alt']"
      size='3x'
    />
    <font-awesome-icon
      v-else
      v-bind:icon="['fas', 'chart-line']"
      size='3x'
    />
  </div>
</template>

<script>
export default {
  data() {
    return {
      showMap: true,
      windowWidth: 0
    }
  },

  methods: {
    toggleShowMap(){
      this.showMap = !this.showMap
      this.$emit('toggle-map', this.showMap);
    },
    onResize() {
      this.windowWidth = window.innerWidth
    }
  },

  watch: {
    windowWidth(newWidth) {
      if (newWidth > 1024) {
        this.showMap = false
        this.$emit('toggle-map', this.showMap);
      }
    }
  },

  mounted() {
    this.$nextTick(() => {
      window.addEventListener('resize', this.onResize);
    })
  },

  beforeDestroy() {
    window.removeEventListener('resize', this.onResize);
  }
}
</script>

<style scoped>
  .circle-button{
    background-color: white;
    width: 50px;
    height: 50px;
    border-radius: 25px;
    box-shadow: 0px 3px 6px #006C5633;
    z-index: 100000;
    display: flex;
    position: fixed;
    right: 20px;
    bottom: 20px;
    justify-content: center;
  }

  .circle-button svg {
    width: 30px;
    color: #646464;
  }
</style>
