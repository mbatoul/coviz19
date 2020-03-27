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
  width: 30px;
  height: 30px;
  margin-left: 10px;
}
.img {
  width: 100%;
}
</style>