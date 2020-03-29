module.exports = {
  runtimeCompiler: true,
  configureWebpack: {
    devServer: {
      compress: true,
      disableHostCheck: true,
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