module.exports = {
  devServer: {
    compress: true,
    contentBase: './public',
    host: '0.0.0.0',
    port: '8080',
    proxy: {
      '/api': {
        target: 'http://backend:4711'
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
    ]
  },
  resolve: {
    alias: {
      'jquery-dateformat': 'jquery-dateformat/dist/jquery-dateFormat.js'
    }
  }
};
