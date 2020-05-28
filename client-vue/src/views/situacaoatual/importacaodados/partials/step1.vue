<template>
  <div>
    <a-upload-dragger :fileList="fileList" :remove="handleRemove" :beforeUpload="beforeUpload">
    <p class="ant-upload-drag-icon"><a-icon type="inbox" /></p>
    <p class="ant-upload-text">Clique ou arraste um arquivo .csv para esta área para importação</p>
    <p class="ant-upload-hint"></p>
    <slot name="error" v-if="showErrorMessage"><h2><div class="invalid-feedback d-block">Tipo de arquivo inválido!</div></h2></slot>
    </a-upload-dragger>


  <div class="row">
    <div class="col-lg-2 text-right" style="margin-top:20px">
    <h4>Tipo de Importação:</h4>
    </div>
    <div class="col-lg-10 text-left">
      <a-select size="large" style="width: 180px;margin-top:10px" @change="onChangeSelectImport($event)">
        <a-select-option v-for="(item, key) in tiposImport[0]" :key="key">
          {{ item }}
        </a-select-option>
      </a-select>
    </div>
</div>


  </div>
</template>

<script>
//import store from "@/store";
import { store } from "../store";
import mimeTypes from "mime-types";
import { drop, every, forEach, get, isArray, map, set } from 'lodash';
import Papa from "papaparse";

export default {
  props: {
    callback: {
      type: Function,
      default: () => ({})
    },
    validation: {
      type: Boolean,
      default: true,
    },
    fileMimeTypes: {
      type: Array,
      default: () => {return ["text/csv","text/x-csv","application/vnd.ms-excel","text/plain"];}
    }
  },
  data() {
    return {
      fileList: [],
      formData: null,
      fileSelected: false,
      isValidFileMimeType: false,
      file: null,
      csv: null,
      tiposImport: [],
    };
  },
  mounted() {
    this.tiposImport = store.state.tiposImport;
    store.dispatch("reset");
  },
  methods: {
    onChangeSelectImport(val){
      store.dispatch("setTipoImportSelected", val);
    },
    handleRemove(file) {
      const index = this.fileList.indexOf(file);
      const newFileList = this.fileList.slice();
      newFileList.splice(index, 1);
      this.fileList = newFileList;
      console.log('handleRemove done');
    },
    beforeUpload(file) {
      this.fileSelected = false;
      this.fileList = [];
      const mimeType = file.type === "" ? mimeTypes.lookup(file.name) : file.type;
      if (file) {
          this.fileSelected = true;
          this.isValidFileMimeType = this.validation ? this.validateMimeType(mimeType) : true;
          if(this.isValidFileMimeType) this.fileList = [...this.fileList, file];
      } else {
          this.isValidFileMimeType = !this.validation;
          this.fileSelected = false;
      }
      store.dispatch("setValidFile", this.isValidFileMimeType);
      return false;
    },
    handleUpload() {
      //const _this = this;
      this.readFile(output => {
        //###Doc Papa-parse https://www.papaparse.com/demo
        this.csv = get(Papa.parse(output, { skipEmptyLines: 'greedy' }), "data")
        store.dispatch("setFirstRow", get(this, "csv.0"));
        this.csv.shift(); //Remove FirstRow
        store.dispatch("setCsv", this.csv);
      });
    },
    readFile(callback) {
      const { fileList } = this;
      let file = fileList[0];
      //console.log('arquivo no readFile'); console.log(file);
      if (file) {
        let reader = new FileReader();
        reader.readAsText(file, "UTF-8");
        store.dispatch("setFileName", file.name);
        reader.onload = function(evt) {
          callback(evt.target.result);
        };
        reader.onerror = function() {};
      }
    },
    completeStep() {
      this.handleUpload();
      this.$message.success("Upload de arquivo realizado com sucesso!");
      return true;
    },
    validFileMimeType(info) {
      let file = info.fileList[0];
      const mimeType =
        file.type === "" ? mimeTypes.lookup(file.name) : file.type;
      if (file) {
        this.isValidFileMimeType = this.validation ? this.validateMimeType(mimeType) : true;
        console.log("debug-step1-validFileMimeType: " + this.isValidFileMimeType.toString());
      } else {
        console.log("debug-step1-validFileMimeType: Inválido.");
        this.isValidFileMimeType = !this.validation;
      }
      store.dispatch("setValidFile", this.isValidFileMimeType);
      console.log("debug-step1-validFileMimeType: Concluido.");
    },
    validateMimeType(type) {
      return this.fileMimeTypes.indexOf(type) > -1;
    }
  },
  computed: {
    showErrorMessage() {
      return this.fileSelected && !this.isValidFileMimeType;
    },
  }
};
</script>

<style scoped>
.steps-content {
  margin-top: 16px;
  border: 1px dashed #e9e9e9;
  border-radius: 6px;
  background-color: #fafafa;
  min-height: 170px;
  text-align: center;
}
.steps-action {
  margin-top: 24px;
}
</style>
