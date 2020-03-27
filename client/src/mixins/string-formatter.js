export default {
  methods: {
    maybePluralize: function (count, noun, suffix = 's') {
      return `${count} ${noun}${count !== 1 ? suffix : ''}`;
    }
  }
}