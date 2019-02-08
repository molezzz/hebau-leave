<template>
  <div class="app-container">
    <el-table
      v-loading="listLoading"
      :data="list"
      element-loading-text="Loading"
      border
      fit
      highlight-current-row>
      <el-table-column align="center" label="ID" width="95">
        <template slot-scope="scope">
          {{ scope.row.id }}
        </template>
      </el-table-column>
      <el-table-column label="用户名">
        <template slot-scope="scope">
          {{ scope.row.username }}
        </template>
      </el-table-column>
      <el-table-column label="最后登录时间" width="160" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.last_sign_in_at }}</span>
        </template>
      </el-table-column>
      <el-table-column label="最后登录IP" width="160" align="center">
        <template slot-scope="scope">
          {{ scope.row.last_sign_in_ip }}
        </template>
      </el-table-column>
      <el-table-column align="center" prop="created_at" label="创建时间" width="250">
        <template slot-scope="scope">
          <i class="el-icon-time"/>
          <span>{{ scope.row.created_at}}</span>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
import request from '../../utils/request'

export default {
  data() {
    return {
      list: null,
      listLoading: true
    }
  },
  created() {
    this.fetchData()
  },
  methods: {
    fetchData() {
      this.listLoading = true
      request({
        url: '/admins'
      }).then(response => {
        this.list =  response
        this.listLoading = false
      })
    }
  }
}
</script>
