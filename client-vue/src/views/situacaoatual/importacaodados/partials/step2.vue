<template>
  <div>
    <h1>STEP2</h1>
  </div>
</template>

<script>
import { store } from "@/store";

export default {
  data() {
    return {
      numberInput: 0
    };
  },
  methods: {
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
  }
};
</script>