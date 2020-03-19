<template>
  <div>

<div :class="$style.wrapper">
  <div :class="$style.searchHeader">
    

    <div class="row">
      <div class="col-xl-7">

          <a-dropdown-button @click="handleButtonClick" :class="$style.searchDropdown">
          Unidade
          <a-menu slot="overlay" @click="handleMenuClick">
            <a-menu-item key="1"><a-icon type="user" />1st menu item</a-menu-item>
            <a-menu-item key="2"><a-icon type="user" />2nd menu item</a-menu-item>
            <a-menu-item key="3"><a-icon type="user" />3rd item</a-menu-item>
          </a-menu>
        </a-dropdown-button>

          <a-dropdown-button @click="handleButtonClick" :class="$style.searchDropdown">
          Centro de Custo
          <a-menu slot="overlay" @click="handleMenuClick">
            <a-menu-item key="1"><a-icon type="user" />1st menu item</a-menu-item>
            <a-menu-item key="2"><a-icon type="user" />2nd menu item</a-menu-item>
            <a-menu-item key="3"><a-icon type="user" />3rd item</a-menu-item>
          </a-menu>
        </a-dropdown-button>

      </div>

      <div class="col-xl-5" style="text-align:right">

        <a-range-picker 
        :placeholder="['Início','Fim']"
        :format="dateFormat">
        </a-range-picker>
        
        <a href="javascript: void(0)" :class="[$style.headerLink, 'ml-4']">
          <i class="icmn icmn-arrow-right2"/>
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

  <a-table :columns="columns" :dataSource="datasource">
    <a slot="name" slot-scope="text">{{text}}</a>
    <p slot="expandedRowRender" slot-scope="record" style="margin: 0"> Cliente: {{record.descNomeCliente}} <br/><br/> Descrição: {{record.descricao}}</p>
  </a-table>

          </div>
        </div>
      </div>
    </div>    
  </div>
</template>

<script>
import axios from 'axios';
import data from './data.json'
import moment from 'moment';
import CuiChartCard from '@/components/CleanUIComponents/ChartCard'

export default {
  components: {
    CuiChartCard,
  },
  data() {
    return {
      chartCardData: data.chartCardData,
      dateFormat: 'DD/MM/YYYY',

      columns: [
        { title: "Data Lançamento", dataIndex: "descDataLancamento" },
        { title: "CPF/CNPJ do Cliente", dataIndex: "descCpfCnpjCliente" },
        { title: "Nome do Cliente", dataIndex: "descNomeCliente" },
        { title: "Valor", dataIndex: "descValor" },
        { title: "Data do Vencimento", dataIndex: "descDataVencimento" },
        { title: "Data do Recebimento", dataIndex: "descDataRecebimento" },
        { title: "Forma de Recebimento", dataIndex: "descFormaRecebimento" },
        { title: "Unidade de Negócios", dataIndex: "descUnidadeNegocio" },
        { title: "Plano de Contas", dataIndex: "descPlanoContas" },
        { title: "Centro de Receitas", dataIndex: "descCentoReceitas" },
        { title: "Caixas/Bancos", dataIndex: "descBanco" },
        { title: "Descrição", dataIndex: "descricao" },
      ],
      datasource: null
    }
  },
  created() {
    moment.locale('pt-br')
  },
  mounted() {
    axios
    .get('https://api.coindesk.com/v1/bpi/currentprice.json')
    .then(response => {
      this.info = response.data.bpi
    })
    .catch(error => {
      console.log(error)
      this.errored = true
    })
    .finally(() => this.loading = false)
  },
  methods: {
      moment,
    },
}
</script>


<style lang="scss" module>
@import "./style.module.scss";
</style>