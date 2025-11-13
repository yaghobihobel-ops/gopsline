<template>
  <q-layout view="lHh Lpr lFf">
    <q-header
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
      }"
    >
      <q-toolbar>
        <q-btn
          flat
          dense
          round
          icon="menu"
          aria-label="Menu"
          @click="drawerLeft = !drawerLeft"
        />
        <q-toolbar-title class="text-weight-bold">{{
          $t(Activity.title)
        }}</q-toolbar-title>
        <!-- <q-btn
          to="/help"
          flat
          round
          dense
          icon="las la-question-circle"
          color="blue"
        /> -->
        <NotiButton ref="noti_button"></NotiButton>
      </q-toolbar>
    </q-header>
    <q-drawer v-model="drawerLeft" :width="230">
      <div class="absolute-top" style="height: 80px">
        <div class="absolute-bottom bg-transparent q-pa-sm q-pl-md">
          <div class="row inline items-center q-col-gutter-md">
            <div class="col-3">
              <q-avatar size="40px">
                <q-img :src="data.avatar" fit="cover" spinner-size="20px">
                  <template v-slot:error>
                    <img src="~assets/user@2x.png" />
                  </template>
                </q-img>
              </q-avatar>
            </div>
            <div class="col">
              <div class="text-med text-weight-bold ellipsis">
                {{ data.first_name }} {{ data.last_name }}
              </div>
              <div class="text-med font12 ellipsis">
                {{ data.email_address }}
              </div>
            </div>
          </div>
        </div>
      </div>
      <q-scroll-area
        class="fit"
        style="padding-top: 80px"
        :style="
          $q.dark.mode
            ? 'border-right:1px solid rgba(255, 255, 255, 0.28);'
            : 'border-right: 1px solid #ddd'
        "
      >
        <q-separator></q-separator>
        <q-list padding class="left-menu">
          <q-item
            clickable
            @click="drawerLeft = !drawerLeft"
            v-ripple
            to="/home"
          >
            <q-item-section avatar>
              <q-icon name="las la-home" color="grey-6" />
            </q-item-section>
            <q-item-section class="text-weight-medium">{{
              $t("Home")
            }}</q-item-section>
            <q-item-section avatar side>
              <q-avatar
                :color="$q.dark.mode ? 'grey600' : 'orange-1'"
                :text-color="$q.dark.mode ? 'grey300' : 'orange'"
                :icon="
                  Activity.rtl ? 'las la-angle-left' : 'las la-angle-right'
                "
                size="xs"
              />
            </q-item-section>
          </q-item>

          <template v-if="!Activity.settings_data.on_demand_availability">
            <template v-if="data.employment_type == 'contractor'">
              <q-item
                clickable
                v-ripple
                to="/home/find_schedule"
                @click="drawerLeft = !drawerLeft"
              >
                <q-item-section avatar>
                  <q-icon name="las la-calendar" color="grey-6" />
                </q-item-section>
                <q-item-section class="text-weight-medium">{{
                  $t("Schedule")
                }}</q-item-section>
                <q-item-section avatar side>
                  <q-avatar
                    :color="$q.dark.mode ? 'grey600' : 'orange-1'"
                    :text-color="$q.dark.mode ? 'grey300' : 'orange'"
                    :icon="
                      Activity.rtl ? 'las la-angle-left' : 'las la-angle-right'
                    "
                    size="xs"
                  />
                </q-item-section>
              </q-item>
            </template>

            <template v-else>
              <q-item
                clickable
                v-ripple
                to="/home/schedule"
                @click="drawerLeft = !drawerLeft"
              >
                <q-item-section avatar>
                  <q-icon name="las la-calendar" color="grey-6" />
                </q-item-section>
                <q-item-section class="text-weight-medium">{{
                  $t("My Schedule")
                }}</q-item-section>
                <q-item-section avatar side>
                  <q-avatar
                    color="orange-1"
                    text-color="orange"
                    :icon="
                      Activity.rtl ? 'las la-angle-left' : 'las la-angle-right'
                    "
                    size="xs"
                  />
                </q-item-section>
              </q-item>
            </template>
          </template>

          <q-item
            clickable
            v-ripple
            to="/home/earning"
            @click="drawerLeft = !drawerLeft"
          >
            <q-item-section avatar>
              <q-icon name="las la-hand-holding-usd" color="grey-6" />
            </q-item-section>
            <q-item-section class="text-weight-medium">{{
              $t("Earnings")
            }}</q-item-section>
            <q-item-section avatar side>
              <q-avatar
                :color="$q.dark.mode ? 'grey600' : 'orange-1'"
                :text-color="$q.dark.mode ? 'grey300' : 'orange'"
                :icon="
                  Activity.rtl ? 'las la-angle-left' : 'las la-angle-right'
                "
                size="xs"
              />
            </q-item-section>
          </q-item>

          <q-item
            clickable
            v-ripple
            @click="drawerLeft = !drawerLeft"
            to="/home/settings"
          >
            <q-item-section avatar>
              <q-icon name="las la-user" color="grey-6" />
            </q-item-section>
            <q-item-section class="text-weight-medium">{{
              $t("Account")
            }}</q-item-section>
            <q-item-section avatar side>
              <q-avatar
                :color="$q.dark.mode ? 'grey600' : 'orange-1'"
                :text-color="$q.dark.mode ? 'grey300' : 'orange'"
                :icon="
                  Activity.rtl ? 'las la-angle-left' : 'las la-angle-right'
                "
                size="xs"
              />
            </q-item-section>
          </q-item>

          <q-item
            clickable
            v-ripple
            to="/home/legal"
            @click="drawerLeft = !drawerLeft"
          >
            <q-item-section avatar>
              <q-icon name="las la-balance-scale" color="grey-6" />
            </q-item-section>
            <q-item-section class="text-weight-medium">{{
              $t("Legal")
            }}</q-item-section>
            <q-item-section avatar side>
              <q-avatar
                :color="$q.dark.mode ? 'grey600' : 'orange-1'"
                :text-color="$q.dark.mode ? 'grey300' : 'orange'"
                :icon="
                  Activity.rtl ? 'las la-angle-left' : 'las la-angle-right'
                "
                size="xs"
              />
            </q-item-section>
          </q-item>
          <!-- <q-separator /> -->

          <q-item clickable v-ripple @click="confirmLogout">
            <q-item-section avatar>
              <q-icon name="las la-sign-out-alt" color="grey-6" />
            </q-item-section>
            <q-item-section class="text-weight-medium">{{
              $t("Logout")
            }}</q-item-section>
            <q-item-section avatar side>
              <q-avatar
                :color="$q.dark.mode ? 'grey600' : 'orange-1'"
                :text-color="$q.dark.mode ? 'grey300' : 'orange'"
                :icon="
                  Activity.rtl ? 'las la-angle-left' : 'las la-angle-right'
                "
                size="xs"
              />
            </q-item-section>
          </q-item>
          <!-- <q-separator /> -->
        </q-list>
      </q-scroll-area>
    </q-drawer>

    <q-footer bordered class="bg-white text-dark modified-footer">
      <TabMenu ref="tabmenu"> </TabMenu>
    </q-footer>

    <q-page-container
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
      }"
    >
      <LocationTracker ref="location_tracker"></LocationTracker>
      <router-view />
    </q-page-container>

    <ConfirmDialog
      ref="confirm_dialog"
      :data="data_dialog"
      @after-confirm="afterConfirm"
    ></ConfirmDialog>
  </q-layout>
