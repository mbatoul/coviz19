<template>
  <div>
    <div
      class='loading small'
      v-if='isLoading'>
    </div>
    <NewsItem
      v-else
      v-for='(article, id) in articlesList'
      v-bind:key='id'
      v-bind:author='article.source.name'
      v-bind:title='article.title'
      v-bind:url-to-image='article.urlToImage'
      v-bind:url='article.url'
    />
  </div>
</template>

<script>
import NewsItem from './NewsItem.vue';

export default {
  components: {
    NewsItem
  },

  props: {
    zoneName: {
      type: String,
      default: () => 'world',
      required: true
    }
  },

  data () {
    return {
      articlesList: [],
      isLoading: false,
    }
  },

  computed: {
    currentZoneName: function () {
      return this.zoneName;
    }
  },

  watch: {
    currentZoneName: function () {
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
        let oneWeekAgo = new Date();
        oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);
        oneWeekAgo = `${oneWeekAgo.getFullYear()}-${oneWeekAgo.getUTCMonth() + 1}-${oneWeekAgo.getUTCDay()}`
        const response = await this.$http.get(`http://newsapi.org/v2/everything?q=coronavirus&from=${oneWeekAgo}&sortBy=publishedAt&apiKey=${process.env.VUE_APP_NEWS_API_KEY}`)
        this.articlesList = [];
        this.articlesList.push(... response.data.articles);
        this.isLoading = false;
      } catch (error) {
        console.error(error)
      }
    },
  }
}
</script>