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
        <el-table-column label="姓名/职务" align="left" width="160">
          <template slot-scope="scope">
            <p>{{ scope.row.user.realname }}</p>
            <p><i class="el-icon-phone-outline"></i> {{ scope.row.user.mobile }}</p>
            <p><i class="el-icon-service"></i> {{ scope.row.user.job }}</p>
          </template>
        </el-table-column>
        <el-table-column label="部门" width="120" align="center">
          <template slot-scope="scope">
            {{ scope.row.user && scope.row.user.department ? scope.row.user.department.name : '-' }}
          </template>
        </el-table-column>
        <el-table-column align="left" prop="cause" label="事由" width="120">
          <template slot-scope="scope">
            {{scope.row.cause}}
          </template>
        </el-table-column>
        <el-table-column align="center" prop="days" label="天数">
          <template slot-scope="scope">
            <span>{{ scope.row.days }}</span>
          </template>
        </el-table-column>
        <el-table-column align="left" prop="created_at" label="起始时间" width="160">
          <template slot-scope="scope">
            <p>开始： {{ scope.row.begin_at | dateFormat('YYYY-MM-DD') }}</p>
            <p>结束： {{ scope.row.end_at | dateFormat('YYYY-MM-DD') }}</p>
          </template>
        </el-table-column>
        <el-table-column align="left" prop="address" label="外出地点" width="160">
          <template slot-scope="scope">
            {{scope.row.address}}
          </template>
        </el-table-column>
        <el-table-column align="left" prop="log" label="审批情况" width="210">
          <template slot-scope="scope">
            <el-steps direction="vertical" :active="3">
              <el-step v-for="(log, idx) in scope.row.logs" :key="idx">
                <div slot="title">
                  <el-tag :type="log.kind != 'refusal' ? 'success' : 'danger'" size="mini">{{showKind(log.kind)}}</el-tag><br>
                  {{log.created_at | dateFormat }}
                </div>
                <div slot="description">
                  {{log.user ? log.user.realname : ''}} {{log.remark}}
                </div>
              </el-step>
            </el-steps>
          </template>
        </el-table-column>
        <el-table-column align="center" prop="created_at" label="申请时间" width="120">
          <template slot-scope="scope">
            <i class="el-icon-time"/>
            <span>{{ scope.row.created_at | dateFormat }}</span>
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
        <el-table-column align="center" width="100">
          <template slot="header" slot-scope="scope">
            <el-button size="mini" type="primary" plain icon="el-icon-plus" @click="addNewItem">新建</el-button>
          </template>
          <template slot-scope="scope">
            <el-button-group>
              <el-button size="small" circle type="primary" icon="el-icon-edit" @click="editItem(scope.$index)"></el-button>
              <el-button size="small" circle type="danger" icon="el-icon-delete" @click="delItem(scope.$index)" v-if="!scope.row.bind_wechat"></el-button>
            </el-button-group>
            <el-button-group style="margin-top: 0.5rem">
              <el-button size="small" circle icon="el-icon-news" v-if="scope.row.status != 'filing'" @click="archive(scope.$index)"></el-button>
              <el-button size="small" circle icon="el-icon-printer" @click="downloadPDF(scope.$index)"></el-button>
            </el-button-group>
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
      :current-page="pageInfo.current_page"
      @current-change="fetchData"
      >
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
  .el-step__title {
    font-size: 14px !important;
  }
</style>
<script>
import request from '../../utils/request'
import dayjs from 'dayjs'
import relativeTime from 'dayjs/plugin/relativeTime'
import 'dayjs/locale/zh-cn'
import { dateFormat } from '../../utils/datetime'
dayjs.extend(relativeTime)
dayjs.locale('zh-cn')
const basePath = '/records'

export default {
  data() {
    return {
      list: [],
      today: dayjs().unix(),
      pageInfo: {
        perpage: 5,
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
        name: null,
        status: null
      }
    }
  },
  filters: {
    dateFormat
  },
  created() {
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
          'user_realname_or_user_mobile_cont': this.filters.name
        }
      }
      this.listLoading = true
      request({
        url: basePath,
        params
      }).then(response => {
        this.list =  response.items.map((item) => {
          item.days = dayjs(item.begin_at).to(item.end_at, true)
          return item
        })
        this.pageInfo = Object.assign(this.pageInfo, response.page_info)
        this.listLoading = false
      })
    },
    showKind(key){
      let m = {
        'refusal': '未批准',
        'superior': '校领导审批',
        'college': '单位领导审批',
        'cancel': '取消',
        'filing': '组织部备案'
      }
      return m[key] || '未知'
      
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
    archive(index){
      let row = this.list[index]
      if(confirm('即将标记这个记录为”组织部备案“，是否继续？')){
        request({
          url: `${basePath}/${row.id}`,
          method: 'PATCH',
          params: {
            record: { status: 'filing'}
          }
        }).then((resp) => {
          this.list[index].status = resp.status
        })
      }
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
