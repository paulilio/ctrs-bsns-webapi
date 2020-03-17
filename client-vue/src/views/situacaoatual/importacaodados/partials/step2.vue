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
              :ref="`csv_uploader_map_${key}`"
              class="form-control"
              :name="`csv_uploader_map_${key}`"
              v-model="map[field.key]"
            >
              <option
                v-for="(column, key) in s_firstRow"
                :key="key"
                :value="key"
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
      map: {
      },
      fieldsToMap: [
        { label: "Data Lançamento", key: "1" },
        { label: "CPF/CNPJ do Cliente", key: "2" },
        { label: "Nome do Cliente", key: "3" },
        { label: "Valor", key: "4" },
        { label: "Data do Vencimento", key: "5" },
        { label: "Data do Recebimento", key: "6" },
        { label: "Forma de Recebimento", key: "7" },
        { label: "Unidade de Negócios", key: "8" },
        { label: "Plano de Contas", key: "9" },
        { label: "Centro de Receitas", key: "10" },
        { label: "Caixas/Bancos", key: "11" },
        { label: "Descrição", key: "12" },
      ],
    };
  },
  mounted() {
    for (var m in this.fieldsToMap) {
      this.map[this.fieldsToMap[m].key] = m;
    }

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
