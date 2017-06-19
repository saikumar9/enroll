const path = require('path');
const nodeModulesPath = path.resolve(__dirname, 'node_modules');
const mainPath = path.resolve(__dirname, 'app/assets/typescripts');
const webpack = require('webpack');
const { CheckerPlugin } = require('awesome-typescript-loader');

module.exports = {
	entry: { 
		ts_modules: "./app/assets/typescripts/src/ts_modules.ts",
	},
	output: {
		path: path.resolve(__dirname, "app/assets/javascripts"),
		filename: "[name].js"
	},
	module: {
		rules: [
		{ test: /\.ts$/,
			loaders: ['awesome-typescript-loader?configFileName=./app/assets/typescripts/tsconfig.json'],
			exclude: [/\.(spec|e2e)\.ts$/, /\.spec\.ts$/, /node_modules\/(?!(ng2-.+))/, /\.e2e-spec\.ts$/] }
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
		})
	],
	externals: {
		jquery: 'jQuery'
	}
};
