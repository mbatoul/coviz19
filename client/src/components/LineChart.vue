<script>
  import { Line } from 'vue-chartjs';

  export default {
    extends: Line,

    props: ['data', 'options', 'plugins'],
    
    mounted () {
      this.renderChart(this.data, this.options);
    },

    watch: {
      data() {
        this.renderChart(this.data, this.options);
      }
    },
  }
</script>
