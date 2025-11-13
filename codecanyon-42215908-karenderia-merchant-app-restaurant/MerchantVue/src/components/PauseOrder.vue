<template>
  <template v-if="SettingStore.loading">
    <q-skeleton type="QBtn" />
  </template>
  <template v-else>
    <q-btn
      rounded
      no-caps
      dense
      @click="dialog = !dialog"
      class="q-pl-sm border-grey"
      unelevated
    >
      <img
        :src="`/svg/${SettingStore.store_status}.svg`"
        width="25"
        height="25"
      />
      <div
        class="q-ml-xs q-mr-sm text-weight-bold"
        :class="{
          'text-white': $q.dark.mode,
          'text-dark': !$q.dark.mode,
        }"
      >
        <template v-if="SettingStore.store_status != 'pause'">
          {{ $t(SettingStore.store_status) }}
        </template>

        <template
          v-if="
            SettingStore.hasPauseData && SettingStore.store_status == 'pause'
          "
        >
          <PauseCountdown
            :start="SettingStore.getPauseData.start_time"
            :end="SettingStore.getPauseData.end_time"
            :timezone="SettingStore.getPauseData.timezone"
            @pause-end="pauseEnd"
          ></PauseCountdown>
        </template>
      </div>
      <q-icon name="keyboard_arrow_down" color="grey-5"></q-icon>
    </q-btn>
  </template>

  <!-- <pre>{{ SettingStore.getPauseData }}</pre> -->

  <q-dialog
    v-model="dialog"
    :maximized="this.$q.screen.lt.sm ? true : false"
    :position="this.$q.screen.lt.sm ? 'bottom' : 'standard'"
    persistent
    @before-show="beforeShow"
  >
    <q-card>
      <q-card-section class="row items-center q-pb-none">
        <q-btn
          color="white"
          square
          unelevated
          text-color="grey"
          icon="las la-angle-left"
          dense
          no-caps
          v-if="show_pause_menu == true || show_pause_reason == true"
          @click="setBack"
        />
        <div class="text-weight-bold">
          {{ setHeader }}
        </div>
        <q-space />

        <template v-if="!show_pause_menu">
          <q-btn
            @click="dialog = !true"
            unelevated
            color="dark"
            icon="las la-times"
            dense
            flat
            no-caps
          />
        </template>
      </q-card-section>

      <q-card-section>
        <template v-if="show_pause_menu == false">
          <q-list>
            <template v-for="items in status_list" :key="items">
              <q-item tag="label" v-ripple class="border-grey q-mb-sm radius10">
                <q-item-section>
                  <q-item-label class="text-body2 text-weight-medium">
                    {{ items.label }}
                  </q-item-label>
                </q-item-section>
                <q-item-section side>
                  <q-radio
                    v-model="status"
                    :val="items.value"
                    color="primary"
                    @update:model-value="setStatus"
                  />
                </q-item-section>
              </q-item>
            </template>
          </q-list>
        </template>
        <template v-else>
          <template v-if="show_pause_reason">
            <q-intersection transition="slide-left">
              <q-list separator>
                <template
                  v-for="items in SettingStore.getPauseReason"
                  :key="items"
                >
                  <q-item tag="label" v-ripple>
                    <q-item-section>{{ items }}</q-item-section>
                    <q-item-section side>
                      <q-radio
                        v-model="pause_reason"
                        :val="items"
                        color="primary"
                      />
                    </q-item-section>
                  </q-item>
                </template>
              </q-list>
            </q-intersection>
          </template>
          <template v-else>
            <q-intersection transition="slide-left">
              <template v-if="time_delay == 'other'">
                <div
                  class="flex items-center justify-center q-gutter-x-sm"
                  style="min-height: 30vh"
                >
                  <div class="">
                    <q-btn
                      round
                      color="grey-2"
                      text-color="dark"
                      icon="remove"
                      unelevated
                      @click="lessMins"
                    />
                  </div>
                  <div class="text-h4">{{ pause_hours }}</div>
                  <div class="text-h4">:</div>
                  <div class="text-h4">{{ pause_minutes }}</div>
                  <div class="">
                    <q-btn
                      round
                      color="grey-2"
                      text-color="dark"
                      icon="add"
                      unelevated
                      @click="addMins"
                    />
                  </div>
                </div>
              </template>
              <template v-else>
                <q-list separator>
                  <template
                    v-for="items in SettingStore.getPauseTime"
                    :key="items"
                  >
                    <q-item tag="label" v-ripple dense>
                      <q-item-section>{{ items.value }}</q-item-section>
                      <q-item-section side>
                        <q-radio
                          v-model="time_delay"
                          color="primary"
                          :val="items.id"
                        />
                      </q-item-section>
                    </q-item>
                  </template>
                </q-list>
              </template>
            </q-intersection>
          </template>
        </template>
        <q-card-actions>
          <template v-if="show_pause_menu == false">
            <q-btn
              color="amber-6"
              text-color="disabled"
              no-caps
              class="radius10 fit"
              size="lg"
              unelevated
              @click="updateStoreStatus"
              :loading="loading_update"
              :disabled="status == 'pause' ? true : false"
            >
              <div class="text-weight-bold text-subtitle2">
                {{ $t("Confirm") }}
              </div>
            </q-btn>
          </template>
          <template v-else>
            <template v-if="show_pause_reason">
              <q-btn
                color="amber-6"
                text-color="disabled"
                no-caps
                class="radius8 fit"
                size="lg"
                unelevated
                :disabled="!pause_reason"
                @click="setPauseOrder"
                :loading="loading_pause"
              >
                <div class="text-weight-bold text-subtitle2">
                  {{ $t("Confirm") }}
                </div>
              </q-btn>
            </template>
            <template v-else>
              <q-intersection transition="slide-left" class="fit">
                <q-btn
                  color="amber-6"
                  text-color="disabled"
                  no-caps
                  class="radius10 fit"
                  size="lg"
                  unelevated
                  @click="show_pause_reason = true"
                  :disabled="!time_delay"
                >
                  <div class="text-weight-bold text-subtitle2">
                    {{ $t("Next") }}
                  </div>
                </q-btn>
              </q-intersection>
            </template>
          </template>
        </q-card-actions>
      </q-card-section>
    </q-card>
  </q-dialog>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useSettingStore } from "stores/SettingStore";

