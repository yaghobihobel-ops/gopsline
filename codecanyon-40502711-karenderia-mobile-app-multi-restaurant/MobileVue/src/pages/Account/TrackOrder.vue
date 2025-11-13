<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-header
      class="bg-white text-dark q-pl-sm q-pr-sm border-bottomx myshadow-1"
    >
      <q-toolbar>
        <q-btn
          dense
          icon="eva-arrow-back-outline"
          class="q-mr-sm"
          text-color="dark"
          size="md"
          unelevated
          v-ripple:purple
          to="/home/orders"
          flat
        />
        <q-toolbar-title>
          <div class="text-weight-bold text-subtitle2">
            {{ $t("Order Place") }}
          </div>
        </q-toolbar-title>
      </q-toolbar>
    </q-header>
    <q-page
      :padding="!showTracking"
      :class="{ 'row items-stretch': showTracking }"
    >
      <template v-if="loading">
        <q-card-section>
          <div
            class="row items-center justify-between text-subtitle2 text-dark"
          >
            <div class="col-4"><q-skeleton type="text"></q-skeleton></div>
            <div class="col-4 text-right">
              <q-skeleton type="text"></q-skeleton>
            </div>
          </div>
        </q-card-section>
        <q-card-section class="bg-white q-pa-xs">
          <q-list>
            <q-item>
              <q-item-section avatar top>
                <q-avatar>
                  <q-responsive style="width: 50px; height: 50px">
                    <q-skeleton type="QAvatar"></q-skeleton>
                  </q-responsive>
                </q-avatar>
              </q-item-section>
              <q-item-section top>
                <q-item-label><q-skeleton type="text" /> </q-item-label>
                <q-item-label> <q-skeleton type="text" /></q-item-label>
              </q-item-section>
              <q-item-section side top>
                <q-skeleton type="QBtn" />
              </q-item-section>
            </q-item>
          </q-list>
        </q-card-section>
      </template>

      <template v-if="data && !loading">
        <template v-if="showTracking">
          <div class="col-12 relative-position bg-grey-1">
            <MapsComponents
              ref="mapRef"
              class="maps"
              size="fit"
              :keys="DataStore.maps_config.key"
              :provider="DataStore.maps_config.provider"
              :zoom="DataStore.maps_config.zoom"
              :language="DataStore.maps_config.language"
              :center="map_center"
              :markers="map_marker"
              :map_controls="true"
              :controls_center="true"
              @after-selectmap="afterSelectmap"
            />
          </div>
          <q-footer class="bg-white text-dark shadow-1">
            <q-card>
              <q-card-section class="q-pt-sm">
                <q-item>
                  <q-item-section>
                    <q-item-label class="text-subtitle1 text-weight-bold">
                      {{ progress_data.estimated_time }}
                    </q-item-label>
                    <q-item-label caption>
                      {{ progress_data.order_status }}
                      <div class="q-mt-sm" style="width: 70%">
                        <q-linear-progress indeterminate color="secondary" />
                      </div>
                    </q-item-label>
                  </q-item-section>
                  <q-item-section side>
                    <OrderStatusAnimation :status="getImageProgress" />
                  </q-item-section>
                </q-item>
                <q-item>
                  <q-item-section class="myqstepper">
                    <q-stepper
                      v-model="order_progress"
                      active-color="secondary"
                      done-color="secondary"
                      inactive-color="grey-3"
                      flat
                      contracted
                      class="no-padding tracking-steps"
                    >
                      <q-step
                        :name="1"
                        done-icon="eva-arrow-forward-outline"
                        active-icon="eva-arrow-forward-outline"
                        icon="eva-arrow-forward-outline"
                        :done="order_progress > 1"
                      />
                      <q-step
                        :name="2"
                        done-icon="restaurant_menu"
                        active-icon="restaurant_menu"
                        icon="restaurant_menu"
                        :done="order_progress > 2"
                      />
                      <q-step
                        :name="3"
                        done-icon="directions_car"
                        active-icon="directions_car"
                        icon="directions_car"
                        :done="order_progress > 3"
                      />
                      <q-step
                        :name="4"
                        done-icon="home"
                        active-icon="home"
                        icon="home"
                        :done="order_progress >= 4"
                      />
                    </q-stepper>
                  </q-item-section>
                </q-item>
                <q-space class="q-pa-xs"></q-space>
                <!-- <q-separator class="q-mb-sm q-mt-sm"></q-separator> -->
                <q-card-section
                  v-if="progress_data.driver_info"
                  class="myshadow-1 q-pa-sm radius8"
                >
                  <q-item>
                    <q-item-section avatar top>
                      <q-avatar style="width: 50px; height: 50px">
                        <img :src="progress_data.driver_info.photo" />
                      </q-avatar>
                    </q-item-section>
                    <q-item-section top>
                      <q-item-label>
                        <div class="flex items-center q-gutter-x-sm">
                          <div class="text-weight-bold">
                            {{ progress_data.driver_info.full_name }}
                          </div>
                          <div>
                            {{ progress_data.driver_info.average_rating }}
                          </div>
                          <div>
                            <q-icon
                              name="star"
                              size="18px"
                              color="yellow-13"
                            ></q-icon>
                          </div>
                        </div>
                      </q-item-label>
                      <q-item-label caption>
                        {{ progress_data.driver_info.car_maker }} &bull;
                        {{ progress_data.driver_info.plate_number }}
                      </q-item-label>
                    </q-item-section>
                  </q-item>
                  <q-item>
                    <q-item-section>
                      <div class="row items-center text-caption">
                        <div class="col">
                          <q-btn
                            no-caps
                            unelevated
                            color="grey-2"
                            text-color="blue-grey-6"
                            padding="10px"
                            class="fit"
                            @click="createChatDriver"
                            :loading="loading_chat"
                          >
                            <q-btn
                              dense
                              color="grey-2"
                              text-color="dark"
                              round
                              icon="eva-message-circle-outline"
                              size="sm"
                              unelevated
                              class="q-mr-sm"
                            >
                              <q-badge floating color="red" rounded />
                            </q-btn>
                            {{ $t("Chat with your driver") }}
                          </q-btn>
                        </div>
                        <div class="col-2 text-center">
                          <q-btn
                            icon="eva-phone-outline"
                            no-caps
                            unelevated
                            color="grey-2"
                            text-color="blue-grey-6"
                            padding="9px"
                            outline
                            :href="
                              'tel:' + progress_data?.driver_info?.phone || ''
                            "
                          ></q-btn>
                        </div>
                      </div>
                    </q-item-section>
                  </q-item>
                </q-card-section>
              </q-card-section>
            </q-card>
          </q-footer>
        </template>

        <template v-if="!showTracking">
          <q-list dense>
            <q-item>
              <q-item-section>
                <div class="text-subtitle1 text-weight-bold">
                  {{ progress_data.estimated_time }}
                </div>
                <div
                  class="text-subtitle2"
                  :class="{
                    'text-warning':
                      progress_data.is_order_late ||
                      progress_data.is_preparation_late ||
                      progress_data.is_driver_delivering_late ||
                      !progress_data.is_order_ongoing,
                  }"
                >
                  {{ progress_data.order_status }}
                </div>
              </q-item-section>
              <q-item-section side>
                <OrderStatusAnimation :status="getImageProgress" />
              </q-item-section>
            </q-item>
          </q-list>

          <TrackingProgress
            :order_progress="order_progress"
            :order_type="data?.order_info?.order_type || ''"
          ></TrackingProgress>

          <div class="q-pl-md q-pr-md q-mt-md">
            <div class="text-caption line-normal">
              {{ progress_data.order_status_details }}
            </div>

            <q-space class="q-pa-sm"></q-space>
            <q-card class="myshadow-1">
              <q-list>
                <q-item>
                  <q-item-section>{{ $t("Order ID") }}</q-item-section>
                  <q-item-section side
                    >#{{ data.order_info.order_id }}</q-item-section
                  >
                </q-item>
              </q-list>
            </q-card>

            <q-space class="q-pa-sm"></q-space>

            <q-card class="myshadow-1">
              <q-list>
                <q-item>
                  <q-item-section class="text-weight-bold text-subtitle2">{{
                    data.merchant_info.restaurant_name
                  }}</q-item-section>
                  <q-item-section
                    side
                    v-if="data.progress.is_order_need_cancellation"
                  >
                    <q-btn
                      :label="$t('Cancel')"
                      no-caps
                      unelevated
                      color="primary"
                      flat
                      padding="0"
                      class="text-weight-bold"
                      @click="
                        this.$refs.cancel_order.showModal(
                          this.data.order_info.order_uuid
                        )
                      "
                    ></q-btn>
                  </q-item-section>
                </q-item>
                <q-item dense>
                  <q-item-section>
                    <div class="row items-center text-caption">
                      <div class="col">
                        <q-btn
                          v-if="DataStore.chat_enabled"
                          icon="eva-message-circle-outline"
                          :label="$t('Chat with restaurant')"
                          no-caps
                          unelevated
                          color="grey-2"
                          text-color="blue-grey-6"
                          padding="6px"
                          class="fit"
                          @click="createChat"
                          :loading="loading_chat"
                        ></q-btn>
                      </div>
                      <div class="col-2 text-center">
                        <q-btn
                          icon="eva-phone-outline"
                          no-caps
                          unelevated
                          color="grey-2"
                          text-color="blue-grey-6"
                          padding="5px"
                          outline
                          :href="
                            'tel:' + data?.merchant_info?.contact_phone || ''
                          "
                        ></q-btn>
                      </div>
                    </div>
                  </q-item-section>
                </q-item>
                <q-item dense v-if="!data.favorites">
                  <q-item-section
                    class="bg-amber-1 text-grey q-pa-sm radius8 text-caption line-normal"
                  >
                    <div class="row items-center">
                      <div class="col">
                        {{
                          $t(
                            "Save this restaurant to Favourites and find it quickly next time."
                          )
                        }}
                      </div>
                      <div class="col-2 text-center">
                        <FavsResto
                          ref="favs"
                          :data="data"
                          :active="data.favorites == 1 ? true : false"
                          :merchant_id="data.merchant_info.merchant_id"
                          size="sm"
                          @after-savefav="afterSavefav"
                        />
                      </div>
                    </div>
                  </q-item-section>
                </q-item>
                <q-item>
                  <q-item-section> {{ $t("Total") }} </q-item-section>
                  <q-item-section side class="text-weight-bold">
                    {{ data.order_info.pretty_total }}</q-item-section
                  >
                </q-item>
                <q-separator></q-separator>
                <q-item clickable @click="showDetails" v-ripple:purple>
                  <q-item-section class="text-weight-bold text-info">
                    {{ $t("View order details") }}
                  </q-item-section>
                  <q-item-section side>
                    <q-btn
                      icon="eva-arrow-forward-outline"
                      unelevated
                      round
                      color="grey-2"
                      text-color="dark"
                      size="xs"
                    ></q-btn>
                  </q-item-section>
                </q-item>
              </q-list>
            </q-card>

            <q-space class="q-pa-sm"></q-space>

            <q-card class="myshadow-1 custom-stepper">
              <q-stepper
                v-model="step"
                vertical
                color="primary"
                flat
                animated
                class="q-pa-none q-pr-sm"
              >
                <q-step
                  :name="1"
                  :title="$t('Order from')"
                  :caption="data.merchant_info.address"
                  :done="true"
                  done-color="blue-grey-6"
                  done-icon="restaurant_menu"
                  active-icon="restaurant_menu"
                  icon="restaurant_menu"
                >
                </q-step>
                <q-step
                  :name="2"
                  :title="$t('Delivered to')"
                  :caption="getDeliveryAddress"
                  :done="true"
                  done-color="primary"
                  done-icon="home"
                  active-icon="home"
                  icon="home"
                >
                </q-step>
              </q-stepper>
            </q-card>
          </div>
          <q-space class="q-pa-lg"></q-space>
        </template>
      </template>

      <OrderDetails
        ref="ref_orderdetails"
        :order_uuid="order_uuid"
        @onclose-order="oncloseOrder"
        :show_actions="false"
        @on-ratereview="showReview"
        @onReorder="reOrder"
      ></OrderDetails>

      <CancelOrder ref="cancel_order" @after-cancelorder="afterCancelorder" />
      <TrackDriver
        ref="ref_trackdriver"
        @set-driverlocation="setDriverlocation"
      ></TrackDriver>

      <ReviewOrder
        ref="ref_revieworder"
        @after-addreview="afterAddreview"
      ></ReviewOrder>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { defineAsyncComponent } from "vue";
