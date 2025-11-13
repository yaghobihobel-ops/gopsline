<template>
  <div
    :class="{
      'bg-mydark ': $q.dark.mode,
      'bg-white ': !$q.dark.mode,
    }"
  >
    <div class="q-pa-md">
      <div class="row justify-between">
        <div class="text-weight-bold">{{ $t("Restaurant Details") }}</div>
        <div>#{{ data.order_id }}</div>
      </div>
      <div class="row items-center">
        <div v-if="merchants[data.merchant_id]" class="col text-weight-medium">
          {{ merchants[data.merchant_id].restaurant_name }}
        </div>
        <div class="col-4 text-right">
          <div class="flex items-center justify-end">
            <q-btn
              round
              color="primary"
              icon="las la-map"
              size="sm"
              unelevated
              flat
              class="q-mr-sm"
              to="/home/maps"
            />

            <q-btn
              :href="'tel:' + merchants[data.merchant_id].contact_phone"
              round
              color="mygreen"
              icon="las la-phone-volume"
              size="sm"
              unelevated
              flat
            />
          </div>
        </div>
      </div>
      <!-- row -->

      <div class="row items-start">
        <div class="col-1">
          <q-icon name="las la-map-marker-alt" size="18px" />
        </div>
        <div class="col">
          <p
            v-if="merchants[data.merchant_id]"
            class="font11 line-normal no-margin"
          >
            {{ merchants[data.merchant_id].address }}
          </p>
        </div>
      </div>
      <!-- flex -->
    </div>
    <!-- q-pa-md -->

    <q-card
      class="no-shadow no-border-radius"
      :class="{
        '': $q.dark.mode,
        'card-bordered': !$q.dark.mode,
      }"
    >
      <q-card-section>
        <div class="text-weight-bold">
          {{ $t("Restaurant time preparation") }}
        </div>

        <div class="text-center">
          <PreparationCircularprogress
            :order_accepted_at="data.order_accepted_at"
            :preparation_starts="data.preparation_starts"
            :timezone="
              order_meta[data.order_id]
                ? order_meta[data.order_id]['timezone']
                : ''
            "
            :total_time="data.preparation_time_estimation"
            :label="{
              hour: $t('hour'),
              hours: $t('hours'),
              min: $t('min'),
              mins: $t('mins'),
              order_overdue: $t('Order is Overdue!'),
            }"
          >
          </PreparationCircularprogress>
        </div>
      </q-card-section>
    </q-card>

    <q-card
      class="no-shadow no-border-radius"
      :class="{
        '': $q.dark.mode,
        'card-bordered': !$q.dark.mode,
      }"
    >
      <q-card-section class="text-center">
        <!-- <template v-if="data.delivery_steps.steps == 2"> -->
        <p class="font12">{{ $t("Estimated Arrival") }}</p>
        <!-- </template> -->

        <!-- map -->
        <div class="map medium bg-grey-1 relative-position">
          <div
            class="q-mr-sm absolute-bottom-right q-ma-md"
            style="z-index: 99"
          >
            <launchNavigation :location="center"> </launchNavigation>
          </div>
          <MapComponents
            class="maps"
            :keys="Activity.maps_config.key"
            :provider="Activity.maps_config.provider"
            :zoom="Activity.maps_config.zoom"
            :center="center"
            :markers="markers"
          ></MapComponents>
        </div>
        <!-- map -->
      </q-card-section>
    </q-card>

    <div class="q-pa-md">
      <q-list bordered separator class="radius8">
        <q-slide-item
          @left="changeStatus"
          left-color="light-green-4"
          class="radius8"
        >
          <template v-slot:left>
            <q-spinner color="primary" size="2em" />
          </template>
          <q-item
            class="text-white text-weight-bold btn-11"
            :style="`background-color:${data.delivery_steps.status_data.bg_color} !important;color:${data.delivery_steps.status_data.font_color} !important;`"
          >
            <q-item-section class="text-center font17">{{
              data.delivery_steps.label
            }}</q-item-section>
            <q-item-section avatar>
              <q-avatar
                text-color="white"
                :style="`color:${data.delivery_steps.status_data.font_color} !important;`"
                icon="las la-angle-double-right"
              />
            </q-item-section>
          </q-item>
        </q-slide-item>
      </q-list>
    </div>
  </div>
</template>

<script>
import { defineAsyncComponent } from "vue";
import jwtDecode from "jwt-decode";
import APIinterface from "src/api/APIinterface";
import { useLocationStore } from "stores/LocationStore";
import { useActivityStore } from "stores/ActivityStore";

export default {
  name: "ActiveOrder",
  props: ["data", "merchants", "order_meta"],
  components: {
    MapComponents: defineAsyncComponent(() =>
      import("components/MapComponents.vue")
    ),
    launchNavigation: defineAsyncComponent(() =>
      import("components/launchNavigation.vue")
    ),
    PreparationCircularprogress: defineAsyncComponent(() =>
      import("components/PreparationCircularprogress.vue")
    ),
  },
  setup() {
    const LocationStore = useLocationStore();
    const Activity = useActivityStore();
    return { LocationStore, Activity };
  },
  data() {
    return {
      loading: false,
      center: [],
      markers: {},
      reset: undefined,
    };
  },
  watch: {
    data(newdata, oldata) {
      this.getLocation();
    },
  },
  created() {
    this.getLocation();
  },
  methods: {
    getLocation() {
      if (this.merchants[this.data.merchant_id]) {
        const $merchant = this.merchants[this.data.merchant_id];
        const $order_meta = this.order_meta[this.data.order_id];

        let $icon = "";
        this.center = {
          lat: parseFloat($merchant.latitude),
          lng: parseFloat($merchant.lontitude),
        };
        //LocationStore.coordinates
        this.markers = [
          {
            lat: parseFloat($merchant.latitude),
            lng: parseFloat($merchant.lontitude),
            label: APIinterface.getIcon("merchant"),
            icon: "marker_icon_merchant",
          },
        ];

        if (this.LocationStore.hadData()) {
          console.log("driver data");
          this.markers.push({
            lat: parseFloat(this.LocationStore.coordinates.lat),
            lng: parseFloat(this.LocationStore.coordinates.lng),
            label: APIinterface.getIcon("driver"),
            icon: "marker_icon_rider",
          });
        } else {
          console.log("no driver data");
        }
      }
    },
    changeStatus(reset) {
      this.reset = reset;
      this.changeOrderStatus(this.data.delivery_steps.methods);
      //reset.reset();
    },
    changeOrderStatus(methods) {
      console.debug("changeOrderStatus=>" + methods);
      console.debug(this.data.order_uuid);

      this.loading = true;
      APIinterface.showLoadingBox("", this.$q);

      APIinterface.fetchDataByToken(methods, {
        order_uuid: this.data.order_uuid,
      })
        .then((result) => {
          this.reset.reset();
          this.$emit("afterChangestatus", result.details);
        })
        .catch((error) => {
          console.debug(error);
          this.reset.reset();
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
          this.loading = false;
        });
    },
  },
};
</script>
