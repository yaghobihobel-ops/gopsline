<template>
  <q-header
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
  >
    <q-toolbar>
      <q-btn
        @click="$router.back()"
        flat
        round
        dense
        icon="las la-angle-left"
        :color="$q.dark.mode ? 'white' : 'dark'"
      />
      <q-toolbar-title class="text-weight-bold">{{
        $t("Request Break")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page class="q-pa-md">
    <h6 class="text-weight-bold no-margin font16">
      {{ $t("Break duration") }}
    </h6>
    <p class="text-weight-light q-ma-none">
      {{ $t("Select your duration for break") }}
    </p>
    <q-space class="q-pa-sm"></q-space>
    <q-form @submit="onSubmit">
      <q-select
        v-model="duration"
        :options="Activity.break_duration"
        :label="$t('Select duration')"
        behavior="dialog"
        input-debounce="700"
        outlined
        color="grey-5"
        lazy-rules
        :rules="[myRule]"
        map-options
        emit-value
      />

      <q-footer
        class="q-pa-md"
        :class="{
          'bg-mydark ': $q.dark.mode,
          'bg-white ': !$q.dark.mode,
        }"
      >
        <q-btn
          type="submit"
          color="primary"
          text-color="white"
          :label="$t('Submit')"
          unelevated
          class="full-width"
          size="lg"
          no-caps
          :loading="loading"
        />
      </q-footer>
    </q-form>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useActivityStore } from "stores/ActivityStore";
import { useScheduleStore } from "stores/ScheduleStore";

export default {
  name: "RequestBreak",
  data() {
    return {
      loading: false,
      duration: "",
      schedule_uuid: "",
    };
  },
  created() {
    this.schedule_uuid = this.$route.query.schedule_uuid;
  },
  setup() {
    const Activity = useActivityStore();
    const Schedule = useScheduleStore();
    return { Activity, Schedule };
  },
  methods: {
    myRule(val) {
      if (APIinterface.empty(val)) {
        return "Duration is required";
      }
    },
    onSubmit() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "requestBreak",
        "schedule_uuid=" + this.schedule_uuid + "&duration=" + this.duration
      )
        .then((data) => {
          this.Schedule.gettShift();
          APIinterface.notify(
            this.$q.dark.mode ? "grey600" : "light-green",
            data.msg,
            "check_circle",
            this.$q
          );
          this.$router.replace("/home");
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
