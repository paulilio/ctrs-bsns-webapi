<template>
  <div>

        <span v-for="fieldsT in groupedfieldsToMap"  class="row">

        <div v-for="(field, key) in fieldsT" :key="key" class="col-lg-4">

<div class="row">
  <div class="col-lg-6  text-right " style="padding-top:5px;font-weight:bold;font-weight:bold;font-size: 16px;">{{ field.label }}:</div>
  <div class="col-lg-6 text-left" style="padding-top:5px;padding-bottom:5px;">

        <select size="large" style="width: 200px; height: 30px;"
              :ref="`csv_uploader_map_${key}`"
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
  </div>
</div>




        </div>
        </span>

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

    //let g = map(this.fieldsToMap, function(obj,index){      });

    for (var m in this.fieldsToMap) {
      //Prenchimento automatico desativado, para forçar usuário a selecionar.
      //this.map[this.fieldsToMap[m].key] = m;
      this.map[this.fieldsToMap[m].key] = null;

      //console.log(m);
    }

    //this.fieldsToMap


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
    groupedfieldsToMap() {
      return _.chunk(this.fieldsToMap, 3)
      // returns a nested array:
      // [[article, article, article], [article, article, article], ...]
    },
    s_firstRow() {
      return store.state.firstRow;
    },
    s_fieldsToMap() {
      return store.state.fieldsToMap;
    },
  }
};
</script>
