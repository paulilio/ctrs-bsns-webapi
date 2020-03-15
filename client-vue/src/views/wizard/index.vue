<template>
  <div>
    <a-steps :current="current">
      <a-step
        v-for="item in steps"
        :key="item.title"
        :title="item.title"
        :description="item.description"
      />
    </a-steps>
    <div class="steps-content">
      <div :is="steps[current].component" :ref="steps[current].component"></div>
    </div>
    <div class="steps-action">
      <a-button v-if="current < steps.length - 1" type="primary" @click="next">Next</a-button>
      <a-button
        v-if="current == steps.length - 1"
        type="primary"
        @click="$message.success('Processing complete!')"
      >Done</a-button>
      <a-button v-if="current>0" style="margin-left: 8px" @click="prev">Previous</a-button>
    </div>
    <h2>teste:</h2>
    <h2>{{ totalTvCount }}</h2>
  </div>
</template>

<script>
import step1 from "./step1";
import step2 from "./step2";
import step3 from "./step3";
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
      if (this.$refs.step1.completeStep()) {
        this.current++;
      }
    },
    prev() {
      this.current--;
    }
  },
  computed: {
    totalTvCount() {
      return store.state.totalTvCount;
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