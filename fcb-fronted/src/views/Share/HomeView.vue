<script setup lang="ts">
import { Upload, TakeawayBox } from '@element-plus/icons-vue';
import { onMounted, reactive, ref, watch } from 'vue'
import { useRoute, useRouter } from "vue-router";
import CardTools from "@/components/CardTools.vue";
import { useFileBoxStore } from "@/stores/fileBox";
import { useFileDataStore } from "@/stores/fileData";
import { ElMessageBox } from 'element-plus'

import { request } from "@/utils/request";
const fileBoxStore = useFileBoxStore();
const fileStore = useFileDataStore();
const router = useRouter()
const route = useRoute()
const code = ref('')
const input_status = reactive({
  'readonly': false,
  'loading': false,
})

import { useI18n } from 'vue-i18n'
const noDialog = ()=>{
  ElMessageBox.alert('根据《中华人民共和国网络安全法》、《中华人民共和国刑法》、《中华人民共和国治安管理处罚法》等相关规定。 传播或存储违法、违规内容，会受到相关处罚，严重者将承担刑事责任。请勿上传非法文件，本站坚决配合相关部门，确保网络内容的安全，和谐，打造绿色网络环境。', '免责声明', {
    confirmButtonText: '确定',
    callback: () => {
    }
  });
}
const { t } = useI18n()
onMounted(() => {
  const query_code = route.query.code as string;
  if (query_code) {
    code.value = query_code
  }
})
watch(code, (newVal) => {
  if (newVal.length === 5) {
    input_status.readonly = true;
    input_status.loading = true;
    request({
      'url': '/share/select/',
      'method': 'POST',
      'data': {
        'code': newVal
      }
    }).then((res: any) => {
      fileBoxStore.showFileBox = true;
      let flag = true;
      fileStore.receiveData.forEach((file: any) => {
        if (file.code === res.detail.code) {
          flag = false;
          return;
        }
      });
      if (flag) {
        fileStore.addReceiveData(res.detail);
      }
    }).finally(() => {
      input_status.readonly = false;
      input_status.loading = false;
      code.value = '';
    });
  }
});
const listenInput = (num: number) => {
  if (code.value.length < 5) {
    code.value += num
  }
};
const name = atob('RmlsZUNvZGVCb3ggVjIuMCBCZXRh');
const url = atob('aHR0cHM6Ly9naXRodWIuY29tL3Zhc3RzYS9GaWxlQ29kZUJveA==');
</script>

<template>
    <main>
      <el-card class="card" style="padding-bottom: 1rem">
        <CardTools/>
        <el-row style="text-align: center">
          <el-col :span="24">
            <el-input :readonly="input_status.readonly" v-loading="input_status.loading" v-model="code" class="code-input" round autofocus clearable maxlength="5" :placeholder="t('fileBox.inputNotEmpty')"/>
          </el-col>
          <el-col :span=8 v-for="i in 9" :key="i">
            <el-button class="key-button" round @click="listenInput(i)">{{ i }}</el-button>
          </el-col>
          <el-col :span=8>
            <el-button @click="router.push({'name':'send'})"  class="key-button" :icon="Upload" round>
            </el-button>
          </el-col>
          <el-col :span=8>
            <el-button class="key-button" round @click="listenInput(0)">0</el-button>
          </el-col>
          <el-col :span=8>
            <el-button class="key-button" round :icon="TakeawayBox" @click="fileBoxStore.showFileBox=true">
            </el-button>
          </el-col>
        </el-row>
      </el-card>
      <div style="text-align: center; margin-top: 1rem;color: #606266">
        <a style="text-decoration: none;color: #606266" target="_blank" :href="url">
          {{ name}}
        </a>
        <a @click="noDialog" style="text-decoration: none;color: #606266;margin-left: 1rem" href="javascript:void(0)">免责声明</a>
      </div>
    </main>
</template>
<style lang='scss'>
  .key-button{
    width: 6rem;
    height: 6rem;
    margin: 0.2rem;
    font-size: 2rem;
    font-weight: bold;
    text-align: center;
  }

  .code-input {
    height: 100px;
    font-size: 30px;
    font-weight: bold;
    margin: 1rem 0;
    .el-input__wrapper{
      border-radius: 20px !important;
    }
  }
</style>