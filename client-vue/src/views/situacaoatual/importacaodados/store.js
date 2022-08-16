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
      //Geral
      { label: "Data de Emissão", key: "dtDataEmissao", usedBy:'F,R,P,I,B', mandatory:true },
      { label: "Data de Vencimento", key: "dtDataVencimento", usedBy:'F,R,P,I,B', mandatory:true },
      { label: "Unidade de Negócio", key: "dsUnidadeNegocio", usedBy:'F,R,P,I,B,E', mandatory:false },

      { label: "Centro de Receita", key: "dsCentroReceita", usedBy:'F,R,I,B', mandatory:false },
      { label: "Centro de Custo", key: "dsCentroCusto", usedBy:'E', mandatory:false },

      { label: "Código Pedido", key: "cdCodigoInterno", usedBy:'F,R,P,I,B', mandatory:false },
      { label: "CPF/CNPJ do Cliente", key: "dsCpfCnpjCliente", usedBy:'F,R,P,I,B', mandatory:false },
      { label: "Nome Cliente", key: "dsNomeCliente", usedBy:'F,R,P,I,B', mandatory:false },
      { label: "Valor", key: "vlValor", usedBy:'F,R,P,I,B', mandatory:true },

      { label: "Data do Pagamento", key: "dtDataPagamento", usedBy:'R,I,B', mandatory:false },

      //Faturamento
      { label: "Código Plano de Contas", key: "cdPlanoContas", usedBy:'F', mandatory:false },
      { label: "Tipo de Recebimento", key: "dsTipoRecebimento", usedBy:'F', mandatory:false },
      { label: "Natureza", key: "dsNatureza", usedBy:'F', mandatory:false },
      { label: "Tipo de Custo", key: "dsTipoCusto", usedBy:'F', mandatory:false },
      { label: "Conta Contábil", key: "dsContaContabil", usedBy:'F', mandatory:false },

      //Estoque
      { label: "Data da Compra", key: "dtDataCompra", usedBy:'E', mandatory:true },
      { label: "CNPJ do Fornecedor", key: "dsCpfCnpjFornecedor", usedBy:'E', mandatory:false },
      { label: "Fornecedor", key: "dsNomeFornecedor", usedBy:'E', mandatory:false },
      { label: "Estoque Central", key: "dsEstoqueCentral", usedBy:'E', mandatory:true },

      //Produto (faturamento e estoque)
      { label: "Código Produto", key: "idProduto", usedBy:'F,E', mandatory:false },
      { label: "Descrição do Produto", key: "dsProduto", usedBy:'F,E', mandatory:false },
      { label: "Classificação do Produto", key: "dsClassificacao", usedBy:'F,E', mandatory:false },
      { label: "Custo Unitário", key: "vlCusto", usedBy:'F,E', mandatory:false },
      { label: "Quantidade", key: "vlQuantidade", usedBy:'F,E', mandatory:false },
      { label: "Custo Total", key: "vlCustoTotal", usedBy:'F,E', mandatory:true },

      { label: "Natureza", key: "descNatureza", usedBy:'R,P,I,B', mandatory:false },
      { label: "Conta Contábil", key: "descContaContabil", usedBy:'R,P,I,B', mandatory:false },
      { label: "Caixas/Bancos", key: "descBanco", usedBy:'B', mandatory:true },
    ],
    tiposImport: [
      {
        "F": "Faturamento",
        "R": "Contas a Receber",
        "P": "Contas a Pagar",
        "I": "Inadimplência",
        "B": "Caixas e Bancos",
        "E": "Estoque",
        "C": "Plano de Contas"
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
