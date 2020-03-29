console.log(`Testing env variable VUE_BUILD_MODE: ${process.env.NODE_ENV}`)

module.exports = {
  runtimeCompiler: true,
  configureWebpack: {
    devServer: {
      compress: true,
      disableHostCheck: true
    },
    module: {
      rules: [
        {
          test: /\.scss$/,
          use: [
            'vue-style-loader',
            'css-loader',
            {
              loader: 'sass-loader',
              options: {
                indentedSyntax: true,
                // sass-loader version >= 8
                sassOptions: {
                  indentedSyntax: true
                }
              }
            }
          ]
        }
      ]
    },
  }
}