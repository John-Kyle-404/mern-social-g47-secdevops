// webpack.config.client.production.js

const path = require('path')

module.exports = {
  mode: 'production',
  // ← change entry from the non-existent index.js to your main.js
  entry: path.resolve(__dirname, 'client', 'main.js'),
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js',
    publicPath: '/dist/'
  },
  module: {
    rules: [
      // Transpile your React and JS
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader'
      },
      // Handle images imported in your client code
      {
        test: /\.(png|jpe?g|gif|svg)$/i,
        loader: 'file-loader',
        options: {
          name: '[name].[contenthash].[ext]',
          outputPath: 'assets/images',
          publicPath: '/dist/assets/images'
        }
      }
    ]
  },
  resolve: {
    extensions: ['.js', '.jsx', '.json']
  }
}
