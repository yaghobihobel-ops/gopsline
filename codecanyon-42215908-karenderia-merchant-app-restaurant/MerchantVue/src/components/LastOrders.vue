<template>
  <PrintReceipt
    ref="ref_printreceipt"
    :data="order_data"
    :printer="printer_details"
  ></PrintReceipt>

  <q-item class="q-pa-none">
    <q-item-section>
      <q-item-label class="text-weight-bold text-body1">{{
        $t("Recent Orders")
      }}</q-item-label>
    </q-item-section>
    <q-item-section side>
      <q-btn flat no-caps unelevated color="primary" to="/orders">
        <div class="text-weight-medium text-subtitle2">
          {{ $t("Show all") }}
        </div>
      </q-btn>
    </q-item-section>
  </q-item>

  <q-tabs
    v-model="tab"
    @update:model-value="getLastOrder()"
    dense
    no-caps
    active-color="primary"
    :indicator-color="$q.dark.mode ? 'mydark' : 'grey-1'"
    align="justify"
    narrow-indicator
    mobile-arrows
    shrink
    switch-indicator="false"
    class="text-grey"
  >
    <q-tab
      v-for="items in DataStore.last_order"
      :key="items"
      :name="items.value"
      no-caps
      class="no-wrap q-pa-none"
    >
      <q-btn
        :label="getTabLabel(items)"
        unelevated
        no-caps
        :color="
          tab == items.value ? 'primary' : $q.dark.mode ? 'grey600' : 'mygrey'
        "
        :text-color="
          tab == items.value ? 'white' : $q.dark.mode ? 'grey300' : 'dark'
        "
        class="radius10 q-mr-sm"
      >
      </q-btn>
    </q-tab>
  </q-tabs>

  <q-space class="q-pa-xs"></q-space>

  <template v-if="loading && !hasData">
    <q-skeleton height="130px" square class="bg-grey-1 radius8" />
  </template>
  <template v-else-if="loading && hasData">
    <q-inner-loading :showing="true" class="z-top">
      <q-spinner-ios size="sm" />
    </q-inner-loading>
  </template>
  <template v-else-if="!loading && !hasData">
    <div
      class="flex justify-center items-center q-gutter-x-sm"
      style="min-height: calc(25vh)"
    >
      <img src="/svg/no-data.svg" />
      <div class="text-body1 text-grey">{{ $t("No data available") }}</div>
    </div>
  </template>

  <template v-for="(order, index) in data" :key="order">
    <div class="radius8 q-pl-sm q-pr-sm box-shadow0 q-mb-md">
      <q-list>
        <q-item
          clickable
          v-ripple:purple
          :to="{
            path: '/orderview',
            query: { order_uuid: order?.order_uuid },
          }"
        >
          <q-item-section>
            <q-item-label class="text-weight-bold text-subtitle2">
              <div class="flex items-center q-gutter-x-sm">
                <div>#{{ order.order_id }}</div>
                <div v-if="order.is_view == '0'" class="blob green"></div>
                <div v-if="order.is_critical == true" class="blob red"></div>
              </div>
            </q-item-label>
            <q-item-label>
              <template v-if="order?.is_timepreparation">
                <PreparationCircularprogress
                  display="text"
                  :order_accepted_at="order.order_accepted_at"
                  :preparation_starts="order.preparation_starts"
                  :timezone="order.timezone"
                  :total_time="order.preparation_time_estimation_raw"
                  :label="{
                    hour: $t('hour'),
                    hours: $t('hours'),
                    min: $t('min'),
                    mins: $t('mins'),
                    order_overdue: $t('Order is Overdue!'),
                  }"
                />
              </template>
              <template v-else>
                {{ order.date_created }}
              </template>
            </q-item-label>
          </q-item-section>
          <q-item-section top side>
            <q-badge
              :color="OrderStore.statusColor[order.status_raw]?.bg || 'primary'"
              :text-color="
                OrderStore.statusColor[order.status_raw]?.text || 'white'
              "
              class="text-weight-medium text-body2 radius10"
            >
              {{ order.status }}
            </q-badge>
          </q-item-section>
        </q-item>
        <q-item
          clickable
          v-ripple:purple
          :to="{
            path: '/orderview',
            query: { order_uuid: order?.order_uuid },
          }"
        >
          <q-item-section>
            <q-item-label class="text-weight-bold text-subtitle2">{{
              order.customer_name
            }}</q-item-label>
            <q-item-label> {{ order.order_type }}</q-item-label>
          </q-item-section>
          <q-item-section top side>
            <q-item-label class="text-weight-medium text-subtitle2">{{
              order.total
            }}</q-item-label>
            <q-item-label>{{ order.payment_name }}</q-item-label>
          </q-item-section>
        </q-item>
        <q-item dense v-if="!order.order_accepted_at && !order.is_completed">
          <q-item-section>
            {{ $t("Preparation Estimate") }}
          </q-item-section>
          <q-item-section side
            ><q-btn
              icon="las la-edit"
              flat
              :label="order.preparation_time_estimation"
              no-caps
              padding="0"
              @click.stop="editPrepationtime(order, index)"
            ></q-btn
          ></q-item-section>
        </q-item>

        <template v-if="!order.is_completed">
          <q-separator></q-separator>
          <q-item>
            <div class="row items-center fit q-gutter-x-sm">
              <div clas="col-3">
                <q-btn
                  @click="showPrinter(order)"
                  color="white"
                  square
                  unelevated
                  text-color="grey"
                  icon="las la-print"
                  dense
                  no-caps
                  class="border-grey radius8"
                />
              </div>

              <div
                class="col"
                v-for="buttons in getButtons(order)"
                :key="buttons"
              >
                <q-btn
                  @click="changeStatus(buttons, order, index)"
                  no-caps
                  unelevated
                  class="radius8 fit"
                  :color="this.OrderStore.changeColor(buttons.class_name)"
                  :text-color="
                    this.OrderStore.changeTextColor(buttons.class_name)
                  "
                >
                  <div
                    class="text-weight-bold text-subtitle2 ellipsis line-normal"
                  >
                    {{ buttons.button_name }}
                  </div>
                </q-btn>
              </div>
            </div>
          </q-item>
          <q-item v-if="order.actions_buttons.length > 2">
            <q-item-section class="text-center">
              <q-item-label>
                <template
                  v-for="buttons in getlastButtons(order)"
                  :key="buttons"
                >
                  <q-btn
                    @click="changeStatus(buttons, order, index)"
                    no-caps
                    unelevated
                    class="radius8"
                    :color="this.OrderStore.changeColor(buttons.class_name)"
                    :text-color="
                      this.OrderStore.changeTextColor(buttons.class_name)
                    "
                  >
                    <div
                      class="text-weight-bold text-subtitle2 ellipsis line-normal"
                    >
                      {{ buttons.button_name }}
                    </div>
                  </q-btn>
                </template>
              </q-item-label>
            </q-item-section>
          </q-item>
        </template>
      </q-list>
    </div>
  </template>

  <RejectionList
    ref="rejection"
    @after-addreason="afterAddreason"
  ></RejectionList>

  <PrinterList
    ref="printer"
    @after-selectprinter="afterSelectprinter"
  ></PrinterList>

  <PreparationTime
    ref="ref_preparation_time"
    :data="preparation_time_estimation"
    :order_uuid="order_uuid"
    :payload="payload"
    @after-updatetime="afterUpdatetime"
  ></PreparationTime>
