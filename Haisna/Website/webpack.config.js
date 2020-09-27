const path = require('path');
const webpack = require('webpack');

module.exports = {
  entry: {
    index: ['babel-polyfill', 'react-hot-loader/patch', './ClientApp/index.jsx'],
    login: ['babel-polyfill', 'react-hot-loader/patch', './ClientApp/login.jsx'],
  },
  output: {
    path: path.resolve(__dirname, 'wwwroot/dist'),
    publicPath: '/dist/',
    filename: '[name].js',
  },
  module: {
    rules: [
      {
        test: /\.(jsx|js)$/,
        exclude: /node_modules/,
        use: [
          'babel-loader',
        ],
      },
      {
        test: /\.css$/,
        use: [
          {
            loader: require.resolve('style-loader'),
          },
          {
            loader: require.resolve('css-loader'),
            options: {
              modules: true,
              localIdentName: '[path]___[name]__[local]___[hash:base64:5]',
            },
          },
        ],
      },
      {
        test: [/\.(png|jpg|jpeg)$/],
        loader: 'url-loader',
      },
      {
        test: /\.svg$/,
        loader: 'url-loader?mimetype=image/svg+xml',
      },
      {
        test: /\.(woff|woff2|eot|ttf)$/,
        loader: 'url-loader?mimetype=application/font-woff',
      },
      {
        test: /\.mp3$/,
        loader: 'file-loader',
      },
    ],
  },
  plugins: [
    new webpack.ProvidePlugin({
      Promise: 'bluebird',
    }),
    new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/),
  ],
  resolve: {
    extensions: ['.js', '.jsx'],
  },
  devtool: (process.env.NODE_ENV !== 'production') ? 'source-map' : false,
};

if (process.env.NODE_ENV === 'production') {
  module.exports.plugins = (module.exports.plugins || []).concat([
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: JSON.stringify('production'),
      },
    }),
    new webpack.optimize.UglifyJsPlugin(),
  ]);
}

