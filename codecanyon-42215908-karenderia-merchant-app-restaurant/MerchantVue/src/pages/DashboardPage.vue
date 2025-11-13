<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
    >
      <div v-if="loading" class="q-pa-md q-gutter-y-md">
        <q-skeleton height="50px" square class="bg-grey-2 radius8" />
        <q-skeleton height="80px" square class="bg-grey-2 radius8" />
        <div class="row q-gutter-x-md" v-for="items in 2" :key="items">
          <div class="col">
            <q-skeleton height="80px" square class="bg-grey-2 radius8" />
          </div>
          <div class="col">
            <q-skeleton height="80px" square class="bg-grey-2 radius8" />
          </div>
        </div>

        <div class="row q-gutter-x-md">
          <div class="col" v-for="items in 4" :key="items">
            <q-skeleton height="40px" square class="bg-grey-2 radius8" />
          </div>
        </div>

        <template v-for="items in 3" :key="items">
          <q-skeleton height="80px" square class="bg-grey-2 radius8" />
        </template>

        <q-skeleton
          v-for="items in 2"
          :key="items"
          height="150px"
          square
          class="bg-grey-2 radius8"
        />
      </div>
      <!-- loader -->

      <div v-if="!loading" class="q-pa-md">
        <q-card flat class="radius8" :class="storeStatusColor">
          <q-item>
            <q-item-section>
              <q-item-label class="text-weight-medium text-dark">{{
                $t("Restaurant Status")
              }}</q-item-label>
              <q-item-label class="text-weight-medium text-caption"
                >{{
                  $t("Set your store availability for customers")
                }}.</q-item-label
              >
            </q-item-section>
            <q-item-section side>
              <q-item-label
                class="text-capitalize text-weight-bold text-subtitle2"
              >
                {{ $t(SettingStore.store_status) }}
              </q-item-label>
            </q-item-section>
          </q-item>
        </q-card>

        <q-space class="q-pa-sm"></q-space>

        <q-card flat class="radius8 bg-oranges border-oranges">
          <q-item>
            <q-item-section avatar>
              <img
                src="/svg/wallet1.svg"
                style="
                  border-right: 1px solid rgba(255, 141, 47, 0.3);
                  padding-right: 8px;
                "
              />
            </q-item-section>
            <q-item-section>
              <q-item-label class="text-body2 text-weight-medium">
                {{ $t("Total Sales") }}
              </q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-item-label class="text-weight-bolder text-h6 text-orange-8">{{
                data?.total_sales
              }}</q-item-label>
            </q-item-section>
          </q-item>

          <div class="border-oranges q-ml-md q-mr-md"></div>

          <q-item>
            <q-item-section
              style="
                border-right: 1px solid rgba(255, 141, 47, 0.3);
                padding-right: 8px;
              "
            >
              <q-item-label class="text-caption">{{
                $t("Sales this week")
              }}</q-item-label>
              <q-item-label
                class="text-weight-bolder text-body1 text-orange-8"
                >{{ data?.sales_week }}</q-item-label
              >
            </q-item-section>
            <q-item-section
              style="
                border-right: 1px solid rgba(255, 141, 47, 0.3);
                padding-right: 8px;
              "
            >
              <q-item-label class="text-caption">{{
                $t("Week's Earnings")
              }}</q-item-label>
              <q-item-label
                class="text-weight-bolder text-body1 text-orange-8"
                >{{ data?.earning_week }}</q-item-label
              >
            </q-item-section>
            <q-item-section>
              <q-item-label class="text-caption">{{
                $t("Total refund")
              }}</q-item-label>
              <q-item-label
                class="text-weight-bolder text-body1 text-orange-8"
                >{{ data?.total_refund }}</q-item-label
              >
            </q-item-section>
          </q-item>
        </q-card>

        <q-space class="q-pa-sm"></q-space>

        <div class="row q-gutter-x-md">
          <div class="col">
            <q-card
              flat
              class="beautiful-shadow wborder-bottom wborder-primary"
            >
              <q-item>
                <q-item-section>
                  <q-item-label class="text-weight-bold text-h6">{{
                    data?.new
                  }}</q-item-label>
                  <q-item-label class="text-caption">{{
                    $t("New")
                  }}</q-item-label>
                </q-item-section>
                <q-item-section side>
                  <img src="/svg/order-new.svg" />
                </q-item-section>
              </q-item>
            </q-card>
          </div>
          <div class="col">
            <q-card flat class="beautiful-shadow wborder-bottom wborder-info">
              <q-item>
                <q-item-section>
                  <q-item-label class="text-weight-bold text-h6">{{
                    data?.processing
                  }}</q-item-label>
                  <q-item-label class="text-caption">{{
                    $t("In Progress")
                  }}</q-item-label>
                </q-item-section>
                <q-item-section side>
                  <img src="/svg/order-pending.svg" />
                </q-item-section>
              </q-item>
            </q-card>
          </div>
        </div>

        <q-space class="q-pa-sm"></q-space>

        <div class="row q-gutter-x-md">
          <div class="col">
            <q-card
              flat
              class="beautiful-shadow wborder-bottom wborder-warning"
            >
              <q-item>
                <q-item-section>
                  <q-item-label class="text-weight-bold text-h6">{{
                    data?.ready
                  }}</q-item-label>
                  <q-item-label class="text-caption">{{
                    $t("On the Way")
                  }}</q-item-label>
                </q-item-section>
                <q-item-section side>
                  <img src="/svg/order-active1.svg" />
                </q-item-section>
              </q-item>
            </q-card>
          </div>
          <div class="col">
            <q-card
              flat
              class="beautiful-shadow wborder-bottom wborder-success"
            >
              <q-item>
                <q-item-section>
                  <q-item-label class="text-weight-bold text-h6">{{
                    data?.completed
                  }}</q-item-label>
                  <q-item-label class="text-caption">{{
                    $t("Completed")
                  }}</q-item-label>
                </q-item-section>
                <q-item-section side>
                  <img src="/svg/order-completed.svg" />
                </q-item-section>
              </q-item>
            </q-card>
          </div>
        </div>

        <q-space class="q-pa-sm"></q-space>

        <div class="relative-position">
          <LastOrders
            :refresh_done="refresh_done"
            v-if="AccessStore.hasAccess('merchant.dashboard.last_5_orders')"
          ></LastOrders>
        </div>
        <q-space class="q-pa-sm"></q-space>
      </div>

      <q-card v-if="!loading" flat class="bg-grey-1">
        <q-card-section>
          <q-item class="q-pa-none">
            <q-item-section>
              <q-item-label class="text-weight-bold text-body1">{{
                $t("Customer Insights")
              }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-btn flat no-caps unelevated color="primary" to="/customer">
                <div class="text-weight-medium text-subtitle2">
                  {{ $t("Show all") }}
                </div>
              </q-btn>
            </q-item-section>
          </q-item>

          <div class="flex items-center q-gutter-x-sm">
            <div class="text-h5 text-weight-bold">
              {{ data?.customer_insight?.total ?? "0" }}
            </div>
            <div>
              <q-badge color="green-1 green-8 text-body2 text-weight-bold">
                <q-icon :name="getTrend" color="green-8" />
                <span class="text-green-8">{{
                  data?.customer_insight?.trend ?? "0%"
                }}</span>
              </q-badge>
            </div>
          </div>

          <div class="q-pa-md q-gutter-sm" style="height: 80px">
            <template
              v-for="(items, index) in data?.customer_list"
              :key="items"
            >
              <q-avatar
                size="40px"
                class="overlapping"
                :style="`left: ${index * 25}px`"
              >
                <img :src="items.image_url" />
              </q-avatar>
            </template>
          </div>
        </q-card-section>
      </q-card>

      <q-space class="q-pa-sm"></q-space>

      <div class="q-pr-md q-pl-md" v-if="!loading">
        <q-card flat>
          <q-item class="q-pa-none">
            <q-item-section>
              <q-item-label class="text-weight-bold text-body1">{{
                $t("Customer Review Insights")
              }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-btn
                flat
                no-caps
                unelevated
                color="primary"
                to="/customer/review-list"
              >
                <div class="text-weight-medium text-subtitle2">
                  {{ $t("Show all") }}
                </div>
              </q-btn>
            </q-item-section>
          </q-item>

          <div class="row items-center q-gutter-y-sm">
            <div class="col-5">
              <div class="q-pa-sm text-center q-gutter-y-sm">
                <q-rating
                  v-model="ratingModel"
                  size="1.4em"
                  :max="5"
                  color="grey-6"
                  color-selected="amber-5"
                  no-dimming
                  readonly
                />

                <div class="text-weight-bold text-subtitle2">
                  <!-- 4.5/5 -->
                  {{ data?.ratings?.ratings }} /
                  {{ data?.ratings?.review_count }}
                </div>
                <div class="text-caption">{{ $t("customer reviews") }}</div>
              </div>
            </div>
            <div class="col">
              <div v-for="n in data?.review_summary" :key="n">
                <div class="row items-center justify-between">
                  <div class="text-caption col-1 text-center text-grey">
                    {{ n.count }}
                  </div>
                  <div class="col">
                    <q-slider
                      dense
                      color="amber"
                      track-color="grey-3"
                      readonly
                      :min="0"
                      :max="100"
                      :model-value="n.review"
                      thumb-size="0"
                    />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </q-card>
      </div>

      <q-space class="q-pa-lg" v-if="!loading"> </q-space>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useDataStore } from "stores/DataStore";
import { useAccessStore } from "stores/AccessStore";
import { useSettingStore } from "stores/SettingStore";
import { useUserStore } from "stores/UserStore";
import APIinterface from "src/api/APIinterface";

export default {
  name: "DashboardPage",
  components: {
    LastOrders: defineAsyncComponent(() => import("components/LastOrders.vue")),
  },
  data() {
    return {
      data: null,
      refresh_done: undefined,
      value: false,
      ratingModel: 2,
      ratings: null,
      loading: false,
    };
  },
  setup() {
    const AccessStore = useAccessStore();
    const SettingStore = useSettingStore();
    const DataStore = useDataStore();
    return { SettingStore, AccessStore, DataStore };
  },
  computed: {
    getTrend() {
      const trendLabel = this.data?.customer_insight?.trendLabel ?? "nochange";
      if (trendLabel == "nochange") {
        return "east";
      } else if (trendLabel == "increase") {
        return "north";
      } else if (trendLabel == "decrease") {
        return "south";
      }
      return "east";
    },
    storeStatusColor() {
      const status = this.SettingStore.store_status ?? null;
      if (!status) {
        return "bg-green-1 text-green-9";
      }
      if (status == "open") {
        return "bg-green-1 text-green-9";
      } else if (status == "close") {
        return "bg-red-1 red-green-9";
      } else if (status == "pause") {
        return "bg-indigo-1 red-indigo-9";
      }

      return "bg-green-1 text-green-9";
    },
  },
  mounted() {
    const data = this.DataStore.dataList?.dashboard_data ?? null;
    if (data) {
      this.data = data;
    } else {
      this.fetchDashboardData();
    }

    const userStore = useUserStore();
    this.$watch(
      () => userStore.pusher_receive_data,
      (newData) => {
        if (newData) {
          this.processReceivePush(newData);
        }
      }
    );
  },
  beforeUnmount() {
    this.DataStore.dataList.dashboard_data = this.data;
  },
  methods: {
    processReceivePush(data) {
      console.log("processReceivePush", data);
      const notification_type = data?.notification_type;

      if (notification_type != "order_update") {
        return;
      }

      const meta_data = data?.meta_data ?? null;
      console.log("notification_type", notification_type);
      const status = meta_data?.status ?? null;
      console.log("order status", status);
      if (!status) {
        return;
      }
      if (status == "new") {
        this.fetchDashboardData();
      }
    },
    async fetchDashboardData() {
      try {
        if (!this.data) {
          this.loading = true;
        }
        const response = await APIinterface.fetchGet("fetchDashboardData");
        this.data = response.details;
      } catch (error) {
        this.data = null;
      } finally {
        this.loading = false;
        if (this.refresh_done) {
          this.refresh_done();
        }
      }
    },
    refresh(done) {
      this.refresh_done = done;
      this.fetchDashboardData();
    },
  },
};
</script>
