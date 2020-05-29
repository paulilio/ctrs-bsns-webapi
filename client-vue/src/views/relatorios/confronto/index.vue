<template>
  <div>

    <div class="utils__title mb-3">
      <strong class="text-uppercase font-size-16">CONFRONTO DE DADOS</strong>
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


    <!-- Confronto de dados contas a receber -->
    <div class="row">

      <div class="col-lg-12">
        <div class="card card--fullHeight">
          <div class="card-header">
            <div class="utils__title utils__title--flat">
              <strong class="text-uppercase font-size-16">Confronto de Dados Contas a Receber</strong>
            </div>
          </div>
          <div class="card-body">
            <div class="row">
              <div class="col-xl-8">
                <div class="mb-3">
                  <a-table
                    :columns="columnsConfronto"
                    :dataSource="this.dataConfronto"
                    :pagination="false"
                    class="utils__scrollTable"
                    :scroll="{ x: '100%' }"
                  >
                  <template slot="footer" slot-scope="currentPageData">
                    <table class="ant-table-fixed" style="width: 100%;"><colgroup><col><col><col><col></colgroup>
                    <thead class="ant-table-fhead">
                    <tr>
                      <td style="width:18%; text-align:center"><h5><strong>Totais:</strong></h5></td>
                      <!-- <td style="width:24%" v-for="(total,key) in totaisConfronto[0]" :key="key"><h5><strong>{{total}}</strong></h5></td> -->

                      <td style="width:24%" ><h5><strong>{{totaisConfronto[0].vlSitualcaoAtualTo}}</strong></h5></td>
                      <td style="width:24%" ><h5><strong>{{totaisConfronto[0].vlDiagnosticoTo}}</strong></h5></td>
                      <td style="width:24%" ><h5><strong>{{totaisConfronto[0].vlConfrontoTo}}</strong></h5></td>

                      <td style="width:6%"></td>
                    </tr>
                    </thead>
                    </table>
                  </template>
                  </a-table>
                </div>
              </div>
              <div class="col-xl-4">
                <div
                  class="h-100 d-flex flex-column justify-content-center align-items-center"
                  :class="$style.chartPieExample"
                >
                  <vue-chartist
                    type="Pie"
                    :data="dataConfrontoPie"
                    :options="dataConfrontoPieOptions"
                  />
                  <div class="text-center mt-2">
                    <span class="mr-2 mt-1 d-inline-block">
                      <cui-donut type="success" name="Boleto"></cui-donut>
                    </span>
                    <span class="mr-2 mt-1 d-inline-block">
                      <cui-donut type="primary" name="Cartão de Crédito"></cui-donut>
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

    </div>

    <!-- Confronto de dados contas a receber -->
    <div class="row">

      <div class="col-lg-12">
        <div class="card card--fullHeight">
          <div class="card-header">
            <div class="utils__title utils__title--flat">
              <strong class="text-uppercase font-size-16">Confronto de dados caixas e bancos</strong>
            </div>
          </div>
          <div class="card-body">
            <div class="row">
              <div class="col-xl-12">
                <div class="mb-3">
                  <a-table
                    :columns="columnsConfrontoBanco"
                    :dataSource="this.dataConfrontoBanco"
                    :pagination="false"
                    class="utils__scrollTable"
                    :scroll="{ x: '100%' }"
                  >
                  <template slot="footer" slot-scope="currentPageData">
                    <table class="ant-table-fixed" style="width: 100%;"><colgroup><col><col><col><col></colgroup>
                    <thead class="ant-table-fhead">
                    <tr>
                      <td style="width:50%"></td>
                      <td style="width:18%; text-align:center"><h5><strong>Totais:</strong></h5></td>
                      <!--<td style="width:13%" v-for="(total,key) in totaisConfrontoBanco[0]" :key="key"><h5><strong>{{total}}</strong></h5></td>-->
                      <td style="width:13%" ><h5><strong>{{totaisConfrontoBanco[0].vlDiagnosticoTo}}</strong></h5></td>
                      <td style="width:13%" ><h5><strong>{{totaisConfrontoBanco[0].vlConfrontoTo}}</strong></h5></td>
                      <td style="width:6%"></td>
                    </tr>
                    </thead>
                    </table>
                  </template>
                  </a-table>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

    </div>



  </div>
</template>

