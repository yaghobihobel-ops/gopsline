<template>
  <q-header
    class="bg-whitex text-dark"
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-black': !$q.dark.mode,
    }"
  >
    <q-toolbar>
      <q-toolbar-title
        class="text-grey-10x"
        :class="{
          'text-white': $q.dark.mode,
          'text-grey-10': !$q.dark.mode,
        }"
        >{{ $t("New Order #") }}{{ data.order_id }}</q-toolbar-title
      >
      <q-btn
        @click="dialog_confirm = true"
        flat
        dense
        :label="$t('Decline')"
        no-caps
        color="blue"
      />
    </q-toolbar>
  </q-header>

  <q-page
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-grey-1 text-dark': !$q.dark.mode,
    }"
  >
    <template v-if="!loading">
      <template v-if="hasData">
        <div
          class="map small"
          style="overflow: hidden"
          :class="{
            'bg-mydark': $q.dark.mode,
            'bg-grey-1': !$q.dark.mode,
          }"
        >
          <MapComponents
            class="maps"
            :keys="Activity.maps_config.key"
            :provider="Activity.maps_config.provider"
            :zoom="Activity.maps_config.zoom"
            :center="map_center"
            :markers="map_markers"
          ></MapComponents>
        </div>
        <div class="delivery-details q-mt-md q-pl-md q-pr-md">
          <p class="font12">{{ $t("Delivery Details") }}</p>
          <q-timeline>
            <q-timeline-entry icon="las la-warehouse">
              <template v-slot:subtitle>{{ $t("Pickup") }}</template>
              <div class="details">
                <div class="text-weight-medium">
                  {{ data.pickup.restaurant_name }}
                </div>
                <p class="font11 line-normal">
                  {{ data.pickup.address }}
                </p>
              </div>
            </q-timeline-entry>
            <q-timeline-entry icon="las la-user-circle">
              <template v-slot:subtitle>{{ $t("Drop-off") }}</template>
              <div class="details">
                <div class="text-weight-medium">
                  {{ data.dropoff.customer_name }}
                </div>
                <p class="font11 line-normal">
                  {{ data.dropoff.address }}
                </p>
              </div>
            </q-timeline-entry>
          </q-timeline>
        </div>
        <!-- delivery-details -->

        <div class="accept-section">
          <template v-if="Activity.settings_data.enabled_acceptance">
            <q-linear-progress
              :value="progress"
              class="q-mt-md"
              color="orange-5"
            />
          </template>
          <template v-else>
            <q-separator></q-separator>
          </template>

          <div class="row items-center q-gutter-sm q-pa-md">
            <div class="col">
              <q-list bordered separator class="radius8">
                <q-slide-item
                  @left="onLeft"
                  left-color="light-green"
                  class="radius8"
                >
                  <template v-slot:left>
                    <q-spinner color="primary" size="2em" />
                    {{ $t("Accepting Orders") }}
                  </template>
                  <q-item
                    class="text-white text-weight-bold btn-11"
                    :style="`background-color:${status_data.bg_color} !important;color:${status_data.font_color} !important;`"
                  >
                    <q-item-section class="text-center font17">{{
                      $t("Accept")
                    }}</q-item-section>
                    <q-item-section avatar>
                      <q-avatar
                        text-color="white"
                        :style="`color:${status_data.font_color} !important;`"
                        icon="las la-angle-double-right"
                      />
                    </q-item-section>
                  </q-item>
                </q-slide-item>
              </q-list>
            </div>
            <div class="col-4 q-pl-sm">
              <p class="line-normal no-margin">Order total</p>
              <div class="text-h7 text-green">
                {{ data.total }}
              </div>
            </div>
          </div>
        </div>
        <!-- accept-section -->
      </template>
    </template>

    <q-dialog v-model="dialog_confirm" persistent>
      <q-card>
        <q-card-section class="row items-center q-pb-none">
          <div class="text-h6 font18">{{ $t("Decline") }}</div>
          <q-space />
          <q-btn icon="close" size="sm" flat round dense v-close-popup />
        </q-card-section>
        <q-card-section>
          <p class="font14">
            {{ $t("Are you sure you want to decline this order") }}?
          </p>
        </q-card-section>
        <q-card-sections>
          <q-btn
            @click="showDeclineReason"
            :label="$t('Decline')"
            color="red"
            unelevated
            class="fit text-weight-bold font17"
            no-caps
          ></q-btn>
        </q-card-sections>
      </q-card>
    </q-dialog>
    <!-- end dialog -->
  </q-page>

  <DeclineReason
    ref="decline_reason"
    @after-submit="afterSubmit"
  ></DeclineReason>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import config from "src/api/config";
import {
  ref,
  computed,
  defineAsyncComponent,
  onMounted,
  onUnmounted,
  watch,
} from "vue";
import { useRouter, useRoute } from "vue-router";
import { useQuasar } from "quasar";
import { useActivityStore } from "stores/ActivityStore";
import { useDriverappStore } from "stores/DriverappStore";

