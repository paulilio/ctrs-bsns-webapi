<template>
  <div>
    <div class="utils__title mb-3">
      <strong class="text-uppercase font-size-16">Importação de Dados</strong>
    </div>
    <div class="row">
      <div class="col-lg-12">
        <div class="card">
          <div class="card-body">

<a-steps :current="current">
      <a-step v-for="item in steps" :key="item.title" :title="item.title" :description="item.description" />
    </a-steps>
    <div class="steps-content">

<!-- Conteúdo Importação-->
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
  </a-upload-dragger>
<!-- Fim: Conteúdo Importação-->

    </div>
    <div class="steps-action">
      <a-button v-if="current < steps.length - 1" type="primary" @click="next">
        Next
      </a-button>
      <a-button
        v-if="current == steps.length - 1"
        type="primary"
        @click="$message.success('Processing complete!')"
      >
        Done
      </a-button>
      <a-button v-if="current>0" style="margin-left: 8px" @click="prev">
        Previous
      </a-button>
    </div>

          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import mimeTypes from "mime-types";

  export default {
    props: {
            value: Array,
            url: {
                type: String
            },
            mapFields: {
                required: true
            },
            callback: {
                type: Function,
                default: () => ({})
            },
            catch: {
                type: Function,
                default: () => ({})
            },
            finally: {
                type: Function,
                default: () => ({})
            },
            parseConfig: {
                type: Object,
                default() {
                    return {};
                }
            },
            headers: {
                default: null
            },
            loadBtnText: {
                type: String,
                default: "Next"
            },
            submitBtnText: {
                type: String,
                default: "Submit"
            },
            tableClass: {
                type: String,
                default: "table"
            },
            checkboxClass: {
                type: String,
                default: "form-check-input"
            },
            buttonClass: {
                type: String,
                default: "btn btn-primary"
            },
            inputClass: {
                type: String,
                default: "form-control-file"
            },
            validation: {
                type: Boolean,
                default: true,
            },
            fileMimeTypes: {
                type: Array,
                default: () => {
                    return ["text/csv", "text/x-csv", "application/vnd.ms-excel", "text/plain"];
                }
            }
        },
    data() {
      return {
        isValidFileMimeType: false,
        form: {
            csv: null,
        },
        fieldsToMap: [],
        map: {},
        hasHeaders: true,
        csv: null,
        sample: null,
        isValidFileMimeType: false,
        fileSelected: false,

        current: 0,
        steps: [
          {
            title: 'Selecione o Arquivo',
            content: 'First-content',
            description: 'Apenas arquivos csv'
          },
          {
            title: 'Análise dos campos',
            content: 'Second-content',
            description: 'Verifica os campos'
          },
          {
            title: 'Conclusão',
            content: 'Last-content',
            description: 'Avaliação final'
          },
        ],
      };
    },
    methods: {
      next() {
        this.current++;
      },
      prev() {
        this.current--;
      },
      validFileMimeType(info) {
          let file = info.fileList[0];
          const mimeType = file.type === "" ? mimeTypes.lookup(file.name) : file.type;
          if (file) {
              this.fileSelected = true;
              this.isValidFileMimeType = this.validation ? this.validateMimeType(mimeType) : true;
          } else {
              this.isValidFileMimeType = !this.validation;
              this.fileSelected = false;
          };
          console.log("ok");
      },
      validateMimeType(type) {
          return this.fileMimeTypes.indexOf(type) > -1;
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