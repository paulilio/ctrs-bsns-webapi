<template>
  <div>
    <div :class="$style.wrapper">
      <div :class="$style.searchHeader">
        <div class="row">
          <div class="col-xl-7">
            <div v-for="(f_content, f_name) in filtros" :key="f_name" style="display: inline-block;">
              <a-select  style="width: 180px; margin-right:12px;" v-for="(i_content, i_name) in f_content" :placeholder="i_name" :key="i_name" v-on:change="changeItem($event, i_name)">
                <a-select-option v-for="item in i_content" :key="item.id">
                  {{ item.value }}
                </a-select-option>
              </a-select>
            </div>
          </div>

          <div class="col-xl-5" style="text-align:right">
            <a-range-picker
              :placeholder="['Início', 'Fim']"
              :format="dateFormat"
              :disabled-date="disabledDate"
            >
            </a-range-picker>

            <a href="javascript: void(0)" :class="[$style.headerLink, 'ml-4']">
              <i class="icmn icmn-arrow-right2" />
            </a>
          </div>
        </div>
      </div>
    </div>

    <!--
    <div class="utils__title mb-3">
      <strong class="text-uppercase font-size-8"></strong>
    </div>
    <div class="row">
      <div class="col-xl-4" v-for="(chartCard, index) in chartCardData" :key="index">
        <cui-chart-card
          :title="chartCard.title"
          :amount="chartCard.amount"
          :chartData="chartCard.chartData"
        />
      </div>
    </div>

-->

    <div class="row">
      <div class="col-lg-12">
        <div class="card">
          <div class="card-header">
            <div class="utils__title">
              <strong>Faturamento</strong>
            </div>
          </div>

          <div class="card-body">

            <!--lista-->
            <a-table
            :columns="columns"
            :dataSource="this.datasource"
            :row-key="record => record.uid"
            @change="handleTableChange"
            >
            <a slot="name" slot-scope="text">{{ text }}</a>
            <p slot="expandedRowRender" slot-scope="record" style="margin: 0">
              Cpf CNPJ Cliente: {{ record.dsCpfCnpjCliente }}
              <br />
              <br />
              Cliente: {{ record.dsNomeCliente }}
              <br />
              <br />
              Natureza: {{ record.dsNatureza }}
              <br />
              <br />
              Conta Contábil: {{ record.dsContaContabil }}
              <br />
              <br />
              Código Interno: {{ record.dsCodigoInterno }}
              <br />
              <br />
              Carga Id: {{ record.idCarga }}
              <br />
              <br />
              Nome Arquivo: {{ record.dsNomeArquivo }}
              <br />
              <br />
              Data Importação: {{ record.dtImport }}
              <br />
              <br />
              Usuário: {{ record.dsLogin }}
            </p>
            </a-table>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { orderBy, filter, map, forEach, set, findIndex, replace, get, mapValues  } from "lodash";
import axios from "axios";
import data from "./data.json";
import moment from "moment";
import CuiChartCard from "@/components/CleanUIComponents/ChartCard";

