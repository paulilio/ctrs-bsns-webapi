<template>
  <div>
    <h1>STEP1</h1>
    <p>I see {{ totalTvCount }} TVs!</p>
    <p v-show="!totalTvCount">I can't buy any..</p>
    <button :disabled="!totalTvCount" @click="buyTv">Buy TV</button>
    <button :disabled="totalTvCount < 2" @click="buyTwoTvs">Buy Two TVs</button>
  </div>
</template>

<script>
import { store } from "./store";

export default {
  data() {
    return {
      numberInput: 0
    };
  },
  methods: {
    buyTv() {
      // Dispatch the action to buy a TV
      store.dispatch("removeTv", 1);
    },
    buyTwoTvs() {
      // Dispatch the action to buy two TVs
      store.dispatch("removeTv", 2);
    },
    completeStep() {
      //valida
      //salva no store
      return true;
    },
    info() {
      this.$message.info("This is a normal message");
    },
    success() {
      this.$message.success("This is a message of success");
    },
    error() {
      this.$message.error("This is a message of error");
    },
    warning() {
      this.$message.warning("This is message of warning");
    }
  },
  computed: {
    totalTvCount() {
      return store.state.totalTvCount;
    }
  }
};
</script>