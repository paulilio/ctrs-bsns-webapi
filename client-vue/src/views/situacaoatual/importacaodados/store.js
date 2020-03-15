import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export const store = new Vuex.Store({
  state: {
    fileSelected: false,
    csv: null
  },
  mutations: {
    SET_FILE_SELECTED(state, value) {
      state.fileSelected = value;
    },
    SET_CSV(state, value) {
      state.csv = value;
    }
  },
  actions: {
    setCsv(context, value) {
      context.commit("SET_CSV", value);
    },
    setFileSelected(context, value) {
      context.commit("SET_FILE_SELECTED", value);
    }
  },
  getters: {
    //state: state => state
  }
});
