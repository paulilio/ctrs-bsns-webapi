<template>
  <div>

  <a-table :columns="columns" :dataSource="this.data">
    <a slot="name" slot-scope="text">{{text}}</a>
    <p slot="expandedRowRender" slot-scope="record" style="margin: 0"> Cliente: {{record.descNomeCliente}} <br/><br/> Descrição: {{record.descricao}}</p>
  </a-table>

  </div>
</template>

<script>
import { drop, every, forEach, get, isArray, map, set } from 'lodash';
import { store } from "../store";

export default {
  data() {
    return {
      columns: [],
      csv: [],
      map: [],
      fieldsToMap: [],
      data: [],
      form: {
        csv: null,
      },
    };
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

    this.data = map(this.csv, (row) => {
      let newRow = {};
      forEach(this.map, (column, field) => {
          set(newRow, field, get(row, column));
      });
      return newRow;
    });

/*
    this.columns = map(this.csv, (row) => {
            let newRow = {};
            forEach(this.map, (column, field) => {
                set(newRow, []], get(row, column));
            });
            return newRow;
        });

    console.log('colunas'); console.log(this.columns);
    this.form.csv = this.buildMappedCsv();
    */
  },
  methods: {
    buildMappedCsv() {
        //const _this = this;
        //let csv = this.hasHeaders ? drop(this.csv) : this.csv;


        return map(this.csv, (row) => {
            let newRow = {};
            forEach(this.map, (column, field) => {
                set(newRow, field, get(row, column));
            });
            return newRow;
        });
    },
    completeStep() {
      //valida
      //salva no store
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