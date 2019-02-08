import request from '../utils/request'

export function login(username, password) {
  return request({
    url: '/admin_token',
    method: 'post',
    data:{ 
      auth: {
        username,
        password
      }
    }
  })
}

export function getInfo() {
  return request({
    url: '/user/info',
    method: 'get'
  })
}

export function logout() {
  return request({
    url: '/admin/logout',
    method: 'post'
  })
}
