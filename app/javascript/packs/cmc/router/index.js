import Vue from 'vue'
import Router from 'vue-router'

// in development-env not use lazy-loading, because lazy-loading too many pages will cause webpack hot update too slow. so only in production use lazy-loading;
// detail: https://panjiachen.github.io/vue-element-admin-site/#/lazy-loading

Vue.use(Router)

/* Layout */
import Layout from '../views/layout/Layout.vue'

/**
* hidden: true                   if `hidden:true` will not show in the sidebar(default is false)
* alwaysShow: true               if set true, will always show the root menu, whatever its child routes length
*                                if not set alwaysShow, only more than one route under the children
*                                it will becomes nested mode, otherwise not show the root menu
* redirect: noredirect           if `redirect:noredirect` will no redirect in the breadcrumb
* name:'router-name'             the name is used by <keep-alive> (must set!!!)
* meta : {
    title: 'title'               the name show in submenu and breadcrumb (recommend set)
    icon: 'svg-name'             the icon show in the sidebar
    breadcrumb: false            if false, the item will hidden in breadcrumb(default is true)
  }
**/
export const constantRouterMap = [
  { path: '/login', component: () => import('../views/login/index.vue'), hidden: true },
  { path: '/404', component: () => import('../views/404.vue'), hidden: true },

  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
    name: 'Dashboard',
    hidden: true,
    children: [{
      path: 'dashboard',
      component: () => import('../views/dashboard/index.vue')
    }]
  },
  
    {
    path: '/data',
    component: Layout,
    redirect: '/data/records',
    name: 'system_data_records',
    meta: { title: '数据管理', icon: 'file' },
    children: [
      {
        path: 'records',
        name: 'records',
        component: () => import('../views/dashboard/records.vue'),
        meta: { title: '请假记录', icon: 'calendar' }
      }
    ]
  },
  
  {
    path: '/user',
    component: Layout,
    redirect: '/users/workers',
    name: 'system_users',
    meta: { title: '用户管理', icon: 'team' },
    children: [
      {
        path: 'workers',
        name: 'workers',
        component: () => import('../views/dashboard/users.vue'),
        meta: { title: '干部', icon: 'user' }
      },
      {
        path: 'admins',
        name: 'admins',
        component: () => import('../views/dashboard/admins.vue'),
        meta: { title: '管理员', icon: 'admin' }
      },{
        path: 'vote_members',
        name: 'vote_members',
        component: () => import('../views/dashboard/vote_members.vue'),
        meta: { title: '投票员', icon: 'vote-member' }
      }
    ]
  },
  
  {
    path: '/config',
    component: Layout,
    redirect: '/config/departments',
    name: 'system_config',
    meta: { title: '系统设置', icon: 'example' },
    children: [
      {
        path: 'departments',
        name: 'departments',
        component: () => import('../views/dashboard/departments.vue'),
        meta: { title: '部门', icon: 'table' }
      },
      {
        path: 'rank',
        name: 'rank',
        component: () => import('../views/dashboard/positions.vue'),
        meta: { title: '职级', icon: 'tree' }
      }
    ]
  },
  {
    path: '/editor',
    name: 'editor',
    hidden: true,
    redirect: 'noredirect',
    meta: { title: '编辑器' },
    component: Layout,
    children: [
      {
        path: 'record/:id?',
        name: 'editor_record',
        meta: {
          title: '编辑请假记录'
        },
        component: () => import('../views/form/record.vue'),
      }
    ]
  },
  // {
  //   path: '/example',
  //   component: Layout,
  //   redirect: '/example/table',
  //   name: 'Example',
  //   meta: { title: 'Example', icon: 'example' },
  //   children: [
  //     {
  //       path: 'table',
  //       name: 'Table',
  //       component: () => import('../views/table/index.vue'),
  //       meta: { title: 'Table', icon: 'table' }
  //     },
  //     {
  //       path: 'tree',
  //       name: 'Tree',
  //       component: () => import('../views/tree/index.vue'),
  //       meta: { title: 'Tree', icon: 'tree' }
  //     }
  //   ]
  // },

  // {
  //   path: '/form',
  //   component: Layout,
  //   children: [
  //     {
  //       path: 'index',
  //       name: 'Form',
  //       component: () => import('../views/form/index.vue'),
  //       meta: { title: 'Form', icon: 'form' }
  //     }
  //   ]
  // },

  // {
  //   path: '/nested',
  //   component: Layout,
  //   redirect: '/nested/menu1',
  //   name: 'Nested',
  //   meta: {
  //     title: 'Nested',
  //     icon: 'nested'
  //   },
  //   children: [
  //     {
  //       path: 'menu1',
  //       component: () => import('../views/nested/menu1/index.vue'), // Parent router-view
  //       name: 'Menu1',
  //       meta: { title: 'Menu1' },
  //       children: [
  //         {
  //           path: 'menu1-1',
  //           component: () => import('../views/nested/menu1/menu1-1/index.vue'),
  //           name: 'Menu1-1',
  //           meta: { title: 'Menu1-1' }
  //         },
  //         {
  //           path: 'menu1-2',
  //           component: () => import('../views/nested/menu1/menu1-2/index.vue'),
  //           name: 'Menu1-2',
  //           meta: { title: 'Menu1-2' },
  //           children: [
  //             {
  //               path: 'menu1-2-1',
  //               component: () => import('../views/nested/menu1/menu1-2/menu1-2-1/index.vue'),
  //               name: 'Menu1-2-1',
  //               meta: { title: 'Menu1-2-1' }
  //             },
  //             {
  //               path: 'menu1-2-2',
  //               component: () => import('../views/nested/menu1/menu1-2/menu1-2-2/index.vue'),
  //               name: 'Menu1-2-2',
  //               meta: { title: 'Menu1-2-2' }
  //             }
  //           ]
  //         },
  //         {
  //           path: 'menu1-3',
  //           component: () => import('../views/nested/menu1/menu1-3/index.vue'),
  //           name: 'Menu1-3',
  //           meta: { title: 'Menu1-3' }
  //         }
  //       ]
  //     },
  //     {
  //       path: 'menu2',
  //       component: () => import('../views/nested/menu2/index.vue'),
  //       meta: { title: 'menu2' }
  //     }
  //   ]
  // },

  // {
  //   path: 'external-link',
  //   component: Layout,
  //   children: [
  //     {
  //       path: 'https://panjiachen.github.io/vue-element-admin-site/#/',
  //       meta: { title: 'External Link', icon: 'link' }
  //     }
  //   ]
  // },

  { path: '*', redirect: '/404', hidden: true }
]

export default new Router({
  // mode: 'history', //后端支持可开
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRouterMap
})
