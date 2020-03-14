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
<step1-upload></step1-upload>
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
  import step1Upload from './partials/step1Upload'

  export default {
    components: { step1Upload },
    props: {
        },
    data() {
      return {
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