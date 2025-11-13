<template>
  <q-page class="row items-stretch">
    <div class="col-12">
      <q-linear-progress :value="progress" color="primary" />
      <div class="q-pa-md">
        <div class="text-h6">{{ $t("Your account is being deleted") }}</div>
        <p class="text-body2">
          {{
            $t(
              "You will be automatically logged out. Your account will be deleted in the next few minutes"
            )
          }}.
        </p>
        <p class="text-body2">
          {{
            $t("Note: We may retain some information when permitted by law")
          }}.
        </p>
      </div>
    </div>
  </q-page>
</template>

<script>
import auth from "src/api/auth";

export default {
  name: "DeleteTy",
  data() {
    return {
      progress: 0,
      counter: 1,
      timer: undefined,
    };
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
      auth.logout();
      this.$router.push("/login");
    },
  },
};
</script>
