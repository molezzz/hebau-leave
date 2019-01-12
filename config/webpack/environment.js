const { environment } = require('@rails/webpacker')
const VueLoaderPlugin = require('vue-loader/lib/plugin')

// Set nested object prop using path notation
// environment.config.set('resolve.extensions', ['.foo', '.bar'])
// environment.config.set('output.filename', '[name].js')
environment.config.merge({
    externals: {
      vue: 'Vue'
    }
})

// Delete a property
// environment.config.delete('output.chunkFilename')
environment.plugins.append('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.append('vue-loader', {
    test: /\.vue$/,
    loader: 'vue-loader'
});
environment.loaders.append('svg-loader', {
    test: /\.svg$/,
    loader: 'svg-sprite-loader',
    // include: [resolve('app/javascript/packs/cmc/icons')],
    options: {
      symbolId: 'icon-[name]'
    }
});
// environment.loaders.append('vue', {
//     test: /\.(png|jpe?g|gif|svg)(\?.*)?$/,
//     loader: 'url-loader',
//     include: [resolve('app/javascript/packs/cmc/icons')],
//     options: {
//         limit: 10000,
//         name: utils.assetsPath('img/[name].[hash:7].[ext]')
//     }
// });

module.exports = environment
