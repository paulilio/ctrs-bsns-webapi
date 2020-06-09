<template>
  <div>
        <span v-for="fieldsT in groupedfieldsToMap"  class="row">

        <div v-for="(field, key) in fieldsT" :key="key" class="col-lg-4">

<div class="row">
  <div class="col-lg-6  text-right " style="padding-top:5px;font-weight:bold;font-weight:bold;font-size: 16px;">{{ field.label }} <div style="display:inline;color:red;" v-if="field.mandatory">*</div>:</div>
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


<div>{{loadFields()}}</div>

        </div>
        </span>
</div>
</template>

<script>
import { drop, every, forEach, get, isArray, map, set, filter } from "lodash";
import { store } from "../store";

export default {
  props: {},
  data() {
    return {
      map: {},
      fieldsToMap: [],
      loading: false
    };
  },
  mounted: function() {
    this.$nprogress.start();
    //Mostra apenas os campos utilizados no tipo de importação selecionada.
    let data = [];
    forEach(store.state.fieldsToMap, function(k){
      if(k.usedBy.indexOf(store.state.tipoImportSelected) > -1){
        data.push(k);
      }
    });
    this.fieldsToMap = data;


  },
  methods: {
    loadFields(){
      //Tenta preencher automaticamente os campos de mapeamento.
      let obj1 = this.fieldsToMap;
      let obj2 = this.s_firstRow;
      let ind = null;
      forEach(obj1, (m,i) => {
        forEach(obj2, function(x, index) {
          if (x.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "").match(m.label.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, ""))) {
                //this.map[this.fieldsToMap[m].key] = index;
                ind = index;
                return false;
            }
        });
        this.map[m.key] = ind;
        ind = null;
      });
      this.$nprogress.done();
    },
    completeStep() {
      //valida
      let valido = true; let test = '';
      forEach(this.fieldsToMap, o => {
          //map(this.fieldsToMap, k =>
        if (o.mandatory === true) {
          test = get(this.map,o.key);
          if(test === null || test == 99) {
            valido = false;
          }
        }; //x[k.key].value)
      });

      if(!valido) {
        this.$message.error("É necessário preencher os campos obrigatórios, com valores existentes.");
        return false;
      }else{
        store.dispatch("setMap", this.map);
        return true;
      }

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
