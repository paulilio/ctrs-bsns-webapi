<template>
  <div>
    <div :class="$style.logo">
      <div :class="$style.logoContainer">
        <img
          v-if="!settings.isMenuCollapsed || withDrawer"
          src="resources/images/logo-inverse.png"
          alt
        >
        <img
          v-if="settings.isMenuCollapsed && !withDrawer"
          src="resources/images/logo-inverse-mobile.png"
          alt
        >
      </div>
    </div>
    <div :class="settings.isLightTheme ? [$style.navigation, $style.light] : $style.navigation">
      <vue-custom-scrollbar
        :class="settings.isMobileView ? $style.scrollbarMobile : $style.scrollbarDesktop"
      >
        <a-menu
          :theme="settings.isLightTheme ? 'light' : 'dark'"
          :inlineCollapsed="withDrawer ? false : settings.isMenuCollapsed"
          :mode="'inline'"
          :selectedKeys="selectedKeys"
          :openKeys.sync="openKeys"
          @click="handleClick"
          @openChange="handleOpenChange"
        >
          <template v-for="(item, index) in menuData">
            <item
              v-if="!item.children && !item.divider"
              :menu-info="item"
              :styles="$style"
              :key="item.key"
            />
            <a-menu-divider v-if="item.divider" :key="index"/>
            <sub-menu v-if="item.children" :menu-info="item" :styles="$style" :key="item.key"/>
          </template>
        </a-menu>
      </vue-custom-scrollbar>
    </div>
  </div>
</template>

<script>
import store from 'store'
import _ from 'lodash'
import vueCustomScrollbar from 'vue-custom-scrollbar'
import { getLeftMenuData } from '@/services/menu'
import SubMenu from './partials/submenu'
import Item from './partials/item'

export default {
  name: 'menu-left',
  components: { vueCustomScrollbar, SubMenu, Item },
  props: {
    settings: Object,
    withDrawer: {
      type: Boolean,
      default: false,
    },
  },
  mounted() {
    this.openKeys = store.get('app.menu.openedKeys') || []
    this.selectedKeys = store.get('app.menu.selectedKeys') || []
    this.setSelectedKeys()
  },
  data() {
    return {
      menuData: getLeftMenuData,
      selectedKeys: [],
      openKeys: [],
    }
  },
  watch: {
    'settings.isMenuCollapsed'() {
      this.openKeys = []
    },
    '$route'() {
      this.setSelectedKeys()
    },
  },
  methods: {
    handleClick(e) {
      if (e.key === 'settings') {
        this.$store.commit('CHANGE_SETTING', { setting: 'isSettingsOpen', value: true })
        return
      }
      store.set('app.menu.selectedKeys', [e.key])
      this.selectedKeys = [e.key]
    },
    handleOpenChange(openKeys) {
      store.set('app.menu.openedKeys', openKeys)
      this.openKeys = openKeys
    },
    setSelectedKeys() {
      const pathname = this.$route.path
      const menuData = this.menuData.concat()
      const flattenItems = (items, key) =>
        items.reduce((flattenedItems, item) => {
          flattenedItems.push(item)
          if (Array.isArray(item[key])) {
            return flattenedItems.concat(flattenItems(item[key], key))
          }
          return flattenedItems
        }, [])
      const selectedItem = _.find(flattenItems(menuData, 'children'), [
        'url',
        pathname,
      ])
      this.selectedKeys = selectedItem ? [selectedItem.key] : []
    },
  },
}
</script>

<style lang="scss" module>
@import "./style.module.scss";
</style>
