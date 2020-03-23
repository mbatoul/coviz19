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
    country: {
      type: String,
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
    currentCountry: function () {
      return this.country;
    }
  },

  watch: {
    currentCountry: function () {
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
        const response = await this.$http.get(`/tweets.json?country=${this.country}`);
        this.tweetsList = [];
        this.tweetsList.push(... response.data[0][1]);
        this.setTweetsWidth();
        this.isLoading = false
      } catch (error) {
        console.error(error)
      }
    },

    setTweetsWidth: function () {
      setTimeout((function() {
        return document.querySelectorAll('.twitter-tweet').forEach((div) => {
          div.style.width = '100%';
          div.shadowRoot.querySelector('.SandboxRoot').querySelector('.EmbeddedTweet').style.width = '99%';
          div.shadowRoot.querySelector('.SandboxRoot').querySelector('.EmbeddedTweet').style.maxWidth = '100%';
        });
      }), 3000);
    }
  }
}
</script>