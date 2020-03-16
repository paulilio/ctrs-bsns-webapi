import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export const store = new Vuex.Store({
  state: {
    uploading: false,
    isValidFile: false,
    csv: null,
    firstRow: null,
  },
  mutations: {
    SET_UPLOADING(state, value) {
      state.uploading = value;
    },
    SET_VALID_FILE(state, value) {
      state.isValidFile = value;
    },
    SET_CSV(state, value) {
      state.csv = value;
    },
    SET_FIRST_ROW(state, value) {
      state.firstRow = value;
    },
  },
  actions: {
    setUploading(context, value) {
      context.commit("SET_UPLOADING", value);
    },
    setCsv(context, value) {
      context.commit("SET_CSV", value);
    },
    setValidFile(context, value) {
      context.commit("SET_VALID_FILE", value);
    },
    setFirstRow(context, value) {
      context.commit("SET_FIRST_ROW", value);
    },
  },
  getters: {
    //state: state => state
  }
});
