<template>
  <q-page padding class="bg-grey-1"> </q-page>
</template>

<script>
import { useActivityStore } from "stores/ActivityStore";
export default {
  name: "SupportPage",
  setup() {
    const Activity = useActivityStore();
    return { Activity };
  },
  created() {
    this.Activity.setTitle(this.$t("Support"));
  },
};
</script>
