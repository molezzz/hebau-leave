<template>
  <div class="app-container">
    <div class="form-toolbar">
      <div class="left"></div>
      <div class="right">
        <el-input
          placeholder="请输入姓名或手机号查询"
          prefix-icon="el-icon-search"
          v-model="filters.name"
          style="width: 240px"
          >
        </el-input>
        <el-button type="primary" @click="fetchData(1)">查询</el-button>
      </div>
    </div>
    <el-form label-position="right" status-icon :model="ruleForm" ref="tableForm" class="user-list">
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
        <el-table-column label="姓名">
          <template slot-scope="scope">
            <template v-if="scope.row.onEdit">
              <el-form-item prop="realname" :rules="[{ required: true, message: '真实姓名不能为空'}]">
                <el-input v-model="scope.row.realname" placeholder="请输入真实姓名"></el-input>
              </el-form-item>
            </template>
            <template v-else>
            {{ scope.row.realname }}
            </template>
          </template>
        </el-table-column>
        <el-table-column label="手机号">
          <template slot-scope="scope">
            <template v-if="scope.row.onEdit">
              <el-form-item prop="mobile" :rules="[{ required: true, message: '手机号不能为空'}]">
                <el-input v-model="scope.row.mobile" placeholder="填写手机号"></el-input>
              </el-form-item>
            </template>
            <template v-else>
            {{ scope.row.mobile }}
            </template>
          </template>
        </el-table-column>
        <el-table-column label="所属部门" width="160" align="center">
          
          <template slot-scope="scope">
            <template v-if="scope.row.onEdit">
              <el-select v-model="scope.row.department_id" placeholder="请选择">
                
                <el-option
                  v-for="(item, key) in departments"
                  :key="key"
                  :label="item.name"
                  :value="item.id">
                </el-option>
                
              </el-select>
            </template>
            <template v-else>
              {{ scope.row.department ? scope.row.department.name : '-' }}
            </template>
          </template>
        </el-table-column>
        <el-table-column label="职务">
          <template slot-scope="scope">
            <template v-if="scope.row.onEdit">
              <el-form-item prop="job">
                <el-input v-model="scope.row.job" placeholder="工作职务，例如党办主任"></el-input>
              </el-form-item>
            </template>
            <template v-else>
            {{ scope.row.job }}
            </template>
          </template>
        </el-table-column>
        <el-table-column label="级别" width="160" align="center">
          
          <template slot-scope="scope">
            <template v-if="scope.row.onEdit">
              <el-select v-model="scope.row.position_id" placeholder="请选择">
                
                <el-option
                  v-for="(item, key) in positions"
                  :key="key"
                  :label="item.name"
                  :value="item.id">
                </el-option>
                
              </el-select>
            </template>
            <template v-else>
              {{ scope.row.position ? scope.row.position.name : '-' }}
            </template>
          </template>
        </el-table-column>
        <el-table-column align="center" prop="bind_wechat" label="已绑微信" width="50">
          <template slot-scope="scope">
            <i class="el-icon-circle-check" style="color: #67C23A" v-if="scope.row.bind_wechat"></i>
          </template>
        </el-table-column>
        <el-table-column align="center" prop="created_at" label="最后修改时间" width="250">
          <template slot-scope="scope">
            <i class="el-icon-time"/>
            <span>{{ scope.row.updated_at | dateFormat }}</span>
          </template>
        </el-table-column>
        <el-table-column align="center" width="120">
          <template slot="header" slot-scope="scope">
            <el-button size="mini" type="primary" plain icon="el-icon-plus" @click="addNewItem">新建</el-button>
          </template>
          <template slot-scope="scope">
            <template v-if="scope.row.onEdit">
              <el-button size="small" circle type="success" icon="el-icon-check" @click="saveItem(scope.$index)"></el-button>
              <el-button size="small" circle icon="el-icon-close" @click="cancelEditItem(scope.$index)"></el-button>
            </template>
            <template v-else>
              <el-button size="small" circle type="primary" icon="el-icon-edit" @click="editItem(scope.$index)"></el-button>
              <el-button size="small" circle type="danger" icon="el-icon-delete" @click="delItem(scope.$index)" v-if="!scope.row.bind_wechat"></el-button>
            </template>
          </template>  
        </el-table-column>
      </el-table>
    </el-form>
    <el-pagination
      background
      layout="prev, pager, next"
      :page-count="pageInfo.total_page"
      :current-page="pageInfo.current_page"
      @current-change="fetchData">
    </el-pagination>
  </div>
