<template>
  <div>
    <!-- Estatísticas -->
    <div class="utils__title mb-3">
      <strong class="text-uppercase font-size-16">ÚLTIMAS ESTATÍSTICAS</strong>
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







<!--
    <div class="row">
      <div class="col-lg-12">
-->
        <div class="card">
          <div class="card-header">

            <div class="utils__title">+
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
      <div class="card">

        <div class="card-body">
          <div class="row">
            <div class="col-lg-6">
              <h5 class="text-black">
                <strong>Faturamento/Categoria</strong>
              </h5>
              <div class="mb-5">
                <vue-c3 :handler="pie" class="height-300"></vue-c3>
              </div>
            </div>

            <div class="col-lg-6">
              <h5 class="text-black">
                <strong>Faturamento</strong>
              </h5>
              <div class="mb-5">
                <!--<vue-c3 :handler="zoom" class="height-300"></vue-c3>-->
                <vue-c3 :handler="handler" class="height-300"></vue-c3>
              </div>
            </div>
        </div>

      </div>
    </div>













      </div>





<!--
    </div>
  </div>
-->


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
      columns: [
        { title: "#", dataIndex: "idFaturamento", sorter: true},
        { title: "Data Lançamento", dataIndex: "dtDataEmissao", sorter: true },
        { title: "Data do Vencimento", dataIndex: "dtDataVencimento", sorter: true },
        { title: "Data do Recebimento", dataIndex: "dtDataPagamento", sorter: true },
        { title: "Forma de Recebimento", dataIndex: "dsFormaPagamento", sorter: true },
        { title: "Valor", dataIndex: "vlValor", sorter: true },
        { title: "Unidade de Negócios", dataIndex: "dsUnidadeNegocio", sorter: true},
        { title: "Centro de Receitas", dataIndex: "dsCentroCusto", sorter: true }
        //#### Teste
        //{ title: "Centro de Receitas", dataIndex: "dsCentroReceita", sorter: true, filters: [{ text: 'Male', value: 'male' },{ text: 'Female', value: 'female' }]}
      ],
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
    },

    zoomOptions() {
      return {
        data: {
          x: 'x',
          columns: [
            ['x', '2013-01-01', '2013-01-02', '2013-01-03', '2013-01-04', '2013-01-05', '2013-01-06'],
//            ['x', '20130101', '20130102', '20130103', '20130104', '20130105', '20130106'],
            ['data1', 30, 200, 100, 400, 150, 250],
            ['data2', 130, 340, 200, 500, 250, 350]
          ],
          axis: {
            x: {
                type: 'timeseries',
                tick: {
                    format: '%Y-%m-%d'
                }
            }
          },
          colors: {
            Sample: this.colors.primary,
          },
        },
        zoom: {
          enabled: !0,
        },
      }
    },
    pieOptions() {
      return {
        data: {
          columns: [['Primary', 30], ['Success', 120]],
          type: 'pie',
        },
        color: {
          pattern: [this.colors.primary, this.colors.success],
        },
      }
    }
  },
  mounted() {
    this.fetch();
    this.zoom.$emit('init', this.zoomOptions);
    this.pie.$emit('init', this.pieOptions);

      // to init the graph call:
      const options = {
        data: {
          x: 'times',
          xFormat: '%Y-%m-%d', // how the date is parsed
          columns: [
            ['times','2015-09-17','2015-10-17','2015-11-17', '2015-12-17', '2016-01-17'],
            ['data','1234','1235','132346','13458']
          ],
          colors: {
                Sample: this.colors.primary,
              },
        },
        axis: {
            x: {
                type: 'timeseries',
                tick: {
                    format: '%d' // how the date is displayed
                }
            }
        }
      };
      this.handler.$emit('init', options);

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

        //Dados Estatística: Mescla Json com dados e Json com configuração
        //console.log(JSON.stringify(_.merge(res.data.stats, this.statsConfig)[0]));
        this.stats = _.merge(res.data.stats, this.statsConfig);
        console.log(
          //Object.keys(this.stats).map(function(key) { return [Number(key), this.stats[key]]})
          this.stats
        )

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
      this.$message.loading("Carregando...");
      //?JsonParams=teste", {params: this.axiosParams})
      //axios
      //.get("https://localhost:44396/api/SituacaoAtual/GetList")

      axios({
        method: 'post',
        url: "https://localhost:44396/api/SituacaoAtual/GetList",
        headers: {},
        data: {
          params: JSON.stringify(this.filtrosRequest), //.replace(/\[|\]/g, ""), // remove brackets
        }
      })
      .then(res => {
        console.log('dOK'+res.data);
        this.datasource = (res.data == '') ? null : res.data;
      })
      .catch(error => {
        console.log('dError'+error);
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
