<template>
  <div class="app-container">
    <el-form label-position="right" status-icon :model="ruleForm" ref="tableForm">
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
        <el-table-column label="名称">
          <template slot-scope="scope">
            <template v-if="scope.row.onEdit">
              <el-form-item prop="name" :rules="[{ required: true, message: '名称不能为空'}]">
                <el-input v-model="scope.row.name" placeholder="请输入名称"></el-input>
              </el-form-item>
            </template>
            <template v-else>
            {{ scope.row.name }}
            </template>
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
              <el-button size="small" circle type="danger" icon="el-icon-delete" @click="delItem(scope.$index)"></el-button>
            </template>
          </template>  
        </el-table-column>
      </el-table>
    </el-form>
  </div>
</template>

<script>
import request from '../../utils/request'
import { dateFormat } from '../../utils/datetime'

const basePath = '/positions'

export default {
  data() {
    return {
      list: [],
      listLoading: true,
      ruleForm: {}
    }
  },
  filters: {
    dateFormat
  },
  created() {
    this.fetchData()
  },
  methods: {
    fetchData() {
      this.listLoading = true
      request({
        url: basePath
      }).then(response => {
        this.list =  response
        this.listLoading = false
      })
    },
    addNewItem(){
      for(var i in this.list){
        if(this.list[i].isNew){
          return
        }
      }
      this.list.push({
        name: null,
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
          request({
            url: `${basePath}${row.isNew ? '' : '/' + row.id}`,
            method: row.isNew ? 'POST' : 'PATCH',
            data: {
              position: row
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
      this.$set(row,'onEdit', true)
    },
    removeItem(index){
      this.list.splice(index,1)
    },
    cateName(key){
      return this.categories[key] || '-'
    }
  }
}
</script>
