<template>
  <a v-bind:href="url" target='_blank'>
    <div class="news is-flex">
      <div class="flex-item">
        <p class='has-text-weight-bold has-text-grey'>{{ author.toUpperCase() }}</p>
        <div class='content' v-html='title'>
        </div>
      </div>
      <div class="flex-item" v-if='urlToImage'>
        <div class="img-container">
          <img v-bind:src="urlToImage" alt="">
        </div>
      </div>
    </div>
  </a>
</template>

<script>
export default {
  props: {
    author: {
      type: String
    },
    content: {
      type: String
    },
    description: {
      type: String
    },
    publishedAt: {
      type: String
    },
    source: {
      type: Object
    },
    title: {
      type: String
    },
    url: {
      type: String
    },
    urlToImage: {
      type: String
    },
  },
}
</script>

<style scoped>
  .news{
    align-items: center;
    justify-content: space-between;
    color: #1c2022;
    padding: 1.25rem;
    border-bottom: 1px solid #EAEAEA;
    width: 100%;
    background-color: white;
  }

  .news:hover{
    opacity: 0.8;
    transition: 0.3s ease all;
  }

  .img-container{
    width: 90px;
    height: auto;
    background-color: transparent;
  }

  .img-container img {
    width: 100%;
    height: 100%;
    border-radius: 2px;
  }

  @media(max-width: 1024px) {
    .img-container {
      display: none;
    }
  }

  .content{
    text-align: left;
    padding-right: 15px;
  }

  .shadow {
    box-shadow: 0px 10px 20px 0px rgba(0,108,86,0.15);
    -moz-box-shadow: 0px 10px 20px 0px rgba(0,108,86,0.15);
    -webkit-box-shadow: 0px 10px 20px 0px rgba(0,108,86,0.15);
    -o-box-shadow: 0px 10px 20px 0px rgba(0,108,86,0.15);
  }
</style>