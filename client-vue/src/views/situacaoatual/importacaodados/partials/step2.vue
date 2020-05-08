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
        <tr v-for="(field, key) in s_fieldsToMap" :key="key">
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
              <option value="99" key="99">Não se aplica</option>
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
      map: {},
      fieldsToMap: [],
    };
  },
  mounted() {

    this.fieldsToMap = store.state.fieldsToMap;
    for (var m in this.fieldsToMap) {
      //Prenchimento automatico desativado, para forçar usuário a selecionar.
      //this.map[this.fieldsToMap[m].key] = m;
      this.map[this.fieldsToMap[m].key] = null;
    }

  },
  methods: {
    completeStep() {
      //valida
      //salva no store
      store.dispatch("setMap", this.map); 
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
      return store.state.firstRow;
    },
    s_fieldsToMap() {
      return store.state.fieldsToMap;
    },
  }
};
</script>
