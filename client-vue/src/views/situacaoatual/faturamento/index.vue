<template>
  <div>
    <div :class="$style.wrapper">
      <div :class="$style.searchHeader">
        <div class="row">
          <div class="col-xl-7">
            <div v-for="(f_content, f_name) in filtros" :key="f_name">
              <a-dropdown-button v-for="(i_content, i_name) in f_content" :key="i_name" @click="handleButtonClick" :class="$style.searchDropdown">
                {{ i_name }}
                <a-menu slot="overlay" @click="handleMenuClick">
                  <a-menu-item v-for="item in i_content" :key="item.id">
                    <a-icon type="user" />{{ item.value }}
                  </a-menu-item>
                </a-menu>
              </a-dropdown-button>
            </div>
          </div>

          <div class="col-xl-5" style="text-align:right">
            <a-range-picker
              :placeholder="['Início', 'Fim']"
              :format="dateFormat"
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
      filtros: null,
      columns: [
        { title: "#", dataIndex: "idFaturamento"},
        { title: "Data Lançamento", dataIndex: "dtDataEmissao" },
        { title: "Data do Vencimento", dataIndex: "dtDataVencimento" },
        { title: "Data do Recebimento", dataIndex: "dtDataRecebimento" },
        { title: "Forma de Recebimento", dataIndex: "dsFormaRecebimento" },
        { title: "Valor", dataIndex: "vlValor" },
        { title: "Unidade de Negócios", dataIndex: "dsUnidadeNegocio" },
        { title: "Centro de Receitas", dataIndex: "dsCentroReceita" }
      ],
      datasource: null
    };
  },
  created() {
    moment.locale("pt-br");
  },
  mounted() {
    axios
      .get("https://localhost:44396/api/SituacaoAtual/GetFiltro")
      .then(res => {
        console.log(res.data);
        this.filtros = res.data;
      })
      .catch(error => {
        console.log(error);
        this.errored = true;
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
  },
  methods: {
    moment
  }
};
</script>

<style lang="scss" module>
@import "./style.module.scss";
</style>
