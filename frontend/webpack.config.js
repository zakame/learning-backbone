var webpack = require('webpack');

module.exports = {
  devServer: {
    compress: true,
    contentBase: './public',
    host: '0.0.0.0',
    port: '8080',
    proxy: {
      '/api': {
        target: process.env.BACKEND
      }
    }
  },
  entry: {
    library: './src/library/js/app.js',
    todos: './src/todos/js/app.js'
  },
  output: {
    path: __dirname + '/public/assets',
    publicPath: '/assets/',
    filename: '[name].bundle.js'
  },
  module: {
    loaders: [
      {
        test: /\.css$/,
        loader: 'style-loader!css-loader'
      },
      {
        test: /\.(jpe?g|png|gif|)$/i,
        loader: 'file-loader'
      },
      {
        test: /\.html$/,
        loader: 'underscore-template-loader'
      }
    ]
  },
  plugins: [
    new webpack.ProvidePlugin({
      _: 'underscore',
      $: 'jquery',
      Backbone: 'backbone',
      jQuery: 'jquery',
      'window.jQuery': 'jquery'
    })
  ],
  resolve: {
    alias: {
      'jquery-dateformat': 'jquery-dateformat/dist/jquery-dateFormat.js'
    }
  }
};
