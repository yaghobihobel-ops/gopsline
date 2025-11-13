<template>
  <template v-if="elapse">
    {{ elapse }}
  </template>
</template>

<script>
import { DateTime, Settings } from "luxon";
import APIinterface from "src/api/APIinterface";

export default {
  name: "ElapsetimeComponents",
  props: ["start", "timezone"],
  emits: ["update:result"],
  data() {
    return {
      elapse: "",
      interval: undefined,
    };
  },
  mounted() {
    if (!APIinterface.empty(this.startElapse)) {
      this.startElapse();
      this.interval = setInterval(this.startElapse, 1000);
    }
  },
  beforeUnmount() {
    clearInterval(this.interval);
  },
  methods: {
    startElapse() {
      if (typeof this.start !== "undefined" && this.start !== null) {
      } else {
        return "";
      }
      const givenDateStr = this.start;
      const timezone = this.timezone;
      const givenDate = DateTime.fromISO(givenDateStr, { zone: timezone });
      const currentDate = DateTime.now().setZone(timezone);
      const timeDiff = currentDate.diff(givenDate).milliseconds;
      const elapsedSeconds = Math.floor(timeDiff / 1000);
      const seconds = elapsedSeconds % 60;
      const minutes = Math.floor(elapsedSeconds / 60) % 60;
      const hours = Math.floor(elapsedSeconds / (60 * 60)) % 24;
      const days = Math.floor(elapsedSeconds / (60 * 60 * 24));

      let elapse_time = "";
      if (minutes > 0 || hours > 0 || days > 0) {
        const formattedHours = hours.toString().padStart(2, "0");
        const formattedMinutes = minutes.toString().padStart(2, "0");
        const formattedSeconds = seconds.toString().padStart(2, "0");

        if (days > 0) {
          let days_word = this.$t("days");
          this.elapse = `${days} ${days_word}, ${formattedHours}:${formattedMinutes}:${formattedSeconds}`;
          let DaystoHours = days * 24;
          elapse_time = `${DaystoHours}:${formattedMinutes}:${formattedSeconds}`;
        } else if (hours > 0) {
          this.elapse = `${formattedHours}:${formattedMinutes}:${formattedSeconds}`;
          elapse_time = this.elapse;
        } else {
          this.elapse = `${formattedHours}:${formattedMinutes}:${formattedSeconds}`;
          elapse_time = this.elapse;
        }
      } else {
        this.elapse = "";
        elapse_time = "";
      }

      //this.$emit("update:result", this.elapse);
      this.$emit("update:result", elapse_time);
      //console.log(`${days} days, ${hours} hours, ${minutes} minutes, ${seconds} seconds elapsed since ${givenDateStr}`);
    },
  },
};
</script>
