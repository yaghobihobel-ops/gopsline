<template>
  <q-page padding class="flex flex-center">
    <q-inner-loading
      :showing="ActivityStore.settings_loading"
      color="primary"
    ></q-inner-loading>
  </q-page>
</template>

<script>
import { useActivityStore } from "stores/ActivityStore";

export default {
  name: "IntroPage",
  setup() {
    const ActivityStore = useActivityStore();
    return { ActivityStore };
  },
  watch: {
    ActivityStore: {
      immediate: true,
      deep: true,
      handler(newValue, oldValue) {
        console.log(newValue.settings_loading);
        if (newValue.settings_loading == false) {
          if (
            newValue.settings_data.enabled_language == true &&
            newValue.choose_language == false
          ) {
            this.$router.replace("/select-language");
          } else {
            this.$router.replace("/user/login");
          }
        }
      },
    },
  },
};
</script>