export default {
  components: {
    CuiChartCard
  },
  data() {
    return {
      chartCardData: data.chartCardData,
      dateFormat: "DD/MM/YYYY",
      dateLimits: null,
      myArray: [],
      filtros: null,
      filtrosRequest: null,
      columns: [
        { title: "#", dataIndex: "idFaturamento", sorter: true},
        { title: "Data Lançamento", dataIndex: "dtDataEmissao", sorter: true },
        { title: "Data do Vencimento", dataIndex: "dtDataVencimento", sorter: true },
        { title: "Data do Recebimento", dataIndex: "dtDataRecebimento", sorter: true },
        { title: "Forma de Recebimento", dataIndex: "dsFormaRecebimento", sorter: true },
        { title: "Valor", dataIndex: "vlValor", sorter: true },
        { title: "Unidade de Negócios", dataIndex: "dsUnidadeNegocio", sorter: true, filters: [
      { text: 'Male', value: 'male' },
      { text: 'Female', value: 'female' }]},
        { title: "Centro de Receitas", dataIndex: "dsCentroReceita", sorter: true }
      ],
      datasource: null,
      pagination: {},
      loading: false
    };
  },
  created() {
    moment.locale("pt-br");
  },
  computed: {
    axiosParams() {
        const params = new URLSearchParams();
        params.append('jsonParams', 'valores');
        return params;
    }
  },
  mounted() {
    this.fetch();
    axios
      .get("https://localhost:44396/api/SituacaoAtual/GetFiltro")
      .then(res => {
        //Filtros Pesquisa: Carregamento dos dados
        this.filtros =res.data.filtros;

        //Filtros Pesquisa: Limite das datas (Máxima e Mínima)
        this.dateLimits = res.data.limites;

        //Filtros Pesquisa: Inicialização dos filtros: Exemplo: [{field1:value2},{field2:value2}]
        this.filtrosRequest = map(this.filtros, function(obj,index){
          return mapValues(obj, function(nm){return ''})
        });
        //console.log(JSON.stringify(this.filtrosRequest));

        /*
        this.filtrosRequest = map(this.filtros, function(obj,index){
        return map(obj, function(content,nm){
          //return {id: parseInt(index), field: name, value: null}
          return {[nm]: ""}
        })});
        this.filtrosRequest = JSON.stringify(r).replace(/\[|\]/g, ""); //remove brackets []
        console.log(this.filtrosRequest);
        */

        //let ind = this.filtrosRequest.findIndex(function(o) {return o[0] == 'dsUnidadeNegocio'}); //Search Json
        //var ind = _.findIndex(this.filtrosRequest, "{dsUnidadeNegocio}");
        //console.log(this.filtrosRequest.hasOwnProperty('dsUnidadeNegocio'));

        //return map(this.filtrosRequest, function(obj,index){return{content}}
        //this.filtrosRequest[0].dsUnidadeNegocio


      })
      .catch(error => {
        console.log(error);
        this.errored = true;
      })
      .finally(() => (this.loading = false));
      this.getList();
  },
  methods: {
    moment,
    disabledDate(current) {
        let start = this.dateLimits[0]["min"];
        let end = this.dateLimits[0]["max"];
        if (current < moment(start)){
            return true;
        }
        else if (current > moment(end)){
            return true;
        }
        else {
            return false;
        }
    },
    changeItem: function changeItem(pValue, pField) {

      //Filtros Pesquisa: Alteração dos Filtros de Pesquisa
      this.filtrosRequest = this.filtrosRequest.map(filtros =>
        Object.keys(filtros)// Get keys of the object
        .map(key => [key, (key == pField) ? pValue: filtros[key]]) // Map them to [key, value] pairs
        .reduce((obj, [key, value]) => (obj[key] = value, obj), {}) // Turn the [key, value] pairs back to an object
      );
      console.log(JSON.stringify(this.filtrosRequest));

      //let ind = this.filtrosRequest.findIndex(function(o) {return o[0].field == pField}); //Search Json
      //this.filtrosRequest.splice(ind, 1, [{[pField] : pValue}]); //Change Value Json
      //console.log(this.filtrosRequest);

      //Filtros Pesquisa: Requisição API
      //this.$emit("input", this.filtrosRequest);
      this.getList();
    },
    getList(){
      this.$message.loading("Carregando...");
      //?JsonParams=teste", {params: this.axiosParams})
      //axios
      //.get("https://localhost:44396/api/SituacaoAtual/GetList")

      axios({
        method: 'post',
        url: "https://localhost:44396/api/SituacaoAtual/GetList",
        headers: {},
        data: {
          params: JSON.stringify(this.filtrosRequest).replace(/\[|\]/g, ""), // remove brackets
        }
      })
      .then(res => {
        console.log(res.data);
        this.datasource = res.data;
      })
      .catch(error => {
        console.log(error);
        this.errored = true;
      })
      .finally(() => {
        this.loading = false
      });
    },
    changeItem2(){
      console.log('searchClick');

/*
      const _this = this;
      this.$emit("input", this.form.csv);
      this.$message.loading("Loading...");

      console.log("csv");
      console.log(this.form.csv);

      axios
        .post(this.url, this.form)
        .then(response => {
          console.log("post ok");
          this.$message.success("Importação concluída com sucesso");
          return true;
        })
        .catch(response => {
          this.$message.error("Falha na importação");
          console.error(response);
          console.log("error post");
          return false;
        })
        .finally(() => (this.loading = false));


      axios
      .get("https://localhost:44396/api/SituacaoAtual/GetList")
      .then(res => {
        console.log(res.data);
        this.datasource = res.data;
      })
      .catch(error => {
        console.log(error);
        this.errored = true;
      })
      .finally(() => (this.loading = false));
*/
    },
    handleButtonClick(){
      console.log('buttonclick');
    },
    handleMenuClick(){
      console.log('menuclick');
      console.log(this.myArray);
    },
    handleTableChange(pagination, filters, sorter) {
      //console.log(pagination);
      console.log(filters);
      //console.log(sorter);
      const pager = { ...this.pagination };
      pager.current = pagination.current;
      this.pagination = pager;
      this.fetch({
        results: pagination.pageSize,
        page: pagination.current,
        sortField: sorter.field,
        sortOrder: sorter.order,
        ...filters
      });
    },
    fetch(params = {}) {
      console.log('params:', params);
      this.loading = true;
      this.datasource = orderBy(
        this.datasource,
        params.sortField,
        params.sortOrder == "descend" ? ["desc"] : ["asc"]
      );
      const pagination = { ...this.pagination };
      //pagination.total = 200;
      this.loading = false;
      this.pagination = pagination;
    },
  }
};
</script>

<style lang="scss" module>
@import "./style.module.scss";
</style>
