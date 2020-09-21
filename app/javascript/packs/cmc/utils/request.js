import axios from 'axios'
import { Message, MessageBox } from 'element-ui'
import store from '../store'
import { getToken } from './auth'
import Qs from 'qs'
import rs from 'jsrsasign'

let header = {alg: 'HS256', typ: 'JWT'}
let payload = {}
payload.iat = rs.jws.IntDate.get('now')
payload.exp = rs.jws.IntDate.get('now + 1year')
payload.jti = `rid-${Math.ceil(Math.random() * 100000)}`

let jwt = rs.jws.JWS.sign('HS256', JSON.stringify(header) , JSON.stringify(payload), 'hebau-weapp')

// 创建axios实例
const service = axios.create({
  baseURL: process.env.BASE_API, // api 的 base_url
  timeout: 50000, // 请求超时时间
  headers: {
    'Accept': 'application/json',
    'x-acc-token': jwt
  }
})

// request拦截器
service.interceptors.request.use(
  config => {

    if (store.getters.token) {
      config.headers['Authorization'] = 'Bearer ' + getToken() // 让每个请求携带自定义token 请根据实际情况自行修改
    }
    return config
  },
  error => {
    // Do something with request error
    console.log(error) // for debug
    Promise.reject(error)
  }
)
// Format nested params correctly
service.interceptors.request.use(config => {

  config.paramsSerializer = params => {
    // Qs is already included in the Axios package
    return Qs.stringify(params, {
      arrayFormat: "brackets",
      encode: false
    });
  };

  return config;
})

// response 拦截器
service.interceptors.response.use(
  response => {
    /**
     * code为非20000是抛错 可结合自己业务进行修改
     */
    const res = response.data
    if (response.status >= 400) {
      Message({
        message: res.message,
        type: 'error',
        duration: 5 * 1000
      })

      // 50008:非法的token; 50012:其他客户端登录了;  50014:Token 过期了;
      if (res.code === 50008 || res.code === 50012 || res.code === 50014) {
        MessageBox.confirm(
          '你已被登出，可以取消继续留在该页面，或者重新登录',
          '确定登出',
          {
            confirmButtonText: '重新登录',
            cancelButtonText: '取消',
            type: 'warning'
          }
        ).then(() => {
          store.dispatch('FedLogOut').then(() => {
            location.reload() // 为了重新实例化vue-router对象 避免bug
          })
        })
      }
      return Promise.reject('error')
    } else {
      return response.data
    }
  },
  error => {
    const res = error.response;

    let message = error.message
    let details = []
  
    console.log('err -> ' + error) // for debug
    if(res.data && res.data.details){
      for(var k in res.data.details) {
        details.push(`${k}: ${res.data.details[k].join(';')}`)
      }
      message = details.join("<br>")
    }
    Message({
      message: message,
      type: 'error',
      duration: 5 * 1000
    })
    return Promise.reject(error)
  }
)

export default service
