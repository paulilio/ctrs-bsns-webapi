<template>
  <div>
    <div class="utils__title mb-3">
      <strong class="text-uppercase font-size-16">{{
        $t("welcomeMsg")
      }}</strong>
    </div>
    <div class="row">
      <div class="col-lg-12">
        <div class="card">
          <div class="card-body">
            &nbsp;
            {{database}}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
//import config from "../../../../../config.json";

export default{
 data() {
    return {
      database: null,
    };
 },
 mounted() {
   //this.database = config.map((item) => {return item.database})
   this.database = process.env.VUE_APP_ENV_DESC;

 }

}


</script>
