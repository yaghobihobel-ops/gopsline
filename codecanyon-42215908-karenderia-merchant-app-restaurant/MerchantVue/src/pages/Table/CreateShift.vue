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
      <template v-if="AccessStore.hasAccess('booking.shift_delete')">
        <q-btn
          v-if="hasData"
          @click="confirmDelete"
          flat
          round
          dense
          icon="las la-trash-alt"
          :color="$q.dark.mode ? 'white' : 'dark'"
        />
      </template>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
      'flex flex-center': isEdit && !hasData,
    }"
    class="q-pa-md"
  >
    <template v-if="loading">
      <q-inner-loading :showing="true" color="primary" size="md" />
    </template>

    <q-form v-else @submit="formSubmit">
      <template v-if="isEdit && !hasData">
        <div class="text-center">
          <p class="q-ma-none text-grey">{{ $t("No data available") }}</p>
        </div>
      </template>

      <template v-else>
        <div class="text-weight-medium">{{ $t("Days of week") }}</div>
        <div class="row">
          <template v-for="items in DataStore.day_list" :key="items">
            <div class="flex flex-center">
              <div>
                <q-checkbox
                  v-model="days_of_week"
                  :val="items.value"
                  color="primary"
                />
              </div>
              <div class="text-capitalize">{{ items.label }}</div>
            </div>
          </template>
        </div>

        <q-input
          v-model="shift_name"
          :label="$t('Shift name')"
          stack-label
          outlined
          color="grey-5"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />

        <q-select
          v-model="first_seating"
          :options="DataStore.time_range"
          :label="$t('First seating')"
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
        />

        <q-select
          v-model="last_seating"
          :options="DataStore.time_range"
          :label="$t('Last seating')"
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
        />

        <q-select
          v-model="shift_interval"
          :options="DataStore.time_interval_list"
          :label="$t('Interval')"
          stack-label
          behavior="dialog"
          outlined
          color="grey-5"
          emit-value
          map-options
          :rules="[(val) => val || this.$t('This field is required')]"
        />

        <q-select
          v-model="status"
          :options="DataStore.status_list"
          :label="$t('Status')"
          stack-label
          behavior="dialog"
          outlined
          color="grey-5"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
          emit-value
          map-options
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
          />
        </q-footer>
      </template>
    </q-form>
  </q-page>
</template>

<script>
import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";
import { useAccessStore } from "stores/AccessStore";

export default {
  name: "CreateShift",
  setup(props) {
    const DataStore = useDataStore();
    const AccessStore = useAccessStore();
    return { DataStore, AccessStore };
  },
  data() {
    return {
      id: "",
      loading: false,
      days_of_week: [],
      shift_name: "",
      first_seating: "00:00",
      last_seating: "00:00",
      shift_interval: 900,
      status: "publish",
      time_interval: [],
      time_range: [],
      data: [],
    };
  },
  mounted() {
    this.id = this.$route.query.id;
    if (!APIinterface.empty(this.id)) {
      this.getShift();
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
  },
  methods: {
    getShift() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getShift", "id=" + this.id)
        .then((data) => {
          this.data = data.details;
          this.days_of_week = data.details.days_of_week;
          this.shift_name = data.details.shift_name;
          this.first_seating = data.details.first_seating;
          this.last_seating = data.details.last_seating;
          this.shift_interval = parseInt(data.details.shift_interval);
          this.status = data.details.status;
        })
        .catch((error) => {
          //APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    formSubmit() {
      let params = {
        id: this.id,
        days_of_week: this.days_of_week,
        shift_name: this.shift_name,
        first_seating: this.first_seating,
        last_seating: this.last_seating,
        shift_interval: this.shift_interval,
        status: this.status,
      };
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        !APIinterface.empty(this.id) ? "UpdateShift" : "CreateShift",
        params
      )
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
          this.$router.replace({
            path: "/table/shifts",
          });
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    confirmDelete() {
      APIinterface.dialog(
        this.$t("Delete Confirmation"),
        this.$t(
          "Are you sure you want to permanently delete the selected item?"
        ),
        this.$t("Okay"),
        this.$t("Cancel"),
        this.$q
      )
        .then((result) => {
          this.deleteRecords();
        })
        .catch((error) => {
          //
        });
    },
    deleteRecords() {
      console.log(this.id);
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });
      APIinterface.fetchDataByTokenPost("deleteShift", "id=" + this.id)
        .then((response) => {
          this.$router.replace({
            path: "/table/shifts",
          });
        })
        .catch((error) => {})
        .then((data) => {
          this.$q.loading.hide();
        });
    },
  },
};
</script>
