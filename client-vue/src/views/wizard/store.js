import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export const store = new Vuex.Store({
  state: {
    totalTvCount: 10 // The TV inventory
  },
  mutations: {
    removeTv(state, amount) {
      // For now we allow Jenny just to remove
      // one TV at a time.
      state.totalTvCount -= amount;
    }
  },
  actions: {
    removeTv(context, amount) {
      // For now we only remove a tv,
      // but this action can contain logic
      // so we could expand it in the future.
      if (context.state.totalTvCount >= amount) {
        // If we enough TVs, ask Jenny to remove it
        context.commit("removeTv", amount);
      }
    }
  },
  getters: {}
});
