<template>
  <q-pull-to-refresh @refresh="refresh" color="primary" bg-color="white">
    <q-header class="bg-white text-dark">
      <q-toolbar v-if="!isScrolled">
        <template v-if="ispage">
          <q-btn
            @click="$router.back()"
            flat
            round
            dense
            icon="eva-arrow-back-outline"
          />
        </template>
        <q-toolbar-title class="text-subtitle2 text-weight-bold">{{
          $t("Orders")
        }}</q-toolbar-title>
      </q-toolbar>

      <q-tabs
        v-model="DataStore.order_tab"
        dense
        active-color="primary"
        active-class="active-tabs"
        indicator-color="primary"
        align="justify"
        no-caps
        mobile-arrows
        narrow-indicator
        @update:model-value="onTabClick"
      >
        <q-tab
          name="recent"
          :label="$t('Recent')"
          no-caps
          active-class="active-tabs"
        />
        <q-tab name="past" :label="$t('Past Orders')" no-caps />
        <q-tab name="search" no-caps v-if="isScrolled">
          <q-intersection transition="slide-left">
            <div
              class="bg-grey-2 text-subtitle2 q-pa-xs radius28 flex justify-center cursor-pointer"
              @click="this.$refs.ref_search.modal = true"
            >
              <div class="q-mr-sm">
                <q-icon name="eva-search-outline" size="20px"></q-icon>
              </div>
              <div class="text-weight-bold">{{ $t("Search") }}</div>
            </div>
          </q-intersection>
        </q-tab>
      </q-tabs>
      <q-separator></q-separator>
    </q-header>
    <q-page>
      <q-scroll-observer @scroll="onScroll" />

      <template v-if="!is_login">
        <div class="text-center q-pa-md absolute-center full-width">
          <div class="text-h6 line-normal text-weight-bold text-dark">
            {{ $t("You are not logged in") }}
          </div>
          <div class="text-caption text-grey">
            {{ $t("please login to continue") }}
          </div>
          <div class="q-mt-md">
            <q-btn
              no-caps
              rounded
              :label="$t('Login')"
              color="primary"
              unelevated
              padding="7px 30px"
              to="/user/login/?redirect=/home/orders"
            ></q-btn>
          </div>
        </div>
      </template>
      <template v-else>
        <q-space class="q-pa-sm"></q-space>

        <template v-if="!hasData && !loading">
          <NoResults
            :message="$t('noOrders')"
            :description="$t('letsChangeThat')"
          ></NoResults>
        </template>

        <q-infinite-scroll
          ref="nscroll"
          @load="fetchData"
          :offset="100"
          :initial-index="getCurrentPage"
        >
          <div class="q-pl-md q-pr-md q-pb-sm">
            <div
              class="bg-grey-1 text-subtitle2 q-pa-sm radius28 flex items-center cursor-pointer"
              @click="this.$refs.ref_search.modal = true"
            >
              <div class="q-mr-sm">
                <q-icon name="eva-search-outline" size="20px"></q-icon>
              </div>
              <div class="text-caption">
                {{ $t("Order ID") }}
              </div>
            </div>
          </div>

          <q-list>
            <template v-for="items in Orders" :key="items">
              <q-item clickable v-ripple:purple @click="showDetails(items)">
                <q-item-section avatar top>
                  <q-avatar>
                    <q-responsive style="width: 50px; height: 50px">
                      <q-img
                        :src="items.merchant_logo"
                        lazy
                        fit="cover"
                        class="radius8"
                        spinner-color="amber"
                        spinner-size="sm"
                      />
                    </q-responsive>
                  </q-avatar>
                </q-item-section>
                <q-item-section>
                  <q-item-label v-if="items.show_status">
                    <div
                      class="text-overline text-orange text-weight-bold line-normal text-capitalize"
                    >
                      {{ items.status }}
                    </div>
                  </q-item-label>
                  <q-item-label class="subtitle-2 text-weight-bold">{{
                    items.restaurant_name
                  }}</q-item-label>
                  <q-item-label caption>
                    #{{ items.order_id }} &bull; {{ items.date_created }}
                  </q-item-label>
                </q-item-section>
                <q-item-section side v-if="!items.show_status">
                  <q-item-label>{{ items.total }}</q-item-label>
                  <q-item-label caption>{{ items.earn_points }}</q-item-label>
                </q-item-section>
              </q-item>
              <q-item>
                <q-item-section avatar></q-item-section>
                <q-item-section class="myqstepper">
                  <template v-if="items.is_order_ongoing">
                    <q-stepper
                      v-model="items.progress.order_progress"
                      active-color="primary"
                      done-color="primary"
                      inactive-color="grey-3"
                      flat
                      contracted
                    >
                      <q-step
                        :name="1"
                        done-icon="eva-arrow-forward-outline"
                        active-icon="eva-arrow-forward-outline"
                        icon="eva-arrow-forward-outline"
                        :done="items.progress.order_progress > 1"
                      />
                      <q-step
                        :name="2"
                        done-icon="restaurant_menu"
                        active-icon="restaurant_menu"
                        icon="restaurant_menu"
                        :done="items.progress.order_progress > 2"
                      />
                      <q-step
                        :name="3"
                        done-icon="directions_car"
                        active-icon="directions_car"
                        icon="directions_car"
                        :done="items.progress.order_progress > 3"
                      />
                      <q-step
                        :name="4"
                        done-icon="home"
                        active-icon="home"
                        icon="home"
                        :done="items.progress.order_progress >= 4"
                      />
                    </q-stepper>
                  </template>
                  <template v-else>
                    <div class="flex q-gutter-x-md items-center">
                      <q-btn
                        v-if="items.show_review"
                        :label="$t('Rate')"
                        text-color="blue-grey-6"
                        dense
                        padding="0px"
                        flat
                        no-caps
                        @click="showReview(items)"
                      >
                        <q-btn
                          dense
                          padding="0px"
                          no-caps
                          rounded
                          color="amber-5"
                          text-color="white"
                          unelevated
                          icon="star"
                          size="xs"
                          class="q-ml-sm"
                        >
                        </q-btn>
                      </q-btn>

                      <q-btn
                        v-if="items.show_review_delivery"
                        :label="$t('Rate Delivery')"
                        text-color="blue-grey-6"
                        dense
                        padding="0px"
                        flat
                        no-caps
                        @click="showReviewdelivery(items)"
                      >
                        <q-btn
                          dense
                          padding="0px"
                          no-caps
                          rounded
                          color="orange"
                          text-color="white"
                          unelevated
                          icon="delivery_dining"
                          size="xs"
                          class="q-ml-sm"
                        >
                        </q-btn>
                      </q-btn>

                      <q-btn
                        :label="$t('Reorder')"
                        text-color="blue-grey-6"
                        dense
                        padding="0px"
                        flat
                        no-caps
                        @click="reOrder(items.order_uuid)"
                      >
                        <q-btn
                          dense
                          padding="0px"
                          no-caps
                          rounded
                          color="secondary"
                          text-color="white"
                          unelevated
                          icon="eva-arrow-forward-outline"
                          size="xs"
                          class="q-ml-sm"
                        >
                        </q-btn>
                      </q-btn>
                    </div>
                  </template>
                </q-item-section>
              </q-item>
            </template>
          </q-list>

          <template v-if="DataStore.orders_no_more_data && !loading && hasData">
            <div
              class="row q-gutter-x-sm justify-center"
              :class="{
                'absolute-bottom-left text-center full-width ':
                  getCurrentPage > 0 && getTotalData <= 10,
              }"
            >
              <div class="text-subtitle1 text-grey">
                {{ $t("end of results") }}
              </div>
            </div>
          </template>

          <template v-slot:loading>
            <div
              class="row q-gutter-x-sm justify-center q-my-md"
              :class="{
                'absolute-center text-center full-width': getCurrentPage == 0,
                'absolute-bottom-left text-center full-width ':
                  getCurrentPage > 0 && getTotalData <= 10,
              }"
            >
              <q-circular-progress
                indeterminate
                rounded
                size="sm"
                color="primary"
              />
              <div class="text-subtitle1 text-grey">{{ $t("Loading") }}...</div>
            </div>
          </template>
        </q-infinite-scroll>
      </template>
      <q-space class="q-pa-md"></q-space>

      <OrderListSearch
        ref="ref_search"
        @onReorder="reOrder"
        @showDetails="showDetails"
        @showReview="showReview"
      ></OrderListSearch>

      <OrderDetails
        ref="ref_orderdetails"
        :order_uuid="order_uuid"
        @onclose-order="oncloseOrder"
        :show_actions="true"
        @on-ratereview="showReview"
        @onReorder="reOrder"
      ></OrderDetails>

      <ReviewOrder ref="ref_order" @after-addreview="resetData"></ReviewOrder>

      <ReviewDelivery
        ref="ref_delivery"
        @after-addreview="resetData"
      ></ReviewDelivery>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import "swiper/css";
