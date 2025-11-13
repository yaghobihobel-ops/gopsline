<template>
  <template v-if="visible">
    <q-btn @click="handleButton" dense round color="teal-2" unelevated>
      <img src="/svg/notification1.svg" width="25" height="25" />
      <transition
        v-if="count > 0"
        appear
        enter-active-class="animated zoomIn"
        leave-active-class="animated zoomOut"
      >
        <q-badge rounded color="red" :label="count" floating />
      </transition>
    </q-btn>
  </template>
</template>

<script>
import { useUserStore } from "stores/UserStore";

export default {
  name: "NotiButton",
  props: ["sound_id", "count", "visible"],
  data() {
    return {
      data: [],
    };
  },
  setup(props) {
    const UserStore = useUserStore();
    return { UserStore };
  },
  methods: {
    handleButton() {
      this.UserStore.setViewedNotifications(0);
      this.$router.push("/notifications");
    },
  },
};
</script>
