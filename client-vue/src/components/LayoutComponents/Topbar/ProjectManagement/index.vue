<template>
  <a-dropdown :trigger="['click']" placement="bottomLeft" class="dropdown_prime">
    <div :class="$style.dropdown" style="">
      <i class="icmn-office" :class="$style.icon"></i>
      <span class="d-none d-xl-inline">
        <strong>Empresa A</strong>
      </span>
    </div>
    <a-menu slot="overlay">
      <a-menu-item-group title="Ativas">
        <a-menu-item>
          <a href="javascript: void(0);">Empresa A</a>
        </a-menu-item>
        <a-menu-item>
          <a href="javascript: void(0);">Empresa B</a>
        </a-menu-item>
        <a-menu-item>
          <a href="javascript: void(0);">Empresa C</a>
        </a-menu-item>
      </a-menu-item-group>
      <a-menu-item-group title="Inativas">
        <a-menu-item>
          <a href="javascript: void(0);">Empresa D</a>
        </a-menu-item>
      </a-menu-item-group>
      <a-menu-divider/>
      <a-menu-item>
        <a href="javascript: void(0);">
          <i class="icmn-cog" :class="$style.menuIcon"/>
          Gerenciar Empresas
        </a>
      </a-menu-item>
    </a-menu>
  </a-dropdown>
</template>

<style lang="scss" module>
@import "./style.module.scss";
</style>
