<template>
  <div :class="$style.card">
    <div :class="[$style.infoCard, type.length > 0 ? $style[type] : '']">
        <span v-if="icon !== false" :class="$style.digit">
          <i :class="'icmn-' + icon"></i>
        </span>
        <!--
        <div :class="$style.desc">
          <div v-if="amount" :class="$style.amount">{{amount}}</div>
          <div v-if="title" :class="$style.title">{{title}}</div>
        </div>
        -->
        <div :class="$style.desc">
          <span :class="$style.title">{{title}}</span>
          <div v-if="amount" :class="$style.amount">{{amount}}</div>
        </div>
    </div>

  </div>
</template>

<script>

export default {
  components: {
  },
  name: 'MyCuiInfoCard',
  props: {
    icon: String,
    amount: String,
    title: String,
    type: String,
  },
  data: function () {
    return {
    }
  },
}
</script>

<style lang="scss" module>
@import "./style.module.scss";
</style>
