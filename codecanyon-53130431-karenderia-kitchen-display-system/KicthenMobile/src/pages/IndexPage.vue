<template>
  <q-pull-to-refresh @refresh="refresh">
    <TopOrdernav
      @after-seletordertype="afterSelectOrderType"
      @after-selectstatus="afterSelectStatus"
      @after-searchsubmit="onSearchSubmit"
      @apply-Filters="applyFilters"
      @clear-filter="clearFilter"
      :total="KitchenStore.getCurrentCount"
      :total_display="KitchenStore.getCurrentCountDisplay"
    >
    </TopOrdernav>

    <q-page :class="{ 'bg-grey600': $q.dark.mode }">
      <template v-if="$q.screen.lt.md">
        <MobileTabMenu></MobileTabMenu>
      </template>

      <div
        v-if="KitchenStore.order_loading"
        class="card-form-height flex flex-center"
      >
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

      <div v-else class="padding-8">
        <template v-if="$q.screen.lt.md">
          <FilterOrder
            @after-seletordertype="afterSelectOrderType"
            @after-selectstatus="afterSelectStatus"
            @after-searchsubmit="onSearchSubmit"
            @apply-Filters="applyFilters"
            @clear-filter="clearFilter"
          ></FilterOrder>
        </template>

        <template v-if="!hasOrderData && !KitchenStore.order_loading">
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
                @click="KitchenStore.refreshOrders(null, this.refresh_filter)"
              >
              </q-btn>
            </div>
          </div>
        </template>

        <template v-else>
          <template v-if="SettingStore.screen_options == 'tiled'">
            <!-- TILE VIEW -->
            <div class="container">
              <template v-for="items in KitchenStore.getOrderData" :key="items">
                <figure>
                  <div class="cell">
                    <OrderComponents
                      :items="items"
                      :can_change="true"
                      @set-bump="setBump"
                      @after-updateitem="afterUpdateitem"
                    ></OrderComponents>
                  </div>
                </figure>
              </template>
            </div>
            <!-- TILE VIEW -->
          </template>
          <template v-else-if="SettingStore.screen_options == 'classic'">
            <!-- CLASSIC VIEW -->
            <swiper
              ref="mySwiper"
              :slidesPerView="getNumberOfSlide"
              :spaceBetween="5"
              class="mySwiper"
            >
              <template v-for="items in KitchenStore.getOrderData" :key="items">
                <swiper-slide>
                  <OrderComponents
                    :items="items"
                    :can_change="true"
                    @set-bump="setBump"
                    @after-updateitem="afterUpdateitem"
                  ></OrderComponents>
                </swiper-slide>
              </template>
            </swiper>
          </template>

          <template v-else-if="SettingStore.screen_options == 'split'">
            <!-- SPLIT VIEW -->
            <q-splitter
              v-model="splitterModel"
              horizontal
              style="height: calc(100vh)"
            >
              <template v-slot:before>
                <q-card class="box-shadow q-pa-sm text-weight-bold q-mb-sm">
                  <template
                    v-for="(ordertype_top, index) in order_type_top"
                    :key="ordertype_top"
                  >
                    <template
                      v-if="
                        this.KitchenStore.getTransactionList2[ordertype_top]
                      "
                    >
                      {{ this.KitchenStore.getTransactionList2[ordertype_top] }}
                    </template>
                    <template v-else>
                      {{ ordertype_top }}
                    </template>
                    <template v-if="index !== order_type_top.length - 1"
                      >,</template
                    >
                  </template>
                </q-card>
                <div class="q-pb-md">
                  <swiper
                    ref="mySwiper"
                    :slidesPerView="getNumberOfSlide"
                    :spaceBetween="5"
                    class="mySwiper"
                  >
                    <template
                      v-for="items in KitchenStore.getOrderDataTop"
                      :key="items"
                    >
                      <swiper-slide>
                        <OrderComponents
                          :items="items"
                          :can_change="true"
                          :filters="filters_top"
                          position="top"
                          @set-bump="setBump"
                          @after-updateitem="afterUpdateitem"
                        ></OrderComponents>
                      </swiper-slide>
                    </template>
                  </swiper>
                </div>
              </template>

              <template v-slot:after>
                <q-card
                  class="box-shadow q-pa-sm text-weight-bold q-mt-sm q-mb-sm"
                >
                  <template
                    v-for="(ordertype_bottom, index2) in order_type_bottom"
                    :key="ordertype_bottom"
                  >
                    <template
                      v-if="
                        this.KitchenStore.getTransactionList2[ordertype_bottom]
                      "
                    >
                      {{
                        this.KitchenStore.getTransactionList2[ordertype_bottom]
                      }}
                    </template>
                    <template v-else>
                      {{ ordertype_bottom }}
                    </template>
                    <template v-if="index2 !== order_type_bottom.length - 1"
                      >,</template
                    >
                  </template>
                </q-card>
                <div class="q-pb-md">
                  <swiper
                    ref="mySwiper"
                    :slidesPerView="getNumberOfSlide"
                    :spaceBetween="5"
                    class="mySwiper"
                  >
                    <template
                      v-for="items in KitchenStore.getOrderDataBottom"
                      :key="items"
                    >
                      <swiper-slide>
                        <OrderComponents
                          :items="items"
                          :can_change="true"
                          :filters="filters_bottom"
                          position="bottom"
                          @set-bump="setBump"
                          @after-updateitem="afterUpdateitem"
                        ></OrderComponents>
                      </swiper-slide>
                    </template>
                  </swiper>
                </div>
              </template>
            </q-splitter>
          </template>
        </template>
      </div>
      <!-- padd 8 -->

      <template v-if="$q.screen.lt.md">
        <q-space class="q-pa-lg"></q-space>
      </template>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useKitchenStore } from "stores/KitchenStore";
