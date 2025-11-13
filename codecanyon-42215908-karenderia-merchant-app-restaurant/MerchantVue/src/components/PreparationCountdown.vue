<template>
  <template v-if="hasTimeRemaining">
    {{ formattedTime }}
  </template>
  <template v-else-if="preparation_starts">
    {{ preparation_starts }}
  </template>
  <template v-else>
    <span class="text-red">{{ label.order_overdue }}</span>
  </template>
</template>

<script>
import { DateTime } from "luxon";
import APIinterface from "src/api/APIinterface";

export default {
  name: "PreparationCountdown",
  props: ["order_accepted_at", "preparation_starts", "timezone", "label"],
  data() {
    return {
      readyTime: null,
      timeRemaining: 0,
      intervalId: null,
    };
  },
  watch: {
    order_accepted_at(newval, oldval) {
      this.init();
    },
  },
  mounted() {
    this.init();
  },
  unmounted() {
    if (this.intervalId) {
      clearInterval(this.intervalId);
    }
  },
  computed: {
    hasTimeRemaining() {
      return this.timeRemaining <= 0 ? false : true;
    },
    formattedTime() {
      if (this.timeRemaining <= 0) {
        return this.label.order_overdue;
      }
      const totalMinutes = Math.floor(this.timeRemaining / 60);
      const hours = Math.floor(totalMinutes / 60);
      const minutes = totalMinutes % 60;
      const seconds = this.timeRemaining % 60;

      let result = "";
      if (hours > 0) {
        let hour_label = minutes !== 1 ? this.label.hours : this.label.hour;
        result += `${hours} ${hour_label} `;
      }
      let min_label = minutes !== 1 ? this.label.mins : this.label.min;
      result += `${minutes} ${min_label}`;
      return result.trim();
    },
  },
  methods: {
    init() {
      this.readyTime = DateTime.fromSQL(this.order_accepted_at, {
        zone: this.timezone,
      });
      if (APIinterface.empty(this.preparation_starts)) {
        this.startCountdown();
      }
    },
    startCountdown() {
      console.log("startCountdown", this.order_accepted_at);
      const nowInTimezone = DateTime.now().setZone(this.timezone);
      this.timeRemaining = Math.floor(
        (this.readyTime.toMillis() - nowInTimezone.toMillis()) / 1000
      );
      this.intervalId = setInterval(() => {
        if (this.timeRemaining > 0) {
          this.timeRemaining--;
        } else {
          console.log("stop inteval");
          clearInterval(this.intervalId);
        }
      }, 1000);
    },
    //
  },
};
</script>
