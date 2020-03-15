import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default {
  state: {
    totalTvCount: 0
  },
  mutations: {
    UPDATE_NUMBER(state, { newNumber }) {
      state.totalTvCount = newNumber;
    }
  },
  actions: {},
  getters: {}
};
