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
      v-bind:author='article.provider.name'
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
      let query = this.zoneName;

      if (query === 'us') {
        query = 'trump'
      } else if (query === 'world') {
        query = ''
      }
      try {
        this.isLoading = true;
        const response = await newsApi.get(`?q=coronavirus,covid,${query}&pageSize=20`)
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