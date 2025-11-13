<template>
  <q-layout view="lHh Lpr lFf">
    <q-footer bordered class="bg-white text-dark footer-shadow">
      <TabsMenu></TabsMenu>
    </q-footer>

    <q-page-container
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
    >
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script>
import { defineComponent, defineAsyncComponent } from "vue";
import { useDataStore } from "stores/DataStore";
import { useUserStore } from "stores/UserStore";

export default defineComponent({
  name: "NoTopLayout",
  components: {
    TabsMenu: defineAsyncComponent(() => import("components/TabsMenu.vue")),
  },
  setup() {
    const DataStore = useDataStore();
    const UserStore = useUserStore();
    return { DataStore, UserStore };
  },
  data() {
    return {
      online: true,
      tab: "home",
    };
  },
  created() {
    this.$q.dark.set(this.DataStore.dark_mode);
  },
});
</script>
