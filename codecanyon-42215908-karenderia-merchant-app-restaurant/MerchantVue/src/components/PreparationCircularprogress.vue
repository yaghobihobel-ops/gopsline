<template>
  <template v-if="order_accepted_at">
    <template v-if="hasTimeRemaining || preparation_starts">
      <template v-if="display == 'text'">
        <template v-if="hasTimeRemaining">
          {{ $t("Remaining") }} {{ formattedTime }}
        </template>
        <template v-else-if="preparation_starts">
          {{ $t("Preparation Estimate") }} {{ preparation_starts }}
        </template>
      </template>
      <template v-else>
        <q-circular-progress
          show-value
          class="text-light-blue"
          :value="progressPercentage2"
          size="40px"
          color="light-blue"
          track-color="grey-3"
        >
          <template v-if="hasTimeRemaining">
            {{ formattedTime }}
          </template>
          <template v-else-if="preparation_starts">
            {{ preparation_starts }}
          </template>
        </q-circular-progress>
      </template>
    </template>
    <template v-else>
      <div class="text-red text-weight-medium text-subtitle2">
        {{ label.order_overdue }} {{ runtimeFormatted }}
      </div>
    </template>
  </template>
</template>

<script>
import { DateTime } from "luxon";
import APIinterface from "src/api/APIinterface";

export default {
  name: "PreparationCircularprogress",
  props: [
    "display",
    "order_accepted_at",
    "preparation_starts",
    "timezone",
    "label",
    "total_time",
  ],
  data() {
    return {
      readyTime: null,
      timeRemaining: 0,
      intervalId: null,
      totalTime: 0,
      runtime: 0,
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
      if (isNaN(this.timeRemaining)) {
        return false;
      }
      return this.timeRemaining <= 0 ? false : true;
    },
    progressPercentage() {
      if (this.totalTime === 0) return 0;
      const elapsed = this.totalTime - this.timeRemaining;
      return Math.min(Math.max((elapsed / this.totalTime) * 100, 0), 100);
    },
    progressPercentage2() {
      if (this.totalTime === 0) return 0;
      const totalTimeInSeconds = this.total_time * 60;
      const elapsed = totalTimeInSeconds - this.timeRemaining;
      const percentage = (elapsed / totalTimeInSeconds) * 100;
      return Math.min(Math.max(percentage, 0), 100);
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
        result += `${hours}:${minutes}:${seconds} `;
      }
      result += `${minutes}:${seconds}`;
      return result.trim();
    },
    runtimeFormatted() {
      return this.formatSeconds(this.runtime);
    },
  },
  methods: {
    init() {
      if (this.intervalId) {
        clearInterval(this.intervalId);
      }

      this.readyTime = DateTime.fromSQL(this.order_accepted_at, {
        zone: this.timezone,
      });

      const nowInTimezone = DateTime.now().setZone(this.timezone);
      this.totalTime = Math.floor(
        (this.readyTime.toMillis() - nowInTimezone.toMillis()) / 1000
      );

      this.totalTime = Math.max(this.totalTime, 0);

      // runtime (elapsed seconds since order accepted)
      this.runtime = Math.floor(
        (nowInTimezone.toMillis() - this.readyTime.toMillis()) / 1000
      );

      if (APIinterface.empty(this.preparation_starts)) {
        this.startCountdown();
      }
    },
    startCountdown() {
      const nowInTimezone = DateTime.now().setZone(this.timezone);
      this.timeRemaining = Math.floor(
        (this.readyTime.toMillis() - nowInTimezone.toMillis()) / 1000
      );

      this.intervalId = setInterval(() => {
        if (this.timeRemaining > 0) {
          this.timeRemaining--;
        } else {
          //clearInterval(this.intervalId);
        }
        this.runtime++;
      }, 1000);
    },
    formatSeconds(seconds) {
      const totalMinutes = Math.floor(seconds / 60);
      const hours = Math.floor(totalMinutes / 60);
      const minutes = totalMinutes % 60;
      const secs = seconds % 60;

      let result = "";
      if (hours > 0) {
        result += `${hours.toString().padStart(2, "0")}:`;
      }
      result += `${minutes.toString().padStart(2, "0")}:${secs
        .toString()
        .padStart(2, "0")}`;
      return result;
    },
    //
  },
};
</script>
