import Vue from "vue";
import Vuex from "vuex";
import user from "./user";
import settings from "./settings";
import imports from "./imports";

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    user,
    settings,
    imports
  },
  state: {},
  mutations: {},
  actions: {}
});
