<template>
  <div class="q-pa-md flex justify-between items-end full-width">
    <div class="borderx">
      <div class="text-h6 text-weight-bold">
        {{ $t("Hello") }}, {{ user_data.first_name }}
      </div>
      <div class="line-1">{{ $t("Account Settings") }}</div>
    </div>
    <div class="borderx">
      <q-avatar size="60px">
        <img :src="user_data.avatar" />
      </q-avatar>
    </div>
  </div>

  <q-list>
    <q-item clickable v-ripple to="/account/edit-profile">
      <q-item-section avatar>
        <q-avatar
          color="primary"
          text-color="white"
          icon="las la-user-alt"
          size="md"
        />
      </q-item-section>
      <q-item-section>{{ $t("Manage Profile") }}</q-item-section>
      <q-item-section side>
        <q-btn
          round
          unelevated
          text-color="dark"
          :icon="rtl ? 'las la-angle-left' : 'las la-angle-right'"
          dense
          class="text-grey-5 font13"
        />
      </q-item-section>
    </q-item>
    <q-item clickable v-ripple to="/account/change-password">
      <q-item-section avatar>
        <q-avatar
          color="primary"
          text-color="white"
          icon="las la-lock"
          size="md"
        />
      </q-item-section>
      <q-item-section>{{ $t("Change Password") }}</q-item-section>
      <q-item-section side>
        <q-btn
          round
          unelevated
          text-color="dark"
          :icon="rtl ? 'las la-angle-left' : 'las la-angle-right'"
          dense
          class="text-grey-5 font13"
        />
      </q-item-section>
    </q-item>
    <q-item clickable v-ripple>
      <q-item-section avatar>
        <q-avatar
          color="primary"
          text-color="white"
          icon="las la-bell"
          size="md"
        />
      </q-item-section>
      <q-item-section>{{ $t("Push Notifications") }} </q-item-section>
      <q-item-section side>
        <q-toggle
          v-model="push_notifications"
          color="secondary"
          @update:model-value="Updateaccountnotification"
        />
      </q-item-section>
    </q-item>

    <q-item clickable v-ripple v-if="is_awake_supported && $q.capacitor">
      <q-item-section avatar>
        <q-avatar
          color="primary"
          text-color="white"
          icon="las la-bell"
          size="md"
        />
      </q-item-section>
      <q-item-section>{{ $t("Keep Awake") }} </q-item-section>
      <q-item-section side>
        <q-toggle
          v-model="keep_awake"
          color="secondary"
          @update:model-value="setAwake"
        />
      </q-item-section>
    </q-item>

    <q-item clickable v-ripple to="/settings/printers">
      <q-item-section avatar>
        <q-avatar
          color="primary"
          text-color="white"
          icon="las la-print"
          size="md"
        />
      </q-item-section>
      <q-item-section>{{ $t("Printers") }}</q-item-section>
      <q-item-section side>
        <q-btn
          round
          unelevated
          text-color="dark"
          :icon="rtl ? 'las la-angle-left' : 'las la-angle-right'"
          dense
          class="text-grey-5 font13"
        />
      </q-item-section>
    </q-item>

    <q-expansion-item
      v-if="AccessStore.hasAccess('services.settings')"
      expand-separator
      expand-icon="las la-angle-down"
      expand-icon-class="text-grey-5 font13  q-pr-sm"
    >
      <template v-slot:header>
        <q-item class="fit q-pa-none">
          <q-item-section avatar>
            <q-avatar
              color="primary"
              text-color="white"
              icon="las la-file-invoice-dollar"
              size="md"
            />
          </q-item-section>
          <q-item-section>
            <q-item-label>
              {{ $t("Order Type") }}
            </q-item-label>
          </q-item-section>
        </q-item>
      </template>
      <template v-slot:default>
        <q-list dense>
          <q-item clickable to="/services/delivery_settings">
            <q-item-section>
              <q-item-label>{{ $t("Delivery") }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-btn
                round
                unelevated
                text-color="dark"
                :icon="rtl ? 'las la-angle-left' : 'las la-angle-right'"
                dense
                class="text-grey-5 font13"
              />
            </q-item-section>
          </q-item>
          <q-item clickable to="/services/charges_table">
            <q-item-section>
              <q-item-label>{{ $t("Rates") }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-btn
                round
                unelevated
                text-color="dark"
                :icon="rtl ? 'las la-angle-left' : 'las la-angle-right'"
                dense
                class="text-grey-5 font13"
              />
            </q-item-section>
          </q-item>
          <q-item clickable to="/services/settings_pickup">
            <q-item-section>
              <q-item-label>{{ $t("Pickup") }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-btn
                round
                unelevated
                text-color="dark"
                :icon="rtl ? 'las la-angle-left' : 'las la-angle-right'"
                dense
                class="text-grey-5 font13"
              />
            </q-item-section>
          </q-item>
          <q-item clickable to="/services/settings_dinein">
            <q-item-section>
              <q-item-label>{{ $t("Dinein") }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-btn
                round
                unelevated
                text-color="dark"
                :icon="rtl ? 'las la-angle-left' : 'las la-angle-right'"
                dense
                class="text-grey-5 font13"
              />
            </q-item-section>
          </q-item>
        </q-list>
      </template>
    </q-expansion-item>

    <q-expansion-item
      v-if="user_data.merchant_type == 1"
      expand-separator
      expand-icon="las la-angle-down"
      expand-icon-class="text-grey-5 font13  q-pr-sm"
    >
      <template v-slot:header>
        <q-item class="fit q-pa-none">
          <q-item-section avatar>
            <q-avatar
              color="primary"
              text-color="white"
              icon="o_payments"
              size="md"
            />
          </q-item-section>
          <q-item-section>
            <q-item-label>
              {{ $t("Payment") }}
            </q-item-label>
          </q-item-section>
        </q-item>
      </template>
      <template v-slot:default>
        <q-list dense>
          <q-item clickable to="/payment/payment_list">
            <q-item-section>
              <q-item-label>{{ $t("All Payment") }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-btn
                round
                unelevated
                text-color="dark"
                :icon="rtl ? 'las la-angle-left' : 'las la-angle-right'"
                dense
                class="text-grey-5 font13"
              />
            </q-item-section>
          </q-item>
          <q-item clickable to="/payment/bank_deposit">
            <q-item-section>
              <q-item-label>{{ $t("Bank Deposit") }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-btn
                round
                unelevated
                text-color="dark"
                :icon="rtl ? 'las la-angle-left' : 'las la-angle-right'"
                dense
                class="text-grey-5 font13"
              />
            </q-item-section>
          </q-item>
        </q-list>
      </template>
    </q-expansion-item>

    <!-- PROMO -->
    <q-expansion-item
      v-if="AccessStore.hasAccess('promo')"
      expand-separator
      expand-icon="las la-angle-down"
      expand-icon-class="text-grey-5 font13  q-pr-sm"
    >
      <template v-slot:header>
        <q-item class="fit q-pa-none">
          <q-item-section avatar>
            <q-avatar
              color="primary"
              text-color="white"
              icon="las la-tag"
              size="md"
            />
          </q-item-section>
          <q-item-section>
            <q-item-label>
              {{ $t("Promo") }}
            </q-item-label>
          </q-item-section>
        </q-item>
      </template>
      <template v-slot:default>
        <q-list dense>
          <q-item clickable to="/promo/coupon-list">
            <q-item-section>
              <q-item-label>{{ $t("Coupon") }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-btn
                round
                unelevated
                text-color="dark"
                :icon="rtl ? 'las la-angle-left' : 'las la-angle-right'"
                dense
                class="text-grey-5 font13"
              />
            </q-item-section>
          </q-item>
          <q-item clickable to="/promo/offers-list">
            <q-item-section>
              <q-item-label>{{ $t("Offers") }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-btn
                round
                unelevated
                text-color="dark"
                :icon="rtl ? 'las la-angle-left' : 'las la-angle-right'"
                dense
                class="text-grey-5 font13"
              />
            </q-item-section>
          </q-item>
        </q-list>
      </template>
    </q-expansion-item>
    <!-- PROMO -->

    <!-- IMAGES -->
    <q-expansion-item
      v-if="AccessStore.hasAccess('merchant.images')"
      expand-separator
      expand-icon="las la-angle-down"
      expand-icon-class="text-grey-5 font13  q-pr-sm"
    >
      <template v-slot:header>
        <q-item class="fit q-pa-none">
          <q-item-section avatar>
            <q-avatar
              color="primary"
              text-color="white"
              icon="collections"
              size="md"
            />
          </q-item-section>
          <q-item-section>
            <q-item-label>
              {{ $t("Images") }}
            </q-item-label>
          </q-item-section>
        </q-item>
      </template>
      <template v-slot:default>
        <q-list dense>
          <q-item clickable to="/images/gallery">
            <q-item-section>
              <q-item-label>{{ $t("Gallery") }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-btn
                round
                unelevated
                text-color="dark"
                :icon="rtl ? 'las la-angle-left' : 'las la-angle-right'"
                dense
                class="text-grey-5 font13"
              />
            </q-item-section>
          </q-item>
          <q-item clickable to="/images/media_library">
            <q-item-section>
              <q-item-label>{{ $t("Media") }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-btn
                round
                unelevated
                text-color="dark"
                :icon="rtl ? 'las la-angle-left' : 'las la-angle-right'"
                dense
                class="text-grey-5 font13"
              />
            </q-item-section>
          </q-item>
        </q-list>
      </template>
    </q-expansion-item>
    <!-- IMAGES -->

    <!-- INVOICE -->
    <q-item
      v-if="AccessStore.hasAccess('invoice')"
      clickable
      v-ripple
      to="/invoice/list"
    >
      <q-item-section avatar>
        <q-avatar
          color="primary"
          text-color="white"
          icon="las la-file-invoice"
          size="md"
        />
      </q-item-section>
      <q-item-section> {{ $t("Invoice") }} </q-item-section>
      <q-item-section side>
        <q-btn
          round
          unelevated
          text-color="dark"
          :icon="rtl ? 'las la-angle-left' : 'las la-angle-right'"
          dense
          class="text-grey-5 font13"
        />
      </q-item-section>
    </q-item>
    <!-- INVOICE -->

    <!-- REPORTS -->
    <q-expansion-item
      v-if="AccessStore.hasAccess('reports')"
      expand-separator
      expand-icon="las la-angle-down"
      expand-icon-class="text-grey-5 font13  q-pr-sm"
    >
      <template v-slot:header>
        <q-item class="fit q-pa-none">
          <q-item-section avatar>
            <q-avatar
              color="primary"
              text-color="white"
              icon="article"
              size="md"
            />
          </q-item-section>
          <q-item-section>
            <q-item-label>
              {{ $t("Reports") }}
            </q-item-label>
          </q-item-section>
        </q-item>
      </template>
      <template v-slot:default>
        <q-list dense>
          <q-item clickable to="/reports/dailysalesreport">
            <q-item-section>
              <q-item-label>{{ $t("Daily") }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-btn
                round
                unelevated
                text-color="dark"
                :icon="rtl ? 'las la-angle-left' : 'las la-angle-right'"
                dense
                class="text-grey-5 font13"
              />
            </q-item-section>
          </q-item>
          <q-item clickable to="/reports/sales">
            <q-item-section>
              <q-item-label>{{ $t("Sales") }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-btn
                round
                unelevated
                text-color="dark"
                :icon="rtl ? 'las la-angle-left' : 'las la-angle-right'"
                dense
                class="text-grey-5 font13"
              />
            </q-item-section>
          </q-item>
          <q-item clickable to="/reports/summary">
            <q-item-section>
              <q-item-label>{{ $t("Summary") }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-btn
                round
                unelevated
                text-color="dark"
                :icon="rtl ? 'las la-angle-left' : 'las la-angle-right'"
                dense
                class="text-grey-5 font13"
              />
            </q-item-section>
          </q-item>
        </q-list>
      </template>
    </q-expansion-item>
    <!-- REPORTS -->

    <q-item
      v-if="DataStore.enabled_language"
      clickable
      v-ripple
      to="/account/language"
    >
      <q-item-section avatar>
        <q-avatar
          color="primary"
          text-color="white"
          icon="las la-globe"
          size="md"
        />
      </q-item-section>
      <q-item-section> {{ $t("Language") }} </q-item-section>
      <q-item-section side v-if="DataStore.language_data">
        <template v-for="lang in DataStore.language_data.data" :key="lang">
          <q-btn
            v-if="lang.code == this.DataPersisted.app_language"
            no-caps
            :label="lang.title"
            unelevated
            text-color="dark"
            :icon-right="rtl ? 'las la-angle-left' : 'las la-angle-right'"
            dense
            class="text-grey-5 font13"
          />
        </template>
      </q-item-section>
    </q-item>

    <q-item
      v-if="DataStore.enabled_language"
      clickable
      v-ripple
      @click="rtl = !rtl"
    >
      <q-item-section avatar>
        <q-avatar
          color="primary"
          text-color="white"
          icon="format_textdirection_l_to_r"
          size="md"
        />
      </q-item-section>
      <q-item-section>{{ $t("Direction") }}</q-item-section>
      <q-item-section side>
        <q-btn
          no-caps
          :label="rtl ? $t('LRT') : $t('RTL')"
          unelevated
          text-color="dark"
          :icon-right="rtl ? 'las la-angle-left' : 'las la-angle-right'"
          dense
          class="text-grey-5 font13"
        />
      </q-item-section>
    </q-item>

    <q-item clickable v-ripple>
      <q-item-section avatar>
        <q-avatar
          color="primary"
          text-color="white"
          icon="las la-adjust"
          size="md"
        />
      </q-item-section>
      <q-item-section>{{ $t("Dark Mode") }}</q-item-section>
      <q-item-section side>
        <q-toggle
          v-model="theme_mode"
          color="secondary"
          @update:model-value="updateDarkmode"
        />
      </q-item-section>
    </q-item>

    <q-item clickable v-ripple to="/account/delete">
      <q-item-section avatar>
        <q-avatar
          color="primary"
          text-color="white"
          icon="las la-user-slash"
          size="md"
        />
      </q-item-section>
      <q-item-section>{{ $t("Delete Account") }}</q-item-section>
      <q-item-section side>
        <q-btn
          round
          unelevated
          text-color="dark"
          :icon="rtl ? 'las la-angle-left' : 'las la-angle-right'"
          dense
          class="text-grey-5 font13"
        />
      </q-item-section>
    </q-item>

    <q-item to="/account/legal" clickable v-ripple>
      <q-item-section avatar>
        <q-avatar
          color="primary"
          text-color="white"
          icon="las la-balance-scale"
          size="md"
        />
      </q-item-section>
      <q-item-section>{{ $t("Legal") }}</q-item-section>
      <q-item-section side>
        <q-btn
          round
          unelevated
          text-color="dark"
          :icon="rtl ? 'las la-angle-left' : 'las la-angle-right'"
          dense
          class="text-grey-5 font13"
        />
      </q-item-section>
    </q-item>
  </q-list>

  <div class="q-pa-md">
    <q-btn
      unelevated
      :color="$q.dark.mode ? 'grey600' : 'white'"
      :text-color="$q.dark.mode ? 'grey300' : 'dark'"
      no-caps
      class="radius8 full-width border-grey text-weight-bold"
      @click="showLogout"
      >{{ $t("Sign Out") }}</q-btn
    >
  </div>
  <LogOut ref="log_out" @after-logout="afterLogout"></LogOut>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useUserStore } from "stores/UserStore";
import { useDataStore } from "stores/DataStore";
import { useOrderStore } from "stores/OrderStore";
import { useGlobalStore } from "stores/GlobalStore";
import APIinterface from "src/api/APIinterface";
import auth from "src/api/auth";
import { useMenuStore } from "stores/MenuStore";
import { FCM } from "@capacitor-community/fcm";
import config from "src/api/config";
import { KeepAwake } from "@capacitor-community/keep-awake";
import { useAccessStore } from "stores/AccessStore";
import { useDataPersisted } from "stores/DataPersisted";

export default {
  name: "DrawerMenu",
  components: {
    LogOut: defineAsyncComponent(() => import("components/LogOut.vue")),
  },
  data() {
    return {
      push_notifications: false,
      app_push_notifications: false,
      theme_mode: false,
      local_notification: false,
      user_data: [],
      rtl: false,
      is_awake_supported: false,
      keep_awake: false,
    };
  },
  setup() {
    const UserStore = useUserStore();
    const DataStore = useDataStore();
    const MenuStore = useMenuStore();
    const AccessStore = useAccessStore();
    const OrderStore = useOrderStore();
    const GlobalStore = useGlobalStore();
    const DataPersisted = useDataPersisted();
    return {
      UserStore,
      DataStore,
      MenuStore,
      AccessStore,
      OrderStore,
      GlobalStore,
      DataPersisted,
    };
  },
  mounted() {
    this.theme_mode = this.DataPersisted.dark_mode;
    this.rtl = this.DataPersisted.rtl;
    this.keep_awake = this.DataPersisted.keep_awake;

    this.$q.dark.set(this.theme_mode);
    if (auth.authenticated()) {
      this.user_data = auth.getUser();
    }
    this.push_notifications = this.DataPersisted.enabled_push
      ? this.DataPersisted.enabled_push
      : false;

    this.getKeepAwake();
  },
  watch: {
    rtl(newval, oldval) {
      this.DataPersisted.rtl = newval;
      this.$q.lang.set({ rtl: newval });
    },
  },
  methods: {
    init() {
      this.push_notifications = this.DataPersisted.enabled_push
        ? this.DataPersisted.enabled_push
        : false;
    },
    updateDarkmode(value) {
      console.log("updateDarkmode", value);
      this.$q.dark.set(value);
      this.DataPersisted.dark_mode = value;
    },
    async getKeepAwake() {
      const result = await KeepAwake.isSupported();
      this.is_awake_supported = result.isSupported;
    },
    async setAwake(data) {
      if (this.is_awake_supported) {
        if (data) {
          await KeepAwake.keepAwake();
          this.DataPersisted.keep_awake = true;
        } else {
          await KeepAwake.allowSleep();
          this.DataPersisted.keep_awake = false;
        }
      }
    },
    showLogout() {
      this.$emit("onLogout");
      this.$refs.log_out.dialog = true;
    },
    Updateaccountnotification(value) {
      if (this.$q.capacitor) {
        if (value) {
          this.subsribeDevice();
        } else {
          let $user_data = auth.getUser();
          if ($user_data) {
            this.unsubscribeToTopic($user_data.merchant_uuid);
          }
        }
      } else {
        APIinterface.fetchDataByTokenPost(
          "Updateaccountnotification",
          "app_push_notifications=" + value
        )
          .then((data) => {
            this.DataPersisted.enabled_push = value;
          })
          .catch((error) => {})
          .then((data) => {});
      }
    },
    subsribeDevice() {
      let $user_data = auth.getUser();
      if ($user_data) {
        FCM.subscribeTo({ topic: $user_data.merchant_uuid })
          .then((r) => {
            this.DataPersisted.enabled_push = true;
          })
          .catch((error) => {
            this.DataPersisted.enabled_push = false;
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
          this.DataPersisted.enabled_push = false;
        })
        .catch((err) => {});
    },
    async afterLogout() {
      console.log("user_data", this.user_data?.merchant_uuid);

      this.DataPersisted.enabled_push = null;
      this.DataStore.earning_summary = [];
      this.MenuStore.category = [];
      this.MenuStore.addon = [];
      this.DataStore.total_order_summary = [];
      this.GlobalStore.clearEarningSummary();

      // stop ringing
      this.OrderStore.updateOrderCount(0);
      this.OrderStore.clearSavedOrderList();

      if (this.$q.capacitor) {
        try {
          await FCM.unsubscribeFrom({
            topic: this.user_data?.merchant_uuid,
          });
        } catch (error) {}
      }
      auth.logout();
      this.$router.push("/login");
    },
    initLocalNotification(value) {
      APIinterface.fetchDataByTokenPost(
        "Updatealocalnotification",
        "local_notification=" + value
      )
        .then((data) => {
          this.DataStore.local_notification = data.details.local_notification;
        })
        .catch((error) => {})
        .then((data) => {});
    },
    //
  },
};
</script>
