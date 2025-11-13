<template>
  <q-btn
    @click="handleButton"
    round
    color="indigo-1"
    text-color="dark"
    unelevated
    dense
  >
    <img src="/svg/chat.svg" width="25" height="25" />
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

<script>
import { useUserStore } from "stores/UserStore";

export default {
  name: "ChatNotifications",
  props: ["count", "sound_id"],
  setup() {
    const UserStore = useUserStore();

    return { UserStore };
  },
  methods: {
    handleButton() {
      this.UserStore.setViewedNotifications(1);
      this.$router.push("/chat");
    },
  },
};
</script>