<script>
import VueChartist from 'v-chartist';
import CuiDonut from '@/components/CleanUIComponents/Donut'
import ChartistTooltip from 'chartist-plugin-tooltips-updated';
import { map, mapValues } from "lodash";
import moment from "moment";
import axios from "axios";
import data from "./data.json";

export default {
  components: {
    'vue-chartist': VueChartist,
    CuiDonut,
  },
  data() {
    return {

      monthFormat: 'MM/YYYY',
      dateLimits: [{min:null, max:null}],

      filtros: null,
      filtrosRequest: null,
      filtroDicionario: data.filtroDicionario[0],

      columnsConfronto: data.columnsConfronto,
      totaisConfronto: [],
      dataConfronto: [],

      dataConfrontoPie: {},
      dataConfrontoPieOptions: {
        donut: true,
        donutWidth: 35,
        showLabel: false,
        fullWidth: true,
        plugins: [
          ChartistTooltip({
            anchorToPoint: false,
            appendToBody: true,
            seriesName: false,
          }),
        ],
      },

      columnsConfrontoBanco: data.columnsConfrontoBanco,
      totaisConfrontoBanco: [],
      dataConfrontoBanco: [],

    }
  },
  created() {
    moment.locale("pt-br");
  },
  mounted() {
    this.$nprogress.start();

    axios
    .get("https://localhost:44396/api/Relatorio/GetRelConfrontoFiltro")
    .then(response => {
      //Filtros Pesquisa: Limite das datas (Máxima e Mínima)
      this.dateLimits = response.data.limites;

      //Filtros Pesquisa: Carregamento dos dados
      this.filtros =response.data.filtros;

      //Filtros Pesquisa: Inicialização dos filtros: Exemplo: [{field1:value2},{field2:value2}]
      this.filtrosRequest = map(this.filtros, function(obj,index){
        return mapValues(obj, function(nm){return ''})
      });
      this.filtrosRequest.push({"dsMesAno": "04/2020"});

      this.getListConfronto();
      this.getListConfrontoBanco();
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
      //console.log(date, dateString);

    },
    disabledDate(current) {
      let start = this.dateLimits[0]["min"];
      let end = this.dateLimits[0]["max"];

      const weekStart = moment(this.dateLimits[0]["min"]).startOf('month');
      const weekEnd = moment(this.dateLimits[0]["max"]).endOf('month');
      return !(weekStart.isSameOrBefore(current) && weekEnd.isAfter(current));
    },
    getListConfronto(){
      this.$nprogress.start();

      console.log(JSON.stringify(this.filtrosRequest));

      var result = axios({
        method: 'post',
        url: "https://localhost:44396/api/Relatorio/GetRelConfronto",
        headers: {},
        data: {
          params: JSON.stringify(this.filtrosRequest), //.replace(/\[|\]/g, ""), // remove brackets
        }
      })
      .then(res => {
        console.log('dOK'+JSON.stringify(res.data, null, 2));
        this.dataConfronto = (res.data == '') ? null : res.data.dados;
        this.totaisConfronto = (res.data == '') ? null : res.data.totais;
        this.dataConfrontoPie = (res.data == '') ? null : res.data.pieDados;

      })
      .catch(error => {
          this.$message.error("Falha ao carregar os dados.");
          this.$notification.error({message:"Falha ao carregar os dados", description: error.response.data, duration:0});
          console.error(error);
          console.error(error.response.data);
      })
      .finally(() => {this.$nprogress.done();});

      this.$nprogress.done();

    },
    getListConfrontoBanco(){
      this.$nprogress.start();

      console.log(JSON.stringify(this.filtrosRequest));

      var result = axios({
        method: 'post',
        url: "https://localhost:44396/api/Relatorio/GetRelConfrontoBanco",
        headers: {},
        data: {
          params: JSON.stringify(this.filtrosRequest), //.replace(/\[|\]/g, ""), // remove brackets
        }
      })
      .then(res => {
        console.log('dOK'+JSON.stringify(res.data, null, 2));
        this.dataConfrontoBanco = (res.data == '') ? null : res.data.dados;
        this.totaisConfrontoBanco = (res.data == '') ? null : res.data.totais;

      })
      .catch(error => {
          this.$message.error("Falha ao carregar os dados.");
          this.$notification.error({message:"Falha ao carregar os dados", description: error.response.data, duration:0});
          console.error(error);
          console.error(error.response.data);
      })
      .finally(() => {this.$nprogress.done();});

      this.$nprogress.done();

    },
  }
}
</script>

<style lang="scss" module>
@import "./style.module.scss";
</style>
