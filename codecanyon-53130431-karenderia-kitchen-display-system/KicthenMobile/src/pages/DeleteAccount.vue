<template>
  <q-page padding class="flex flex-center">
    <div class="text-center">
      <q-linear-progress :value="progress" color="primary" />
      <div class="text-h6 q-mb-sm q-mt-sm">
        {{ $t("Your account is being deleted") }}
      </div>
      <p>
        {{
          $t(
            "You will be automatically logged out. Your account will be deleted in the next few minutes"
          )
        }}.
      </p>
      <p>
        {{ $t("Note: We may retain some information when permitted by law") }}.
      </p>
    </div>
  </q-page>
</template>

<script>
import { useIdentityStore } from "stores/IdentityStore";

export default {
  name: "DeleteAccount",
  data() {
    return {
      progress: 0,
      counter: 1,
      timer: undefined,
    };
  },
  setup() {
    const IdentityStore = useIdentityStore();
    return { IdentityStore };
  },
  created() {
    this.startTimer();
  },
  unmounted() {
    this.stopTimer();
  },
  watch: {
    counter(newval, oldval) {
      this.progress = (newval * 10) / 100;
      if (newval >= 10) {
        this.stopTimer();
        this.redirect();
      }
    },
  },
  methods: {
    startTimer() {
      this.stopTimer();
      this.counter = 1;
      this.timer = setInterval(() => {
        this.counter++;
      }, 900);
    },
    stopTimer() {
      clearInterval(this.timer);
    },
    redirect() {
      this.IdentityStore.logout();
      this.$router.replace("/login");
    },
  },
};
</script>
