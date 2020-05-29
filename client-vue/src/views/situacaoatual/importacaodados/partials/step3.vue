<template>
  <div>
    <section v-if="errored">
      <p>
        Pedimos desculpas, não estamos conseguindo recuperar as informações no
        momento. Por favor, tente novamente mais tarde.
      </p>
    </section>

    <a-table
      :columns="columns"
      :dataSource="this.form.csv"
      :row-key="record => record.uid"
      @change="handleTableChange"
    >
      <a slot="name" slot-scope="text">{{ text }}</a>
      <p slot="expandedRowRender" slot-scope="record" style="margin: 0">
        Cpf CNPJ Cliente: {{ record.descCpfCnpjCliente }}
        <br />
        <br />
        Cliente: {{ record.descNomeCliente }}
        <br />
        <br />
        Natureza: {{ record.descNatureza }}
        <br />
        <br />
        Conta Contábil: {{ record.descContaContabil }}
        <br />
        <br />
        Caixas/Bancos: {{ record.descBanco }}
        <br />
        <br />
        Código Interno: {{ record.descCodigoInterno }}
      </p>
    </a-table>

    <!--<div>{{ this.form.csv }}</div>-->
  </div>
</template>

<script>
import { drop, every, forEach, get, isArray, map, set, orderBy } from "lodash";
import { store } from "../store";
import axios from "axios";

export default {
  props: {
    callback: {
      type: Function,
      default: () => ({})
    },
    catch: {
      type: Function,
      default: () => ({})
    },
    finally: {
      type: Function,
      default: () => ({})
    }
  },
  data() {
    return {
      columns: [],
      csv: [],
      map: [],
      fieldsToMap: [],
      //firstLineRemoved: false,
      form: {
        csv: null,
        idEmpresa: 1,
        idUsuario: 1,
        cdTipoImport: null,
        dsNomeArquivo: "NomeArquivo.csv"
      },
      url: "https://localhost:44396/api/situacaoatual/Importcsv",
      errored: false
    };
  },
  mounted() {
    this.fieldsToMap = store.state.fieldsToMap;
    this.form.cdTipoImport = store.state.tipoImportSelected;
    this.form.dsNomeArquivo = store.state.fileName;
    this.csv = this.s_csv;
    this.map = this.s_map;

    //Doc: regular expression number: https://www.regular-expressions.info/numericranges.html

    //Definição de colunas e mapeamento da tabela
    this.columns.push({ title: "#", dataIndex: "uid", sorter: true }); //Código da linha na tabela

    let re_0A99 = /^([0-9]|[0-9][0-8])$/;
    forEach(this.fieldsToMap, (f_obj, f_index, i) => {
      if (f_obj.key == "descCpfCnpjCliente") return;
      if (f_obj.key == "descNomeCliente") return;
      if (f_obj.key == "descNatureza") return;
      if (f_obj.key == "descContaContabil") return;
      if (f_obj.key == "descBanco") return;
      if (f_obj.key == "descCodigoInterno") return;

      if (re_0A99.test(get(this.map, f_obj.key))) {
       //Mapeado na fase anterior. null ou acima de 98 é não mapeado.
        this.columns.push({
          title: f_obj.label,
          dataIndex: f_obj.key,
          sorter: true
        });
      } else {
        this.columns.push({
          title: f_obj.label,
          dataIndex: null
        });
      }
    });

    // *Preenchimento dos dados na tabela*

    // Remove primeira linha (cabeçalhos)
    /*
    if(!this.firstLineRemoved)
    {
      this.csv.shift();
      this.firstLineRemoved = true;
    }
    */


    let i = 0;
    this.form.csv = map(this.csv, row => {
      let newRow = {};
      set(newRow, "uid", i++); //Código da linha na tabela (#)
      forEach(this.map, (column, field) => {
        set(newRow, field, get(row, column));
      });
      return newRow;
    });
  },
  methods: {
    //Alterações Registro Tabela
    handleTableChange(pagination, filters, sorter) {
      console.log(pagination);
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
      //console.log('params:', params);
      this.$nprogress.start();
      this.form.csv = orderBy(
        this.form.csv,
        params.sortField,
        params.sortOrder == "descend" ? ["desc"] : ["asc"]
      );
      const pagination = { ...this.pagination };
      //pagination.total = 200;
      this.$nprogress.done();
      this.pagination = pagination;
    },
    completeStep() {

      this.$emit("input", this.form.csv);
      this.$nprogress.start();


      console.log("csv");
      console.log(this.form.csv);

      var res = axios
        .post(this.url, this.form)
        .then(response => {
          this.$message.success("Importação concluída com sucesso");
          this.$nprogress.done();
          return true;
        })
        .catch(error => {
          this.$message.error("Falha na importação");
          this.$notification.error({message:"Falha na importação", description: error.response.data, duration:0});
          console.error(error);
          console.error(error.response.data);
          return false;
        })
        .finally(() => (this.$nprogress.done()));

      return res;

    },
  },
  computed: {
    s_csv() {
      return store.state.csv;
    },
    s_map() {
      return store.state.map;
    }
  }
};
</script>