</template>

<script>
import { Device } from "@capacitor/device";
import { defineComponent } from "vue";
import { defineAsyncComponent } from "vue";
import { useActivityStore } from "stores/ActivityStore";
import auth from "src/api/auth";
import APIinterface from "src/api/APIinterface";
import { useScheduleStore } from "stores/ScheduleStore";
import { DeliveryOverviewStore } from "stores/DeliveryOverviewStore";
import { ReviewOverviewStore } from "stores/ReviewOverviewStore";
import { FCM } from "@capacitor-community/fcm";
import { KeepAwake } from "@capacitor-community/keep-awake";

export default defineComponent({
  name: "MainLayout",
  components: {
    TabMenu: defineAsyncComponent(() => import("components/TabMenu.vue")),
    NotiButton: defineAsyncComponent(() => import("components/NotiButton.vue")),
    LocationTracker: defineAsyncComponent(() =>
      import("components/LocationTracker.vue")
    ),
    ConfirmDialog: defineAsyncComponent(() =>
      import("components/ConfirmDialog.vue")
    ),
  },
  setup() {
    const Activity = useActivityStore();
    const Schedule = useScheduleStore();
    const DeliveryOverview = DeliveryOverviewStore();
    const ReviewOverview = ReviewOverviewStore();
    return { Activity, Schedule, DeliveryOverview, ReviewOverview };
  },
  data() {
    return {
      drawerLeft: false,
      data: [],

      data_dialog: {
        title: this.$t("Sign Out"),
        subtitle: this.$t("Do you want to logout?"),
        cancel: this.$t("Cancel"),
        confirm: this.$t("Log out"),
      },
    };
  },
  created() {
    this.data = auth.getUser();
    if (this.$q.capacitor) {
      this.DeviceInit();
      this.setAwake();
    }
    this.$q.dark.set(this.Activity.dark_mode);
  },
  methods: {
    confirmLogout() {
      this.drawerLeft = false;
      this.$refs.confirm_dialog.dialog = true;
    },
    afterConfirm() {
      this.$refs.confirm_dialog.dialog = false;
      this.logout();
    },
    logout() {
      if (this.$q.capacitor) {
        this.$refs.location_tracker.stopWacthers();
      } else {
        this.$refs.location_tracker.clearWatch();
      }

      this.Schedule.clearData();
      this.DeliveryOverview.clearData();
      this.ReviewOverview.clearData();
      APIinterface.setSession("skip_location", "");

      let $user_data = auth.getUser();
      if ($user_data && this.$q.capacitor) {
        this.unsubscribeToTopic($user_data.driver_uuid);
      }

      auth.logout();
      this.$router.replace("/user/login");
    },
    DeviceInit() {
      const $deviceToken = APIinterface.getSession("device_token");
      const $isRegistered = APIinterface.getSession("device_registered");
      const $isRegisteredAuth = APIinterface.getSession(
        "device_registered_auth"
      );

      if (auth.authenticated()) {
        if ($isRegisteredAuth !== 1) {
          Device.getId().then((data) => {
            Device.getInfo().then((Info) => {
              this.updateDevice($deviceToken, data.identifier, Info.platform);
            });
          });
        }
      } else {
        if ($isRegistered !== 1) {
          Device.getId().then((data) => {
            Device.getInfo().then((Info) => {
              this.registerDevice($deviceToken, data.identifier, Info.platform);
            });
          });
        }
      }

      this.subsribeDevice();
      //
    },
    registerDevice(token, deviceUuid, platform) {
      APIinterface.fetchDataByBearer("registerDevice", {
        token: token,
        device_uiid: deviceUuid,
        platform: platform,
      }).then((data) => {
        APIinterface.setSession("device_registered", 1);
        //alert(JSON.stringify(data));
      });
    },
    updateDevice(token, deviceUuid, platform) {
      APIinterface.fetchDataByToken("updateDevice", {
        token: token,
        device_uiid: deviceUuid,
        platform: platform,
      })
        .then((data) => {
          APIinterface.setSession("device_registered_auth", 1);
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        });
    },
    subsribeDevice() {
      let $user_data = auth.getUser();
      if ($user_data && !this.Activity.push_off) {
        FCM.subscribeTo({ topic: $user_data.driver_uuid })
          .then((r) => {
            this.Activity.push_notifications = true;
          })
          .catch((error) => {
            this.Activity.push_notifications = false;
            APIinterface.notify(
              "dark",
              "Error subscribing topics" + JSON.stringify(error),
              "warning",
              this.$q
            );
          });
      }
    },
    unsubscribeToTopic(data) {
      FCM.unsubscribeFrom({ topic: data })
        .then(() => {
          this.DataStore.push_notifications = false;
        })
        .catch((err) => {});
    },
    async setAwake() {
      if (this.Activity.keep_awake) {
        const result = await KeepAwake.keepAwake();
      } else {
        const result = await KeepAwake.allowSleep();
      }
    },
    //
  },
});
</script>
