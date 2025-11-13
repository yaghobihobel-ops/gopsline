<template>
  <q-page>
    <q-space class="q-pa-md"></q-space>

    <template v-if="loading1">
      <div
        class="row q-gutter-x-sm justify-center absolute-center text-center full-width"
      >
        <q-circular-progress indeterminate rounded size="sm" color="primary" />
        <div class="text-subtitle1 text-grey">{{ $t("Loading") }}...</div>
      </div>
    </template>
    <template v-else>
      <q-item tag="label">
        <q-item-section avatar>
          <q-toggle color="primary" v-model="loyalty_points" val="1" />
        </q-item-section>
        <q-item-section>
          <q-item-label>
            {{ $t("Activate Loyalty Points System") }}
          </q-item-label>
        </q-item-section>
      </q-item>
      <q-card-actions class="q-pa-md">
        <q-btn
          type="submit"
          color="amber-6"
          text-color="disabled"
          unelevated
          class="full-width radius10"
          size="lg"
          no-caps
          :loading="loading"
          @click="onSubmit"
        >
          <div class="text-weight-bold text-subtitle2">{{ $t("Save") }}</div>
        </q-btn></q-card-actions
      >
    </template>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "src/stores/DataStore";

export default {
  name: "PointSettings",
  data() {
    return {
      loyalty_points: false,
      loading: false,
      loading1: false,
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    return {
      DataStore,
    };
  },
  mounted() {
    this.DataStore.page_title = this.$t("Loyalty Points");
    this.fetchCampaightPoints();
  },
  methods: {
    async fetchCampaightPoints() {
      try {
        this.loading1 = true;
        const response = await APIinterface.fetchGet("fetchCampaightPoints");
        this.loyalty_points = response.details.enabled;
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        this.loading1 = false;
      }
    },
    async onSubmit() {
      try {
        this.loading = true;
        const params = new URLSearchParams({
          loyalty_points: this.loyalty_points ? 1 : 0,
        }).toString();
        const response = await APIinterface.fetchDataByTokenPost(
          "CampaightPoints",
          params
        );
        APIinterface.ShowSuccessful(response.msg, this.$q);
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>