import { useDataStore } from "stores/DataStore";
import { useClientStore } from "stores/ClientStore";
import FirebaseService from "src/api/FirebaseService";
import auth from "src/api/auth";
import { App } from "@capacitor/app";

export default {
  name: "TrackOrder",
  components: {
    OrderDetails: defineAsyncComponent(() =>
      import("components/OrderDetails.vue")
    ),
    CancelOrder: defineAsyncComponent(() =>
      import("components/CancelOrder.vue")
    ),
    FavsResto: defineAsyncComponent(() => import("components/FavsResto.vue")),
    MapsComponents: defineAsyncComponent(() =>
      import("components/MapsComponents.vue")
    ),
    TrackDriver: defineAsyncComponent(() =>
      import("components/TrackDriver.vue")
    ),
    TrackingProgress: defineAsyncComponent(() =>
      import("components/TrackingProgress.vue")
    ),
    OrderStatusAnimation: defineAsyncComponent(() =>
      import("components/OrderStatusAnimation.vue")
    ),
    ReviewOrder: defineAsyncComponent(() =>
      import("components/ReviewOrder.vue")
    ),
  },
  data() {
    return {
      order_progress: 1,
      progress_data: null,
      step: 3,
      loading: false,
      order_uuid: "",
      data: null,
      fetch_error: null,
      order_cancelled: null,
      timer: null,
      request_interval: 50000,
      //request_interval: 3000,
      map_marker: {},
      map_center: {},
      driver_coordinates: null,
      loading_chat: false,
      from_info: null,
      to_info: null,
      lottieInstance: null,
      back_url: null,
      backButtonListener: null,
    };
  },
  setup() {
    const DataStore = useDataStore();
    const ClientStore = useClientStore();
    return { DataStore, ClientStore };
  },
  mounted() {
    this.order_uuid = this.$route.query.order_uuid;
    this.back_url = this.$route.query?.back_url ?? null;
    let user = auth.getUser();
    this.from_info = {
      client_uuid: user.client_uuid,
      first_name: user.first_name,
      last_name: user.last_name,
      photo: user.avatar,
      user_type: "customer",
    };

    // CLEAR WALLET BALANCE
    this.ClientStore.wallet_balance = null;
    this.getOrder();

    this.$watch(
      () => this.DataStore.$state.tracking_data,
      (newData, oldData) => {
        this.order_progress = newData?.order_progress ?? null;
        this.progress_data = newData;
        if (newData.is_order_ongoing && !this.timer) {
          this.timer = setInterval(() => {
            this.trackOrder();
          }, this.request_interval);
        }
      }
    );
    //

    if (this.$q.platform.is.android && !this.back_url) {
      App.addListener("backButton", this.handleBackButton).then((listener) => {
        this.backButtonListener = listener;
      });
    }
  },
  beforeUnmount() {
    if (this.backButtonListener) {
      this.backButtonListener.remove();
    }
  },
  unmounted() {
    this.stopTimer();
  },
  computed: {
    showTracking() {
      if (this.data) {
        if (
          this.data.order_info.order_type == "delivery" &&
          this.order_progress == 3
        ) {
          return true;
        }
      }
      return false;
    },
    getDeliveryAddress() {
      let completeAdddres = "";
      if (this.data) {
        completeAdddres += this.data.order_info.address_label;
        completeAdddres += " - ";
        completeAdddres += this.data.order_info.complete_delivery_address;
      }
      return completeAdddres;
    },
    getImageProgress() {
      let results = "";
      if (this.data) {
        if (this.data.order_info.order_type == "delivery") {
          switch (this.order_progress) {
            case 0:
              results = "failed";
              break;
            case 1:
              results = "received";
              break;
            case 2:
              results = "cooking";
              break;
            case 3:
              results = "delivering";
              break;
            case 4:
              results = "completed";
              break;
            default:
              results = "receive";
              break;
          }
        } else {
          switch (this.order_progress) {
            case 0:
              results = "failed";
              break;
            case 1:
              results = "receive";
              break;
            case 2:
              results = "cooking";
              break;
            case 3:
              results = "pickup";
              break;
            case 4:
              results = "completed";
              break;
            default:
              results = "received";
              break;
          }
        }
      }
      return results;
    },
  },
  watch: {
    order_progress(newval, oldval) {
      console.log("order_progress change", newval);
      if (this.showTracking) {
        this.doFirebaseTrack();
      }
    },
  },
  methods: {
    handleBackButton() {
      setTimeout(() => {
        this.$router.replace({ path: "/home/orders" });
      }, 50);
    },
    afterAddreview() {
      console.log("afterAddreview");
      this.$refs.ref_orderdetails.modal = false;
      this.getOrder();
    },
    showReview(value) {
      console.log("showReview", value);
      this.$refs.ref_revieworder.show(value);
    },
    refresh(done) {
      done();
      this.getOrder();
    },
    doFirebaseTrack() {
      console.log("doFirebaseTrack");

      this.addTrackMarker();

      this.$refs.ref_trackdriver.driver_uuid =
        this.progress_data?.driver_info?.driver_uuid || null;
    },
    addTrackMarker() {
      console.log("addTrackMarker");
      if (this.data.merchant_info.latitude && !this.map_marker[1]) {
        this.map_marker[1] = {
          lat: parseFloat(this.data.merchant_info.latitude),
          lng: parseFloat(this.data.merchant_info.longitude),
          label: APIinterface.getIcon("merchant"),
          icon:
            this.DataStore.maps_config.provider == "mapbox"
              ? "marker_icon_merchant"
              : this.DataStore.maps_config.icon_merchant,
          draggable: false,
          title: this.data.merchant_info.address,
          id: 1,
        };
      }

      if (
        !APIinterface.empty(this.data.order_info.longitude) &&
        !this.map_marker[2]
      ) {
        this.map_marker[2] = {
          lat: parseFloat(this.data.order_info.latitude),
          lng: parseFloat(this.data.order_info.longitude),
          label: APIinterface.getIcon("customer"),
          icon:
            this.DataStore.maps_config.provider == "mapbox"
              ? "marker_icon_destination"
              : this.DataStore.maps_config.icon_destination,
          draggable: false,
          title: this.data.order_info.complete_delivery_address,
          id: 2,
        };
      }

      if (
        !APIinterface.empty(this.data.progress.driver_info) &&
        !this.map_marker[3]
      ) {
        this.map_marker[3] = {
          lat: parseFloat(this.data.progress.driver_info.latitude),
          lng: parseFloat(this.data.progress.driver_info.lontitude),
          label: APIinterface.getIcon("driver"),
          icon:
            this.DataStore.maps_config.provider == "mapbox"
              ? "marker_icon_rider"
              : this.DataStore.maps_config.icon_rider,
          draggable: false,
          title: this.data.progress.driver_info.full_name,
          id: 3,
        };
      }
    },
    setDriverlocation(data) {
      console.log("setDriverlocation", data);

      this.driver_coordinates = {
        lat: parseFloat(data.lat),
        lng: parseFloat(data.lng),
      };

      let driverCoords = null;

      if (this.DataStore.maps_config.provider == "mapbox") {
        driverCoords = [parseFloat(data.lng), parseFloat(data.lat)];
      } else {
        driverCoords = {
          lat: parseFloat(data.lat),
          lng: parseFloat(data.lng),
        };
      }
      if (this.map_marker[3]) {
        this.$refs.mapRef.setNewCoordinates(driverCoords, 3);
        this.addDriverRoute();
      } else {
        if (!APIinterface.empty(this.data.progress.driver_info)) {
          this.map_marker[3] = {
            lat: parseFloat(data.lat),
            lng: parseFloat(data.lng),
            label: APIinterface.getIcon("driver"),
            icon:
              this.DataStore.maps_config.provider == "mapbox"
                ? "marker_icon_rider"
                : this.DataStore.maps_config.icon_rider,
            draggable: false,
            title: this.data.progress.driver_info.full_name,
            id: 3,
          };
          this.$refs.mapRef.insertMarker(this.map_marker[3]);
          this.addDriverRoute();
        }
      }
    },
    addDriverRoute() {
      if (!this.data.progress.is_order_ongoing) {
        return;
      }
      console.log("addDriverRoute");

      if (this.map_marker[1]) {
        this.$refs.mapRef.removeMarkers(1);
      }
      let startLocation, endLocation;

      console.log("driver_coordinates", this.driver_coordinates);

      if (this.DataStore.maps_config.provider == "mapbox") {
        startLocation = [
          parseFloat(this.driver_coordinates.lng),
          parseFloat(this.driver_coordinates.lat),
        ];
        endLocation = [
          parseFloat(this.data.order_info.longitude),
          parseFloat(this.data.order_info.latitude),
        ];
      } else if (this.DataStore.maps_config.provider == "google.maps") {
        startLocation = {
          lat: parseFloat(this.driver_coordinates.lat),
          lng: parseFloat(this.driver_coordinates.lng),
        };
        endLocation = {
          lat: parseFloat(this.data.order_info.latitude),
          lng: parseFloat(this.data.order_info.longitude),
        };
      }
      this.$refs.mapRef.addRoute(startLocation, endLocation);
    },
    oncloseOrder(value) {
      console.log("oncloseOrder", value);
      if (value) {
        this.getOrder();
      }
    },
    async getOrder() {
      try {
        this.loading = true;
        const result = await APIinterface.fetchDataByTokenPost(
          "getOrder",
          "order_uuid=" + this.order_uuid
        );
        this.data = result.details;
        this.order_progress = this.data.progress.order_progress;
        this.progress_data = this.data.progress;

        this.map_center = {
          lat: parseFloat(this.data.merchant_info.latitude),
          lng: parseFloat(this.data.merchant_info.longitude),
        };

        if (this.data.progress.is_order_ongoing && !this.timer) {
          this.timer = setInterval(() => {
            this.trackOrder();
          }, this.request_interval);
        }

        //
      } catch (error) {
        console.log("error", error);
        this.fetch_error = error;
        this.data = null;
      } finally {
        this.loading = false;
      }
    },
    async trackOrder() {
      try {
        const results = await APIinterface.fetchDataByTokenGet("trackOrder", {
          order_uuid: this.order_uuid,
        });
        console.log("trackOrder", results);
        console.log("order_progress", results.details.data.order_progress);

        this.order_progress = results.details.data.order_progress;
        this.progress_data = results.details.data;

        if (!results.details.data.is_order_ongoing) {
          this.stopTimer();
        }
      } catch (error) {
        console.log("error", error);
      } finally {
      }
    },
    showDetails() {
      this.$refs.ref_orderdetails.modal = true;
    },
    afterCancelorder() {
      this.$refs.cancel_order.show_modal = false;
      this.order_cancelled = true;
      this.getOrder();
    },
    stopTimer() {
      clearInterval(this.timer);
    },
    afterSavefav(data, added) {
      data.favorites = added;
    },
    async createChat() {
      this.to_info = {
        client_uuid: this.data?.merchant_info?.merchant_uuid,
        photo: this.data?.merchant_info?.url_logo,
        first_name: this.data?.merchant_info.restaurant_name,
        last_name: "",
        user_type: "merchant",
      };
      try {
        this.loading_chat = true;
        const results = await FirebaseService.createChatOrder(
          this.data?.order_info?.order_id,
          this.order_uuid,
          this.data?.merchant_info?.merchant_uuid,
          this.from_info?.client_uuid,
          this.from_info,
          this.to_info
        );
        this.$router.push({
          path: "/account/chat/conversation",
          query: { doc_id: results },
        });
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        this.loading_chat = false;
      }
    },
    async createChatDriver() {
      try {
        const to_info = {
          client_uuid: this.progress_data?.driver_info?.driver_uuid,
          photo: this.progress_data?.driver_info?.photo,
          first_name: this.progress_data?.driver_info?.first_name,
          last_name: this.progress_data?.driver_info?.first_name,
          user_type: "driver",
        };

        this.loading_chat = true;
        const documentId = await FirebaseService.createChatOrder(
          this.data?.order_info?.order_id,
          "ORD-" + this.order_uuid,
          this.progress_data?.driver_info?.driver_uuid,
          this.from_info?.client_uuid,
          this.from_info,
          to_info
        );
        this.$router.push({
          path: "/account/chat/conversation",
          query: { doc_id: documentId },
        });
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        this.loading_chat = false;
      }
    },
    // end methods
  },
};
</script>
