<template>
  <q-header
    reveal
    reveal-offset="10"
    :class="{
      'bg-custom-grey text-dark': !$q.dark.mode,
      'bg-grey600 text-grey300': $q.dark.mode,
    }"
  >
    <q-toolbar style="border-bottom-right-radius: 25px">
      <q-btn
        @click="$router.back()"
        flat
        round
        dense
        icon="eva-arrow-ios-back-outline"
      />
      <q-toolbar-title style="font-size: 14px">{{
        $t("Sounds")
      }}</q-toolbar-title>
    </q-toolbar>
  </q-header>
  <q-page padding>
    <q-list separator>
      <q-item tag="label" v-ripple>
        <q-item-section>
          <q-item-label>{{ $t("Push Notifications") }}</q-item-label>
        </q-item-section>
        <q-item-section avatar>
          <q-toggle
            v-model="SettingStore.push_notifications"
            val="1"
            @update:model-value="updatePushNotifications"
          />
        </q-item-section>
      </q-item>

      <q-item tag="label" v-ripple>
        <q-item-section>
          <q-item-label>{{ $t("Mute Order Sounds") }}</q-item-label>
        </q-item-section>
        <q-item-section avatar>
          <q-toggle v-model="SettingStore.mute_sounds" val="1" />
        </q-item-section>
      </q-item>

      <q-item tag="label" v-ripple>
        <q-item-section>
          <q-item-label>{{
            $t("Repeat Until Order Acknowledge")
          }}</q-item-label>
          <q-item-label caption>
            {{ $t('Repeat sounds until order is marked "in progress"') }}
          </q-item-label>
        </q-item-section>
        <q-item-section avatar>
          <q-toggle
            v-model="SettingStore.repeat_notication"
            val="1"
            @update:model-value="setRepeat"
          />
        </q-item-section>
      </q-item>
    </q-list>
  </q-page>
</template>

<script>
import { useKitchenStore } from "stores/KitchenStore";
import { useIdentityStore } from "stores/IdentityStore";
import { useSettingStore } from "stores/SettingStore";
import { jwtDecode } from "jwt-decode";
import { FCM } from "@capacitor-community/fcm";
import APIinterface from "src/api/APIinterface";

export default {
  name: "DisplayMode",
  setup() {
    const KitchenStore = useKitchenStore();
    const IdentityStore = useIdentityStore();
    const SettingStore = useSettingStore();
    return { KitchenStore, IdentityStore, SettingStore };
  },
  data() {
    return {
      merchant_uuid: "",
    };
  },
  methods: {
    setRepeat(value) {
      value = value == true ? 1 : 0;
      console.log("setRepeat", value);
      this.KitchenStore.setRepeatNotification("value=" + value);
    },
    updatePushNotifications(value) {
      if (this.IdentityStore.authenticated()) {
        try {
          let user_data = jwtDecode(this.IdentityStore.user_data);
          this.merchant_uuid = user_data.merchant_uuid + "-kitchen";
          if (this.$q.capacitor) {
            if (value) {
              FCM.subscribeTo({ topic: this.merchant_uuid })
                .then((r) => {
                  console.log("succesful", r);
                })
                .catch((error) => {
                  console.log("error", error);
                });
            } else {
              FCM.unsubscribeFrom({ topic: this.merchant_uuid })
                .then((r) => {
                  console.log("succesful", r);
                })
                .catch((error) => {
                  console.log("error", error);
                });
            }
          }
        } catch (err) {
          console.log("ERROR", err.message);
          APIinterface.notify(
            this.$q,
            this.$t("Error"),
            err.message,
            "myerror",
            "highlight_off",
            "bottom"
          );
        }
      }
    },
  },
};
</script>
