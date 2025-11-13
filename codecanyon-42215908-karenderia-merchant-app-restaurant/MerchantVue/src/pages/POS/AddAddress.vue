<template>
  <q-header
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
    reveal
  >
    <q-toolbar>
      <!-- <q-btn
        @click="$router.back()"
        flat
        round
        dense
        icon="las la-angle-left"
        :color="$q.dark.mode ? 'white' : 'dark'"
      /> -->
      <q-toolbar-title class="text-weight-bold">
        {{ $t("Delivery address") }}
      </q-toolbar-title>
      <q-btn
        @click="$router.back()"
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
  </q-header>
  <q-page
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
    class="q-pl-md q-pr-md"
  >
    <SearchAddress
      ref="search_address"
      @after-selectaddress="afterSelectaddress"
      :placeholder="$t('Enter your street and house number')"
    />
    <q-space class="q-pa-xs"></q-space>

    <template v-if="DataStore.getMapsConfig">
      <MapsComponents
        ref="mapRef"
        class="maps"
        size="fit"
        :keys="DataStore.getMapsConfig.key"
        :provider="DataStore.getMapsConfig.provider"
        :zoom="DataStore.getMapsConfig.zoom"
        :center="center"
        :markers="marker_position"
        @after-selectmap="afterSelectmap"
      >
      </MapsComponents>
    </template>

    <div class="q-pt-sm q-pb-md">
      <div class="text-subtitle2">{{ address1 }}</div>
      <div class="text-caption">{{ formatted_address }}</div>
    </div>

    <q-form @submit="onSubmit">
      <q-input
        outlined
        v-model="formatted_address"
        :label="$t('Street name')"
        stack-label
        color="grey-5"
        lazy-rules
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      />
      <q-input
        outlined
        v-model="address1"
        :label="$t('Street number')"
        stack-label
        color="grey-5"
        lazy-rules
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      />

      <q-input
        outlined
        v-model="location_name"
        :label="$t('Aparment, suite or floor')"
        stack-label
        color="grey-5"
      />
      <q-space class="q-pa-sm"></q-space>

      <q-select
        outlined
        v-model="delivery_options"
        :options="CartStore.getDeliveryOption"
        :label="$t('Delivery options')"
      />

      <q-space class="q-pa-sm"></q-space>
      <q-input
        v-model="delivery_instructions"
        outlined
        autogrow
        stack-label
        :label="$t('Add delivery instructions')"
        :hint="
          $t(
            'eg. ring the bell after dropoff, leave next to the porch, call upon arrival, etc'
          )
        "
      />
      <q-space class="q-pa-md"></q-space>
      <div class="text-weight-bold q-mb-sm">{{ $t("Address label") }}</div>

      <div v-if="CartStore.getAddresslabel" class="border-grey radius8">
        <q-btn-toggle
          v-model="address_label"
          toggle-color="green"
          unelevated
          no-caps
          :options="CartStore.getAddresslabel"
          spread
          padding="10px"
        />
      </div>

      <q-space class="q-pa-md"> </q-space>

      <q-footer>
        <q-btn
          type="submit"
          color="primary"
          text-color="white"
          :label="$t('Save address')"
          unelevated
          class="full-width"
          size="lg"
          no-caps
          :loading="loading"
          :disable="!hasAddress"
        />
      </q-footer>
      <!-- end form -->
    </q-form>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import { useCartStore } from "stores/CartStore";

export default {
  name: "AddAddress",
  components: {
    SearchAddress: defineAsyncComponent(() =>
      import("components/SearchAddress.vue")
    ),
    MapsComponents: defineAsyncComponent(() =>
      import("components/MapsComponents.vue")
    ),
  },
  setup(props) {
    const DataStore = useDataStore();
    const CartStore = useCartStore();
    return { DataStore, CartStore };
  },
  mounted() {
    this.CartStore.posAttributes();
  },
  computed: {
    hasAddress() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  data() {
    return {
      data: [],
      center: { lat: 34.04703, lng: -118.24686 },
      marker_position: {},
      dialog: false,
      loading: false,
      formatted_address: "",
      address1: "",
      location_name: "",
      delivery_options: "Leave it at my door",
      delivery_instructions: "",
      address_label: "Home",
    };
  },
  watch: {
    DataStore: {
      immediate: true,
      deep: true,
      handler(newValue, oldValue) {
        console.log(newValue.loading);
        if (Object.keys(newValue.maps_config).length > 0) {
          this.maps_config = newValue.maps_config;

          this.setMarkerPosition(
            this.maps_config.default_lat,
            this.maps_config.default_lng
          );
          this.checkSavedLocation();
        } else if (newValue.loading == false) {
        }
      },
    },
  },
  methods: {
    setMarkerPosition(lat, lng) {
      this.marker_position = [
        {
          id: 0,
          lat: parseFloat(lat),
          lng: parseFloat(lng),
          label: APIinterface.getIcon("customer"),
          icon: null,
          draggable: true,
        },
      ];
    },
    afterSelectaddress(data) {
      this.data = data;
      this.setMarkerPosition(data.latitude, data.longitude);
      this.formatted_address = data.address.formatted_address;
      this.address1 = data.address.address1;
    },
    afterSelectmap(lat, lng) {
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });
      APIinterface.fetchDataByTokenPost(
        "reverseGeocoding",
        "lat=" + lat + "&lng=" + lng
      )
        .then((response) => {
          this.data = response.details.data;
          this.setMarkerPosition(
            response.details.data.latitude,
            response.details.data.longitude
          );
          this.formatted_address =
            response.details.data.address.formatted_address;
          this.address1 = response.details.data.address.address1;
        })
        .catch((error) => {})
        .then((data) => {
          this.$q.loading.hide();
        });
    },
    checkSavedLocation() {
      console.log("checkSavedLocation");
      let $data = this.DataStore.place_data;
      //if (!APIinterface.empty($data)) {
      if (Object.keys($data).length > 0) {
        this.data = $data;
        this.formatted_address = $data.address.formatted_address;
        this.address1 = $data.address.address1;
        this.location_name = $data.location_name;
        this.delivery_options = $data.delivery_options;
        this.delivery_instructions = $data.delivery_instructions;
        this.address_label = $data.address_label;

        this.setMarkerPosition($data.latitude, $data.longitude);
      }
    },
    onSubmit() {
      console.log("onSubmit");
      if (APIinterface.empty(this.formatted_address)) {
        APIinterface.notify(
          "dark",
          this.$t("Enter your location or select on the map"),
          "error",
          this.$q
        );
      }

      this.loading = true;

      APIinterface.fetchDataByTokenPost("saveCartAddress", {
        client_id: this.CartStore.customer_id,
        place_id: this.data.place_id,
        formatted_address: this.formatted_address,
        address1: this.address1,
        latitude: this.data.latitude,
        longitude: this.data.longitude,
        location_name: this.location_name,
        delivery_options: !APIinterface.empty(this.delivery_options)
          ? !APIinterface.empty(this.delivery_options.value)
            ? this.delivery_options.value
            : this.delivery_options
          : "",
        delivery_instructions: this.delivery_instructions,
        address_label: this.address_label,
      })
        .then((response) => {
          this.data.location_name = this.location_name;
          this.data.delivery_options = this.delivery_options;
          this.data.delivery_instructions = this.delivery_instructions;
          this.data.address_label = this.address_label;
          this.DataStore.place_data = this.data;
          this.$router.back();
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
