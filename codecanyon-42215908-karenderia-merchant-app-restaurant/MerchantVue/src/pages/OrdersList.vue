<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page class="bg-white q-pt-md">
      <q-scroll-observer @scroll="onScroll" />

      <div :class="{ 'fixed-top z-max bg-grey-1 q-mt-xl ': isScrolled }">
        <q-tabs
          v-model="tab"
          @update:model-value="resetPagination()"
          dense
          active-color="primary"
          active-class="active-tabs"
          indicator-color="primary"
          align="justify"
          no-caps
          mobile-arrows
          narrow-indicator
          class="q-pr-md q-pl-md text-disabled"
        >
          <template v-for="items in DataStore.last_order" :key="items">
            <q-tab
              v-if="AccessStore.hasAccess(items.permission)"
              :name="items.value"
              :label="getTabLabel(items)"
              active-class="active-tabs"
              no-caps
            >
            </q-tab>
          </template>
        </q-tabs>
        <q-separator></q-separator>
      </div>

      <q-space class="q-pa-xs"></q-space>

      <q-virtual-scroll
        class="fit q-pl-md q-pr-md"
        separator
        :items="data"
        :virtual-scroll-item-size="60"
        v-slot="{ item: order, index }"
      >
        <q-card class="radius8 q-pl-xs q-pr-xs box-shadow0 q-mb-md" flat>
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
                    <div
                      v-if="order.is_critical == true"
                      class="blob red"
                    ></div>
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
                  :color="
                    OrderStore.statusColor[order.status_raw]?.bg || 'primary'
                  "
                  :text-color="
                    OrderStore.statusColor[order.status_raw]?.text || 'white'
                  "
                  class="text-weight-medium text-body2"
                  rounded
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
              <q-item-section
                top
                side
                class="text-weight-medium text-subtitle2"
                >{{ order.total }}</q-item-section
              >
            </q-item>
            <q-item
              dense
              v-if="!order.order_accepted_at && !order.is_completed"
            >
              <q-item-section>
                {{ $t("Preparation Estimate") }}
              </q-item-section>
              <q-item-section side
                ><q-btn
                  icon="eva-edit-2-outline"
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
        </q-card>
      </q-virtual-scroll>

      <q-infinite-scroll
        ref="nscroll"
        @load="fetchOrders"
        :offset="250"
        :disable="scroll_disabled"
      >
        <template v-slot:default>
          <NoData v-if="!hasMore && !hasData" icon="/svg/no-data.svg" />
        </template>

        <template v-slot:loading>
          <LoadingData :page="current_page"></LoadingData>
        </template>
      </q-infinite-scroll>

      <q-space class="q-pa-lg"></q-space>

      <q-page-scroller
        position="bottom-right"
        :scroll-offset="150"
        :offset="[18, 18]"
      >
        <q-btn
          fab
          icon="keyboard_arrow_up"
          :color="$q.dark.mode ? 'grey600' : 'mygrey'"
          :text-color="$q.dark.mode ? 'grey300' : 'dark'"
          dense
          padding="3px"
        />
      </q-page-scroller>

      <RejectionList
        ref="rejection"
        @after-addreason="afterAddreason"
      ></RejectionList>

      <PreparationTime
        ref="ref_preparation_time"
        :data="preparation_time_estimation"
        :order_uuid="order_uuid"
        :payload="payload"
        @after-updatetime="afterUpdatetime"
      ></PreparationTime>

      <PrinterList
        ref="printer"
        @after-selectprinter="afterSelectprinter"
      ></PrinterList>

      <PrintReceipt
        ref="ref_printreceipt"
        :data="order_data"
        :printer="printer_details"
      ></PrintReceipt>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";
import { useUserStore } from "stores/UserStore";
import { useAccessStore } from "stores/AccessStore";
import { useOrderStore } from "stores/OrderStore";
import AppBluetooth from "src/api/AppBluetooth";
import { Device } from "@capacitor/device";
import { useDataPersisted } from "stores/DataPersisted";

