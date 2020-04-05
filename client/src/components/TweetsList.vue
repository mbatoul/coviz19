<template>
  <div class="tweets-wrapper">
    <div
      class='loading small'
      v-if='isLoading'>
    </div>
    <div v-else>
      <Tweet
        v-for='(tweet, id) in tweetsList'
        v-bind:key='id'
        v-bind:id='tweet.id_str'
        v-bind:options="{ cards: 'hidden' }"
        widget-class='tweet-custom'
      />
    </div>
  </div>
</template>

<script>
import { Tweet } from 'vue-tweet-embed'

export default {
  components: {
    Tweet
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
      tweetsList: [],
      isLoading: false
    }
  },

  computed: {
    currentZoneName: function () {
      return this.zoneName;
    }
  },

  watch: {
    currentZoneName: function () {
      this.getTweets();
    }
  },

  mounted () {
    this.getTweets();
  },

  methods: {
    getTweets: async function () {
      try {
        this.isLoading = true;
        const response = await this.$http.get(`/tweets.json?zones=${this.zoneName}`);
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

<style>
  .tweets-wrapper {
    width: 100%;
  }

  @media(min-width: 1024px) {
    .tweets-wrapper {
      display: flex;
      justify-content: center;
      /* align-items: center; */
    }
  }

  .tweets-container {
    margin: 0 auto;
  }
</style>