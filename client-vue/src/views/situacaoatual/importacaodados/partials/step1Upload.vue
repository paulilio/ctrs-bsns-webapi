<template>
  <a-upload-dragger
    name="csv"
    :multiple="false"
    action="https://www.mocky.io/v2/5cc8019d300000980a055e76"
    @change="validFileMimeType"
    ref="csv"
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
import mimeTypes from "mime-types";

export default {
  props: {
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
      fieldsToMap: [],
      map: {},
      hasHeaders: true,
      sample: null,
      isValidFileMimeType: false
    };
  },
  methods: {
    validFileMimeType(info) {
      let file = info.fileList[0];
      const mimeType =
        file.type === "" ? mimeTypes.lookup(file.name) : file.type;
      if (file) {
        this.isValidFileMimeType = this.validation
          ? this.validateMimeType(mimeType)
          : true;
        this.$emit("setDataFromStep1", this.isValidFileMimeType);
        console.log(
          "debug-isValidFileMimeType: " + this.isValidFileMimeType.toString()
        );
      } else {
        console.log("not ok");
        this.isValidFileMimeType = !this.validation;
        this.fileSelected = false;
      }
      console.log("o-conck");
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
