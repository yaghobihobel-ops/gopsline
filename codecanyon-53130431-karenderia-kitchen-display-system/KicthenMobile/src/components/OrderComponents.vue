<template>
  <q-card flat bordered class="box-shadow">
    <!-- =>{{ getOrderStatus(items.transaction_type, items.order_reference) }} -->
    <!-- =>{{ getColorStatus(items.transaction_type, items.order_reference) }} -->
    <div
      class="bg-green-15x text-dark q-pa-sm"
      :class="{ 'cursor-pointer': can_change }"
      :style="`background-color: ${getColorStatus(
        items.transaction_type,
        items.order_reference
      )}`"
      @click="can_change ? setBump(items.order_reference) : false"
    >
      <div class="row items-center">
        <div class="col text-weight-bold text-body2 line-normal ellipsisx">
          #{{ items.order_reference }}
        </div>
        <div v-if="items.room_name" class="col text-right">
          {{ items.room_name }} [ {{ items.table_name }} ]
        </div>
      </div>

      <div class="row items-center">
        <div
          class="col col-xs-6 text-weight-regular line-normal ellipsis-2 line-normal text-caption"
        >
          {{ items.customer_name }}
        </div>
        <div class="col-3 col-xs-6 text-right line-normal" v-if="can_change">
          <ElapsetimeComponents
            :start="items.request_time"
            :timezone="items.timezone"
            v-model:result="elapse_time"
          ></ElapsetimeComponents>
        </div>
      </div>
    </div>
    <!-- bg-primary -->

    <div
      class="text-dark q-pa-sm row items-center"
      :style="`background-color: ${
        SettingStore.color_status[items.transaction_type]
      }`"
    >
      <div class="col text-weight-bold line-normal ellipsis">
        <div class="text-capitalize">
          {{ items.transaction_type_pretty }}
        </div>
      </div>
      <div class="col text-right text-weight-regular">
        {{ items.delivery_time_pretty }}
      </div>
    </div>
    <!-- row -->

    <q-space class="q-pa-xs"></q-space>

    <q-list dense>
      <q-item v-if="!can_change">
        <div
          class="full-width flex items-center q-gutter-x-sm bg-blue-1 text-blue-9 radius-6 q-pa-xs q-mb-xs"
        >
          <div>
            <q-icon name="eva-clock-outline" size="20px"></q-icon>
          </div>
          <div class="col">
            {{ items.delivery_datetime }}
          </div>
        </div>
      </q-item>
      <template v-for="list in items.items" :key="list">
        <q-item tag="label" v-ripple>
          <q-item-section>
            <q-item-label>
              <span
                :class="{
                  'text-strike': KitchenStore.isDone(list.item_status),
                  'text-red': KitchenStore.isCancel(list.item_status),
                }"
                class="text-weight-medium"
              >
                {{ list.qty }} x {{ list.item_name }}
              </span>
            </q-item-label>
            <q-item-label>
              <q-badge
                outline
                :color="KitchenStore.getItemStatus(list.item_status)"
                :label="list.item_status_pretty"
              />
            </q-item-label>
            <q-item-label class="text-green-4 text-caption">
              <template
                v-for="(attributes, index) in list.attributes"
                :key="attributes"
              >
                {{ attributes.value }}
                <template v-if="index !== list.attributes.length - 1"
                  >,</template
                >
              </template>
            </q-item-label>
            <q-item-label>
              <template v-for="addons in list.addons" :key="addons">
                <div
                  :class="{
                    'text-strike': KitchenStore.isDone(list.item_status),
                    'text-red': KitchenStore.isCancel(list.item_status),
                  }"
                >
                  - {{ addons.value }}
                </div>
              </template>
            </q-item-label>
          </q-item-section>

          <template v-if="can_change">
            <q-item-section
              side
              v-if="!KitchenStore.isDone(list.item_status)"
              top
              style="padding-left: 0"
            >
              <q-checkbox
                v-model="list.checked"
                :val="list.kitchen_order_id"
                color="primary"
              >
              </q-checkbox>
            </q-item-section>
          </template>
        </q-item>
        <q-item v-if="list.special_instructions">
          <template v-if="list.special_instructions">
            <div
              class="full-width flex items-center q-gutter-x-sm bg-red-1 text-red-9 radius-6 q-pa-xs q-mb-xs"
            >
              <div>
                <q-icon name="eva-message-circle-outline" size="20px"></q-icon>
              </div>
              <div class="col">{{ list.special_instructions }}</div>
            </div>
          </template>
        </q-item>

        <q-separator></q-separator>
      </template>
    </q-list>

    <q-card-section class="flex q-gutter-x-sm">
      <q-btn
        outline
        color="negative"
        icon="eva-printer-outline"
        class="radius6 col"
        no-caps
        @click="showSelectPrinter"
      >
      </q-btn>

      <template v-if="can_change">
        <template v-if="items.total_pending > 0">
          <q-btn-dropdown
            outline
            color="primary"
            :label="$t('Status')"
            class="radius6 col"
            no-caps
            :disable="!selectedItems(items.items)"
            :loading="loading"
          >
            <q-list>
              <template
                v-for="(status_pretty, status) in KitchenStore.getKitchenStatus"
                :key="status_pretty"
              >
                <q-item
                  clickable
                  v-close-popup
                  @click="updateItemStatus(status)"
                >
                  <q-item-section>
                    <q-item-label>{{ status_pretty }}</q-item-label>
                  </q-item-section>
                </q-item>
              </template>
            </q-list>
          </q-btn-dropdown>
        </template>
        <template v-else>
          <q-btn
            unelevated
            color="primary"
            :label="$t('Bump')"
            class="radius6 col"
            no-caps
            @click="setBump(items.order_reference)"
          ></q-btn>
        </template>
      </template>
      <template v-else>
        <q-btn
          unelevated
          color="primary"
          :label="$t('Move to current')"
          class="radius6 col"
          no-caps
          @click="$emit('moveOrder', items.order_reference)"
          style="line-height: 1em"
        ></q-btn>
      </template>
    </q-card-section>
  </q-card>

  <PrinterSelect
    ref="ref_printer_select"
    @after-chooseprinter="afterChooseprinter"
  ></PrinterSelect>

  <PrinterPreview ref="ref_print"> </PrinterPreview>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useKitchenStore } from "stores/KitchenStore";
import { useSettingStore } from "stores/SettingStore";
import { defineAsyncComponent } from "vue";

export default {
  name: "OrderComponents",
  components: {
    ElapsetimeComponents: defineAsyncComponent(() =>
      import("components/ElapsetimeComponents.vue")
    ),
    PrinterSelect: defineAsyncComponent(() =>
      import("components/PrinterSelect.vue")
    ),
    PrinterPreview: defineAsyncComponent(() =>
      import("components/PrinterPreview.vue")
    ),
  },
  props: ["items", "can_change", "filters", "position"],
  data() {
    return {
      loading: false,
      check_all: false,
      elapse_time: "",
    };
  },
  setup() {
    const KitchenStore = useKitchenStore();
    const SettingStore = useSettingStore();
    return { KitchenStore, SettingStore };
  },
  methods: {
    showSelectPrinter() {
      this.$refs.ref_printer_select.modal = true;
    },
    selectedItems(value) {
      return value.some((item) => item.checked === true);
    },
    updateItemStatus(status) {
      this.loading = true;
      APIinterface.fetchDataPost("updateItemStatus", {
        status: status,
        items: this.items.items,
        filters: this.filters,
      })
        .then((data) => {
          console.log("data", data);
          if (this.SettingStore.screen_options == "split") {
            if (this.position == "top") {
              this.KitchenStore.order_data_top = data.details;
            } else if (this.position == "bottom") {
              this.KitchenStore.order_data_bottom = data.details;
            }
          } else {
            this.KitchenStore.order_data = data.details;
          }
          APIinterface.notify(
            this.$q,
            this.$t("Done"),
            data.msg,
            "mysuccess",
            "done",
            "bottom"
          );
        })
        .catch((error) => {
          APIinterface.notify(
            this.$q,
            this.$t("Error"),
            error,
            "myerror",
            "highlight_off",
            "bottom"
          );
        })
        .then((data) => {
          this.loading = false;
        });
    },
    setBump(order_reference) {
      console.log("setBump", order_reference);
      APIinterface.showLoadingBox(this.$t("Processing"), this.$q);
      APIinterface.fetchDataPost("setOrderBump", {
        order_reference: order_reference,
        filters: this.filters,
      })
        .then((data) => {
          if (this.SettingStore.screen_options == "split") {
            if (this.position == "top") {
              this.KitchenStore.order_data_top = data.details;
            } else if (this.position == "bottom") {
              this.KitchenStore.order_data_bottom = data.details;
            }
          } else {
            if (data.details.count > 0) {
              this.KitchenStore.order_data = data.details;
            } else {
              this.KitchenStore.order_data = null;
            }
          }
          this.KitchenStore.refreshOrdersCount();
        })
        .catch((error) => {
          APIinterface.notify(
            this.$q,
            this.$t("Error"),
            error,
            "myerror",
            "highlight_off",
            "bottom"
          );
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    getColorStatus(transaction_type, order_reference) {
      const result = this.getOrderStatus(transaction_type, order_reference);
      switch (result) {
        case "last_time":
          return this.SettingStore.color_late;
          break;

        case "caution_time":
          return this.SettingStore.color_caution;
          break;

        default:
          return this.SettingStore.color_ontime;
          break;
      }
    },
    getOrderStatus(transaction_type, order_reference) {
      // console.log("transaction_type", transaction_type);
      // console.log("elapse_time", this.elapse_time);
      let deliveryItem = this.SettingStore.transition_times.find(
        (item) => item.value === transaction_type
      );

      if (deliveryItem && this.elapse_time) {
        let caution_time = deliveryItem.caution;
        let last_time = deliveryItem.last;
        // console.log(
        //   "elapse_time=>" +
        //     this.elapse_time +
        //     " caution =>" +
        //     caution_time +
        //     " last=>" +
        //     last_time
        // );
        const result = this.isWithinTimeRange(
          this.elapse_time,
          caution_time,
          last_time
        );
        return result;
      } else {
        return "on_time";
      }
    },
    isWithinTimeRange(currentTime, cautionTime, lastTime) {
      const [currentHours, currentMinutes, currentSeconds] = currentTime
        .split(":")
        .map(Number);
      const [cautionHours, cautionMinutes, cautionSeconds] = cautionTime
        .split(":")
        .map(Number);
      const [lastHours, lastMinutes, lastSeconds] = lastTime
        .split(":")
        .map(Number);

      const currentTotalSeconds =
        currentHours * 3600 + currentMinutes * 60 + currentSeconds;
      const cautionTotalSeconds =
        cautionHours * 3600 + cautionMinutes * 60 + cautionSeconds;
      const lastTotalSeconds =
        lastHours * 3600 + lastMinutes * 60 + lastSeconds;

      if (currentTotalSeconds >= lastTotalSeconds) {
        return "last_time";
      } else if (currentTotalSeconds >= cautionTotalSeconds) {
        return "caution_time";
      } else {
        return "on_time";
      }
    },
    async afterChooseprinter(data) {
      if (data.printer_model == "feieyun") {
        APIinterface.showLoadingBox(this.$t("Printing..."), this.$q);
        APIinterface.fetchDataPost(
          "PrintTicketFP",
          "printer_id=" +
            data.printer_id +
            "&order_reference=" +
            this.items.order_reference
        )
          .then((data) => {
            APIinterface.notify(
              this.$q,
              this.$t("Print"),
              data.msg,
              "mysuccess",
              "highlight_off",
              "bottom"
            );
          })
          .catch((error) => {
            APIinterface.notify(
              this.$q,
              this.$t("Error"),
              error,
              "myerror",
              "highlight_off",
              "bottom"
            );
          })
          .then((data) => {
            APIinterface.hideLoadingBox(this.$q);
          });
      } else {
        APIinterface.showLoadingBox(this.$t("Getting ticket info..."), this.$q);
        let results = await this.KitchenStore.getTicket(
          this.items.order_reference,
          data.printer_id
        );
        APIinterface.hideLoadingBox(this.$q);
        let print_data = results.data ? results.data : null;
        if (print_data) {
          this.$refs.ref_print.print(results);
        } else {
          APIinterface.notify(
            this.$q,
            this.$t("Error"),
            results,
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
