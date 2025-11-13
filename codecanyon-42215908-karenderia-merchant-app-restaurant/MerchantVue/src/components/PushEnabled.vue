<template>
  <q-dialog v-model="modal" persistent>
    <q-card class="rounded-borders-top" style="width: 700px; max-width: 80vw">
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <q-btn round color="teal-2" text-color="dark" unelevated dense
          ><img src="/svg/notification1.svg" width="25" />
        </q-btn>
        <q-toolbar-title
          class="text-dark text-weight-bold"
          style="overflow: inherit"
        >
          {{ $t("Order Notifications") }}
        </q-toolbar-title>
        <q-space></q-space>
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
      </q-toolbar>
      <q-card-section>
        <div class="text-body2 text-text">
          {{ $t("push_enabled_message") }}
        </div>
      </q-card-section>
      <q-card-actions class="row">
        <q-btn
          unelevated
          no-caps
          color="disabled"
          text-color="disabled"
          class="radius10 col"
          size="lg"
          v-close-popup
        >
          <div class="text-weight-bold text-subtitle2">
            {{ $t("Skip") }}
          </div>
        </q-btn>
        <q-btn
          type="submit"
          unelevated
          no-caps
          color="amber-6"
          text-color="disabled"
          class="radius10 col"
          size="lg"
          @click="handlePush"
          :loading="loading"
        >
          <div class="text-weight-bold text-subtitle2">
            {{ $t("Enabled Push") }}
          </div>
        </q-btn>
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script>
import { FCM } from "@capacitor-community/fcm";
import APIinterface from "src/api/APIinterface";
import auth from "src/api/auth";
import { useDataPersisted } from "stores/DataPersisted";

export default {
  name: "PushEnabled",
  data() {
    return {
      modal: false,
      loading: false,
    };
  },
  setup() {
    const DataPersisted = useDataPersisted();
    return { DataPersisted };
  },
  methods: {
    async handlePush() {
      if (!auth.authenticated()) {
        APIinterface.ShowAlert(
          this.$t("Authentication failed. please re-login again"),
          this.$q.capacitor,
          this.$q
        );
        return;
      }

      this.loading = true;

      const user_data = auth.getUser();
      const merchant_uuid = user_data?.merchant_uuid || null;

      try {
        const results = await FCM.subscribeTo({
          topic: merchant_uuid,
        });
        console.log("results", results);
        this.DataPersisted.enabled_push = true;
        this.modal = false;
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>
