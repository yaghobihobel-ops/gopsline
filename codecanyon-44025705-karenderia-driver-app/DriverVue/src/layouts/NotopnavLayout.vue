<template>
  <q-layout view="lHh Lpr lFf">
    <q-footer bordered class="bg-white text-dark modified-footer">
      <TabMenu ref="tabmenu"> </TabMenu>
    </q-footer>
    <q-page-container
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
      }"
    >
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script>
import { defineComponent } from "vue";
import { defineAsyncComponent } from "vue";
import { useActivityStore } from "stores/ActivityStore";

export default defineComponent({
  name: "NotopfooterLayout",
  setup() {
    const Activity = useActivityStore();
    return { Activity };
  },
  components: {
    TabMenu: defineAsyncComponent(() => import("components/TabMenu.vue")),
  },
  created() {
    this.$q.dark.set(this.Activity.dark_mode);
  },
});
</script>
