<template>
  <TopOrdernav
    @after-seletordertype="afterSelectOrderType"
    @after-selectstatus="afterSelectStatus"
    @after-searchsubmit="onSearchSubmit"
    @apply-Filters="applyFilters"
    :total="KitchenStore.getScheduledTotal"
    :total_display="KitchenStore.displayScheduledTotal"
  >
  </TopOrdernav>

  <q-page :class="{ 'bg-grey600': $q.dark.mode }">
    <q-pull-to-refresh @refresh="refresh">
      <template v-if="$q.screen.lt.md">
        <MobileTabMenu></MobileTabMenu>
      </template>

      <template v-if="KitchenStore.order_loading">
        <div class="card-form-height flex flex-center">
          <q-circular-progress
            indeterminate
            size="50px"
            :thickness="0.22"
            rounded
            color="primary"
            track-color="grey-3"
            class="q-ma-md"
          />
        </div>
      </template>

      <template v-else>
        <div class="padding-8">
          <template v-if="$q.screen.lt.md">
            <FilterOrder
              @after-seletordertype="afterSelectOrderType"
              @after-selectstatus="afterSelectStatus"
              @after-searchsubmit="onSearchSubmit"
              @apply-Filters="applyFilters"
              @clear-filter="clearFilter"
            ></FilterOrder>
          </template>

          <template
            v-if="!KitchenStore.hasScheduledData && !KitchenStore.order_loading"
          >
            <div class="card-form-height flex flex-center">
              <div>
                <p
                  :class="{
                    'text-grey300': $q.dark.mode,
                  }"
                >
                  {{ $t("No available data") }}
                </p>
                <q-btn
                  :color="$q.dark.mode ? 'grey500' : 'primary'"
                  icon-right="eva-refresh-outline"
                  :label="$t('Refresh')"
                  no-caps
                  unelevated
                  flat
                  @click="
                    KitchenStore.refreshScheduled(null, this.refresh_filter)
                  "
                >
                </q-btn>
              </div>
            </div>
          </template>

          <div class="row">
            <template
              v-for="items in KitchenStore.getScheduledData"
              :key="items"
            >
              <div
                :class="{ 'col-3': $q.screen.gt.sm, 'col-12': $q.screen.lt.md }"
              >
                <div class="q-pa-xs">
                  <OrderComponents
                    :items="items"
                    :can_change="false"
                    @set-bump="setBump"
                    @move-order="moveOrder"
                  ></OrderComponents>
                </div>
              </div>
            </template>
          </div>
        </div>
        <!-- padd 8 -->
      </template>

      <template v-if="$q.screen.lt.md">
        <q-space class="q-pa-lg"></q-space>
      </template>
    </q-pull-to-refresh>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useKitchenStore } from "stores/KitchenStore";
import { useIdentityStore } from "stores/IdentityStore";
import { useSettingStore } from "stores/SettingStore";
import APIinterface from "src/api/APIinterface";

export default {
  components: {
    OrderComponents: defineAsyncComponent(() =>
      import("components/OrderComponents.vue")
    ),
    TopOrdernav: defineAsyncComponent(() =>
      import("components/TopOrdernav.vue")
    ),
    MobileTabMenu: defineAsyncComponent(() =>
      import("components/MobileTabMenu.vue")
    ),
    FilterOrder: defineAsyncComponent(() =>
      import("components/FilterOrder.vue")
    ),
  },
  data() {
    return {
      tab: "current",
      q: "",
      awaitingSearch: false,
      filters: {
        whento_deliver: "schedule",
        is_completed: 0,
        q: "",
        order_type: [],
        order_status: [],
      },
      refresh_filter: {
        whento_deliver: "schedule",
        is_completed: 0,
        q: "",
        order_type: [],
        order_status: [],
      },
      filters_top: {
        position: "",
        whento_deliver: "now",
        is_completed: 0,
        q: "",
        order_type: [],
        order_status: [],
      },
      filters_bottom: {
        position: "",
        whento_deliver: "now",
        is_completed: 0,
        q: "",
        order_type: [],
        order_status: [],
      },
    };
  },
  setup() {
    const KitchenStore = useKitchenStore();
    const IdentityStore = useIdentityStore();
    const SettingStore = useSettingStore();
    return { KitchenStore, IdentityStore, SettingStore };
  },
  mounted() {
    this.KitchenStore.getScheduled(this.filters);

    this.$watch(
      () => this.KitchenStore.$state.notification_type,
      (newData, oldData) => {
        //console.log("scheduled notification_type =>", newData);
        this.KitchenStore.notification_type = "";
        this.KitchenStore.refreshOrdersCount();
        if (newData == "new_order") {
          if (this.SettingStore.screen_options == "split") {
            this.getSplitOrder();
          } else {
            this.KitchenStore.order_data = null;
            this.KitchenStore.getOrders({
              position: "",
              whento_deliver: "now",
              is_completed: 0,
              q: "",
              order_type: [],
              order_status: [],
            });
          }
        } else if (newData == "schedule_order") {
          this.KitchenStore.refreshScheduled(null, {
            whento_deliver: "schedule",
            is_completed: 0,
            q: "",
            order_type: [],
            order_status: [],
          });
        } else if (newData == "move_orders_to_current") {
          if (this.SettingStore.screen_options == "split") {
            this.getSplitOrder();
          } else {
            this.KitchenStore.order_data = null;
            this.KitchenStore.getOrders({
              position: "",
              whento_deliver: "now",
              is_completed: 0,
              q: "",
              order_type: [],
              order_status: [],
            });
          }
          setTimeout(() => {
            this.KitchenStore.refreshScheduled(null, {
              whento_deliver: "schedule",
              is_completed: 0,
              q: "",
              order_type: [],
              order_status: [],
            });
          }, 1000);
        }
      }
    );
  },
  methods: {
    getSplitOrder() {
      this.filters_top.position = "top";
      this.order_type_top = this.getOrderSplit(this.filters_top.position);
      this.KitchenStore.getOrdersTop(this.filters_top);

      this.filters_bottom.position = "bottom";
      this.filters_bottom.order_type = this.order_type_bottom;
      this.KitchenStore.getOrdersBottom(this.filters_bottom);
    },
    refresh(done) {
      this.KitchenStore.refreshScheduled(done, this.refresh_filter);
      this.KitchenStore.refreshOrdersCount();
    },
    afterSelectOrderType(value) {
      this.filters.order_type = value;
    },
    afterSelectStatus(value) {
      this.filters.order_status = value;
    },
    onSearchSubmit(value) {
      this.filters.q = value;
      this.applyFilters();
    },
    clearFilter() {
      this.filters = this.refresh_filter;
      this.applyFilters();
    },
    applyFilters() {
      this.KitchenStore.refreshScheduled(null, this.filters);
    },
    moveOrder(order_reference) {
      APIinterface.showLoadingBox(this.$t("Processing"), this.$q);
      APIinterface.fetchDataPost("moveOrder", {
        order_reference: order_reference,
        filters: this.refresh_filter,
      })
        .then((data) => {
          if (data.details.count > 0) {
            this.KitchenStore.order_data2 = data.details;
          } else {
            this.KitchenStore.order_data2 = null;
          }
          this.KitchenStore.refreshOrdersCount();
          this.KitchenStore.refreshOrders(null, this.refresh_filter);
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
  },
};
</script>