</template>

<style lang="sass">
.user-list {
  .el-form-item {
    margin-bottom: 0
  }
}
</style>

<script>
import request from '../../utils/request'
import { dateFormat } from '../../utils/datetime'

const basePath = '/users'

export default {
  data() {
    return {
      list: [],
      pageInfo: {
        perpage: 10,
        current_page: null,
        pervious_page: null,
        next_page: null,
        total_page: null
      },
      listLoading: false,
      ruleForm: {},
      positions: null,
      departments: null,
      filters: {
        name: null
      }
    }
  },
  filters: {
    dateFormat
  },
  created() {
    this.loadPositions()
    this.loadDepartments()
    this.fetchData()
  },
  methods: {
    fetchData(page) {
      if(this.listLoading) return
      let params = {
        perpage: this.pageInfo.perpage,
        page: page || 1
      }
      if(this.filters.name && this.filters.name != '') {
        params.q = {
          'realname_or_mobile_cont': this.filters.name
        }
      }
      this.listLoading = true
      request({
        url: basePath,
        params
      }).then(response => {
        this.list =  response.items
        this.pageInfo = Object.assign(this.pageInfo, response.page_info)
        this.listLoading = false
      })
    },
    addNewItem(){
      for(var i in this.list){
        if(this.list[i].isNew){
          return
        }
      }
      this.list.unshift({
        realname: null,
        isNew: true,
        onEdit: true
      })
      this.setEditRow(this.list[this.list.length - 1])
    },
    editItem(index){
      let row = this.list[index]

      this.setEditRow(row)
    },
    saveItem(index){
      let row = this.list[index]

      this.$refs['tableForm'].validate((valid) => {
        if(valid){
          if(row.isNew && !row.password) row.password = row.mobile || `pwd${Math.random()}`
          request({
            url: `${basePath}${row.isNew ? '' : '/' + row.id}`,
            method: row.isNew ? 'POST' : 'PATCH',
            data: {
              user: row
            }
          }).then((r)=> {
            this.$set(this.list, index, r)
            this.ruleForm = null
          })
        }
      })
    },
    cancelEditItem(index){
      let row = this.list[index]

      if(row.isNew) {
        this.removeItem(index)
      } else {
        row.onEdit = false
      }
      this.ruleForm = null
    },
    delItem(index){
      let row = this.list[index]

      if(confirm('是否要删除该条目？')){
        request({
          url: `${basePath}/${row.id}`,
          method: 'DELETE'
        }).then(() => {
          this.removeItem(index)
        })
      }
    },
    setEditRow(row){
      if(this.ruleForm) {
        if(this.ruleForm.isNew){
          this.removeItem(this.list.length - 1)
        } else {
          this.ruleForm.onEdit = false
        }
      }
      this.ruleForm = row
      this.$set(row, 'department_id', row.department ? row.department.id : null)
      this.$set(row, 'position_id', row.position ? row.position.id : null)
      this.$set(row,'onEdit', true)
    },
    removeItem(index){
      this.list.splice(index,1)
    },
    cateName(key){
      return this.categories[key] || '-'
    },
    loadPositions(){
      if(this.positions) return
      request({
        url: '/positions'
      }).then((data) => {
        this.positions = data
      })
    },
    loadDepartments(){
      if(this.departments) return
      request({
        url: '/departments'
      }).then((data) => {
        this.departments = data
      })
    }
  }
}
</script>
