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
          {{ $t("Update Schedule") }}
        </template>
        <template v-else>
          {{ $t("Add Schedule") }}
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

      <q-input
        v-model="date_start"
        mask="date"
        :label="$t('Date start')"
        :rules="['date']"
        stack-label
        outlined
        color="grey-5"
      >
        <template v-slot:append>
          <q-icon name="event" class="cursor-pointer">
            <q-popup-proxy
              cover
              transition-show="scale"
              transition-hide="scale"
            >
              <q-date v-model="date_start" color="blue">
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

      <div class="row q-gutter-x-sm">
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
        <q-select
          v-model="time_end"
          :label="$t('Time end')"
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
        <q-select
          v-model="driver_id"
          :label="$t('Select Driver')"
          :options="DriverStore.getScheduleAttributes.driver_list"
          stack-label
          behavior="dialog"
          outlined
          color="grey-5"
          emit-value
          map-options
          :rules="[
            (val) => (val && val > 0) || this.$t('This field is required'),
          ]"
          class="col"
        />
        <q-select
          v-model="vehicle_id"
          :label="$t('Select Car')"
          :options="DriverStore.getScheduleAttributes.vehicle_list"
          stack-label
          behavior="dialog"
          outlined
          color="grey-5"
          emit-value
          map-options
          :rules="[
            (val) => (val && val > 0) || this.$t('This field is required'),
          ]"
          class="col"
        />
      </div>

      <q-input
        v-model="instructions"
        :label="$t('Instructions')"
        stack-label
        outlined
        color="grey-5"
        :hint="$t('Add instructions to driver')"
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
import APIinterface from "src/api/APIinterface";

export default {
  name: "ScheduleManage",
  components: {},
  data() {
    return {
      id: "",
      data: [],
      loading: false,
      zone_id: "",
      driver_id: "",
      vehicle_id: "",
      date_start: "",
      time_start: "",
      time_end: "",
      instructions: "",
    };
  },
  setup(props) {
    const DriverStore = useDriverStore();
    return { DriverStore };
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

      APIinterface.fetchDataByTokenPost("getSchedule", "id=" + this.id)
        .then((data) => {
          this.data = data.details;
          this.zone_id = data.details.zone_id;
          this.driver_id = data.details.driver_id;
          this.vehicle_id = data.details.vehicle_id;
          this.date_start = data.details.date_start;
          this.time_start = data.details.time_start;
          this.time_end = data.details.time_end;
          this.instructions = data.details.instructions;
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
        driver_id: this.driver_id,
        vehicle_id: this.vehicle_id,
        date_start: this.date_start,
        time_start: this.time_start,
        time_end: this.time_end,
        instructions: this.instructions,
      };
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        !APIinterface.empty(this.id) ? "UpdateSchedule" : "AddSchedule",
        params
      )
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
          this.$router.replace({
            path: "/delivery-management/schedule",
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
