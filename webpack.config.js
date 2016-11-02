module.exports = {
  devServer: {
    compress: true,
    contentBase: './public'
  },
  entry: {
    todos: './src/todos/js/app.js'
  },
  output: {
    path: __dirname + '/public',
    filename: '[name].bundle.js'
  }
};
