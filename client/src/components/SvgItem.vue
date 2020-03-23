<template>
  <div class='img-container'>
    <img
      v-bind:src="src"
    />
  </div>
</template>

<script>
export default {
  computed: {
    src: function () {
      return `https://coviz-19-bucket.s3.eu-west-3.amazonaws.com/flags/${this.name}.svg`
    }
  },

  props: {
    folder: {
      type: String,
      required: true
    },
    name: {
      type: String,
      required: true
    }
  },
}
</script>

<style scoped>
.img-container {
  display: inline-block;
  width: 50px;
  height: 50px;
}
.img {
  width: 100%;
}
</style>