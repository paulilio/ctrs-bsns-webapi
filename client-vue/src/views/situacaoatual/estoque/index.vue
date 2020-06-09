<template>
  <div>
    <!-- Estatísticas -->
    <div class="utils__title mb-3">
      <strong class="text-uppercase font-size-16">Estoque</strong>
    </div>
    <div class="row">
      <div class="col-xl-4" v-for="(st, index) in stats" :key="index">
        <my-cui-info-card
          :icon="st[Object.keys(st)[0]].icon"
          :type="st[Object.keys(st)[0]].type"
          :title="st[Object.keys(st)[0]].title"
          :amount="st[Object.keys(st)[0]].amount"
        />
      </div>
    </div>

    <div :class="$style.wrapper" style="padding-top: 20px; border-top: 1px solid #e4e9f0">
      <div :class="$style.searchHeader">
        <div class="row">
          <div class="col-xl-2">
            <a-month-picker placeholder="Mês" @change="onChangeMonth" size="large" :disabled-date="disabledDate" :defaultValue="moment()" :format="monthFormat">
                  <template slot="renderExtraFooter">
                  Dados a partir de {{moment(String(this.dateLimits[0]["min"])).format('DD/MM/YYYY')}}
                  </template>
                </a-month-picker>
          </div>
          <div class="col-xl-10 text-right">
            <div v-for="(f_content, f_name) in filtros" :key="f_name" style="display: inline-block;">
              <a-select size="large" style="width: 180px; margin-right:12px;" v-for="(i_content, i_name) in f_content" :placeholder="filtroDicionario[i_name]" :key="i_name" v-on:change="changeItem($event, i_name)">
                <a-select-option v-for="item in i_content" :key="item.id">
                  {{ item.value }}
                </a-select-option>
              </a-select>
            </div>
          </div>
        </div>
      </div>
    </div>


    <div class="card">

      <div class="card-body">

        <!--lista-->
        <a-table
        :columns="columns"
        :dataSource="this.datasource"
        :row-key="record => record.idFaturamento"
        @change="handleTableChange"
        >
        <a slot="name" slot-scope="text">{{ text }}</a>
        <p slot="expandedRowRender" slot-scope="record" style="margin: 0">
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
</template>

<script>
import { orderBy, filter, map, forEach, set, findIndex, replace, get, mapValues,merge  } from "lodash";
import axios from "axios";
import data from "./data.json";
import moment from "moment";
import MyCuiInfoCard from "@/components/MyComponents/InfoCard";
import Vue from 'vue'
import VueC3 from 'vue-c3';
import 'c3/c3.min.css'


export default {
  components: {
    MyCuiInfoCard,
    VueC3,
  },
  data() {
    return {
      chartCardData: data.chartCardData,
      statsConfig: data.statsConfig,
      dateLimits: [{min:null, max:null}],
      monthFormat: 'MM/YYYY',
      myArray: [],
      filtros: null,
      stats: null,
      pie: new Vue(),
      zoom: new Vue(),
      handler: new Vue(),
      filtrosRequest: null,
      filtroDicionario: data.filtroDicionario[0],
      columns: data.dtColumns,
      datasource: null,
      pagination: {},
      loading: true,
      colors: {
        primary: '#01a8fe',
        def: '#acb7bf',
        success: '#46be8a',
        danger: '#fb434a',
      },
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

    axios({
    method: 'post',
    url: "https://localhost:44396/api/SituacaoAtual/GetFiltro",
    headers: {},
    data: {
      params: '',
      cdTipoImport: 'E'
    }
  })
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

    //Dados Estatística: Mescla Json com dados e Json com configuração
    //console.log(JSON.stringify(_.merge(res.data.stats, this.statsConfig)[0]));
    this.stats = _.merge(res.data.stats, this.statsConfig);
    console.log(
      //Object.keys(this.stats).map(function(key) { return [Number(key), this.stats[key]]})
      this.stats
    )

    this.getList();

  })
  .catch(error => {
    this.$message.error("Falha ao carregar os dados");
    this.$notification.error({message:"Falha ao carregar os dados", description: (error.response.data) ? error.response.data : error.response, duration:0});
    console.error(error);
  })
  .finally(() => (this.$nprogress.done()));
  },
  methods: {
    moment,
    onChangeMonth(date, dateString) {
      console.log(date, dateString);
    },
    disabledDate(current) {
        let start = this.dateLimits[0]["min"];
        let end = this.dateLimits[0]["max"];

        const weekStart = moment(this.dateLimits[0]["min"]).startOf('month');
        const weekEnd = moment(this.dateLimits[0]["max"]).endOf('month');
        return !(weekStart.isSameOrBefore(current) && weekEnd.isAfter(current));
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
      this.$nprogress.start();
      //?JsonParams=teste", {params: this.axiosParams})
      //axios
      //.get("https://localhost:44396/api/SituacaoAtual/GetList")

      axios({
        method: 'post',
        url: "https://localhost:44396/api/SituacaoAtual/GetSituacaoAtualLista",
        headers: {},
        data: {
          params: JSON.stringify(this.filtrosRequest), //.replace(/\[|\]/g, ""), // remove brackets
          cdTipoImport: 'E'
        }
      })
      .then(res => {
        console.log('dOK'+res.data);
        this.datasource = (res.data == '') ? null : res.data;
      })
      .catch(error => {
        this.$message.error("Falha ao carregar os dados");
        this.$notification.error({message:"Falha ao carregar os dados", description: (error.response.data) ? error.response.data : error.response, duration:0});
        console.error(error);
      })
      .finally(() => (this.$nprogress.done()));
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
