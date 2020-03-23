export default {
  methods: {
    parameterize: function (string) {
      return string
        .trim()
        .toLowerCase()
        .replace(/[^a-zA-Z0-9 -]/, '')
        .replace(/\s/g, '-');
    },

    maybePluralize: function (count, noun, suffix = 's') {
      return `${count} ${noun}${count !== 1 ? suffix : ''}`;
    }
  }
}