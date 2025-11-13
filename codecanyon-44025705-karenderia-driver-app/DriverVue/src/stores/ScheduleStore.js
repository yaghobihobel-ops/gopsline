import { defineStore } from "pinia";
import APIinterface from "src/api/APIinterface";
import config from "src/api/config";
import { DateTime, Settings } from "luxon";

export const useScheduleStore = defineStore("schedule", {
  state: () => ({
    loading: false,
    date_now: "",
    data: [],
    vehicle_data: [],
    vehicle_maker: [],
    vehicle_type: [],
    vehicle_documents: [],
    timer: undefined,
    time_interval: 60000,
    $q: undefined,
    data_break: [],
    timer_break: undefined,
    break_status: "",
    can_request_break: false,
  }),

  getters: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
    hasBreak() {
      if (Object.keys(this.data_break).length > 0) {
        return true;
      }
      return false;
    },
    isWorking() {
      let $found = false;
      if (Object.keys(this.data).length > 0) {
        Object.entries(this.data).forEach(([key, items]) => {
          if (items.shift_time_started != null) {
            $found = true;
          }
        });
      }
      return $found == true ? $found : false;
    },
  },

  actions: {
    clearData() {
      this.data = [];
      this.vehicle_data = [];
      this.vehicle_maker = [];
      this.vehicle_type = [];
      this.vehicle_documents = [];
    },
    gettShift() {
      let dateNow = APIinterface.getDateNow();
      this.loading = true;
      APIinterface.getShift({
        date: dateNow,
      })
        .then((data) => {
          this.date_now = data.details.date_now;
          this.data = data.details.data.list;
          this.data_break = data.details.data_break;
          this.can_request_break = data.details.can_request_break;
          this.vehicle_data = data.details.vehicle_data;
          this.vehicle_maker = data.details.vehicle_maker;
          this.vehicle_type = data.details.vehicle_type;
          this.vehicle_documents = data.details.vehicle_documents;
          this.runRemainingTime();
          this.startTimer();

          if (Object.keys(this.data_break).length > 0) {
            this.runRemainingBreak();
            this.startTimerBreak();
          }
        })
        .catch((error) => {
          this.data = [];
          this.vehicle_data = [];
          this.vehicle_maker = [];
          this.vehicle_type = [];
          this.vehicle_documents = [];
          this.data_break = [];
        })
        .then((data) => {
          this.loading = false;
        });
    },
    runRemainingTime() {
      if (Object.keys(this.data).length > 0) {
        Object.entries(this.data).forEach(([key, items]) => {
          this.getTimeRemaining(items);
          //this.getRemainingShift(items);
        });
      }
    },
    startTimer() {
      this.stopTimer();
      this.timer = setInterval(() => {
        this.runRemainingTime();
      }, this.time_interval);
    },
    stopTimer() {
      clearInterval(this.timer);
    },
    startTimerBreak() {
      this.stopTimerBreak();
      this.timer_break = setInterval(() => {
        this.runRemainingBreak();
      }, this.time_interval);
    },
    stopTimerBreak() {
      clearInterval(this.timer_break);
    },
    hadData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
    refreshShift(done) {
      let dateNow = APIinterface.getDateNow();
      APIinterface.getShift({
        date: dateNow,
      })
        .then((data) => {
          this.date_now = data.details.date_now;
          this.data = data.details.data.list;
          this.data_break = data.details.data_break;
          this.can_request_break = data.details.can_request_break;
          this.vehicle_data = data.details.vehicle_data;
          this.vehicle_maker = data.details.vehicle_maker;
          this.vehicle_type = data.details.vehicle_type;
          this.vehicle_documents = data.details.vehicle_documents;
          this.runRemainingTime();
          this.startTimer();

          if (Object.keys(this.data_break).length > 0) {
            this.runRemainingBreak();
            this.startTimerBreak();
          }
        })
        .catch((error) => {
          this.data = [];
          this.vehicle_data = [];
          this.vehicle_maker = [];
          this.vehicle_type = [];
          this.vehicle_documents = [];
        })
        .then((data) => {
          done();
        });
    },
    getTimeRemaining(items) {
      let Datenow = APIinterface.getDateTimeNow();
      //console.log("==> runRemainingTime");
      // console.log(Datenow);
      // console.log(items.shift_start);

      // START SHIFT
      let end = DateTime.fromISO(items.shift_start);
      let start = DateTime.fromISO(Datenow);
      const diff = end.diff(start, ["hours", "minutes"]);
      const timereps = diff.toObject();
      //console.log(timereps);

      let end2 = DateTime.fromISO(items.shift_end);
      let start2 = DateTime.fromISO(Datenow);
      const diff2 = end2.diff(start2, ["hours", "minutes"]);
      const timereps2 = diff2.toObject();
      //console.log(timereps2);

      let starting_in = "";
      items.shift_status = "";

      if (
        timereps.hours <= 0 &&
        timereps.minutes <= -1 &&
        items.shift_time_started == null &&
        items.shift_time_ended == null
      ) {
        //console.log("late already => " + items.shift_time_started);
        items.shift_status = "late";
        items.starting_in = "";

        if (timereps2.hours <= -1) {
          items.shift_status = "shift_ended";
        }
      } else {
        //console.log("not late");
        if (
          timereps.hours <= 0 &&
          timereps.minutes <= 30 &&
          APIinterface.empty(items.shift_time_started)
        ) {
          items.shift_status = "ready";
          if (timereps.hours <= 1) {
            starting_in = timereps.hours > 0 ? timereps.hours + " hour " : "";
            starting_in +=
              timereps.minutes > 0 ? parseInt(timereps.minutes) + " mins" : "";

            items.starting_in = starting_in;
          }
        } else if (
          timereps2.hours <= 0 &&
          timereps2.minutes <= 0 &&
          !APIinterface.empty(items.shift_time_started)
        ) {
          items.shift_status = "ended";
        } else if (!APIinterface.empty(items.shift_time_started)) {
          items.shift_status = "started";
        } else {
          if (timereps.hours > 1) {
            starting_in = timereps.hours > 0 ? timereps.hours + " hour " : "";
            starting_in +=
              timereps.minutes > 0 ? parseInt(timereps.minutes) + " mins" : "";

            items.starting_in = starting_in;
          }
        }
      }

      if (items.shift_status == "late") {
        APIinterface.notify(
          "red-5",
          "Reminder: You are already late in your shift",
          "error_outline",
          this.$q
        );
      }

      //console.log("==> runRemainingTime");
    },
    runRemainingBreak() {
      //console.log("==> runRemainingBreak");
      let Datenow = APIinterface.getDateTimeNow();
      //console.log(this.data_break.break_until);
      let end = DateTime.fromISO(this.data_break.break_until);
      let start = DateTime.fromISO(Datenow);
      const diff = end.diff(start, ["hours", "minutes"]);
      const timereps = diff.toObject();
      //console.log(timereps);
      if (timereps.hours <= 0 && timereps.minutes <= 0) {
        //console.log("break ended");
        this.break_status = "break_ended";
        APIinterface.notify(
          "red-5",
          "Reminder: Your break is already ended",
          "error_outline",
          this.$q
        );
      } else {
        //console.log("break on going");
        this.break_status = "break_ongoing";
      }
      //console.log("==> end runRemainingBreak");
    },
    //
  },
});
