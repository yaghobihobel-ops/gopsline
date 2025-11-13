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
        {{ $t("Collect Cash") }}
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
        v-model="driver_id"
        :label="$t('Select Driver')"
        :options="DriverStore.getDriverList"
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
        v-model="amount_collected"
        type="number"
        step="any"
        :label="$t('Amount')"
        stack-label
        outlined
        color="grey-5"
        :rules="[
          (val) => (val && val > 0) || this.$t('This field is required'),
        ]"
      />

      <q-input
        v-model="reference_id"
        :label="$t('Reference')"
        stack-label
        outlined
        autogrow
        color="grey-5"
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
    </q-form>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDriverStore } from "stores/DriverStore";

export default {
  name: "CollectcashManage",
  components: {},
  data() {
    return {
      id: "",
      data: [],
      loading: false,
      driver_id: "",
      amount_collected: 0,
      reference_id: "",
    };
  },
  setup(props) {
    const DriverStore = useDriverStore();
    return { DriverStore };
  },
  mounted() {
    this.DriverStore.DriverList();
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
    formSubmit() {
      let params = {
        id: this.id,
        driver_id: this.driver_id,
        amount_collected: this.amount_collected,
        reference_id: this.reference_id,
      };
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        !APIinterface.empty(this.id) ? "UpdateCollectCash" : "AddCollectCash",
        params
      )
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
          this.$router.replace({
            path: "/delivery-management/collect-cash",
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
