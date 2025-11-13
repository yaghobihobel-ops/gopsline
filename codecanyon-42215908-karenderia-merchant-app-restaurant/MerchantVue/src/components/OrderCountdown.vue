<template>
  <div>{{ countdown }}</div>
</template>

<script>
import { DateTime, Settings } from "luxon";
import APIinterface from "src/api/APIinterface";

export default {
  name: "OrderCountdown",
  props: ["start", "end", "timezone"],
  data() {
    return {
      startDate: "",
      endDate: "",
      countdown: "",
      interval: undefined,
      test: "",
    };
  },
  mounted() {
    if (!APIinterface.empty(this.start) && !APIinterface.empty(this.end)) {
      this.startDate = DateTime.fromISO(this.start, { zone: this.timezone });
      this.endDate = DateTime.fromISO(this.end, { zone: this.timezone });

      this.updateCountdown();
      this.interval = setInterval(this.updateCountdown, 1000);
    }
  },
  beforeUnmount() {
    clearInterval(this.interval);
  },
  methods: {
    updateCountdown() {
      if (this.startDate > DateTime.now()) {
        this.countdown = this.$t("Pending");
      } else {
        const now = DateTime.now().setZone(this.timezone);
        this.test = now;
        const distance = this.endDate.diff(now, "milliseconds").milliseconds;

        if (distance <= 0) {
          this.countdown = this.$t("Delayed");
          clearInterval(this.interval);
        } else {
          const { minutes, seconds } =
            this.convertMillisecondsToMinutesSeconds(distance);

          // this.countdown = `${minutes} ${this.$t("mins")} ${seconds}${this.$t(
          //   "s"
          // )}`;
          this.countdown = `${minutes} ${this.$t("mins")}`;
        }
      }
    },
    convertMillisecondsToMinutesSeconds(milliseconds) {
      const minutes = Math.floor(milliseconds / (1000 * 60));
      const seconds = Math.floor((milliseconds % (1000 * 60)) / 1000);
      return { minutes, seconds };
    },
  },
};
</script>
