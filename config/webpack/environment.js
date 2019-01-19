const { environment } = require('@rails/webpacker')
const { resolve } = require('path')
const VueLoaderPlugin = require('vue-loader/lib/plugin')
const fileLoader = environment.loaders.get('file')

fileLoader.exclude = [resolve('app/javascript/packs/cmc/icons')]

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
    include: [resolve('app/javascript/packs/cmc/icons')],
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
//         name: 'img/[name].[hash:7].[ext]'
//     }
// });

// throw JSON.stringify(environment, null, 2)

module.exports = environment