export default {
  name: "OrdersList",
  setup() {
    const DataStore = useDataStore();
    const UserStore = useUserStore();
    const AccessStore = useAccessStore();
    const OrderStore = useOrderStore();
    const DataPersisted = useDataPersisted();
    return { DataStore, UserStore, AccessStore, OrderStore, DataPersisted };
  },
  components: {
    RejectionList: defineAsyncComponent(() =>
      import("components/RejectionList.vue")
    ),
    PreparationCircularprogress: defineAsyncComponent(() =>
      import("components/PreparationCircularprogress.vue")
    ),
    PreparationTime: defineAsyncComponent(() =>
      import("components/PreparationTime.vue")
    ),
    PrinterList: defineAsyncComponent(() =>
      import("components/PrinterList.vue")
    ),
    PrintReceipt: defineAsyncComponent(() =>
      import("components/PrintReceipt.vue")
    ),
    NoData: defineAsyncComponent(() => import("components/NoData.vue")),
    LoadingData: defineAsyncComponent(() =>
      import("components/LoadingData.vue")
    ),
  },
  data() {
    return {
      loading: false,
      tab: "all",

      isScrolled: false,

      params: {},
      current_page: 1,
      scroll_disabled: true,
      hasMore: true,
      data: [],

      payload: "",
      order_uuid: null,
      preparation_time_estimation: null,
      button_uuid: null,
      current_row: null,
      printer_details: null,
      osVersion: 0,
      order_data: null,
      default_printer: null,
    };
  },
  computed: {
    hasData() {
      if (this.data.length > 0) {
        return true;
      }
      return false;
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
            this.tab = "all";
            this.resetPagination();
          }
        }
      }
    );

    this.$watch(
      () => this.OrderStore.$state.pollNewOrder,
      (newData) => {
        if (newData) {
          console.log("here");
          this.resetPagination();
        }
      }
    );

    if (this.OrderStore.orderListFeed?.data.length > 0) {
      console.log("same data", this.OrderStore.orderListFeed?.hasMore);
      this.tab = this.OrderStore.orderListFeed?.tab || "all";
      this.data = this.OrderStore.orderListFeed?.data || [];
      this.current_page = this.OrderStore.orderListFeed?.current_page || 1;
      this.hasMore = this.OrderStore.orderListFeed?.hasMore || false;
    } else {
      this.OrderStore.orderListFeed = null;
    }

    this.scroll_disabled = false;
  },
  beforeUnmount() {
    this.OrderStore.orderListFeed = {
      tab: this.tab,
      data: this.data,
      current_page: this.current_page,
      hasMore: this.hasMore,
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
    onScroll(info) {
      this.isScrolled = info.position.top > 140;
    },
    refresh(done) {
      setTimeout(() => {
        done();
      }, 100);
      this.resetPagination();
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
    async fetchOrders(index, done) {
      try {
        if (this.loading) {
          return;
        }
        if (!this.hasMore) {
          this.scroll_disabled = true;
          done(true);
          return;
        }

        this.loading = true;
        this.params = {
          filter_by: this.tab,
          page: this.current_page,
        };
        const response = await APIinterface.fetchGet(
          "OrderListNew",
          this.params
        );

        if (response.code == 3) {
          this.OrderStore.order_count = response.details?.tabs_total_order;
          this.OrderStore.updateOrderCount(
            this.OrderStore.order_count?.new_order
          );
          this.data = [];
          this.hasMore = false;
          this.scroll_disabled = true;
          this.default_printer = null;
          done(true);
          return;
        }
        this.current_page++;

        this.data = [...this.data, ...response.details.data];
        this.default_printer = response.details?.printer_details;

        this.OrderStore.order_count = response.details.tabs_total_order;
        this.OrderStore.updateOrderCount(
          this.OrderStore.order_count?.new_order
        );

        if (response.details.is_last_page) {
          this.hasMore = false;
          this.scroll_disabled = true;
          done(true);
          return;
        }
        done();
      } catch (error) {
        console.log("error", error);
        this.data = [];
        if (this.tab == "all") {
          this.OrderStore.order_count = [];
          this.OrderStore.updateOrderCount(0);
        }
        this.hasMore = false;
        this.scroll_disabled = true;
        this.default_printer = null;
        done(true);
      } finally {
        this.loading = false;
      }
    },
    resetPagination() {
      this.data = [];
      this.current_page = 1;
      this.hasMore = true;
      this.scroll_disabled = false;
      this.$nextTick(() => {
        this.$refs.nscroll?.resume?.();
        this.$refs.nscroll?.trigger?.();
      });
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

        this.OrderStore.lastOrders = null;

        this.OrderStore.updateOrderCount(
          this.OrderStore.order_count?.new_order
        );
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
    async showPrinter(order) {
      this.order_uuid = order?.order_uuid;
      if (this.$q.capacitor) {
        if (this.$q.platform.is.ios) {
          this.EnabledBT();
        } else {
          if (this.osVersion >= 12) {
            try {
              await AppBluetooth.CheckBTConnectPermission();
              await AppBluetooth.CheckBTScanPermission();
              this.$refs.printer.dialog = true;
            } catch (error) {
              const errorMessage = error.message || error;
              APIinterface.ShowAlert(errorMessage, this.$q.capacitor, this.$q);
            }
            return;
          }

          try {
            await AppBluetooth.CheckLocationOnly();
            if (this.default_printer) {
              this.printer_details = this.default_printer;
              this.orderDetails();
              return;
            }
            this.$refs.printer.dialog = true;
          } catch (error) {
            this.$router.push("/settings/location-enabled");
          }
        }
      } else {
        if (this.default_printer) {
          this.printer_details = this.default_printer;
          this.orderDetails();
          return;
        }
        this.$refs.printer.dialog = true;
      }
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
    EnabledBT() {
      AppBluetooth.Enabled()
        .then((data) => {
          this.$refs.printer.dialog = true;
        })
        .catch((error) => {
          APIinterface.ShowAlert(error.message, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          //
        });
    },
    async afterSelectprinter(data) {
      this.$refs.printer.dialog = false;
      this.printer_details = data;

      if (data.printer_model == "feieyun") {
        // CHINESE PRINTER
        this.FPprint(data?.printer_id, this.order_uuid);
      } else {
        this.orderDetails();
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
