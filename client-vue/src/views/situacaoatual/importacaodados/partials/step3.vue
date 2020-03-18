<template>
  <div>

  <section v-if="errored">
    <p>Pedimos desculpas, não estamos conseguindo recuperar as informações no momento. Por favor, tente novamente mais tarde.</p>
  </section>
  <section v-else>
    <div v-if="loading">Carregando...</div>
    <div
      v-else
      v-for="currency in info"
      class="currency">
      oi
    </div>
  </section>

  <a-table :columns="columns" :dataSource="this.form.csv">
    <a slot="name" slot-scope="text">{{text}}</a>
    <p slot="expandedRowRender" slot-scope="record" style="margin: 0"> Cliente: {{record.descNomeCliente}} <br/><br/> Descrição: {{record.descricao}}</p>
  </a-table>

  </div>
</template>

<script>
import { drop, every, forEach, get, isArray, map, set } from 'lodash';
import { store } from "../store";
import axios from 'axios';

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
    },
  },
  data() {
    return {
      columns: [],
      csv: [],
      map: [],
      fieldsToMap: [],
      form: {
        csv: null,
      },
      url:'https://localhost:44396/api/sales/ImportCSV',
      loading: false,
      errored: false,
    }
  },
  mounted() {
    this.fieldsToMap = store.state.fieldsToMap;
    this.csv = this.s_csv;
    this.map = this.s_map;

    forEach(this.map, (column, field) => {
      if(field=='descNomeCliente') return;
      if(field=='descricao') return;
      this.columns.push({
        title : get(this.fieldsToMap,column).label,
        dataIndex : field,
      });
    });

    this.form.csv = map(this.csv, (row) => {
      let newRow = {};
      forEach(this.map, (column, field) => {
          set(newRow, field, get(row, column));
      });
      return newRow;
    });
  },
  methods: {
    buildMappedCsv() {
        return map(this.csv, (row) => {
            let newRow = {};
            forEach(this.map, (column, field) => {
                set(newRow, field, get(row, column));
            });
            return newRow;
        });
    },
    completeStep() {
      const _this = this;
      this.$emit('input', this.form.csv);
      this.$message.loading('Loading...');
      axios.post(this.url, this.form).then(response => {
          console.log('teste1');
          this.$message.success("Importação concluída com sucesso");
          return true;
      }).catch(response => {
          this.$message.error("Falha na importação");
          console.error(response);
          console.log('test2');
          return false;
      }).finally(() => this.loading = false);
      console.log('teste3');
      return true;
    },
    info() {
      this.$message.info("This is a normal message");
    },
    success() {
      this.$message.success("This is a message of success");
    },
    error() {
      this.$message.error("This is a message of error");
    },
    warning() {
      this.$message.warning("This is message of warning");
    }
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