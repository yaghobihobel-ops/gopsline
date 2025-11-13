<template>
  <q-dialog
    v-model="modal"
    @before-show="beforeShow"
    maximized
    transition-show="slide-up"
    transition-hide="slide-down"
  >
    <q-card class="rounded-borders-top">
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <div class="q-gutter-x-sm">
          <q-btn
            icon="las la-times"
            color="grey"
            flat
            round
            dense
            v-close-popup
          />
        </div>
        <q-toolbar-title
          class="text-darkx text-weight-bold"
          style="overflow: inherit"
          :class="{
            'text-white': $q.dark.mode,
            'text-dark': !$q.dark.mode,
          }"
        >
          {{ $t("Notifications Settings") }}
        </q-toolbar-title>
      </q-toolbar>
      <q-list dense>
        <q-item tag="label" v-ripple>
          <q-item-section>
            <q-item-label>{{ $t("Push Notifications") }}</q-item-label>
          </q-item-section>
          <q-item-section avatar>
            <q-toggle
              color="blue-grey-7"
              v-model="push"
              val="1"
              @update:model-value="HandlePush"
            />
          </q-item-section>
        </q-item>
        <q-item tag="label" v-ripple v-if="$q.capacitor">
          <q-item-section>
            <q-item-label>{{ $t("Keep Awake") }}</q-item-label>
          </q-item-section>
          <q-item-section side>
            <q-toggle
              color="blue-grey-7"
              v-model="keep_awake"
              val="1"
              @update:model-value="handleKeepAwake"
            />
          </q-item-section>
        </q-item>
        <q-item tag="label" v-ripple>
          <q-item-section>
            <q-item-label>{{ $t("Enable New Order Alert") }}</q-item-label>
          </q-item-section>
          <q-item-section side>
            <q-toggle
              color="blue-grey-7"
              v-model="enable_new_order_alert"
              val="1"
              @update:model-value="handleOrderalert"
            />
          </q-item-section>
        </q-item>

        <q-item
          tag="label"
          v-ripple
          clickable
          @click="this.$refs.ref_popup_edit.show()"
        >
          <q-item-section>
            <q-item-label>{{
              $t("New Order Alert Interval (seconds)")
            }}</q-item-label>
          </q-item-section>
          <q-item-section side>
            <q-item-label class="text-weight-bold text-subtitle2 q-pr-md">
              {{ new_order_alert_interval }}

              <q-popup-edit
                ref="ref_popup_edit"
                v-model="new_order_alert_interval"
                auto-save
                v-slot="scope"
                @save="SaveOrderInterval"
              >
                <q-input
                  v-model="scope.value"
                  dense
                  autofocus
                  counter
                  @keyup.enter="scope.set"
                  type="number"
                  :rules="[
                    (val) => /^\d+$/.test(val) || this.$t('Numbers only'),
                  ]"
                />
              </q-popup-edit>
            </q-item-label>
          </q-item-section>
        </q-item>
      </q-list>
      <q-space class="q-pa-md"></q-space>
    </q-card>
  </q-dialog>
</template>

<script>
import { FCM } from "@capacitor-community/fcm";
import APIinterface from "src/api/APIinterface";
import auth from "src/api/auth";
import { useAccessStore } from "src/stores/AccessStore";
import { useDataPersisted } from "src/stores/DataPersisted";
import { useOrderStore } from "src/stores/OrderStore";

export default {
  name: "NotificationSettings",
  data() {
    return {
      modal: false,
      push: false,
      enable_new_order_alert: false,
      keep_awake: false,
      loading: false,
      new_order_alert_interval: null,
    };
  },
  setup() {
    const AccessStore = useAccessStore();
    const DataPersisted = useDataPersisted();
    const OrderStore = useOrderStore();
    return { AccessStore, DataPersisted, OrderStore };
  },
  methods: {
    beforeShow() {
      console.log("beforeShow", this.AccessStore.app_settings);
      if (this.$q.capacitor) {
        this.push = this.DataPersisted.enabled_push;
        this.keep_awake = this.DataPersisted.keep_awake ?? false;
      } else {
        this.push = this.AccessStore.app_settings?.app_push_notifications;
      }

      const enabledNewAlert =
        this.AccessStore.app_settings?.enable_new_order_alert ?? false;

      this.new_order_alert_interval =
        this.AccessStore.app_settings?.new_order_alert_interval ?? 0;

      if (enabledNewAlert == "not_define") {
        this.enable_new_order_alert = false;
      } else {
        this.enable_new_order_alert =
          this.AccessStore.app_settings?.enable_new_order_alert;
      }
    },
    async HandlePush(value) {
      const user_data = auth.getUser();
      const merchant_uuid = user_data?.merchant_uuid || null;

      if (!merchant_uuid) {
        APIinterface.ShowAlert(
          this.$t("Invalid merchant uuid"),
          this.$q.capacitor,
          this.$q
        );
        return;
      }
      if (this.$q.capacitor) {
        try {
          if (value) {
            const results = await FCM.subscribeTo({
              topic: merchant_uuid,
            });
            console.log("results", JSON.stringify(results));
            this.DataPersisted.enabled_push = true;
          } else {
            const results = await FCM.unsubscribeFrom({ topic: merchant_uuid });
            console.log("results", JSON.stringify(results));
            this.DataPersisted.enabled_push = false;
          }
        } catch (error) {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        } finally {
        }
      } else {
        this.updateNotifications(value);
      }
    },
    async updateNotifications(value) {
      try {
        const params = new URLSearchParams({
          push: value ? 1 : 0,
        }).toString();
        await APIinterface.fetchDataByTokenPost(
          "Updateaccountnotification",
          params
        );
        this.AccessStore.app_settings.app_push_notifications = value;
      } catch (error) {
      } finally {
      }
    },
    async handleOrderalert(value) {
      try {
        const params = new URLSearchParams({
          push: value ? 1 : 0,
        }).toString();

        await APIinterface.fetchDataByTokenPost("updateOrderAlert", params);

        this.AccessStore.app_settings.enable_new_order_alert = value;
        if (!value) {
          this.OrderStore.updateOrderCount(0);
        } else {
          this.OrderStore.getCountNewOrder();
        }
      } catch (error) {
      } finally {
      }
    },
    handleKeepAwake(value) {
      this.DataPersisted.keep_awake = value;
    },
    updateOrderInterval(value) {
      console.log("updateOrderInterval", value);
    },
    async SaveOrderInterval(value, oldVal) {
      if (!value) {
        setTimeout(() => {
          this.new_order_alert_interval = oldVal;
        }, 100);
        return;
      }

      if (value < 10) {
        APIinterface.ShowAlert(
          this.$t("Minimum value is 10 seconds"),
          this.$q.capacitor,
          this.$q
        );
        setTimeout(() => {
          this.new_order_alert_interval = oldVal;
        }, 100);
        return;
      }

      try {
        const params = new URLSearchParams({
          interval: value,
        }).toString();

        await APIinterface.fetchDataByTokenPost("SaveOrderInterval", params);
        this.AccessStore.app_settings.new_order_alert_interval = value;
        this.OrderStore.getCountNewOrder();
      } catch (error) {
      } finally {
      }
    },
  },
};
</script>
