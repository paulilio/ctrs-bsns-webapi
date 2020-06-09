import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

const getDefaultState = () => {
  return {
    uploading: false,
    isValidFile: false,
    fileName: null,
    tipoImportSelected: null,
    csv: null,
    firstRow: null,
    map: null,
    fieldsToMap: [
        { label: "CPF/CNPJ do Cliente", key: "descCpfCnpjCliente", usedBy:'F,R,P,I,B', mandatory:false },
        { label: "Cliente", key: "descNomeCliente", usedBy:'F,R,P,I,B', mandatory:false },
        { label: "CNPJ do Fornecedor", key: "descCpfCnpjCliente", usedBy:'E', mandatory:false },
        { label: "Fornecedor", key: "descNomeCliente", usedBy:'E', mandatory:false },

        { label: "Data de Emissão", key: "descDataEmissao", usedBy:'F,R,P,I,B', mandatory:true },
        { label: "Data da Compra", key: "descDataEmissao", usedBy:'E', mandatory:true },

        { label: "Data de Vencimento", key: "descDataVencimento", usedBy:'F,R,P,I,B', mandatory:true },
        { label: "Data do Pagamento", key: "descDataPagamento", usedBy:'F,R,I,B', mandatory:false },
        { label: "Forma de Pagamento", key: "descFormaPagamento", usedBy:'F,R,I,B', mandatory:false },

        { label: "Valor", key: "descValor", usedBy:'F,R,P,I,B', mandatory:true },
        { label: "Custo Total", key: "descValor", usedBy:'E', mandatory:true },

        { label: "Produto", key: "descProduto", usedBy:'E', mandatory:true },
        { label: "Linha de Produto", key: "descLinhaProduto", usedBy:'E', mandatory:true },
        { label: "Quantidade", key: "descQuantidade", usedBy:'E', mandatory:true },
        { label: "Custo Unitário", key: "descValorUnitario", usedBy:'E', mandatory:true },

        { label: "Natureza", key: "descNatureza", usedBy:'F,R,P,I,B', mandatory:false },
        { label: "Conta Contábil", key: "descContaContabil", usedBy:'F,R,P,I,B', mandatory:false },
        { label: "Unidade de Negócios", key: "descUnidadeNegocio", usedBy:'F,R,P,I,B,E', mandatory:false },
        { label: "Centro de Custo", key: "descCentoCusto", usedBy:'F,R,I,B,E', mandatory:false },

        { label: "Caixas/Bancos", key: "descBanco", usedBy:'B', mandatory:true },
        { label: "Código Interno", key: "descCodigoInterno", usedBy:'F,R,P,I,B,E', mandatory:false },

      ],
    tiposImport: [
      {
        "F": "Faturamento",
        "R": "Contas a Receber",
        "P": "Contas a Pagar",
        "I": "Inadimplência",
        "B": "Caixas e Bancos",
        "E": "Estoque"
      }
    ]
  }
}

const state = getDefaultState()

export const store = new Vuex.Store({
  state,
  mutations: {
    resetState (state) {
      Object.assign(state, getDefaultState())
    },
    SET_UPLOADING(state, value) {
      state.uploading = value;
    },
    SET_VALID_FILE(state, value) {
      state.isValidFile = value;
    },
    SET_FILE_NAME(state, value){
      state.fileName = value;
    },
    SET_TIPO_IMPORT_SELECTED(state, value) {
      state.tipoImportSelected = value;
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
    setFileName(context, value){
      context.commit("SET_FILE_NAME", value);
    },
    setTipoImportSelected(context, value) {
      context.commit("SET_TIPO_IMPORT_SELECTED", value);
    },
    setFirstRow(context, value) {
      context.commit("SET_FIRST_ROW", value);
    },
    setMap(context, value) {
      context.commit("SET_MAP", value);
    },
    reset ({ commit }) {
      commit('resetState')
    },
  },
  getters: {
    //state: state => state
  }
});
