<template>
  {{ countdown }}
</template>

<script>
import { DateTime } from "luxon";
import APIinterface from "src/api/APIinterface";

export default {
  name: "PauseCountdown",
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
  watch: {
    start(newval, oldval) {
      console.log("d2", newval);
      this.refreshCountdown();
    },
  },
  beforeUnmount() {
    clearInterval(this.interval);
  },
  methods: {
    refreshCountdown() {
      clearInterval(this.interval);
      if (!APIinterface.empty(this.start) && !APIinterface.empty(this.end)) {
        this.startDate = DateTime.fromISO(this.start, { zone: this.timezone });
        this.endDate = DateTime.fromISO(this.end, { zone: this.timezone });

        this.updateCountdown();
        this.interval = setInterval(this.updateCountdown, 1000);
      }
    },
    updateCountdown() {
      if (this.startDate > DateTime.now()) {
        this.$emit("pauseEnd");
      } else {
        const now = DateTime.now().setZone(this.timezone);
        this.test = now;
        const distance = this.endDate.diff(now, "milliseconds").milliseconds;

        if (distance <= 0) {
          //this.countdown = "00:00:00";
          this.$emit("pauseEnd");
          clearInterval(this.interval);
        } else {
          const { hours, minutes, seconds } =
            this.convertMillisecondsToHoursMinutesSeconds(distance);
          const formattedHours = hours.toString().padStart(2, "0");
          const formattedMinutes = minutes.toString().padStart(2, "0");
          const formattedSeconds = seconds.toString().padStart(2, "0");

          if (hours <= 0) {
            this.countdown = `${formattedMinutes}:${formattedSeconds}`;
          } else {
            this.countdown = `${formattedHours}:${formattedMinutes}:${formattedSeconds}`;
          }
        }
      }
    },
    convertMillisecondsToHoursMinutesSeconds(milliseconds) {
      const hours = Math.floor(milliseconds / (1000 * 60 * 60));
      const minutes = Math.floor(
        (milliseconds % (1000 * 60 * 60)) / (1000 * 60)
      );
      const seconds = Math.floor((milliseconds % (1000 * 60)) / 1000);
      return { hours, minutes, seconds };
    },
  },
};
</script>
