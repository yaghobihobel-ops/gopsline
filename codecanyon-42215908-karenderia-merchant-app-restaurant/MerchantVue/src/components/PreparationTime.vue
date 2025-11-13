<template>
  <q-dialog v-model="modal" persistent position="bottom">
    <q-card class="rounded-borders-top">
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <q-toolbar-title
          class="text-weight-bold text-subtitle2"
          :class="{
            'text-white': $q.dark.mode,
            'text-dark': !$q.dark.mode,
          }"
          style="text-overflow: initial"
        >
          {{ $t("Preparation Estimate") }}
        </q-toolbar-title>
        <q-space></q-space>
        <q-btn
          @click="modal = !true"
          color="white"
          square
          unelevated
          text-color="grey"
          icon="las la-times"
          dense
          no-caps
          size="sm"
          class="border-grey radius8"
        />
      </q-toolbar>
      <div
        class="q-pl-md q-pr-md q-pb-sm flex flex-center"
        style="min-height: calc(20vh)"
      >
        <div class="flex items-center q-gutter-x-md">
          <div>
            <q-btn
              outline
              round
              color="grey"
              icon="eva-minus-outline"
              @click="lessTimes"
              size="sm"
            />
          </div>
          <div class="text-h4">
            {{ estimate_data.hour }}:{{ estimate_data.minute }}
          </div>
          <div>
            <q-btn
              outline
              round
              color="grey"
              icon="eva-plus-outline"
              @click="addTimes"
              size="sm"
            />
          </div>
        </div>
      </div>
      <q-card-actions class="q-pl-md q-pr-md">
        <q-btn
          no-caps
          class="radius10 fit"
          color="primary"
          unelevated
          size="lg"
          @click="updatePreparationtime"
          :loading="loading"
        >
          <div class="text-weight-bold text-subtitle2">
            {{ $t("Update Time") }}
          </div>
        </q-btn>
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "PreparationTime",
  props: ["data", "order_uuid", "payload"],
  data() {
    return {
      modal: false,
      estimate: null,
      estimate_data: null,
      loading: false,
    };
  },
  watch: {
    data(newval, oldval) {
      this.estimate = newval;
    },
    estimate(newval, oldval) {
      this.convertMinutesToReadableTime(newval);
    },
  },
  methods: {
    addTimes() {
      this.estimate = parseInt(this.estimate) + 1;
    },
    lessTimes() {
      this.estimate = parseInt(this.estimate) - 1;
    },
    convertMinutesToReadableTime(totalMinutes = 0) {
      const hours = Math.floor(totalMinutes / 60);
      const minutes = totalMinutes % 60;
      this.estimate_data = {
        hour: hours,
        minute: minutes,
      };
    },
    updatePreparationtime() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "updatePreparationtime",
        "order_uuid=" +
          this.order_uuid +
          "&estimate=" +
          this.estimate +
          "&payload=" +
          this.payload
      )
        .then((data) => {
          APIinterface.notify(
            this.$q.dark.mode ? "grey600" : "light-green",
            data.msg,
            "check_circle",
            this.$q
          );
          this.modal = false;
          this.$emit("afterUpdatetime", data);
        })
        .catch((error) => {})
        .then((data) => {
          this.loading = false;
        });
    },
    //
  },
};
</script>
