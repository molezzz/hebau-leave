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
        <el-table-column align="center" label="ID" width="60">
          <template slot-scope="scope">
            {{ scope.row.id }}
          </template>
        </el-table-column>
        <el-table-column label="姓名" align="center">
          <template slot-scope="scope">
            {{ scope.row.user.realname }}
          </template>
        </el-table-column>
        <el-table-column label="手机号" align="center">
          <template slot-scope="scope">
            {{ scope.row.user.mobile }}
          </template>
        </el-table-column>
        <el-table-column label="职务" align="center">
          <template slot-scope="scope">
            {{ scope.row.user.job }}
          </template>
        </el-table-column>
        <el-table-column label="部门" width="120" align="center">
          <template slot-scope="scope">
            {{ scope.row.user && scope.row.user.department ? scope.row.user.department.name : '-' }}
          </template>
        </el-table-column>
        <el-table-column label="销假" align="center">
          <template slot-scope="scope">
            <template v-if="scope.row.back_at && scope.row.back_at <= scope.row.end_at">
              <el-tag type="success">按期销假</el-tag>
            </template>
            <template v-if="scope.row.back_at && scope.row.back_at > scope.row.end_at">
              <el-tag type="warning">超期销假</el-tag>
            </template>
            <template v-if="!scope.row.back_at && (today > dateToInt(scope.row.end_at))">
              <el-tag type="danger">未销假</el-tag>
            </template>
          </template>
        </el-table-column>
        <el-table-column align="center" prop="created_at" label="开始时间" width="160">
          <template slot-scope="scope">
            <i class="el-icon-time"/>
            <span>{{ scope.row.begin_at | dateFormat('YYYY-MM-DD') }}</span>
          </template>
        </el-table-column>
        <el-table-column align="center" prop="created_at" label="结束时间" width="160">
          <template slot-scope="scope">
            <i class="el-icon-time"/>
            <span>{{ scope.row.end_at | dateFormat('YYYY-MM-DD') }}</span>
          </template>
        </el-table-column>
        <el-table-column align="center" prop="created_at" label="申请时间" width="220">
          <template slot-scope="scope">
            <i class="el-icon-time"/>
            <span>{{ scope.row.created_at | dateFormat }}</span>
          </template>
        </el-table-column>
        <el-table-column align="center" width="160">
          <template slot="header" slot-scope="scope">
            <el-button size="mini" type="primary" plain icon="el-icon-plus" @click="addNewItem">新建</el-button>
          </template>
          <template slot-scope="scope">
            <el-button size="small" circle type="primary" icon="el-icon-edit" @click="editItem(scope.$index)"></el-button>
            <el-button size="small" circle type="danger" icon="el-icon-delete" @click="delItem(scope.$index)" v-if="!scope.row.bind_wechat"></el-button>
            <el-button size="small" circle icon="el-icon-printer" @click="downloadPDF(scope.$index)"></el-button>
          </template>  
        </el-table-column>
        <el-table-column type="expand">
          <template slot-scope="props">
            <el-form label-position="left" inline class="table-expand-detail">
              <el-form-item label="外出地点">
                <span>{{ props.row.address }}</span>
              </el-form-item>
              <el-form-item label="外出事由">
                <span>{{ props.row.cause }}</span>
              </el-form-item>
              <el-form-item label="代管人">
                <span>{{ props.row.agent }}</span>
              </el-form-item>
              <el-form-item label="代管人职务">
                <span>{{ props.row.agent_office }}</span>
              </el-form-item>
              <el-form-item label="代管人办公电话">
                <span>{{ props.row.agent_office_tel }}</span>
              </el-form-item>
              <el-form-item label="代管人移动电话">
                <span>{{ props.row.agent_mobile }}</span>
              </el-form-item>
              <el-form-item label="销假时间">
                <span>{{ props.row.back_at | dateFormat}}</span>
              </el-form-item>
              <el-form-item label="备注">
                <span>{{ props.row.remark }}</span>
              </el-form-item>
              <el-form-item label="单位意见">
                <span>{{ props.row.unit_opinion }}</span>
              </el-form-item>
              <el-form-item label="校领导意见">
                <span>{{ props.row.leader_opinion }}</span>
              </el-form-item>
            </el-form>
          </template>
        </el-table-column>
      </el-table>
    </el-form>
    <el-pagination
      background
      layout="prev, pager, next"
      :page-count="pageInfo.total_page"
      :current-page="pageInfo.current_page">
    </el-pagination>
  </div>
</template>
<style>
  .table-expand-detail {
    font-size: 0;
  }
  .table-expand-detail label {
    width: 120px;
    color: #99a9bf;
  }
  .table-expand-detail .el-form-item {
    margin-right: 0;
    margin-bottom: 0;
    width: 50%;
  }
</style>
<script>
import request from '../../utils/request'
import dayjs from 'dayjs'
import { dateFormat } from '../../utils/datetime'

const basePath = '/records'

export default {
  data() {
    return {
      list: [],
      today: dayjs().unix(),
      pageInfo: {
        perpage: 20,
        current_page: null,
        pervious_page: null,
        next_page: null,
        total_page: null
      },
      listLoading: true,
      ruleForm: {},
      positions: null,
      departments: null
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
        this.list =  response.items
        this.pageInfo = Object.assign(this.pageInfo, response.page_info)
        this.listLoading = false
      })
    },
    dateToInt(date){
      return dayjs(date).unix()
    },
    addNewItem(){
      this.editItem(-1)
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
    removeItem(index){
      this.list.splice(index,1)
    },
    downloadPDF(index){
      let row = this.list[index]

      window.open(`/records/${row.id}.pdf`)
    },
    editItem(index){
      let row = this.list[index]
      let params = {}

      if(row) {
        params = { id: row.id, item: row }
      }
      this.$router.push({name: 'editor_record', params: params})
    }
  }
}
</script>
