<template>
  <nav class="level">
    <div class="level-item has-text-centered">
      <div
        class='has-text-danger has-background-light box-category shadow'
        v-on:click="onCategorySelected('death')"
        v-bind:class=" { 'selected': currentCategory === 'death' }"
      >
        <p class="heading is-size-8">Total Deaths</p>
        <div class="box-category-figure">
          <div
            class='loading small'
            v-if='totalDeath === null'>
          </div>
          <p
            class="title is-size-4"
            v-else
          >
            {{ numberWithCommas(totalDeath) }}
          </p>
        </div>
      </div>
    </div>

    <div class="level-item has-text-centered">
      <div
        class='has-text-info has-background-light box-category shadow'
        v-on:click="onCategorySelected('confirmed')"
        v-bind:class=" { 'selected': currentCategory === 'confirmed' }"
      >
        <p class="heading is-size-8">Total Confirmed</p>
        <div
          class='loading small'
          v-if='totalConfirmed === null'>
        </div>
        <p
          class="title is-size-4"
          v-else 
        >
          {{ numberWithCommas(totalConfirmed) }}
        </p>
      </div>
    </div>

    <div class="level-item has-text-centered">
      <div
        class='has-text-success has-background-light box-category shadow'
        v-on:click="onCategorySelected('recovered')"
        v-bind:class=" { 'selected': currentCategory === 'recovered' }"
      >
        <p class="heading is-size-8">Total Recovered</p>
        <div
          class='loading small'
          v-if='totalRecovered === null'>
        </div>
        <p
          class="title is-size-4"
          v-else 
        >
          {{ numberWithCommas(totalRecovered) }}
        </p>
      </div>
    </div>
  </nav>
</template>

<script>
export default {
  props: {
    currentCategory: {
      type: String,
      required: true,
    },
    totalDeath: {
      required: true,
      validator: prop => typeof prop === 'number' || prop === null
    },
    totalConfirmed: {
      required: true,
      validator: prop => typeof prop === 'number' || prop === null
    },
    totalRecovered: {
      required: true,
      validator: prop => typeof prop === 'number' || prop === null
    },
    isLoading: {
      type: Boolean,
      required: true
    }
  },

  methods: {
    numberWithCommas: function (number) {
      return number.toLocaleString();
    },
    onCategorySelected: function (category) {
      this.$emit('categorySelected', category);
    }
  }
}
</script>

<style scoped>
  .box-category {
    padding: 20px;
    border-radius: 5px;
    cursor: pointer;
    border: 1px solid #EAEAEA;
    width: 160px;
    height: 100px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
  }

  .box-category:hover {
    transform: translateY(-2px);
    transition: 0.3s ease all;
  }

  .box-category.selected {
    border: 1px solid #646464;
  }

  .box-category .box-category-figure{
    height: 30px;
  }

  .categories {
    margin-bottom: 25px;
  }
</style>