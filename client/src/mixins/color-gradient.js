export default  {
  methods: {
    getRedColor: function (value) {
      switch (true) {
        case (value > 2000): return '#82152b';
        case (value > 1000): return '#ad1b39';
        case (value > 100): return '#d82247';
        case (value > 10): return '#ee385e';
        case (value > 0): return '#f1607e';
        default: return '#EAEAEA';
      }
    },
    
    getBlueColor: function (value) {
      switch (true) {
        case (value > 10000): return '#1728b1';
        case (value > 5000): return '#2d3ec7';
        case (value > 1000): return '#5764d2';
        case (value > 100): return '#818bdd';
        case (value > 0): return '#abb1e8';
        default: return '#EAEAEA';
      }
    },
    
    getGreenColor: function (value) {
      switch (true) {
        case (value > 1000): return '#00441b';
        case (value > 500): return '#006d2c';
        case (value > 200): return '#238b45';
        case (value > 100): return '#41ab5d';
        case (value > 50): return '#74c476';
        case (value > 20): return '#a1d99b';
        case (value > 10): return '#c7e9c0';
        default: return '#EAEAEA';
      }
    },
  
    getColor: function (value, category) {
      switch (category) {
        case 'death': return this.getRedColor(value);
        case 'confirmed': return this.getBlueColor(value);
        case 'recovered': return this.getGreenColor(value);
        default: return '';
      }
    }
  }
}