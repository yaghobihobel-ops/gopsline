<template>
  <q-page>
    <q-list>
      <q-item>
        <q-item-section avatar top>
          <q-img
            :src="user_data?.avatar"
            style="height: 50px; width: 50px"
            loading="lazy"
            fit="cover"
            class="radius8"
          >
            <template v-slot:loading>
              <q-skeleton height="50px" width="50px" square class="bg-grey-2" />
            </template>
          </q-img>
        </q-item-section>
        <q-item-section top>
          <q-item-label class="text-capitalize">
            {{ user_data?.first_name }}
          </q-item-label>
          <q-item-label>
            <q-btn flat no-caps padding="0px" to="/account/edit-profile">
              <div class="text-grey text-weight-medium text-caption">
                {{ $t("Edit Profile") }}
              </div>
              <q-icon :name="getIconDirections" color="grey-4"></q-icon>
            </q-btn>
          </q-item-label>
        </q-item-section>
      </q-item>
    </q-list>
    <q-space class="q-pa-sm"></q-space>

    <q-card
      flat
      class="beautiful-shadow border-greyx q-pl-md q-pr-md no-border-radius"
    >
      <q-tabs
        v-model="shortcut_nav"
        no-caps
        indicator-color="transparent"
        align="justify"
        :breakpoint="0"
        active-bg-color="grey-1"
      >
        <q-route-tab name="campaigns" class="q-pt-sm q-pb-sm" to="/campaigns">
          <template v-slot:default>
            <q-btn
              icon="campaign"
              round
              color="blue-grey-1"
              text-color="blue-grey-8"
              unelevated
              dense
            />
            <div class="text-caption q-mt-sm">{{ $t("Campaigns") }}</div>
          </template>
        </q-route-tab>

        <q-route-tab name="printer" to="/settings/printers">
          <template v-slot:default>
            <q-btn
              icon="o_local_printshop"
              round
              color="blue-grey-1"
              text-color="blue-grey-8"
              unelevated
              dense
            />
            <div class="text-caption q-mt-sm">{{ $t("Printers") }}</div>
          </template>
        </q-route-tab>

        <q-route-tab name="chat" to="/chat">
          <template v-slot:default>
            <q-btn
              icon="o_textsms"
              round
              color="blue-grey-1"
              text-color="blue-grey-8"
              unelevated
              dense
            />
            <div class="text-caption q-mt-sm">{{ $t("Chat") }}</div>
          </template>
        </q-route-tab>

        <q-route-tab name="orders" @click="this.$refs.ref_logout.confirm()">
          <template v-slot:default>
            <q-btn
              icon="o_key"
              round
              color="blue-grey-1"
              text-color="blue-grey-8"
              unelevated
              dense
            />
            <div class="text-caption q-mt-sm">{{ $t("Logout") }}</div>
          </template>
        </q-route-tab>
      </q-tabs>
    </q-card>

    <q-list>
      <q-item-label header>{{ $t("Account") }}</q-item-label>
      <q-item clickable to="/account/edit-profile">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/profile1.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t("Profile") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
        </q-item-section>
      </q-item>

      <q-item clickable to="/account/change-password">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/password.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t("Change Password") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
        </q-item-section>
      </q-item>

      <q-item clickable to="/account/delete">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/delete-account.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t("Delete Account") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
        </q-item-section>
      </q-item>

      <q-item-label header>{{ $t("App Preferences") }}</q-item-label>

      <q-item clickable to="/account/language">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/globe.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t("Language") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
        </q-item-section>
      </q-item>

      <q-item clickable class="hidden">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/dark-mode.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t("Dark Mode") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-toggle
            v-model="theme_mode"
            color="primary"
            @update:model-value="updateDarkmode"
          />
        </q-item-section>
      </q-item>

      <q-item clickable @click="changeDirection">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/rtl.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label
            >{{ $t("Direction") }} (
            {{ rtl ? $t("LTR") : $t("RTL") }} )</q-item-label
          >
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
        </q-item-section>
      </q-item>

      <q-item-label header>{{ $t("Food Management") }}</q-item-label>

      <q-item clickable to="/manage/items">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/food_items.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t("Food Items") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
        </q-item-section>
      </q-item>

      <q-item clickable to="/manage/category">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/food_category.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t("Category") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
        </q-item-section>
      </q-item>

      <q-item clickable to="/manage/addoncategory">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/food_addoncategory.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t("Addon Category") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
        </q-item-section>
      </q-item>

      <q-item clickable to="/manage/addonitems">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/food_addonitems.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t("Addon Items") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
        </q-item-section>
      </q-item>

      <q-item clickable to="/manage/size">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/food_size.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t("Size") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
        </q-item-section>
      </q-item>

      <q-item clickable to="/manage/ingredients">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/food_ingredients.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t("Ingredients") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
        </q-item-section>
      </q-item>

      <q-item clickable to="/manage/cookingref">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/food_cooking_ref.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t("Cooking Reference") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
        </q-item-section>
      </q-item>

      <q-item-label header>{{ $t("Orders & Services") }}</q-item-label>

      <q-expansion-item
        v-if="AccessStore.hasAccess('services.settings')"
        expand-icon-class="text-grey-4"
      >
        <template v-slot:header>
          <q-item-section avatar class="itemsection-dense">
            <img src="/svg/orders.svg" width="25" height="25" />
          </q-item-section>
          <q-item-section>
            <q-item-label>{{ $t("Order Type") }}</q-item-label>
          </q-item-section>
        </template>
        <template v-slot:default>
          <div class="q-pl-lg">
            <q-item clickable to="/services/delivery_settings">
              <q-item-section avatar class="itemsection-dense">
                <img src="/svg/delivery.svg" width="25" height="25" />
              </q-item-section>
              <q-item-section>
                <q-item-label>{{ $t("Delivery") }}</q-item-label>
              </q-item-section>
              <q-item-section side>
                <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
              </q-item-section>
            </q-item>

            <q-item clickable to="/services/settings_pickup">
              <q-item-section avatar class="itemsection-dense">
                <img src="/svg/pickup.svg" width="25" height="25" />
              </q-item-section>
              <q-item-section>
                <q-item-label>{{ $t("Pickup") }}</q-item-label>
              </q-item-section>
              <q-item-section side>
                <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
              </q-item-section>
            </q-item>

            <q-item clickable to="/services/settings_dinein">
              <q-item-section avatar class="itemsection-dense">
                <img src="/svg/dinein.svg" width="25" height="25" />
              </q-item-section>
              <q-item-section>
                <q-item-label>{{ $t("Dinein") }}</q-item-label>
              </q-item-section>
              <q-item-section side>
                <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
              </q-item-section>
            </q-item>
          </div>
        </template>
      </q-expansion-item>

      <q-item clickable to="/settings/printers">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/printer.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t("Printers") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
        </q-item-section>
      </q-item>

      <q-item clickable @click="this.$refs.ref_notification.modal = true">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/push-notification.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t("Notifications Settings") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
        </q-item-section>
      </q-item>

      <q-item-label header>{{ $t("Campaigns") }}</q-item-label>

      <q-item clickable to="/campaigns/points_settings">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/points.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t("Loyalty Points") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
        </q-item-section>
      </q-item>

      <q-item clickable to="/campaigns/suggested_items">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/suggested-item.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t("Suggested Items") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
        </q-item-section>
      </q-item>

      <q-item clickable to="/campaigns/free_item">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/free-item.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t("Spend-Based Free Item") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
        </q-item-section>
      </q-item>

      <template v-if="AccessStore.hasAccess('promo')">
        <q-item-label header>{{ $t("Promotions") }}</q-item-label>

        <q-item clickable to="/promo/coupon-list">
          <q-item-section avatar class="itemsection-dense">
            <img src="/svg/coupon.svg" width="25" height="25" />
          </q-item-section>
          <q-item-section>
            <q-item-label>{{ $t("Coupons") }}</q-item-label>
          </q-item-section>
          <q-item-section side>
            <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
          </q-item-section>
        </q-item>

        <q-item clickable to="/promo/offers-list">
          <q-item-section avatar class="itemsection-dense">
            <img src="/svg/offers.svg" width="25" height="25" />
          </q-item-section>
          <q-item-section>
            <q-item-label>{{ $t("Offers") }}</q-item-label>
          </q-item-section>
          <q-item-section side>
            <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
          </q-item-section>
        </q-item>
      </template>

      <template v-if="AccessStore.hasAccess('merchant.images')">
        <q-item-label header>{{ $t("Media") }}</q-item-label>
        <q-item clickable to="/images/gallery">
          <q-item-section avatar class="itemsection-dense">
            <img src="/svg/gallery.svg" width="25" height="25" />
          </q-item-section>
          <q-item-section>
            <q-item-label>{{ $t("Gallery") }}</q-item-label>
          </q-item-section>
          <q-item-section side>
            <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
          </q-item-section>
        </q-item>

        <q-item clickable to="/images/media_library">
          <q-item-section avatar class="itemsection-dense">
            <img src="/svg/media.svg" width="25" height="25" />
          </q-item-section>
          <q-item-section>
            <q-item-label>{{ $t("Media") }}</q-item-label>
          </q-item-section>
          <q-item-section side>
            <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
          </q-item-section>
        </q-item>
      </template>

      <template v-if="AccessStore.hasAccess('reports')">
        <q-item-label header>{{ $t("Reports & Invoices") }}</q-item-label>

        <q-item clickable to="/reports/dailysalesreport">
          <q-item-section avatar class="itemsection-dense">
            <img src="/svg/report.svg" width="25" height="25" />
          </q-item-section>
          <q-item-section>
            <q-item-label>{{ $t("Daily Reports") }}</q-item-label>
          </q-item-section>
          <q-item-section side>
            <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
          </q-item-section>
        </q-item>

        <q-item clickable to="/reports/sales">
          <q-item-section avatar class="itemsection-dense">
            <img src="/svg/report.svg" width="25" height="25" />
          </q-item-section>
          <q-item-section>
            <q-item-label>{{ $t("Sales Reports") }}</q-item-label>
          </q-item-section>
          <q-item-section side>
            <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
          </q-item-section>
        </q-item>

        <q-item clickable to="/reports/summary">
          <q-item-section avatar class="itemsection-dense">
            <img src="/svg/report.svg" width="25" height="25" />
          </q-item-section>
          <q-item-section>
            <q-item-label>{{ $t("Summary Reports") }}</q-item-label>
          </q-item-section>
          <q-item-section side>
            <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
          </q-item-section>
        </q-item>

        <q-item clickable to="/invoice/list">
          <q-item-section avatar class="itemsection-dense">
            <img src="/svg/invoice.svg" width="25" height="25" />
          </q-item-section>
          <q-item-section>
            <q-item-label>{{ $t("Invoices") }}</q-item-label>
          </q-item-section>
          <q-item-section side>
            <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
          </q-item-section>
        </q-item>
      </template>

      <q-item-label header>{{ $t("Legal & Help") }}</q-item-label>
      <q-item clickable to="/account/page/merchant_page_privacy_policy">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/privacy.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t("Privacy Policy") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
        </q-item-section>
      </q-item>

      <q-item clickable to="/account/page/merchant_page_terms">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/terms.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t("Terms & Conditions") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
        </q-item-section>
      </q-item>

      <q-item clickable to="/account/page/merchant_page_aboutus">
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/info.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t("About Us") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" :name="getIconDirections" />
        </q-item-section>
      </q-item>
    </q-list>

    <q-space class="q-pa-md"></q-space>

    <NotificationSettings ref="ref_notification"></NotificationSettings>

    <DeleteComponents
      ref="ref_logout"
      :title="$t('Sign Out')"
      :subtitle="$t('Do you want to logout?')"
      :cancel="$t('Cancel')"
      :deleteText="$t('Log out?')"
      @after-confirm="Logout"
    >
    </DeleteComponents>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useUserStore } from "stores/UserStore";