</template>

<script>
import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";
import { useUserStore } from "stores/UserStore";
import { useOrderStore } from "stores/OrderStore";
import { defineAsyncComponent } from "vue";
import AppBluetooth from "src/api/AppBluetooth";
import { Device } from "@capacitor/device";
import { useDataPersisted } from "stores/DataPersisted";

export default {
  name: "LastOrders",
  props: ["refresh_done"],
  data() {
    return {
      tab: "all",
      loading: false,
      data: [],
      limit: 5,
      status_list: [],
      item_details: [],
      order_items: [],
      settings_tabs: [],
      order_group_buttons: [],
      order_buttons: [],
      services_list: [],
      order_uuid: null,
      preparation_time_estimation: null,
      payload: "",
      button_uuid: null,
      current_row: null,
      printer_details: null,
      osVersion: 0,
      order_data: null,
      default_printer: null,
    };
  },
  components: {
    RejectionList: defineAsyncComponent(() =>
      import("components/RejectionList.vue")
    ),
    PreparationCircularprogress: defineAsyncComponent(() =>
      import("components/PreparationCircularprogress.vue")
    ),
    PrinterList: defineAsyncComponent(() =>
      import("components/PrinterList.vue")
    ),
    PreparationTime: defineAsyncComponent(() =>
      import("components/PreparationTime.vue")
    ),
    PrintReceipt: defineAsyncComponent(() =>
      import("components/PrintReceipt.vue")
    ),
  },
  setup() {
    const DataStore = useDataStore();
    const UserStore = useUserStore();
    const OrderStore = useOrderStore();
    const DataPersisted = useDataPersisted();
    return { DataStore, UserStore, OrderStore, DataPersisted };
  },
  watch: {
    refresh_done(newval, oldva) {
      this.data = [];
      this.getLastOrder();
    },
  },
  computed: {
    hasData() {
      return Object.keys(this.data).length > 0;
    },
  },
  mounted() {
    if (this.$q.capacitor) {
      this.getDevice();
    }

    this.$watch(
      () => this.UserStore.$state.pusher_receive_data,
      (newData) => {
        if (newData) {
          const notification_type = newData?.notification_type || null;
          if (notification_type == "order_update") {
            this.getLastOrder();
          }
        }
      }
    );

    this.$watch(
      () => this.OrderStore.$state.pollNewOrder,
      (newData) => {
        if (newData) {
          this.getLastOrder();
        }
      }
    );

    if (this.OrderStore.lastOrders?.data.length > 0) {
      console.log("same data", this.OrderStore.lastOrders);
      this.data = this.OrderStore.lastOrders?.data;
      this.tab = this.OrderStore.lastOrders?.tab;
      this.default_printer = this.OrderStore.lastOrders?.default_printer;
    } else {
      this.OrderStore.lastOrders = null;
      this.getLastOrder();
    }
  },
  beforeUnmount() {
    this.OrderStore.lastOrders = {
      tab: this.tab,
      data: this.data,
      default_printer: this.default_printer,
    };
  },
  methods: {
    getButtons(value) {
      if (!value) {
        return false;
      }
      if (value?.actions_buttons?.length > 2) {
        return value?.actions_buttons.slice(0, 2);
      }
      return value?.actions_buttons;
    },
    getlastButtons(value) {
      if (!value) {
        return false;
      }
      if (value?.actions_buttons?.length > 2) {
        return value?.actions_buttons.slice(2);
      }
      return false;
    },
    getTabLabel(data) {
      let total = "";
      if (this.OrderStore.foundCountOrder(data.value)) {
        total = `(${this.OrderStore.foundCountOrder(data.value)})`;
      }
      return data?.label + " " + total;
    },
    async getDevice() {
      const info = await Device.getInfo();
      this.osVersion = info.osVersion;
    },
    async getLastOrder() {
      try {
        this.loading = true;
        const params = {
          filter_by: this.tab,
          limit: this.limit,
          page: 1,
        };
        const response = await APIinterface.fetchGet("OrderListNew", params);

        if (response.code == 3) {
          this.data = [];
          this.OrderStore.order_count = response.details.tabs_total_order;
          this.OrderStore.updateOrderCount(
            this.OrderStore.order_count?.new_for_today
          );
          return;
        }

        this.OrderStore.order_count = response.details.tabs_total_order;
        this.data = response.details.data;
        this.default_printer = response.details?.printer_details;

        this.OrderStore.updateOrderCount(
          this.OrderStore.order_count?.new_for_today
        );
      } catch (error) {
        this.data = [];
        this.default_printer = null;
        if (this.tab == "all") {
          this.OrderStore.order_count = [];
          this.OrderStore.updateOrderCount(0);
        }
      } finally {
        this.loading = false;
      }
    },
    afterAddreason(data) {
      this.updateOrderStatus(data, "updateOrderStatus");
    },
    changeStatus(value, order, index) {
      this.current_row = index;
      this.button_uuid = value?.uuid;
      this.order_uuid = order?.order_uuid;
      const do_actions = value?.do_actions;
      if (do_actions == "reject_form") {
        this.$refs.rejection.dialog = true;
      } else {
        this.updateOrderStatus("", "updateOrderStatus");
      }
    },
    async updateOrderStatus(reason, actions) {
      try {
        APIinterface.showLoadingBox("", this.$q);
        const response = await APIinterface.fetchDataByToken(actions, {
          order_uuid: this.order_uuid,
          reason: reason,
          uuid: this.button_uuid,
          current_row: this.current_row,
        });

        APIinterface.ShowSuccessful(response.msg, this.$q);

        this.data[this.current_row] = response.details.data;
        this.OrderStore.order_count = response.details.tabs_total_order;

        this.OrderStore.orderListFeed = null;
        if (this.DataStore.dataList?.order_data) {
          this.DataStore.dataList.order_data = null;
        }

        this.OrderStore.updateOrderCount(
          this.OrderStore.order_count?.new_order
        );
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
    async showPrinter(order) {
      this.order_uuid = order?.order_uuid;
      if (this.default_printer) {
        this.printer_details = this.default_printer;
        this.orderDetails();
        return;
      }
      this.$refs.printer.dialog = true;
    },
    async afterSelectprinter(data) {
      this.$refs.printer.dialog = false;
      this.printer_details = data;
      this.orderDetails();
    },
    async orderDetails() {
      try {
        const printer_model = this.printer_details?.printer_model ?? null;
        console.log("printer_model", printer_model);

        if (printer_model == "feieyun") {
          this.FPprint(this.default_printer?.printer_id, this.order_uuid);
          return;
        }

        if (!this.$q.capacitor) {
          APIinterface.ShowAlert(
            this.$t(
              "To use Bluetooth printers, please connect from a real device."
            ),
            this.$q.capacitor,
            this.$q
          );
          return;
        }

        this.printer_details.print_type = this.DataPersisted.printer_set;

        APIinterface.showLoadingBox(this.$t("Getting order..."), this.$q);
        this.order_data = await this.OrderStore.orderDetails(this.order_uuid);

        setTimeout(() => {
          this.$refs.ref_printreceipt.initData();
        }, 500);
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
    editPrepationtime(data, index) {
      this.current_row = index;
      let prep_time =
        data?.preparation_time_estimation_raw > 0
          ? data?.preparation_time_estimation_raw
          : 10;

      this.order_uuid = data.order_uuid;
      this.preparation_time_estimation = prep_time;
      this.$refs.ref_preparation_time.modal = true;
    },
    afterUpdatetime(data) {
      this.OrderStore.clearSavedOrderList();

      const response = data?.details?.data || null;
      if (response) {
        this.data[this.current_row] = response;
      }
    },
    async FPprint(printer_id, order_uuid) {
      try {
        APIinterface.showLoadingBox(this.$t("Printing..."), this.$q);
        const response = await APIinterface.fetchDataByTokenPost(
          "FPprint",
          new URLSearchParams({
            printer_id: printer_id,
            order_uuid: order_uuid,
          }).toString()
        );
        APIinterface.ShowSuccessful(response.msg, this.$q);
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
    //
  },
};
</script>
