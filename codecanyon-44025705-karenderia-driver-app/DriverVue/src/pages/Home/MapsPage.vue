<template>
  <q-page id="addressesOverview" class="row items-stretch">
    <div class="col-12 map bg-grey-1 relative-position">
      <template v-if="!loading">
        <MapComponents
          ref="maps_cmp"
          class="maps"
          :keys="Activity.maps_config.key"
          :provider="Activity.maps_config.provider"
          :zoom="Activity.maps_config.zoom"
          :center="map_center"
          :markers="markers"
        ></MapComponents>
      </template>
    </div>
    <!-- col -->

    <q-page-sticky position="bottom-right" :offset="[18, 40]">
      <div class="column items-center">
        <div class="col q-mb-md">
          <q-btn
            @click="reCenterMap"
            fab
            color="deep-purple"
            unelevated
            padding="12px"
          >
            <q-icon name="my_location" size="17px" />
          </q-btn>
        </div>
        <div class="col">
          <launchNavigation :location="destination" size_icon="lg">
          </launchNavigation>
        </div>
      </div>
    </q-page-sticky>
  </q-page>
</template>

<script>
import { useActivityStore } from "stores/ActivityStore";
import { useLocationStore } from "stores/LocationStore";
import APIinterface from "src/api/APIinterface";
import { defineAsyncComponent } from "vue";
//coordinates
export default {
  name: "MapsPage",
  components: {
    MapComponents: defineAsyncComponent(() =>
      import("components/MapComponents.vue")
    ),
    launchNavigation: defineAsyncComponent(() =>
      import("components/launchNavigation.vue")
    ),
  },
  data() {
    return {
      map_center: [],
      markers: [],
      data: [],
      merchant: [],
      order_meta: [],
      steps: 0,
      destination: [],
      loading: true,
    };
  },
  setup() {
    const Activity = useActivityStore();
    const LocationStore = useLocationStore();
    return { Activity, LocationStore };
  },
  watch: {
    Activity: {
      immediate: true,
      deep: true,
      handler(newValue, oldValue) {
        if (!newValue.settings_loading) {
          this.getMapsConfig();
        }
      },
    },
    LocationStore: {
      immediate: true,
      deep: true,
      handler(newValue, oldValue) {
        if (Object.keys(newValue.coordinates).length > 0) {
          this.markers[0] = {
            lat: parseFloat(newValue.coordinates.lat),
            lng: parseFloat(newValue.coordinates.lng),
            label: APIinterface.getIcon("driver"),
            icon: "marker_icon_rider",
          };
          if (!APIinterface.empty(this.$refs.maps_cmp)) {
            this.reCenterMap();
          }
        }
      },
    },
  },
  mounted() {
    this.getDelivery();
    this.Activity.setTitle(this.$t("Maps"));
  },
  computed: {
    hasMarkers() {
      if (Object.keys(this.map_center).length > 0) {
        return true;
      }
      return false;
    },
    hasData() {
      if (Object.keys(this.map_center).length > 0) {
        return true;
      }
      return false;
    },
    hasDestination() {
      if (Object.keys(this.destination).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    getMapsConfig() {
      this.maps_config = this.Activity.maps_config;
      this.map_center = {
        lat: parseFloat(this.maps_config.default_lat),
        lng: parseFloat(this.maps_config.default_lng),
      };
      if (Object.keys(this.markers).length > 0) {
      } else {
        this.markers[0] = {
          lat: parseFloat(this.maps_config.default_lat),
          lng: parseFloat(this.maps_config.default_lng),
          label: APIinterface.getIcon("driver"),
          icon: "marker_icon_rider",
        };
      }
    },
    reCenterMap() {
      this.$refs.maps_cmp.centerMap();
    },
    getDelivery() {
      let dateNow = APIinterface.getDateNow();
      this.loading = true;
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByToken("getorderlist", {
        date: dateNow,
      })
        .then((result) => {
          this.data = result.details.data;
          this.merchant = result.details.merchant;
          this.order_meta = result.details.order_meta;
          this.getMarkers();
        })
        .catch((error) => {
          this.data = [];
          this.merchant = [];
          this.order_meta = [];
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
          this.loading = false;
        });
    },
    getMarkers() {
      if (Object.keys(this.data).length > 0) {
        Object.entries(this.data).forEach(([key, items]) => {
          this.Activity.setTitle(this.$t("Order#") + key);

          let Steps = items.delivery_steps.steps;
          this.steps = Steps;
          let MerchantId = items.merchant_id;
          let OrderId = items.order_id;
          let MerchantData = !APIinterface.empty(this.merchant[MerchantId])
            ? this.merchant[MerchantId]
            : "";

          let CustomerData = !APIinterface.empty(this.order_meta[OrderId])
            ? this.order_meta[OrderId]
            : "";

          switch (Steps) {
            case 2:
            case 3:
            case 4:
              this.markers.push({
                lat: parseFloat(MerchantData.latitude),
                lng: parseFloat(MerchantData.lontitude),
                label: APIinterface.getIcon("merchant"),
                icon: "marker_icon_merchant",
              });
              this.destination = {
                lat: parseFloat(MerchantData.latitude),
                lng: parseFloat(MerchantData.lontitude),
              };
              break;

            case 5:
            case 6:
            case 7:
              this.markers.push({
                lat: parseFloat(CustomerData.latitude),
                lng: parseFloat(CustomerData.longitude),
                label: APIinterface.getIcon("customer"),
                icon: "marker_icon_destination",
              });
              this.destination = {
                lat: parseFloat(CustomerData.latitude),
                lng: parseFloat(CustomerData.longitude),
              };
              break;
          }
        });
        //this.reCenterMap();
      }
    },
    //
  },
};
</script>