import { useDataStore } from "stores/DataStore";
import { useDataPersisted } from "stores/DataPersisted";
import { useOrderStore } from "stores/OrderStore";
import { useAccessStore } from "stores/AccessStore";
import { loadAppSettings } from "src/api/SettingsLoader";
import auth from "src/api/auth";
import { Device } from "@capacitor/device";
import { App } from "@capacitor/app";

export default {
  name: "AccountMenu",
  components: {
    DeleteComponents: defineAsyncComponent(() =>
      import("components/DeleteComponents.vue")
    ),
    NotificationSettings: defineAsyncComponent(() =>
      import("components/NotificationSettings.vue")
    ),
  },
  setup(props) {
    const UserStore = useUserStore();
    const DataStore = useDataStore();
    const DataPersisted = useDataPersisted();
    const OrderStore = useOrderStore();
    const AccessStore = useAccessStore();
    return { UserStore, DataStore, DataPersisted, OrderStore, AccessStore };
  },
  data() {
    return {
      shortcut_nav: "orders",
      isScrolled: false,
      user_data: null,
      theme_mode: false,
      rtl: false,
    };
  },
  mounted() {
    this.DataStore.page_title = this.$t("Account Menu");
    if (!auth.authenticated()) {
      this.$router.replace("/login");
      return;
    }

    this.user_data = auth.getUser();
    this.theme_mode = this.DataPersisted.dark_mode;
    this.rtl = this.DataPersisted.rtl;
    this.keep_awake = this.DataPersisted.keep_awake;
  },
  computed: {
    getIconDirections() {
      return this.rtl ? "keyboard_arrow_left" : "keyboard_arrow_right";
    },
  },
  methods: {
    async Logout() {
      const merchant_uuid = this.user_data?.merchant_uuid;

      this.OrderStore.stopAllFallback();

      this.OrderStore.clearCache();
      this.DataStore.clearCache();
      this.UserStore.clearCache();
      this.AccessStore.clearCache();
      this.DataPersisted.clearCache();

      this.DataStore.fcmSubscribed = false;

      try {
        await loadAppSettings();
      } catch (error) {
        console.error("Error loading settings:", error);
      }

      this.reLoadSettings();

      if (this.$q.capacitor) {
        try {
          await FCM.unsubscribeFrom({
            topic: merchant_uuid,
          });
        } catch (error) {}
      }
      auth.logout();
      this.$router.replace("/login");
    },
    changeDirection() {
      this.rtl = !this.rtl;
      this.DataPersisted.rtl = this.rtl;
      this.$q.lang.set({ rtl: this.rtl });
    },
    updateDarkmode(value) {
      this.$q.dark.set(value);
      this.DataPersisted.dark_mode = value;
    },
    async reLoadSettings() {
      if (!this.$q.capacitor) {
        return;
      }

      try {
        const info = await Device.getLanguageCode();
        this.DataStore.device_language = info.value;
      } catch (error) {}

      try {
        const result = await App.getInfo();
        this.DataStore.app_version = result.version;
      } catch (error) {}

      try {
        const info = await Device.getInfo();
        this.DataStore.osVersion = info.osVersion;
      } catch (error) {}
    },
  },
};
</script>