import { useIdentityStore } from "stores/IdentityStore";
import APIinterface from "src/api/APIinterface";
import { useSettingStore } from "stores/SettingStore";
import { Swiper, SwiperSlide } from "swiper/vue";
import "swiper/css";

export default {
  components: {
    Swiper,
    SwiperSlide,
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
      splitterModel: 50,
      tab: "current",
      q: "",
      awaitingSearch: false,
      filters: {
        position: "",
        whento_deliver: "now",
        is_completed: 0,
        q: "",
        order_type: [],
        order_status: [],
      },
      refresh_filter: {
        whento_deliver: "now",
        is_completed: 0,
        q: "",
        order_type: [],
        order_status: [],
      },
      order_type_top: [],
      order_type_bottom: [],
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
    this.initOrder();

    //
    this.$watch(
      () => this.KitchenStore.$state.notification_type,
      (newData, oldData) => {
        this.KitchenStore.notification_type = "";

        switch (newData) {
          case "new_order":
          case "cancelled_order":
            this.KitchenStore.order_data = null;
            this.KitchenStore.order_count = null;
            this.initOrder();
            break;

          case "schedule_order":
            this.KitchenStore.refreshOrdersCount();
            setTimeout(() => {
              this.KitchenStore.refreshScheduled(null, {
                whento_deliver: "schedule",
                is_completed: 0,
                q: "",
                order_type: [],
                order_status: [],
              });
            }, 1000);
            break;

          case "move_orders_to_current":
            this.KitchenStore.order_data = null;
            this.KitchenStore.order_count = null;
            this.initOrder();
            this.KitchenStore.notification_type = "";
            setTimeout(() => {
              this.KitchenStore.refreshScheduled(null, {
                whento_deliver: "schedule",
                is_completed: 0,
                q: "",
                order_type: [],
                order_status: [],
              });
            }, 1000);
            break;
        }
      }
    );
    //
  },
  computed: {
    hasOrderData() {
      if (this.SettingStore.screen_options == "split") {
        let res1 = this.KitchenStore.hasOrderDataTop();
        let res2 = this.KitchenStore.hasOrderDataBottom();
        if (res1 || res2) {
          return true;
        } else {
          return false;
        }
      } else {
        return this.KitchenStore.hasOrder();
      }
    },
    getNumberOfSlide() {
      if (this.$q.screen.sm) {
        return 3.1;
      } else if (this.$q.screen.xs) {
        return this.$q.screen.width > 320 ? 2.1 : 1.1;
      }
      return 4.1;
    },
  },
  methods: {
    initOrder() {
      if (this.SettingStore.screen_options == "split") {
        this.getSplitOrder();
      } else {
        this.KitchenStore.getOrders(this.filters);
      }
      this.KitchenStore.getOrdersCount();
    },
    getSplitOrder() {
      this.filters_top.position = "top";
      this.order_type_top = this.getOrderSplit(this.filters_top.position);
      this.filters_top.order_type = this.order_type_top;
      this.KitchenStore.getOrdersTop(this.filters_top);

      this.filters_bottom.position = "bottom";
      this.order_type_bottom = this.getOrderSplit(this.filters_bottom.position);
      this.filters_bottom.order_type = this.order_type_bottom;
      this.KitchenStore.getOrdersBottom(this.filters_bottom);
    },
    getOrderSplit(position) {
      let data = [];
      if (Object.keys(this.SettingStore.split_order_type).length > 0) {
        Object.entries(this.SettingStore.split_order_type).forEach(
          ([key, items]) => {
            if (position == items) {
              data.push(key);
            }
          }
        );
      }
      return data;
    },
    refresh(done) {
      if (this.SettingStore.screen_options == "split") {
        this.filters_top.order_status = [];
        this.filters_bottom.order_status = [];
        this.getSplitOrder();
        done();
      } else {
        this.KitchenStore.refreshOrders(done, this.refresh_filter);
      }
      this.KitchenStore.refreshOrdersCount();
    },
    afterSelectOrderType(value) {
      this.filters.order_type = value;
    },
    afterSelectStatus(value) {
      if (this.SettingStore.screen_options == "split") {
        this.filters_top.order_status = value;
        this.filters_bottom.order_status = value;
      } else {
        this.filters.order_status = value;
      }
    },
    onSearchSubmit(value) {
      this.filters.q = value;
      this.filters_top.q = value;
      this.filters_bottom.q = value;
      this.applyFilters();
    },
    clearFilter() {
      this.filters = {
        q: "",
        order_type: [],
        order_status: [],
      };
      this.filters_top.q = "";
      this.filters_bottom.q = "";
      this.filters_top.order_status = [];
      this.filters_bottom.order_status = [];
      this.applyFilters();
    },
    applyFilters() {
      if (this.SettingStore.screen_options == "split") {
        this.getSplitOrder();
      } else {
        this.KitchenStore.refreshOrders(null, this.filters);
      }
      this.filters = {
        position: "",
        whento_deliver: "now",
        is_completed: 0,
        q: "",
        order_type: [],
        order_status: [],
      };
    },
    afterUpdateitem() {
      console.log("afterUpdateitem");
      this.getSplitOrder();
    },
  },
};
</script>

<style scoped>
/* .cell {
  max-width: 100%;
  display: block;
}

figure {
  margin: 0;
  display: grid;
  grid-template-rows: 1fr auto;
  margin-bottom: 10px;
  break-inside: avoid;
}

figure > .cell {
  grid-row: 1 / -1;
  grid-column: 1;
}

figure a {
  color: black;
  text-decoration: none;
}

figcaption {
  grid-row: 2;
  grid-column: 1;
  background-color: rgba(255, 255, 255, 0.5);
  padding: 0.2em 0.5em;
  justify-self: start;
}

.container {
  column-count: 4;
  column-gap: 10px;
} */
</style>
