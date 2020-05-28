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
              <a-step
                v-for="item in steps"
                :key="item.title"
                :title="item.title"
                :description="item.description"
              />
            </a-steps>
            <div class="steps-content">
              <div class="steps-content" style="margin-bottom:20px;">
                <div :is="steps[current].component" :ref="steps[current].component"></div>
              </div>
            </div>

            <div class="steps-action">
              <a-button
                v-if="current < steps.length - 1"
                :disabled="!s_isValidFile"
                type="primary"
                @click.prevent="next"
              >Próximo</a-button>
              <a-button
                v-if="current == steps.length - 1"
                type="primary"
                @click.prevent="done"
              >Concluído</a-button>
              <a-button v-if="current > 0" style="margin-left: 8px" @click="prev">Anterior</a-button>
            </div>
          </div>
        </div>
      </div>

    </div>
  </div>
</template>

<script>
import step1 from "./partials/step1";
import step2 from "./partials/step2";
import step3 from "./partials/step3";
import { store } from "./store";

export default {
  components: { step1, step2, step3 },
  props: {},
  data() {
    return {
      current: 0,
      steps: [
        {
          title: "Selecione o Arquivo",
          description: "Apenas arquivos csv",
          component: "step1"
        },
        {
          title: "Análise dos campos",
          description: "Verifica os campos",
          component: "step2"
        },
        {
          title: "Conclusão",
          description: "Avaliação final",
          component: "step3"
        }
      ]
    };
  },
  methods: {
    next() {
      var comp = this.steps[this.current].component;
      if (this.$refs[comp].completeStep()) {
        this.current++;
      }
    },
    prev() {
      this.current--;
    },
    done() {
      var comp = this.steps[this.current].component;
       this.$refs[comp].completeStep()
       .then(result => {
          if (result) {
            //Sucesso
            this.current = 0;
            store.dispatch("reset");
            this.steps[0].component;
          }
       });
    },
  },
  computed: {
    disabledNextButton() {
      return !this.isValidFileMimeType;
    },
    s_isValidFile() {
      return (store.state.isValidFile && (store.state.tipoImportSelected != null || store.state.tipoImportSelected != ''));
    },
    s_csv() {
      return store.state.csv;
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
