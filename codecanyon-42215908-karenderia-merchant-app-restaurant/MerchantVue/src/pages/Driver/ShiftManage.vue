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
      <q-toolbar-title class="text-weight-bold">
        <template v-if="isEdit">
          {{ $t("Update Shift") }}
        </template>
        <template v-else>
          {{ $t("Add Shift") }}
        </template>
      </q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
    class="q-pa-md"
  >
    <template v-if="loading">
      <q-inner-loading :showing="true" color="primary" size="md" />
    </template>
    <q-form v-else @submit="formSubmit">
      <q-select
        v-model="zone_id"
        :label="$t('Zone')"
        :options="DriverStore.getScheduleAttributes.zone_list"
        stack-label
        behavior="dialog"
        outlined
        color="grey-5"
        emit-value
        map-options
        :rules="[
          (val) => (val && val > 0) || this.$t('This field is required'),
        ]"
      />

      <div class="row q-gutter-x-sm">
        <q-input
          v-model="date_shift"
          mask="date"
          :rules="['date']"
          stack-label
          outlined
          color="grey-5"
          :label="$t('Date start')"
          class="col"
        >
          <template v-slot:append>
            <q-icon name="event" class="cursor-pointer">
              <q-popup-proxy
                cover
                transition-show="scale"
                transition-hide="scale"
              >
                <q-date v-model="date_shift" color="blue">
                  <div class="row items-center justify-end">
                    <q-btn
                      v-close-popup
                      :label="$t('Close')"
                      color="dark"
                      flat
                      no-caps
                    />
                  </div>
                </q-date>
              </q-popup-proxy>
            </q-icon>
          </template>
        </q-input>
        <q-select
          v-model="time_start"
          :label="$t('Time start')"
          :options="DriverStore.getScheduleAttributes.time_range"
          stack-label
          behavior="dialog"
          outlined
          color="grey-5"
          emit-value
          map-options
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
          class="col"
        />
      </div>

      <div class="row q-gutter-x-sm">
        <q-input
          v-model="date_shift_end"
          mask="date"
          :rules="['date']"
          stack-label
          outlined
          color="grey-5"
          :label="$t('Date end')"
          class="col"
        >
          <template v-slot:append>
            <q-icon name="event" class="cursor-pointer">
              <q-popup-proxy
                cover
                transition-show="scale"
                transition-hide="scale"
              >
                <q-date v-model="date_shift_end" color="blue">
                  <div class="row items-center justify-end">
                    <q-btn
                      v-close-popup
                      :label="$t('Close')"
                      color="dark"
                      flat
                      no-caps
                    />
                  </div>
                </q-date>
              </q-popup-proxy>
            </q-icon>
          </template>
        </q-input>
        <q-select
          v-model="time_end"
          :label="$t('Time start')"
          :options="DriverStore.getScheduleAttributes.time_range"
          stack-label
          behavior="dialog"
          outlined
          color="grey-5"
          emit-value
          map-options
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
          class="col"
        />
      </div>

      <q-input
        v-model="max_allow_slot"
        :label="$t('Max allow slot')"
        type="number"
        stack-label
        outlined
        color="grey-5"
        :hint="
          $t(
            'Number of driver that can take this shift. default value is 0 for unlimited'
          )
        "
      />

      <q-space class="q-pa-md"></q-space>
      <q-select
        v-model="status"
        :options="DataStore.customer_status"
        :label="$t('Status')"
        stack-label
        behavior="dialog"
        outlined
        color="grey-5"
        emit-value
        map-options
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      />

      <q-footer>
        <q-btn
          type="submit"
          color="primary"
          text-color="white"
          :label="$t('Save')"
          unelevated
          class="full-width radius8"
          size="lg"
          no-caps
          :disable="CheckData"
        />
      </q-footer>
    </q-form>
  </q-page>
</template>

<script>
import { useDriverStore } from "stores/DriverStore";
import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";

export default {
  name: "ShiftManage",
  components: {},
  data() {
    return {
      id: "",
      data: [],
      loading: false,
      zone_id: "",
      date_shift: "",
      time_start: "",
      date_shift_end: "",
      time_end: "",
      max_allow_slot: 0,
      status: "active",
    };
  },
  setup(props) {
    const DriverStore = useDriverStore();
    const DataStore = useDataStore();
    return { DriverStore, DataStore };
  },
  created() {
    this.DriverStore.ScheduleAttributes("employee");
  },
  mounted() {
    this.id = this.$route.query.id;
    if (!APIinterface.empty(this.id)) {
      this.getData();
    }
  },
  computed: {
    isEdit() {
      if (!APIinterface.empty(this.id)) {
        return true;
      }
      return false;
    },
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
    CheckData() {
      if (!APIinterface.empty(this.id)) {
        if (Object.keys(this.data).length <= 0) {
          return true;
        }
      }
      return false;
    },
  },
  methods: {
    getData() {
      this.loading = true;

      APIinterface.fetchDataByTokenPost("getShiftSchedule", "id=" + this.id)
        .then((data) => {
          this.data = data.details;
          this.zone_id = data.details.zone_id;
          this.date_shift = data.details.date_shift;
          this.date_shift_end = data.details.date_shift_end;

          this.time_start = data.details.time_start;
          this.time_end = data.details.time_end;
          this.max_allow_slot = data.details.max_allow_slot;
          this.status = data.details.status;
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    formSubmit() {
      let params = {
        id: this.id,
        zone_id: this.zone_id,
        date_shift: this.date_shift,
        time_start: this.time_start,
        date_shift_end: this.date_shift_end,
        time_end: this.time_end,
        max_allow_slot: this.max_allow_slot,
        status: this.status,
      };
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        !APIinterface.empty(this.id)
          ? "UpdateShiftSchedule"
          : "AddShiftSchedule",
        params
      )
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
          this.$router.replace({
            path: "/delivery-management/shifts",
          });
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    //
  },
};
</script>
