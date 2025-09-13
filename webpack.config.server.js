// webpack.config.server.js

const path = require('path')
const nodeExternals = require('webpack-node-externals')

module.exports = {
  entry: './server/server.js',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'server.generated.js'
  },
  target: 'node',
  externals: [nodeExternals()],
  module: {
    rules: [
      // Transpile JS
      {
        test: /\.js$/,
        loader: 'babel-loader',
        exclude: /node_modules/
      },
      // Handle images on the server bundle
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
  }
}
