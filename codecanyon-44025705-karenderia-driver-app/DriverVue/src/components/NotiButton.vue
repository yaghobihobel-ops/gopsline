<template>
  <q-btn
    to="/account/notifications"
    flat
    round
    dense
    icon="las la-bell"
    color="amber-5"
  >
    <transition
      v-if="hasData"
      appear
      enter-active-class="animated zoomIn"
      leave-active-class="animated zoomOut"
    >
      <q-badge floating color="red" rounded style="top: 2px" />
    </transition>
  </q-btn>

  <Realtime
    ref="realtime"
    getevent="notifications"
    @after-receive="afterReceive"
    sound_id="notify"
  />

  <q-dialog v-model="chat_modal" position="bottom" persistent seamless>
    <q-card>
      <q-bar class="transparent q-pa-sm" style="height: auto">
        <div class="col">
          <div class="text-weight-bold">
            {{ $t("New Message") }}
          </div>
        </div>
        <q-btn dense flat icon="close" v-close-popup>
          <q-tooltip class="bg-white text-primary">Close</q-tooltip>
        </q-btn>
      </q-bar>

      <q-card-section class="q-pt-none q-pb-none">
        <p>{{ chat_message }}</p>
      </q-card-section>

      <q-card-actions align="center">
        <q-btn
          no-caps
          unelevated
          :label="$t('View Message')"
          color="primary"
          size="15px"
          class="fit"
          @click="viewChatMessage"
        ></q-btn>
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useDriverappStore } from "stores/DriverappStore";
import { ShiftHistoryStore } from "stores/MyScheduleStore";

export default {
  name: "NotiButton",
  components: {
    Realtime: defineAsyncComponent(() => import("src/components/RealTime.vue")),
  },
  setup() {
    const DriverappStore = useDriverappStore();
    const history = ShiftHistoryStore();
    return { DriverappStore, history };
  },
  data() {
    return {
      data: [],
      chat_modal: false,
      chat_message: "",
      chat_id: null,
    };
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    afterReceive(data) {
      console.debug("afterReceive", data);
      this.data = data;
      const $notification_type = this.data.notification_type;
      if ($notification_type == "assign_order") {
        const $message = JSON.parse(this.data.message);
        if ($message.order_uuid) {
          this.DriverappStore.getTotalTask();
          this.$router.push({
            path: "/order/new",
            query: { order_uuid: $message.order_uuid },
          });
        }
      } else if ($notification_type == "order_update") {
        if (this.data.meta_data) {
          if (this.data.meta_data.order_uuid) {
            if (this.data.meta_data.status == "new") {
              this.$router.push({
                path: "/order/new",
                query: { order_uuid: this.data.meta_data.order_uuid },
              });
            }
          }
        }
      } else if ($notification_type == "chat-message") {
        if (this.chat_modal) {
          this.chat_modal = false;
        }
        this.history.chat_data = [];
        this.chat_message = this.data.message;
        this.chat_modal = true;
        this.chat_id = this.data.meta_data.conversation_id;
      }
    },
    viewChatMessage() {
      this.$router.push({
        path: "/chat",
        query: { conversation_id: this.chat_id },
      });
    },
  },
};
</script>
