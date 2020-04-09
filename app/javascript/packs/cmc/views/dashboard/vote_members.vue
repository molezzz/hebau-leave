<template>
  <div class="app-container">
    <el-form :model="form" class="demo-form-inline" style="width:80%">
      <el-form-item label="用户类型">
        <el-select v-model="form.kind" placeholder="类型">
          <el-option label="自评" value="zp"></el-option>
          <el-option label="互评" value="hp"></el-option>
          <el-option label="党群、行政党建" value="dj"></el-option>
          <el-option label="后勤党建" value="dj-hq"></el-option>
          <el-option label="研究生院党建" value="dj-yjs"></el-option>
          <el-option label="继续教育学院党建" value="dj-jx"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="部门类型" v-if="form.kind === 'hp'">
        <el-select v-model="form.category" placeholder="部门类型">
          <el-option label="行政部门" value="0"></el-option>
          <el-option label="教学部门" value="1"></el-option>
          <el-option label="党群部门" value="2"></el-option>
          <el-option label="科研教辅" value="3"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="选择部门" v-if="form.kind === 'zp'">
        <el-select v-model="form.department" placeholder="部门">
          <el-option v-for="(d, idx) in departments" :key="idx" :label="d.name" :value="d.id"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="填写手机号（逗号','分隔）">
        <el-input type="textarea" v-model="form.mobiles"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="gen">生成</el-button>
        <el-button @click="getSendCodes">查询</el-button>
      </el-form-item>
    </el-form>
    <el-transfer :left-default-checked="codeChecked" :titles="['未发送','待发送']" v-model="selectedCodes" :data="codes" v-if="codes.length > 0">
      <el-button style="margin-left: 0.5rem;" slot="right-footer" size="small" @click="sendCodes">发送</el-button>
    </el-transfer>
  </div>
</template>

<script>
import request from '../../utils/request'
import { dateFormat } from '../../utils/datetime'

export default {
  data() {
    return {
      form: {

      },
      departments: [],
      codes: [],
      selectedCodes: [],
      codeChecked: []
    }
  },
  created() {
    this.getDepartments();
  },
  methods: {
    getDepartments(){
      request({
        url: '/departments',
        params: {
          q: {
            category_in: [1,3]
          }
        }
      }).then(response => {
        this.departments =  response
      })
    },
    gen(){
      request({
        url: '/assess/generate_codes',
        method: 'POST',
        data: this.form
      }).then(response => {
        if(response.failed) {
          this.form.mobiles = response.failed.join(',')
        }
        this.getSendCodes()
      })
    },
    getSendCodes(){
      this.codeChecked = []
      this.selectedCodes = []
      this.codes = []
      request({
        url: '/assess/send_code_list',
        params: {
          kind: this.form.kind,
          category: this.form.category,
          department: this.form.department
        }
      }).then(response => {
        this.codes = response.map(c => {
          this.codeChecked.push(c.id)
          return {
            key: c.id,
            label: c.mobile
          }
        })
      })
    },
    sendCodes(){
      console.log(this.selectedCodes);
      request({
        url: '/assess/send_codes',
        method: 'POST',
        data: {
          codes: this.selectedCodes
        }
      }).then(response => {
        alert(response.message);
        this.selectedCodes = []
      })
    }
  },
  watch: {
    // selectedCodes: {
    //   deep: true,
    //   handler(v){
    //     console.log(v)
    //   }
    // }
  }
}
</script>
