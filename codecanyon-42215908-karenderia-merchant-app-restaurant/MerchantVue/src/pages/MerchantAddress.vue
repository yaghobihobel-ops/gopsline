<template>
  <q-pull-to-refresh @refresh="refresh">
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
          $t("Address")
        }}</q-toolbar-title>
      </q-toolbar>
      <q-separator></q-separator>
    </q-header>
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
    >
      <template v-if="loading">
        <q-inner-loading
          :showing="true"
          color="primary"
          size="md"
          label-class="dark"
          class="transparent"
        />
      </template>
      <q-form v-else @submit="onSubmit">
        <div class="q-pa-md q-gutter-md">
          <q-input
            outlined
            v-model="address"
            :label="$t('Address')"
            stack-label
            color="grey-5"
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <div class="row items-center field-no-bottom">
            <q-input
              outlined
              v-model="latitude"
              :label="$t('Latitude')"
              stack-label
              color="grey-5"
              lazy-rules
              :rules="[
                (val) =>
                  (val && val.length > 0) || this.$t('This field is required'),
              ]"
              class="col q-mr-sm"
            />
            <q-input
              outlined
              v-model="lontitude"
              :label="$t('Lontitude')"
              stack-label
              color="grey-5"
              lazy-rules
              :rules="[
                (val) =>
                  (val && val.length > 0) || this.$t('This field is required'),
              ]"
              class="col"
            />
          </div>

          <p class="font11 text-grey q-mb-none">
            {{ $t("Get your address geolocation via service like") }}
            https://www.maps.ie/coordinates.html{{ $t("or") }}
            https://www.latlong.net/,
            {{
              $t(
                "entering invalid coordinates will make your store not available for ordering"
              )
            }}
          </p>
          <q-btn
            flat
            color="blue"
            no-caps
            size="sm"
            class="q-pa-none q-mt-none"
            href="https://www.maps.ie/coordinates.html"
            target="_blank"
            >{{ $t("Click here") }}</q-btn
          >

          <div class="text-weight-bold">
            {{ $t("Radius distance covered") }}
          </div>

          <!-- <div class="row items-center"> -->
          <q-input
            outlined
            v-model="delivery_distance_covered"
            :label="$t('Delivery Distance Covered')"
            stack-label
            color="grey-5"
            lazy-rules
            autogrow
          />

          <q-select
            outlined
            v-model="distance_unit"
            :options="DataStore.unit"
            :label="$t('Distance Unit')"
            color="grey-5"
            stack-label
            map-options
            emit-value
          />
          <!-- </div> -->
        </div>

        <q-footer
          class="q-pl-md q-pr-md q-pb-xs"
          :class="{
            'bg-mydark ': $q.dark.mode,
            'bg-white ': !$q.dark.mode,
          }"
        >
          <q-btn
            type="submit"
            color="primary"
            text-color="white"
            :label="$t('Save')"
            unelevated
            class="full-width radius8"
            size="lg"
            no-caps
            :loading="loading2"
          />
        </q-footer>
      </q-form>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";

export default {
  name: "MerchantAddress",
  data() {
    return {
      loading: false,
      loading2: false,
      address: "",
      latitude: "",
      lontitude: "",
      delivery_distance_covered: "",
      distance_unit: "",
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    return { DataStore };
  },
  created() {
    this.getInformation();
  },
  methods: {
    refresh(done) {
      this.getInformation(done);
    },
    getInformation(done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getInformation")
        .then((data) => {
          this.address = data.details.address;
          this.latitude = data.details.latitude;
          this.lontitude = data.details.lontitude;
          this.delivery_distance_covered =
            data.details.delivery_distance_covered;
          this.distance_unit = data.details.distance_unit;
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    onSubmit() {
      this.loading2 = true;
      APIinterface.fetchDataByToken("saveAddress", {
        address: this.address,
        latitude: this.latitude,
        lontitude: this.lontitude,
        delivery_distance_covered: this.delivery_distance_covered,
        distance_unit: this.distance_unit,
      })
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading2 = false;
        });
    },
  },
};
</script>
