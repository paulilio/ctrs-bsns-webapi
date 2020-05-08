import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export const store = new Vuex.Store({
  state: {
    uploading: false,
    isValidFile: false,
    csv: null,
    firstRow: null,
    map: null,
    fieldsToMap: [
        { label: "CPF/CNPJ do Cliente", key: "descCpfCnpjCliente" },
        { label: "Nome do Cliente", key: "descNomeCliente" },
        { label: "Data Emissão", key: "descDataLancamento" },
        { label: "Data do Vencimento", key: "descDataVencimento" },
        { label: "Data do Recebimento", key: "descDataRecebimento" },
        { label: "Forma de Recebimento", key: "descFormaRecebimento" },
        { label: "Valor", key: "descValor" },
        { label: "Natureza", key: "descNatureza" },
        { label: "Conta Contábil", key: "descContaContabil" },
        { label: "Unidade de Negócios", key: "descUnidadeNegocio" },
        { label: "Centro de Receitas", key: "descCentoReceitas" },
        { label: "Caixas/Bancos", key: "descBanco" },
        { label: "Código Interno", key: "descCodigoInterno" },
      ],
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
    SET_MAP(state, value) {
      state.map = value;
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
    setMap(context, value) {
      context.commit("SET_MAP", value);
    },
    reset(context, value) {
      context.commit("RESET", value);
    },
  },
  getters: {
    //state: state => state
  }
});
