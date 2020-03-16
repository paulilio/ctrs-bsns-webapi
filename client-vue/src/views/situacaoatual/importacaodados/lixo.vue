<template>
  <div class="clearfix">


<div class="vue-csv-mapping">
      <table :class="tableClass">
        <slot name="thead">
          <thead>
            <tr>
              <th>Field</th>
              <th>CSV Column</th>
            </tr>
          </thead>
        </slot>
        <tbody>
          <tr v-for="(field, key) in fieldsToMap" :key="key">
            <td>{{ field.label }}</td>

            <td>
              <select
                class="form-control"
                :name="`csv_uploader_map_${key}`"
                v-model="map[field.key]"
              >
                <option
                  v-for="(column, key) in firstRow"
                  :key="key"
                  :value="key"
                  >{{ column }}</option
                >
              </select>
            </td>
          </tr>
        </tbody>
      </table>

      <div class="form-group" v-if="url">
        <slot name="submit" :submit="submit">
          <input
            type="submit"
            :class="buttonClass"
            @click.prevent="submit"
            :value="submitBtnText"
          />
        </slot>
      </div>
    </div>













  <a-upload-dragger
    :fileList="fileList"
    name="csv"
    ref="csv"
    :multiple="false"
    action="https://www.mocky.io/v2/5cc8019d300000980a055e76"
    @change="validFileMimeType"
  >
    <p class="ant-upload-drag-icon"><a-icon type="inbox" /></p>
    <p class="ant-upload-text">Clique ou arraste um arquivo .csv para esta área para importação</p>
    <p class="ant-upload-hint">Suporte para um upload único.</p>
    <slot name="error" v-if="showErrorMessage"><div class="invalid-feedback d-block">File type is invalid</div></slot>
  </a-upload-dragger>


    <a-upload :fileList="fileList" :remove="handleRemove" :beforeUpload="beforeUpload">
      <a-button> <a-icon type="upload" /> Select File </a-button>
    </a-upload>

    <a-button
      type="primary"
      @click="handleUpload"
      :disabled="fileList.length === 0"
      :loading="uploading"
      style="margin-top: 16px"
    >
      {{uploading ? 'Uploading' : 'Start Upload' }}
    </a-button>
  </div>
</template>
<script>
  import reqwest from 'reqwest';
  export default {
    data() {
      return {
        fileList: [],
        uploading: false,
      };
    },
    methods: {
      handleRemove(file) {
        const index = this.fileList.indexOf(file);
        const newFileList = this.fileList.slice();
        newFileList.splice(index, 1);
        this.fileList = newFileList;
      },
      beforeUpload(file) {
        this.fileList = [...this.fileList, file];
        return false;
      },
      handleUpload() {
        const { fileList } = this;
        const formData = new FormData();
        fileList.forEach(file => {
          formData.append('files[]', file);
        });
        this.uploading = true;

        // You can use any AJAX library you like
        reqwest({
          url: 'https://www.mocky.io/v2/5cc8019d300000980a055e76',
          method: 'post',
          processData: false,
          data: formData,
          success: () => {
            this.fileList = [];
            this.uploading = false;
            this.$message.success('upload successfully.');
          },
          error: () => {
            this.uploading = false;
            this.$message.error('upload failed.');
          },
        });
      },
    },
  };
</script>