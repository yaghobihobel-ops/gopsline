<template>
  <div class="hiddenx">
    <!-- <pre>{{ data }}</pre> -->
    <!-- <pre>{{ order_uuid }}</pre> -->
  </div>

  <PrintReceipt
    ref="ref_printreceipt"
    :data="order_data"
    :printer="printer_details"
  ></PrintReceipt>

  <q-dialog v-model="is_printing" position="bottom" seamless persistent>
    <q-card class="rounded-borders-top">
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <q-toolbar-title class="text-dark text-weight-bold">
          {{ $t("Auto print") }}
        </q-toolbar-title>
        <q-space></q-space>
        <q-btn
          icon="las la-times"
          color="grey"
          flat
          round
          dense
          v-close-popup
        />
      </q-toolbar>
      <q-card-section class="text-body2">
        <div>{{ processing_text }}</div>
        <q-linear-progress indeterminate color="primary" class="q-mt-sm" />
      </q-card-section>
    </q-card>
  </q-dialog>

  <q-dialog v-model="chat_modal" position="bottom" persistent>
    <q-card class="rounded-borders-top">
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <q-toolbar-title class="text-dark text-weight-bold">
          {{ $t("You have new message") }}
        </q-toolbar-title>
        <q-space></q-space>
        <q-btn
          icon="las la-times"
          color="grey"
          flat
          round
          dense
          v-close-popup
        />
      </q-toolbar>
      <q-item>
        <q-item-section avatar>
          <q-avatar size="lg" v-if="meta_data?.avatar">
            <img :src="meta_data?.avatar ?? ''" />
          </q-avatar>
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ meta_data?.from ?? "" }}</q-item-label>
          <q-item-label caption>
            {{ meta_data?.message ?? "" }}
          </q-item-label>
        </q-item-section>
      </q-item>
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
            {{ $t("Cancel") }}
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
          @click="replyTochat"
        >
          <div class="text-weight-bold text-subtitle2">
            {{ $t("Reply") }}
          </div>
        </q-btn>
      </q-card-actions>
    </q-card>
  </q-dialog>

  <PushEnabled ref="ref_push"></PushEnabled>
</template>

<script>
import { useUserStore } from "stores/UserStore";
import APIinterface from "src/api/APIinterface";
import PrintTemplate from "src/api/PrintTemplate";
import AppBluetooth from "src/api/AppBluetooth";
import { useDataStore } from "stores/DataStore";
import { defineAsyncComponent } from "vue";
import auth from "src/api/auth";
import { useChatStore } from "stores/ChatStore";
import { useOrderStore } from "stores/OrderStore";
import { useDataPersisted } from "stores/DataPersisted";
import { useAccessStore } from "stores/AccessStore";

export default {
  name: "PrinterAuto",
  components: {
    PushEnabled: defineAsyncComponent(() =>
      import("components/PushEnabled.vue")
    ),
    PrintReceipt: defineAsyncComponent(() =>
      import("components/PrintReceipt.vue")
    ),
  },
  data() {
    return {
      order_uuid: "",
      is_printing: false,
      processing_text: this.$t("Gettting order info..."),
      payload: [
        "merchant_info",
        "items",
        "summary",
        "order_info",
        "status_allowed_cancelled",
        "order_delivery_status",
        "refund_transaction",
      ],
      order_data: [],
      printer_details: null,
      chat_modal: false,
      meta_data: null,
      notification_uuid: null,
      notification_data: null,
    };
  },
  setup() {
    const UserStore = useUserStore();
    const DataStore = useDataStore();
    const ChatStore = useChatStore();
    const OrderStore = useOrderStore();
    const DataPersisted = useDataPersisted();
    return {
      UserStore,
      DataStore,
      ChatStore,
      OrderStore,
      DataPersisted,
    };
  },
  mounted() {
    this.connect_attemp = 0;
    const userStore = useUserStore();
    this.showEnabledPush();

    this.$watch(
      () => userStore.pusher_receive_data,
      (newData) => {
        if (newData) {
          this.ReceiveData(newData);
        }
      }
    );
  },
  methods: {
    showEnabledPush() {
      if (!this.$q.capacitor) return;

      if (this.DataPersisted.enabled_push) return;

      setTimeout(() => {
        if (this.$refs.ref_push) {
          this.$refs.ref_push.modal = true;
        }
      }, 2000);
    },
    ReceiveData(data) {
      this.meta_data = null;
      console.log("Printer data", data);
      this.notification_data = data;
      const notification_type = data.notification_type;
      console.log("notification_type", notification_type);
      console.log("route", this.$route.path);

      if (notification_type == "auto_print" && this.$q.capacitor) {
        if (data?.printer_model == "bluetooth") {
          this.initPrinting(data);
        }
      } else if (notification_type == "chat-message") {
        this.ChatStore.data = null;

        if (this.$route.name == "conversation") {
          return;
        }
        this.chat_modal = false;
        this.notification_uuid = data.notification_uuid
          ? data.notification_uuid
          : null;
        this.meta_data = data.meta_data ? data.meta_data : null;
      } else if (notification_type == "order_update") {
        this.meta_data = data.meta_data ? data.meta_data : null;
        const order_status = this.meta_data ? this.meta_data.status : null;
        const request_from = this.meta_data
          ? this.meta_data.request_from
          : null;

        console.log("order_status", order_status);
        console.log("request_from", request_from);

        if (
          (order_status == "new" &&
            request_from != "pos" &&
            this.$route.path != "/dashboard") ||
          this.$route.path != "/orders"
        ) {
          console.log("call get new order");

          this.OrderStore.clearSavedOrderList();
          this.OrderStore.getCountNewOrder();
        }
      } else if (notification_type == "booking") {
        this.OrderStore.fetchReservationcount();
      }
    },
    replyTochat() {
      this.$router.push({
        path: "/chat/conversation",
        query: {
          conversation_id: this.meta_data?.conversation_id,
          notification_uuid: this.notification_uuid,
        },
      });
    },
    viewOrder() {
      if (!this.meta_data) {
        return;
      }
      this.$router.push({
        path: "/orderview",
        query: {
          order_uuid: this.meta_data.order_uuid,
        },
      });
    },
    initPrinting(data) {
      console.log("initPrinting", data);
      this.order_uuid = data?.order_uuid;
      this.orderDetails();
    },
    async orderDetails() {
      try {
        this.is_printing = true;
        this.processing_text = this.$t("Gettting order info...");

        const response = await APIinterface.fetchDataByToken("orderDetails", {
          order_uuid: this.order_uuid,
          hide_currency: this.DataPersisted.hide_currency ? 1 : 0,
          payload: this.payload,
        });
        console.log("response", response);
        this.order_data = response.details?.data;
        const printer = this.order_data?.printer_details ?? null;
        if (printer) {
          printer.print_type = this.DataPersisted.printer_set;
          this.printer_details = printer;
          if (this.printer_details == "feieyun") {
            this.is_printing = false;
            this.FPprint();
            return;
          }

          setTimeout(() => {
            this.is_printing = false;
            this.$refs.ref_printreceipt.initData();
          }, 500);
        }
      } catch (error) {
        this.order_data = [];
        this.printer_details = null;
      } finally {
      }
    },
    async FPprint() {
      try {
        APIinterface.showLoadingBox(this.$t("Printing..."), this.$q);
        const response = await APIinterface.fetchDataByTokenPost(
          "FPprint",
          new URLSearchParams({
            printer_id: this.printer_details?.printer_id,
            order_uuid: this.order_uuid,
          }).toString()
        );
        APIinterface.ShowSuccessful(response.msg, this.$q);
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
  },
};
</script>
