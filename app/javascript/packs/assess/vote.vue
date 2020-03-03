<template>
  <div>
    <div v-if="!member">
      <h3 style="text-align:center;margin-top: 30%;">
        对不起，您不能访问！
      </h3>
    </div>
    <div style="padding: 0.5rem;" v-else>
      <h1>{{title}}</h1>
      <div v-if="voted" style="text-align: center;margin-top: 30%;">
        <van-circle
          style="margin: 1rem auto; display: block;"
          v-model="currentRate"
          :text="voteSuccess ? '✓' : 'x'"
          size="160px"
          :color="voteSuccess ? '#19be6b' : '#ed4014'"
          :stroke-width="60"
          :class="{success: voteSuccess}"
        />
        <h2 style="margin-top: 3rem;">{{voteSuccess ? '投票完成！' : ''}}链接已失效！</h2>
      </div>
      <div v-else>
        <van-panel v-for="(p,idx) in projects" :key="idx" class="project">
          <div slot="header" class="panel-header">
            <h4 class="title">{{p.name}}</h4>
            <div class="note" v-html="p.desc">
            </div>
          </div>
          <div class="user" v-for="(it, n) in p.items" :key="n" :title="it.name + desc(it)">
            <h4>{{ it.name }}</h4>
            <span class="desc">{{desc(it)}}</span>
            <div class="votes">
              <van-radio-group v-model="p.votes[it.id]" direction="horizontal" @change="vote(it)">
                <van-radio v-for="(c, i) in p.choice" :key="i" :name="c.val">{{c.label}}</van-radio>
              </van-radio-group>
            </div>
          </div>
        </van-panel>
        <van-button type="danger" block @click="submitConfirm">提交保存</van-button>
      </div>
    </div>
  </div>
</template>
<style lang="sass">
  body {
    background: #F7F8FA;
  }
  h1 {
    font-size: 1.2rem;
    text-align: center;
  }
  .project {
    .van-panel {
      padding: 0.5rem;
      margin-bottom: 1rem;
    }
    
    .panel-header {
      padding: 0.2rem 1rem;
      .title {
        text-align: center;
        margin-top: 1.5rem;
      }
      p {
        font-size: 12px;
        color: #666;
        margin: 0.2rem auto;

        strong {
          color: #333;
        }
      }
    }
  }
  .van-radio--horizontal {
    margin: 0.3rem 0 0.3rem 1rem;
    .van-radio__label {
      min-width: 5rem;
    }
  }
  .van-circle__text {
    font-size: 4rem;
    color: #ed4014;
  }
  .success .van-circle__text {
    color: #19be6b;
  }
  .van-panel__header {
    text-align: center;
    .van-cell__title span {
      font-size: 1.1rem;
    }
    .van-cell__label {
      text-align: left;
    }
  }
  .user {
    margin: 0.5rem;
    padding: 1rem;
    background-color: #FCFCFC;
    border-radius: 12px;
    box-shadow: 0 3px 5px #ebedf0;

    h4 {
      margin-block-start: 0.2rem;
      margin-block-end: 0.2rem;
    }
    .desc {
      font-size: 0.8rem;
      color: #969799;
    }
    .votes {
      padding: 0.8rem 0;
    }
  }
</style>
<script>
import { 
  Cell, 
  CellGroup,
  Panel,
  RadioGroup, 
  Radio,
  Circle,
  Notify,
  Button,
  Dialog
} from 'vant';
import axios from 'axios';
import 'vant/lib/button/style';
import 'vant/lib/cell/style';
import 'vant/lib/cell-group/style';
import 'vant/lib/panel/style';
import 'vant/lib/radio/style';
import 'vant/lib/radio-group/style';
import 'vant/lib/circle/style';
import 'vant/lib/notify/style';
import 'vant/lib/dialog/style';

// let projects = [
//   {
//     name: '处级班子考核民主测评表',
//     desc: '',
//     kind: 'bz',
//     items: [
//       {name: '信息学院', id: 1}
//     ],
//     choice: [
//       {label: '优秀', val: 100 },
//       {label: '良好', val: 80 },
//       {label: '一般', val: 60 },
//       {label: '较差', val: 3 }
//     ],
//     votes: {}
//   },{
//     name: '处级干部考核民主测评表',
//     desc: '',
//     kind: 'gb',
//     items: [
//       {name: '张三', id: 1}
//     ],
//     choice: [
//       {label: '优秀', val: 100 },
//       {label: '称职', val: 80 },
//       {label: '基本称职', val: 60 },
//       {label: '不称职', val: 30 }
//     ],
//     votes: {}
//   },{
//     name: '处级干部廉政考核民主测评表',
//     desc: '',
//     kind: 'lz',
//     items: [
//       {name: '张三', id: 1}
//     ],
//     choice: [
//       {label: '优秀', val: 100 },
//       {label: '良好', val: 80 },
//       {label: '一般', val: 60 },
//       {label: '较差', val: 30 }
//     ],
//     votes: {}
//   },
// ]

export default {
  data() {
    let projects = [];
    ['dj','bz', 'gb', 'lz'].forEach((k) => {
      if(window._data.projects[k].items.length > 0) { 
        projects.push(window._data.projects[k])
      }
    })
    return {
      title: '河北农大2019年度处级干部考核',
      radio: 0,
      member: window._data.member,
      projects: projects,
      voted: window._data.member ? window._data.member.vote_at : null,
      currentRate: 100,
      voteSuccess: false
    }
  },
  methods: {
    desc(u){
      let title = [];
      if(u.department) title.push(u.department);
      if(u.job) title.push(u.job);
      return title.length > 0 ? title.join(' - ') : '';
    },
    vote(item){
      item.voted = true
    },
    submitConfirm(){
      Dialog.confirm({
        title: '注意！',
        message: '提交后，本次投票结束，您不能再返回修改投票。是否继续？'
      }).then(() => {
        this.submit()
      }).catch(() => {
        // on cancel
      });
    },
    async submit(){
      let data = {};
      let total = 0;
      let voteCount = 0;
      let unvoted = {}
      for(let i in this.projects) {
        if(['dj','bz','gb','lz'].includes(this.projects[i].kind)) {
          // 检查没投票的
          for(let k in this.projects[i].items) {
            if(!this.projects[i].items[k].voted) {
              unvoted = {
                project: this.projects[i],
                item: this.projects[i].items[k]
              }
              break
            }
          }
          data[this.projects[i].kind] = this.projects[i].votes;
          total += this.projects[i].items.length;
          voteCount += Object.keys(this.projects[i].votes).length;
        }
      }
      if (voteCount < total) {
        console.log(unvoted)
        let tip = [unvoted.project.name, unvoted.item.department, unvoted.item.name].filter(u => u).join(' - ')
        Notify({ type: 'danger', message: '您没给: ' + tip +' 投票！', duration: 10000});
        return;
      }
      let result = await axios.post('/assess/votes.json', { code: window._data.member.code, votes: data })
      if (!result.error) {
        this.voted = true;
        this.voteSuccess = true;
      }
    }
  },
  components: {
    VanCell: Cell,
    VanCellGroup: CellGroup,
    VanPanel: Panel,
    VanRadio: Radio,
    VanRadioGroup: RadioGroup,
    VanButton: Button
  },
  watch: {
    // projects: {
    //   deep: true,
    //   handler(v){
    //     console.log(v);
    //   }
    // }
  }
}
</script>