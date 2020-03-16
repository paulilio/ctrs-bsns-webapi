<template>
  <div>
    <table border="1">
      <thead>
        <tr>
          <th>Field</th>
          <th>CSV Column</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(field, key) in fieldsToMap" :key="key">
          <td>{{ field.label }}</td>
          <td>
            <select
              class="form-control"
              :name="`csv_uploader_map_${key}`"
              v-model="map[field.key]"
            >
              <option
                v-for="(column, key) in s_firstRow"
                :key="key"
                :value="key"
                :selected="key == 1"
                >{{ column }}</option
              >
            </select>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import { drop, every, forEach, get, isArray, map, set } from "lodash";
import { store } from "../store";

export default {
  props: {},
  data() {
    return {
      fieldsToMap: [
        { label: "Data Lançamento", key: "1" },
        { label: "Nome do Cliente", key: "2" },
        { label: "CPF do Cliente", key: "3" },
        { label: "Valor", key: "4" },
        { label: "Forma de Recebimento", key: "5" },
        { label: "Plano de Contas", key: "6" },
        { label: "Unidade de Negócios", key: "7" },
        { label: "Centro de Receitas", key: "8" },
        { label: "Caixas e Bancos", key: "9" }
      ],
      map: {}
    };
  },
  methods: {
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
    s_firstRow() {
      console.log(store.state.firstRow);
      return store.state.firstRow;
    }
  }
};
</script>
