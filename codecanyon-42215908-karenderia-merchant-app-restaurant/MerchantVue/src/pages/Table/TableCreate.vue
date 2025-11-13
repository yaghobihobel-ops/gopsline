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
          {{ $t("Update Table") }}
        </template>
        <template v-else>
          {{ $t("Add Table") }}
        </template>
      </q-toolbar-title>

      <template v-if="AccessStore.hasAccess('booking.tables_delete')">
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
        <q-input
          v-model="table_name"
          :label="$t('Table Name')"
          stack-label
          outlined
          color="grey-5"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />

        <q-select
          v-model="room_id"
          :options="DataStore.table_room_list"
          :label="$t('Room')"
          stack-label
          behavior="dialog"
          outlined
          color="grey-5"
          :rules="[(val) => val || this.$t('This field is required')]"
          emit-value
          map-options
        />

        <q-input
          v-model="min_covers"
          type="number"
          :label="$t('Min Covers')"
          stack-label
          outlined
          color="grey-5"
          :rules="[(val) => val > 0 || this.$t('This field is required')]"
        />

        <q-input
          v-model="max_covers"
          type="number"
          :label="$t('Max Covers')"
          stack-label
          outlined
          color="grey-5"
          :rules="[(val) => val > 0 || this.$t('This field is required')]"
        />

        <q-toggle v-model="available" val="1" :label="$t('Available')" />

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
  name: "TableCreate",
  setup() {
    const DataStore = useDataStore();
    const AccessStore = useAccessStore();
    return { DataStore, AccessStore };
  },
  data() {
    return {
      id: "",
      loading: false,
      table_name: "",
      room_id: "",
      min_covers: 0,
      max_covers: 0,
      available: true,
      status: "publish",
      data: [],
    };
  },
  mounted() {
    this.id = this.$route.query.id;
    if (!APIinterface.empty(this.id)) {
      this.getRoom();
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
      APIinterface.fetchDataByTokenPost("deleteTable", "id=" + this.id)
        .then((response) => {
          this.$router.replace({
            path: "/table/tables",
          });
        })
        .catch((error) => {})
        .then((data) => {
          this.$q.loading.hide();
        });
    },
    formSubmit() {
      let params = {
        id: this.id,
        table_name: this.table_name,
        room_id: this.room_id,
        min_covers: this.min_covers,
        max_covers: this.max_covers,
        available: this.available,
        status: this.status,
      };
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        !APIinterface.empty(this.id) ? "UpdateTable" : "CreateTable",
        params
      )
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
          this.$router.replace({
            path: "/table/tables",
          });
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    getRoom() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getTable", "id=" + this.id)
        .then((data) => {
          this.table_name = data.details.table_name;
          this.room_id = parseInt(data.details.room_id);
          this.min_covers = data.details.min_covers;
          this.max_covers = data.details.max_covers;
          this.available = data.details.available == 1 ? true : false;

          this.data = data.details;
        })
        .catch((error) => {
          //APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
