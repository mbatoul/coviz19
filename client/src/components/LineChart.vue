<template>
  <div>
    <ul>
      <li v-for='(zone, id) in selectedZones' v-bind:key='id'>
        {{ zone }}
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  props: {
    selectedZones: {
      type: Array
    }
  }
}
</script>

<style>

</style>