<template>
  <a-upload-dragger
    name="csv"
    ref="csv"
    :multiple="false"
    action="https://www.mocky.io/v2/5cc8019d300000980a055e76"
    @change="validFileMimeType"
  >
    <p class="ant-upload-drag-icon">
      <a-icon type="inbox" />
    </p>
    <p class="ant-upload-text">Clique ou arraste um arquivo .csv para esta área para importação</p>
    <p class="ant-upload-hint">Suporte para um upload único.</p>
    <slot name="error" v-if="showErrorMessage">
      <div class="invalid-feedback d-block">File type is invalid</div>
    </slot>
  </a-upload-dragger>
</template>

<script>
//import store from "@/store";
import { store } from "../store";
import mimeTypes from "mime-types";
import Papa from "papaparse";

export default {
  props: {
    callback: {
      type: Function,
      default: () => ({})
    },
    fileMimeTypes: {
      type: Array,
      default: () => {
        return [
          "text/csv",
          "text/x-csv",
          "application/vnd.ms-excel",
          "text/plain"
        ];
      }
    }
  },
  data() {
    return {
      isValidFileMimeType: false,
      file: null,
      csv: null
    };
  },
  methods: {
    completeStep() {
      //valida
      //salva no store
      this.load();
      this.$message.success("This is a message of success");
      return true;
    },
    load() {
      const _this = this;
      this.readFile(output => {
        _this.csv = get(Papa.parse(output, { skipEmptyLines: true }), "data");
      });
      //store.dispatch("setCsv", csvUpload);
      console.log(_this.csv);
    },
    readFile(callback) {
      let file = this.file;
      if (file) {
        let reader = new FileReader();
        reader.readAsText(file, "UTF-8");
        reader.onload = function(evt) {
          callback(evt.target.result);
        };
        reader.onerror = function() {};
      }
    },
    validFileMimeType(info) {
      let file = info.fileList[0];
      const mimeType =
        file.type === "" ? mimeTypes.lookup(file.name) : file.type;
      if (file) {
        this.isValidFileMimeType = this.validation
          ? this.validateMimeType(mimeType)
          : true;
        //this.$emit("setDataFromStep1", this.isValidFileMimeType);
        (this.file = file),
          console.log(
            "debug-step1-validFileMimeType: " +
              this.isValidFileMimeType.toString()
          );
      } else {
        console.log("debug-step1-validFileMimeType: Inválido.");
        this.isValidFileMimeType = !this.validation;
        //this.fileSelected = false;
        //store.dispatch("setFileSelected", false);
      }
      store.dispatch("setFileSelected", this.isValidFileMimeType);
      console.log("debug-step1-validFileMimeType: Concluido.");
    },
    validateMimeType(type) {
      return this.fileMimeTypes.indexOf(type) > -1;
    }
  },
  computed: {
    showErrorMessage() {
      return this.fileSelected && !this.isValidFileMimeType;
    }
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