export default {
  name: "NewOrder",
  components: {
    MapComponents: defineAsyncComponent(() =>
      import("components/MapComponents.vue")
    ),
    DeclineReason: defineAsyncComponent(() =>
      import("components/DeclineReason.vue")
    ),
  },
  setup() {
    const router = useRouter();
    const route = useRoute();
    const mapRef = ref(null);
    const cmapsMarker = ref([]);
    const order_uuid = ref("");
    const loading = ref(false);
    const accept_loading = ref(false);
    const data = ref([]);
    const maps_config = ref([]);
    const dialog_confirm = ref(false);
    const title = config.title;
    const map_center = ref([]);
    const map_markers = ref({});
    const $q = useQuasar();
    const reason = ref("");
    const decline_reason = ref(null);
    const status_data = ref([]);
    const remaining = ref(45);
    const progress = ref(1);
    const timer = ref(undefined);

    order_uuid.value = route.query.order_uuid;
    const Activity = useActivityStore();
    const DriverappStore = useDriverappStore();

    const getMapKeys = () => {
      try {
        if (!APIinterface.empty(Activity.maps_config)) {
          map_center.value = {
            lat: parseFloat(Activity.maps_config.default_lat),
            lng: parseFloat(Activity.maps_config.default_lng),
          };
        }
        // const $storage = APIinterface.getStorage("driver_maps_config");
        // maps_config.value = jwtDecode($storage);
        // map_center.value = {
        //   lat: parseFloat(maps_config.value.default_lat),
        //   lng: parseFloat(maps_config.value.default_lng),
        // };
      } catch (err) {
        console.debug(err);
      }
    };

    getMapKeys();

    const orderPreview = () => {
      APIinterface.showLoadingBox("", $q);
      loading.value = true;
      APIinterface.orderPreview({
        order_uuid: order_uuid.value,
      })
        .then((result) => {
          data.value = result.details;
          status_data.value = data.value.status_data;
          map_markers.value = [
            {
              id: 0,
              lat: parseFloat(data.value.pickup.latitude),
              lng: parseFloat(data.value.pickup.longitude),
              label: APIinterface.getIcon("merchant"),
              icon: "marker_icon_merchant",
              draggable: false,
            },
            {
              id: 1,
              lat: parseFloat(data.value.dropoff.latitude),
              lng: parseFloat(data.value.dropoff.longitude),
              label: APIinterface.getIcon("customer"),
              icon: "marker_icon_destination",
              draggable: false,
            },
          ];

          map_center.value = {
            lat: parseFloat(data.value.pickup.latitude),
            lng: parseFloat(data.value.pickup.longitude),
          };
        })
        .catch((error) => {
          console.debug(error);
          router.replace("/order/404");
        })
        .then((data) => {
          loading.value = false;
          APIinterface.hideLoadingBox($q);
        });
    };

    orderPreview();

    const hasData = computed(() =>
      Object.keys(data.value).length ? true : false
    );

    const acceptOrder = (reset) => {
      APIinterface.showLoadingBox("", $q);
      accept_loading.value = true;
      APIinterface.acceptOrder({
        order_uuid: order_uuid.value,
      })
        .then((data) => {
          console.debug(data);
          router.replace("/home/deliveries");
        })
        .catch((error) => {
          console.log("here error");
          reset.reset();
          APIinterface.notify("red-5", error, "error_outline", $q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox($q);
          accept_loading.value = false;
        });
    };

    const onLeft = (reset) => {
      acceptOrder(reset);
    };

    const showDeclineReason = () => {
      dialog_confirm.value = false;
      decline_reason.value.reason = "";
      decline_reason.value.dialog = true;
    };

    const afterSubmit = (data) => {
      reason.value = data;
      declineOrder();
    };

    const declineOrder = () => {
      APIinterface.showLoadingBox("", $q);
      APIinterface.declineOrder({
        order_uuid: order_uuid.value,
        reason: reason.value,
      })
        .then((data) => {
          console.debug(data);
          DriverappStore.getTotalTask();
          router.replace("/home/deliveries");
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", $q);
        })
        .then(() => {
          APIinterface.hideLoadingBox($q);
        });
    };

    onMounted(() => {
      if (Activity.settings_data.enabled_acceptance) {
        remaining.value = parseInt(Activity.settings_data.time_acceptance) * 60;
        startTimer();
      }
    });

    onUnmounted(() => {
      stopTimer();
    });

    watch(remaining, (newValue, oldValue) => {
      //console.log("watch" + remaining.value);
      if (remaining.value < 0) {
        stopTimer();
        timeoutAcceptOrder();
      }
    });

    const startTimer = () => {
      stopTimer();
      timer.value = setInterval(() => {
        remaining.value = remaining.value - 1;
        progress.value = remaining.value / 100;
      }, 1000);
    };
    const stopTimer = () => {
      clearInterval(timer.value);
    };

    const timeoutAcceptOrder = () => {
      APIinterface.showLoadingBox("", $q);
      APIinterface.fetchDataByTokenPost(
        "timeoutAcceptOrder",
        "order_uuid=" + order_uuid.value
      )
        .then((data) => {
          router.replace("/home");
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error_outline", $q);
        })
        .then(() => {
          APIinterface.hideLoadingBox($q);
        });
    };

    return {
      mapRef,
      hasData,
      loading,
      data,
      maps_config,
      dialog_confirm,
      title,
      map_center,
      map_markers,
      cmapsMarker,
      acceptOrder,
      onLeft,
      accept_loading,
      showDeclineReason,
      decline_reason,
      afterSubmit,
      status_data,
      Activity,
      remaining,
      progress,
    };
  },
  //
};
</script>
