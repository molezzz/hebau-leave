<template>
  <div class="app-container">
    <div class="form-toolbar">
      <div class="left">
        <span style="margin-right: 1.5rem;color:#909399">筛选: </span>
        <el-select v-model="filters.master_id" placeholder="请选择主管校领导">
                  
          <el-option
            v-for="(item, key) in masters"
            :key="key"
            :label="item.realname"
            :value="item.id">
          </el-option>
          
        </el-select>
        <el-select v-model="filters.approver_id" placeholder="请选择审批校领导">
                  
          <el-option
            v-for="(item, key) in masters"
            :key="key"
            :label="item.realname"
            :value="item.id">
          </el-option>
          
        </el-select>
        <el-select v-model="filters.department_id" placeholder="请选择部门">
                  
          <el-option
            v-for="(item, key) in departments"
            :key="key"
            :label="item.name"
            :value="item.id">
          </el-option>
          
        </el-select>
        <el-date-picker
          v-model="filters.dateRange"
          type="daterange"
          align="right"
          unlink-panels
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          :picker-options="pickerOptions">
        </el-date-picker>
      </div>
      <div class="right">
        <el-input
          placeholder="请输入姓名或手机号查询"
          prefix-icon="el-icon-search"
          v-model="filters.name"
          style="width: 240px"
          >
        </el-input>
        <el-button type="primary" @click="fetchData(1)">查询</el-button>
        <el-button plain @click="exportCSV()" icon="el-icon-download">导出</el-button>
      </div>
    </div>
    <el-form label-position="right" status-icon :model="ruleForm" ref="tableForm">
      <el-table
        v-loading="listLoading"
        :data="list"
        element-loading-text="Loading"
        border
        fit
        highlight-current-row
        @expand-change="getAddress"
        >
        <el-table-column align="center" label="ID" width="60">
          <template slot-scope="scope">
            {{ scope.row.id }}
          </template>
        </el-table-column>
        <el-table-column label="姓名/职务" align="left" width="160">
          <template slot-scope="scope">
            <p>{{ scope.row.user ? scope.row.user.realname : '' }}</p>
            <p><i class="el-icon-phone-outline"></i> {{ scope.row.user ? scope.row.user.mobile : '' }}</p>
            <p><i class="el-icon-service"></i> {{ scope.row.user ? scope.row.user.job : '' }}</p>
          </template>
        </el-table-column>
        <el-table-column label="部门" width="120" align="center">
          <template slot-scope="scope">
            {{ scope.row.user && scope.row.user.department ? scope.row.user.department.name : '-' }}<br>
            <span v-if="scope.row.user && scope.row.user.department  && scope.row.user.department.master">
              （{{scope.row.user.department.master.realname}}）
            </span>
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
            <template v-if="scope.row.back_at && !isOverTime(scope.row)">
              <el-tag type="success">按期销假</el-tag>
            </template>
            <template v-if="scope.row.back_at && isOverTime(scope.row)">
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
              <el-form-item label="外出方式">
                <span>{{ props.row.travel }}</span>
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
              <el-form-item label="销假地点">
                <span>{{ address[props.row.id] }}</span>
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

const pointToAddress = function(lng,lat){
  return new Promise((resolve, reject) => {
    AMap.plugin('AMap.Geocoder', function() {
      let geocoder = new AMap.Geocoder({
        // city 指定进行编码查询的城市，支持传入城市名、adcode 和 citycode
        // city: '010'
      })
    
      let lnglat = [lng, lat]

      geocoder.getAddress(lnglat, function(status, result) {
        if (status === 'complete' && result.info === 'OK') {
          // result为对应的地理位置详细信息
          console.log(result)
          resolve(result.regeocode)
        } else {
          reject(result)
        }
      })
    })
  })
}

