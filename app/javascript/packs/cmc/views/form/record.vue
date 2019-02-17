<template>
  <div class="app-container">
    <el-form ref="dataForm" :model="record" :rules="rules" label-width="120px" status-icon style="max-width: 640px">
      <el-form-item label="请假人" prop="user_id">
        <template v-if="isNew()">
          <el-select 
            v-model="userSelected" 
            placeholder="选择请假人(输入关键字查询)" 
            filterable 
            remote 
            :loading="searching" 
            :remote-method="searchUser"
          >
            <el-option 
              v-for="item in userList"
              :key="item.id"
              :label="item.realname + ' - ' + item.job"
              :value="item"
            />
          </el-select>
        </template>
        <template v-else>
          {{record.user.realname}} - {{record.user.job}}
        </template>
      </el-form-item>
      <el-form-item label="联系电话" prop="tel">
        <el-input v-model="record.tel"/>
      </el-form-item>
      <el-form-item label="外出地点" prop="address">
        <el-input v-model="record.address"/>
      </el-form-item>
      <el-form-item label="外出时间">
        <el-col :span="11">
          <el-form-item prop="begin_at">
            <el-date-picker v-model="record.begin_at" type="date" placeholder="开始时间" style="width: 100%;"/>
          </el-form-item>
        </el-col>
        <el-col :span="2" class="line">-</el-col>
        <el-col :span="11">
          <el-form-item prop="end_at">
            <el-date-picker v-model="record.end_at" type="date" placeholder="结束时间" style="width: 100%;"/>
          </el-form-item>
        </el-col>
      </el-form-item>
      <el-form-item label="外出事由" prop="cause">
        <el-input v-model="record.cause" type="textarea"/>
      </el-form-item>
      <el-form-item label="代管人姓名" prop="agent">
        <el-input v-model="record.agent"/>
      </el-form-item>
      <el-form-item label="代管人职务" prop="agent_office">
        <el-input v-model="record.agent_office"/>
      </el-form-item>
      <el-form-item label="代管人办公电话" prop="agent_mobile">
        <el-col :span="10">
          <el-input v-model="record.agent_office_tel" placeholder="办公电话"/>
        </el-col>
        <el-col :span="4" class="line">移动电话</el-col>
        <el-col :span="10">
          <el-input v-model="record.agent_mobile" placeholder="移动电话"/>
        </el-col>
      </el-form-item>
      <el-form-item label="销假">
        <el-switch v-model="record.isBack"/>
      </el-form-item>
      <el-form-item label="单位意见">
        <el-input v-model="record.unit_opinion" type="textarea"/>
      </el-form-item>
      <el-form-item label="校领导意见">
        <el-input v-model="record.leader_opinion" type="textarea"/>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit">保存</el-button>
        <el-button @click="onCancel">放弃</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
import request from '../../utils/request'

export default {
  data() {
    return {
      userList: [],
      userSelected: null,
      record: {
      },
      loading: false,
      searching: false,
      form: {
        name: '',
        region: '',
        date1: '',
        date2: '',
        delivery: false,
        type: [],
        resource: '',
        desc: ''
      }
    }
  },
  created(){
    this.record = Object.assign({}, this.$route.params.item)
    if(this.record.back_at) {
      this.$set(this.record, 'isBack', true)
    }
    this.record.user_id = this.record.user ? this.record.user.id : null
  },
  computed:{
    rules(){
      let rules = {};

      [
        'user_id',
        'tel',
        'address',
        'begin_at',
        'end_at',
        'cause',
        'agent',
        'agent_office'
      ].forEach((key) => { rules[key] = [{ required: true, message: '此项不能为空'}] })
      rules['agent_mobile'] = [
        {
          validator: (rule, value, callback) => {
            if(!this.record.agent_office_tel && !this.record.agent_mobile) {
              callback(new Error('代理人联系方式至少填写一个'))
            } else {
              callback()
            }
          }
        }
      ]
      return rules
    }
  },
  methods: {
    onSubmit() {
      this.$refs['dataForm'].validate((valid) => {
        let data = {}
        if(!valid || this.loading) return
        data = this.buildData()
        this.loading = true
        request({
          url: this.isNew() ? '/records' : `/records/${this.record.id}`,
          method: this.isNew() ? 'POST' : 'PATCH',
          data: { record: data }
        }).then((r) => {
          let _self = this
          this.$message({
            message: '保存成功，即将返回列表',
            type: 'success',
            onClose(){
              _self.$router.go(-1)
            }
          })

        })
      })
    },
    onCancel() {
      if(confirm('是否放弃修改？')){
        this.$router.go(-1)
      }
    },
    searchUser(name){
      if(this.searching || name == '') return
      this.searching = true
      request({
        url: '/users',
        params: {
          'q[realname_cont]': name,
          perpage: 1000
        }
      }).then((data) => {
        this.userList = data.items
        this.searching = false
      })
    },
    isNew(){
      return !this.record.id
    },
    buildData(){
      let data = Object.assign({}, this.record)

      if(data.isBack && !data.back_at) {
        data.back_at = new Date()
      }
      if(!data.isBack && data.back_at) {
        data.back_at = null
      }
      
      ['id','user','url','isBack','created_at','updated_at'].forEach((key) => {
        delete data[key]
      })
      
      console.log(data)
      return data
    }
  },
  watch:{
    userSelected(val){
      this.$set(this.record, 'user_id', val.id)
      this.$set(this.record, 'tel', val.mobile)
    }
  }
}
</script>

<style scoped>
.line{
  text-align: center;
}
</style>