export default {
  name: "PauseOrder",
  components: {
    PauseCountdown: defineAsyncComponent(() =>
      import("components/PauseCountdown.vue")
    ),
  },
  data() {
    return {
      loading: false,
      loading_pause: false,
      loading_update: false,
      dialog: false,
      status: "open",
      show_pause_menu: false,
      show_pause_reason: false,
      pause_reason: "",
      time_delay: null,
      pause_hours: 0,
      pause_minutes: 0,
      pause_time: null,
      pause_interval: 10,
      status_list: [
        {
          label: this.$t("Open"),
          value: "open",
          icon: "adjust",
        },
        {
          label: this.$t("Close"),
          value: "close",
          icon: "schedule",
        },
        {
          label: this.$t("Pause"),
          value: "pause",
          icon: "pause",
        },
      ],
    };
  },
  setup() {
    const SettingStore = useSettingStore();
    return { SettingStore };
  },
  mounted() {
    this.SettingStore.getOrderingStatus();
  },
  computed: {
    setHeader() {
      let label = "";
      if (this.show_pause_menu == false) {
        label = this.$t("Store Status");
      } else {
        if (this.show_pause_menu) {
          label = this.$t("Pause New Orders");
        }
        if (this.show_pause_reason) {
          label = this.$t("Reason for pausing");
        }
      }
      return label;
    },
    setStatusColor() {
      let statusColor = "transparent";
      if (this.SettingStore.store_status == "open") {
        statusColor = "transparent";
      } else if (this.SettingStore.store_status == "close") {
        statusColor = "close";
      } else if (this.SettingStore.store_status == "pause") {
        statusColor = "pause";
      }
      return statusColor;
    },
    setStatusIcon() {
      let statusIcon = "transparent";
      if (this.SettingStore.store_status == "open") {
        statusIcon = "fiber_manual_record";
      } else if (this.SettingStore.store_status == "close") {
        statusIcon = "schedule";
      } else if (this.SettingStore.store_status == "pause") {
        statusIcon = "pause";
      }
      return statusIcon;
    },
  },
  methods: {
    beforeShow() {
      this.status = this.SettingStore.store_status;
      this.show_pause_menu = false;
      this.show_pause_reason = false;
      this.pause_reason = "";
      this.time_delay = "";
      console.log("beforeShow");
      this.SettingStore.getPauseOptions();
    },
    setStatus(value) {
      console.log("value", value);
      this.show_pause_menu = value == "pause" ? true : false;
    },
    setBack() {
      console.log("setBack");
      if (this.show_pause_menu && this.show_pause_reason) {
        this.show_pause_reason = false;
      } else if (this.show_pause_menu) {
        this.show_pause_menu = false;
        this.time_delay = null;
        //this.status = "";
      }
    },
    setPauseOrder() {
      this.loading_pause = true;
      let params = "time_delay=" + this.time_delay;
      params += "&pause_hours=" + this.pause_hours;
      params += "&pause_minutes=" + this.pause_minutes;
      params += "&pause_reason=" + this.pause_reason;
      params += "&status=" + this.status;

      APIinterface.fetchDataByTokenPost("setPauseOrder", params)
        .then((data) => {
          this.SettingStore.store_status = this.status;
          this.SettingStore.pause_data = data.details;
          this.dialog = false;

          // this.store_status = data.details.store_status;
          // this.pause_data = data.details;
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading_pause = false;
        });
    },
    pauseEnd() {
      console.log("pauseEnd");
      this.SettingStore.store_status = "open";
      this.SettingStore.pause_data = null;
      APIinterface.fetchDataByTokenPost("updateOrderingStatus")
        .then((data) => {})
        .catch((error) => {})
        .then((data) => {});
    },
    updateStoreStatus() {
      this.loading_update = true;
      APIinterface.fetchDataByTokenPost(
        "updateStoreStatus",
        "status=" + this.status
      )
        .then((data) => {
          this.SettingStore.store_status = data.details.status;
          this.SettingStore.pause_data = null;
          this.dialog = false;
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading_update = false;
        });
    },
    addMins() {
      if (this.pause_minutes >= 60) {
        this.pause_minutes = 0;
        this.pause_hours += 1;
      } else {
        this.pause_minutes += this.pause_interval;
      }
    },
    lessMins() {
      if (this.pause_minutes <= 0) {
        if (this.pause_hours > 0) {
          this.pause_minutes = 60;
          this.pause_hours -= 1;
        } else {
          this.pause_minutes = 0;
        }
      } else {
        this.pause_minutes -= this.pause_interval;
      }
    },
    //
  },
};
</script>
