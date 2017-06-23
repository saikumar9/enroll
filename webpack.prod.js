const path = require('path');
const nodeModulesPath = path.resolve(__dirname, 'node_modules');
const mainPath = path.resolve(__dirname, 'app/assets/angular2');
const webpack = require('webpack');
const { CheckerPlugin } = require('awesome-typescript-loader');
const UglifyJSPlugin = require('uglifyjs-webpack-plugin');
const { NgcWebpackPlugin } = require('ngc-webpack');

module.exports = {
	entry: { 
		angular2: "./app/assets/angular2/dist-aot/incremental.prod.js"
	},
	output: {
		path: path.resolve(__dirname, "app/assets/javascripts"),
		filename: "[name].js"
	},
	module: {
		rules: [
		{ test: /\.css$/, loaders: ['raw-loader'], include: [mainPath] },
		{ test: /\.html$/, loader: 'raw-loader', include: [mainPath] }
		]
	},
	resolve: {
		modules: [nodeModulesPath],
		extensions: ['.ts', '.js' ],
		alias: { }
	},
	plugins: [
		new NgcWebpackPlugin({
			tsConfig: "./app/assets/angular2/tsconfig.prod.json",
			debug: "true"
		}),
		new webpack.ProvidePlugin({
			jQuery: 'jquery',
			$: 'jquery',
			jquery: 'jquery'
		}),
		new UglifyJSPlugin({mangle: false, comments: false}),
		new webpack.ContextReplacementPlugin(/moment[\/\\]locale$/, /en/)
	],
	externals: {
		jquery: 'jQuery'
	}
};
