export default {
  methods: {
    maybePluralize: function (count, noun, suffix = 's') {
      return `${count} ${noun}${count !== 1 ? suffix : ''}`;
    },
    capitalize: function (string) {
      return string.charAt(0).toUpperCase() + string.slice(1);
    }
  }
}