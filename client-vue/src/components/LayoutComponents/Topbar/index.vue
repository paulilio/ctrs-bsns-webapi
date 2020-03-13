<template>
  <div :class="$style.topbar">
    <div class="mr-auto">
      <cui-project-management />
    </div>
    <cui-profile-menu />
  </div>
</template>

<script>
import CuiProjectManagement from '@/components/LayoutComponents/Topbar/ProjectManagement'
import CuiProfileMenu from '@/components/LayoutComponents/Topbar/ProfileMenu'

export default {
  components: {
    CuiProjectManagement,
    CuiProfileMenu,
  },
}
</script>

<style lang="scss" module>
@import "./style.module.scss";
</style>
