<template>
  <q-layout view="lHh Lpr lFf">
    <Realtime
      ref="realtime"
      getevent="notifications"
      @after-receive="afterReceive"
      sound_id="notify1"
    />
    <q-page-container>
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
  components: {
    Realtime: defineAsyncComponent(() => import("src/components/RealTime.vue")),
  },
  setup() {
    const Activity = useActivityStore();
    return { Activity };
  },
  created() {
    this.$q.dark.set(this.Activity.dark_mode);
  },
});
</script>
