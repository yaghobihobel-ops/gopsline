<template>
  <q-tabs
    v-model="calendar"
    align="justify"
    dense
    narrow-indicator
    indicator-color="transparent"
    class="modified-qtabs"
  >
    <q-tab
      v-for="items in range"
      :key="items"
      :name="items.day"
      no-caps
      @click="setCalendar(items.date)"
    >
      <div
        class="text-dark q-pa-sm radius8 fit"
        :class="{
          'bg-primary text-white': items.day == calendar,
          'bg-grey-1': items.day != calendar,
        }"
      >
        <div class="font12 text-weight-medium">{{ items.abb }}</div>
        <div class="text-weight-medium font15">{{ items.day }}</div>
      </div>
    </q-tab>
  </q-tabs>
</template>

<script>
import { DateTime } from "luxon";
import { date } from "quasar";

export default {
  name: "CalendarWeekly",
  data() {
    return {
      calendar: undefined,
      range: [],
    };
  },
  created() {
    this.calendar = DateTime.now().toFormat("dd");
    this.generateCalendar();
  },
  methods: {
    generateCalendar() {
      console.debug("generateCalendar");
      let rangeDate = [];
      let startDate = DateTime.now().minus({ days: 5 });
      for (let i = 0; i < 6; i++) {
        let dateraw = startDate.plus({ days: i });
        rangeDate.push({
          day: dateraw.toFormat("dd"),
          abb: dateraw.toFormat("ccc"),
          date: dateraw.toJSON().slice(0, 10).replace(/-/g, "-"),
        });
      }
      this.range = rangeDate;
    },
    setCalendar(data) {
      this.$emit("afterSelectdate", data);
    },
  },
};
</script>
