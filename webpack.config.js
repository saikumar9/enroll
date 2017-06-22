const path = require('path');
const nodeModulesPath = path.resolve(__dirname, 'node_modules');
const mainPath = path.resolve(__dirname, 'app/assets/angular2');
const webpack = require('webpack');
const { CheckerPlugin } = require('awesome-typescript-loader');
const UglifyJSPlugin = require('uglifyjs-webpack-plugin');

module.exports = {
	entry: { 
		angular2: "./app/assets/angular2/incremental.ts",
		angular2_polyfills: "./app/assets/angular2/polyfills.ts"
	},
	output: {
		path: path.resolve(__dirname, "app/assets/javascripts"),
		filename: "[name].js"
	},
	module: {
		rules: [
		{ test: /\.css$/, loaders: ['raw-loader'], include: [mainPath] },
		{ test: /\.ts$/,
			loaders: ['awesome-typescript-loader?configFileName=./app/assets/angular2/tsconfig.json', 'angular2-template-loader'],
			exclude: [/\.(spec|e2e)\.ts$/, /\.spec\.ts$/, /node_modules\/(?!(ng2-.+))/, /\.e2e-spec\.ts$/] },
		{ test: /\.html$/, loader: 'raw-loader', include: [mainPath] }
		]
	},
	resolve: {
		modules: [nodeModulesPath],
		extensions: ['.ts', '.js' ],
		alias: {}
	},
	plugins: [
		new CheckerPlugin(),
		new webpack.ProvidePlugin({
			jQuery: 'jquery',
			$: 'jquery',
			jquery: 'jquery'
		}),
		new UglifyJSPlugin({mangle: false, comments: false})
	],
	externals: {
		jquery: 'jQuery'
	}
};
