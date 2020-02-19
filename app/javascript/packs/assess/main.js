import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

Vue.config.productionTip = false

let router = new Router({
  // mode: 'history', //后端支持可开
  scrollBehavior: () => ({ y: 0 }),
  routes: [
    {
      path: '',
      name: 'vote',
      component: () => import('./vote.vue')
    }
  ]
})

new Vue({
  el: '#app',
  router
})