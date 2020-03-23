<template>
  <div>
    <div
      class='loading'
      v-if='isLoading'>
    </div>
    <NewsItem
      v-else
      v-for='(article, id) in articlesList'
      v-bind:key='id'
      v-bind:title='article.title'
      v-bind:url-to-image='article.image.url'
      v-bind:url='article.url'
    />
  </div>
</template>

<script>
import NewsItem from './NewsItem.vue';
import newsApi from '../plugins/news-api.js'

export default {
  components: {
    NewsItem
  },

  props: {
    country: {
      type: String,
      required: true
    }
  },

  data () {
    return {
      articlesList: [],
      isLoading: false
    }
  },

  computed: {
    currentCountry: function () {
      return this.country;
    }
  },

  watch: {
    currentCountry: function () {
      this.getArticles();
    }
  },

  mounted () {
    this.getArticles();
  },

  methods: {
    getArticles: async function () {
      try {
        this.isLoading = true;
        const response = await newsApi.get(`?q=coronavirus,covid,${this.country}&pageSize=10`)
        this.articlesList = [];
        this.articlesList.push(... response.data.value);
        this.isLoading = false;
      } catch (error) {
        console.error(error)
      }
    },
  }
}
</script>