import { defineAsyncComponent } from "@vue/runtime-core";
import { useDataStore } from "stores/DataStore";
import { useDataStorePersisted } from "stores/DataStorePersisted";
import auth from "src/api/auth";

export default {
  name: "OrderList",
  components: {
    NoResults: defineAsyncComponent(() => import("components/NoResults.vue")),
    OrderListSearch: defineAsyncComponent(() =>
      import("components/OrderListSearch.vue")
    ),
    OrderDetails: defineAsyncComponent(() =>
      import("components/OrderDetails.vue")
    ),
    ReviewOrder: defineAsyncComponent(() =>
      import("components/ReviewOrder.vue")
    ),
    ReviewDelivery: defineAsyncComponent(() =>
      import("components/ReviewDelivery.vue")
    ),
  },
  setup() {
    const DataStore = useDataStore();
    const DataStorePersisted = useDataStorePersisted();
    return { DataStore, DataStorePersisted };
  },
  data() {
    return {
      q: "",
      data: [],
      isScrolled: false,
      is_login: false,
      loading: false,
      params: {},
      order_uuid: null,
      ispage: false,
    };
  },
  mounted() {
    this.is_login = auth.authenticated();
    this.ispage = this.$route.query.page;
    this.ispage = this.ispage == "true" ? true : false;
  },
  computed: {
    Orders() {
      return this.DataStore.orders_list;
    },
    getCurrentPage() {
      return this.DataStore.PageIndexOrders
        ? this.DataStore.PageIndexOrders - 1
        : 0;
    },
    getTotalData() {
      return this.DataStore.orders_list ? this.DataStore.orders_list.length : 0;
    },
    hasData() {
      return this.DataStore.orders_list ? this.DataStore.orders_list : false;
    },
    getPage() {
      if (this.params) {
        if (this.params.page) {
          return this.params.page;
        }
      }
      return null;
    },
  },
  methods: {
    showReviewdelivery(value) {
      this.$refs.ref_delivery.show(value);
    },
    showReview(value) {
      this.$refs.ref_order.show(value);
    },
    async reOrder(value) {
      try {
        APIinterface.showLoadingBox("", this.$q);
        const results = await APIinterface.orderBuyAgain({
          order_uuid: value,
        });
        this.DataStorePersisted.cart_uuid = results.details.cart_uuid;
        this.$router.push("/cart");
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
    oncloseOrder(value) {
      if (value) {
        this.resetData();
      }
    },
    showDetails(value) {
      if (value.is_order_ongoing) {
        this.$router.push({
          path: "/account/trackorder",
          query: { order_uuid: value.order_uuid, back_url: 1 },
        });
      } else {
        this.order_uuid = value.order_uuid;
        this.$refs.ref_orderdetails.modal = true;
      }
    },
    onScroll(info) {
      this.isScrolled = info.position.top > 140;
    },
    refresh(done) {
      setTimeout(() => {
        done();
      }, 100);
      this.resetData();
    },
    onTabClick(value) {
      console.log("onTabClick", value);
      if (value != "search") {
        this.resetData();
      }
    },
    resetData() {
      this.DataStore.clearOrders();
      this.DataStore.orders_no_more_data = false;
      if (!this.$refs.nscroll) {
        return;
      }
      this.$refs.nscroll.reset();
      this.$refs.nscroll.resume();
      this.$refs.nscroll.trigger();
    },
    async fetchData(index, done) {
      console.log("fetchData", index);
      if (this.loading) {
        done();
        return;
      }
      if (this.DataStore.orders_no_more_data) {
        done(true);
        return;
      }
      this.loading = true;

      this.params.page = index;
      this.params.order_type = this.DataStore.order_tab;
      this.DataStore.setCurrentPageOrders(index);
      try {
        const result = await APIinterface.fetchDataByTokenGet(
          "OrderList",
          this.params
        );
        console.log("result", result);

        if (result.code == 3) {
          this.DataStore.orders_no_more_data = true;
          done(true);
        } else if (result.code == 1) {
          if (!this.DataStore.isDataLoadedOrders) {
            this.DataStore.setOrders(result.details.data);
          } else {
            this.DataStore.appendOrders(result.details.data);
          }
        }
      } catch (error) {
        if (this.$refs.nscroll) {
          this.$refs.nscroll.stop();
        }
      } finally {
        this.loading = false;
        done();
      }
    },
  },
};
</script>

<style lang="scss">
.q-focus-helper {
  visibility: hidden;
}
</style>