export default {
  data() {
    return {
      list: [],
      today: dayjs().unix(),
      address: {},
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
      masters: [],
      departments: [],
      filters: {
        name: null,
        status: null,
        master_id: null,
        dateRange: null,
        department_id: null,
        approver_id: null
      },
      pickerOptions: {
        shortcuts: [{
          text: '最近一周',
          onClick(picker) {
            const end = new Date();
            const start = new Date();
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
            picker.$emit('pick', [start, end]);
          }
        }, {
          text: '最近一个月',
          onClick(picker) {
            const end = new Date();
            const start = new Date();
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 30);
            picker.$emit('pick', [start, end]);
          }
        }, {
          text: '最近三个月',
          onClick(picker) {
            const end = new Date();
            const start = new Date();
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 90);
            picker.$emit('pick', [start, end]);
          }
        }]
      }
    }
  },
  filters: {
    dateFormat
  },
  created() {
    this.fetchData()
    this.loadMaster()
    this.loadDepartment()
  },
  methods: {
    fetchData(page) {
      if(this.listLoading) return
      this.listLoading = true
      request(this.buildQuery(page)).then(response => {
        this.list =  response.items.map((item) => {
          item.days = dayjs(item.begin_at).to(item.end_at, true)
          return item
        })
        this.pageInfo = Object.assign(this.pageInfo, response.page_info)
        this.listLoading = false
      })
    },
    async getAddress(row){
      if(!row) return '-'
      if(this.address[row.id]){
        return this.address[row.id]
      }
      if(!row.back_lat || !row.back_lon) {
        return '-'
      }
      try {
        let result = await pointToAddress(row.back_lon, row.back_lat)
        let data  =  {
          lat: row.back_lat,
          lng: row.back_lon,
          name: result.formattedAddress
        }
        this.$set(this.address, row.id, `${data.name} (${data.lat},${data.lng})`)
        return this.address[row.id]
      } catch (e) {
        console.error(e)
        return '-'
      }
    },
    buildQuery(page, perpage, format){
      let params = {
        perpage: perpage || this.pageInfo.perpage,
        page: page || 1
      }
      if(this.filters.name && this.filters.name != '') {
        params.q = {
          'user_realname_or_user_mobile_cont': this.filters.name
        }
      }
      if(this.filters.master_id && this.filters.master_id != 0){
        params.q = Object.assign({
          'user_department_master_id_eq': this.filters.master_id
        }, params.q)
      }
      if(this.filters.approver_id && this.filters.approver_id != 0){
        params.q = Object.assign({
          'record_logs_user_id_eq': this.filters.approver_id
        }, params.q)
      }
      if(this.filters.department_id && this.filters.department_id != 0){
        params.q = Object.assign({
          'user_department_id_eq': this.filters.department_id
        }, params.q)
      }
      if(this.filters.dateRange && this.filters.dateRange.length > 0) {
        params.q = Object.assign({
          'begin_at_gteq': this.filters.dateRange[0],
          'end_at_lteq': this.filters.dateRange[1]
        }, params.q)
      }
      //console.log(this.filters)
      return {
        url: `${basePath}${format || '.json'}`,
        params
      }
    },
    exportCSV(){
      request(Object.assign(this.buildQuery(1, 1000000000, '.csv'),{responseType: 'blob'})).then((response) => {
        console.log(response)
        // Let the user save the file.
        const url = window.URL.createObjectURL(new Blob([response]));
        const link = document.createElement('a');
        link.href = url;
        link.style = 'display:none'
        link.setAttribute('download', 'records.csv'); //or any other extension
        document.body.appendChild(link);
        link.click();
      })
    },
    isOverTime(row){
      let endTime = dayjs(row.end_at).add(1, 'day')
      return dayjs(row.back_at).isAfter(endTime)
    },
    showKind(key){
      let m = {
        'refusal': '未批准',
        'superior': '部门负责人审批',
        'college': '校领导审批',
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
    loadMaster(){
      request({
        url: '/users',
        params: {
          q:{
            position_name_in: ['正厅级', '副厅级']
          }
        }
      }).then(response => {
        this.masters = response.items
        this.masters.unshift({
          id: 0,
          realname: '不限'
        })
      })      
    },
    loadDepartment(){
      request({
        url: '/departments'
      }).then(response => {
        this.departments = response || []
        this.departments.unshift({
          id: 0,
          name: '不限'
        })
      })      
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
