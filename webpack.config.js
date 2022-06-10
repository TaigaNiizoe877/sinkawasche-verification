const path = require("path")
const webpack = require("webpack")
const glob = require("glob");

const entries = glob
  .sync("./app/javascript/*.js", {})
  .map(function (key) {
    const filename = path.basename(key, '.js');
    return [filename, key];
  });

// 配列→{key:value}の連想配列へ変換
const entryObj = Object.fromEntries(entries);
console.log(entryObj)
module.exports = {
  mode: "production",
  devtool: "source-map",
  entry: entryObj,
  output: {
    filename: "[name].js",
    sourceMapFilename: "[name].js.map",
    path: path.resolve(__dirname, "app/assets/builds"),
  },
  plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1
    }),
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
    })
  ]
}
