<template>
  <q-layout view="lHh Lpr lFf">
    <q-page-container>
      <transition
        enter-active-class="animated fadeIn"
        leave-active-class="animated fadeOut"
        appear
        :duration="300"
      >
        <router-view />
      </transition>
    </q-page-container>
  </q-layout>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useDataStore } from "stores/DataStore";

export default {
  name: "NotopfooterLayout",
  components: {},
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  created() {
    this.$q.dark.set(this.DataStore.dark_mode);
  },
};
</script>
