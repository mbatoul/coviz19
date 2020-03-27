<template>
  <div>
    <div
      class='loading'
      v-if='isLoading'>
    </div>
    <Tweet
      v-else
      v-for='(tweet, id) in tweetsList'
      v-bind:key='id'
      v-bind:id='tweet.id_str'
      v-bind:options="{ cards: 'hidden' }"
      widget-class='tweet-custom'
    />
  </div>
</template>

<script>
import { Tweet } from 'vue-tweet-embed'

export default {
  components: {
    Tweet
  },

  props: {
    selectedZonesNames: {
      type: Array,
      required: true
    }
  },

  data () {
    return {
      tweetsList: [],
      isLoading: false
    }
  },

  computed: {
    currentSelectedZonesNames: function () {
      return this.selectedZonesNames;
    }
  },

  watch: {
    currentSelectedZonesNames: function () {
      this.getTweets();
    }
  },

  mounted () {
    this.getTweets();
  },

  methods: {
    getTweets: async function () {
      let queryString;

      if (this.selectedZonesNames.length) {
        queryString = this.selectedZonesNames[this.selectedZonesNames.length - 1];
      } else {
        queryString = 'world';
      }

      try {
        this.isLoading = true;
        const response = await this.$http.get(`/tweets.json?zones=${queryString}`);
        this.tweetsList = [];
        this.tweetsList.push(... response.data[0][1]);
        this.isLoading = false
      } catch (error) {
        console.error(error)
      }
    },
  }
}
</script>