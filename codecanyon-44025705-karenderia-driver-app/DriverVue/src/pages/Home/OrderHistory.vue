<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page>
      <div class="q-pl-sm q-pr-sm q-pt-xs">
        <!-- <CalendarHalf
          ref="calendar"
          @after-selectdate="afterSelectdate"
          :today_date="date_start"
        ></CalendarHalf> -->

        <div class="row">
          <div class="col-11">
            <CalendarHalf
              ref="calendar"
              @after-selectdate="afterSelectdate"
              :today_date="date_start"
            ></CalendarHalf>
          </div>
          <div class="col">
            <q-btn icon="event" round color="green-4" size="sm" flat>
              <q-popup-proxy
                @before-show="updateProxy"
                cover
                transition-show="scale"
                transition-hide="scale"
              >
                <q-date v-model="proxyDate" mask="YYYY-MM-DD" range>
                  <div class="row items-center justify-end q-gutter-sm">
                    <q-btn label="Cancel" color="primary" flat v-close-popup />
                    <q-btn
                      :label="$t('OK')"
                      color="primary"
                      flat
                      @click="filterByDate"
                      v-close-popup
                    />
                  </div>
                </q-date>
              </q-popup-proxy>
            </q-btn>
          </div>
        </div>

        <template v-if="loading_summary">
          <div class="q-mb-sm">
            <div class="row q-col-gutter-sm">
              <div v-for="items in 3" :key="items" class="col">
                <q-skeleton height="60px" square />
              </div>
            </div>
          </div>
        </template>
        <template v-else>
          <swiper
            :slidesPerView="2.5"
            :spaceBetween="10"
            @swiper="onSwiper"
            class="q-mb-md"
          >
            <swiper-slide>
              <div class="text-white q-pa-sm radius8 bg-blue">
                <div class="font12">{{ $t("Total delivered") }}</div>
                <div class="text-weight-bold">
                  {{ summary_data.total_deliveries }}
                </div>
              </div>
            </swiper-slide>
            <swiper-slide>
              <div class="text-white q-pa-sm radius8 bg-green-4">
                <div class="font12">{{ $t("Cash collected") }}</div>
                <div class="text-weight-bold">
                  {{ summary_data.cash_collected }}
                </div>
              </div>
            </swiper-slide>
            <swiper-slide>
              <div class="text-white q-pa-sm radius8 bg-amber-14">
                <div class="font12">{{ $t("Delivery pay") }}</div>
                <div class="text-weight-bold">
                  {{ summary_data.total_delivery_pay }}
                </div>
              </div>
            </swiper-slide>
            <swiper-slide>
              <div
                class="text-white q-pa-sm radius8"
                style="background-color: #9689e7"
              >
                <div class="font12">{{ $t("Total Tips") }}</div>
                <div class="text-weight-bold">
                  {{ summary_data.total_tips }}
                </div>
              </div>
            </swiper-slide>
          </swiper>
        </template>

        <div class="text-h7">{{ $t("Transaction history") }}</div>
      </div>

      <div class="q-pl-sm q-pr-sm q-pt-xs">
        <q-card class="no-shadow">
          <q-infinite-scroll ref="nscroll" @load="getHistory" :offset="250">
            <template v-slot:loading>
              <template v-if="page <= 0">
                <div
                  class="flex flex-center full-width q-pa-xl"
                  style="min-height: calc(30vh)"
                >
                  <q-spinner color="primary" size="2em" />
                </div>
              </template>
              <template v-else>
                <div v-if="data.length > 1" class="text-center">
                  <q-circular-progress
                    indeterminate
                    rounded
                    size="30px"
                    color="primary"
                    class="q-ma-md"
                  />
                </div>
              </template>
            </template>
            <template v-slot:default>
              <template v-if="!loading && !hasData">
                <div class="flex flex-center" style="min-height: calc(50vh)">
                  <div class="text-center">
                    <div class="font16 text-weight-bold">
                      {{ $t("No available data") }}
                    </div>
                    <p class="font11">
                      {{ $t("Pull down the page to refresh") }}
                    </p>
                  </div>
                </div>
              </template>

              <q-list separator>
                <template v-for="itemdata in data" :key="itemdata">
                  <q-item v-for="items in itemdata" :key="items">
                    <q-item-section avatar style="min-width: 35px">
                      <!-- green-4 -->
                      <q-avatar
                        :color="items.online_payment ? 'blue' : 'green-4'"
                        text-color="white"
                        size="md"
                        :icon="
                          items.online_payment
                            ? 'las la-credit-card'
                            : 'las la-hand-holding-usd'
                        "
                      />
                    </q-item-section>
                    <q-item-section>
                      <q-item-label>{{ items.order_id }}</q-item-label>
                      <q-item-label caption>{{
                        items.merchant.restaurant_name
                      }}</q-item-label>
                      <q-item-label caption class="font11">{{
                        items.total
                      }}</q-item-label>
                    </q-item-section>
                    <q-item-section side>
                      <q-item-label>{{ items.delivery_pay }}</q-item-label>
                      <q-item-label
                        v-if="items.courier_tip_raw > 0"
                        caption
                        class="font11"
                        >{{ items.delivery_fee }} + {{ items.courier_tip }}
                        {{ $t("tips") }}</q-item-label
                      >
                    </q-item-section>
                    <!-- <q-item-section side> {{ items.total }}</q-item-section> -->
                  </q-item>
                </template>
              </q-list>
            </template>
          </q-infinite-scroll>
        </q-card>
      </div>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { useActivityStore } from "stores/ActivityStore";
import APIinterface from "src/api/APIinterface";
import { defineAsyncComponent } from "vue";
import { Swiper, SwiperSlide } from "swiper/vue";
import "swiper/css";

export default {
  name: "PageName",
  data() {
    return {
      calendar: "1",
      loading: true,
      loading_summary: true,
      data: [],
      page: 0,
      data_done: false,
      order_meta: [],
      merchant: [],
      payment_list: [],
      summary_data: [],
      date_start: "",
      date_end: "",
      proxyDate: undefined,
    };
  },
  components: {
    Swiper,
    SwiperSlide,
    CalendarHalf: defineAsyncComponent(() =>
      import("components/CalendarHalf.vue")
    ),
    //LoaderOrder: defineAsyncComponent(() => import("components/LoaderOrder.vue")),
    //CalendarWeekly: defineAsyncComponent(() => import("components/CalendarWeekly.vue")),
  },
  setup() {
    const Activity = useActivityStore();
    return { Activity };
  },
  created() {
    this.Activity.setTitle(this.$t("History"));
    this.date_start = APIinterface.getDateNow();
    this.date_end = APIinterface.getDateNow();
    this.getDeliverySummary();
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
    filterByDate() {
      this.date_start = this.proxyDate.from;
      this.date_end = this.proxyDate.to;
      this.resetPagination();
    },
    afterSelectdate(data) {
      console.log(data);
      this.date_start = data;
      this.date_end = data;
      this.resetPagination();
      this.getDeliverySummary();
    },
    refresh(done) {
      this.getDeliverySummary(done);
      this.resetPagination();
    },
    getDeliverySummary(done) {
      this.loading_summary = true;
      APIinterface.fetchDataByTokenPost(
        "deliverysummary",
        "date_start=" + this.date_start + "&date_end=" + this.date_end
      )
        .then((data) => {
          this.summary_data = data.details;
        })
        .catch((error) => {
          this.summary_data = [];
        })
        .then((data) => {
          this.loading_summary = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    getHistory(index, done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "orderhistory",
        "page=" +
          index +
          "&date_start=" +
          this.date_start +
          "&date_end=" +
          this.date_end
      )
        .then((data) => {
          this.page = index;
          this.data.push(data.details.data);
          this.order_meta = data.details.order_meta;
        })
        .catch((error) => {
          if (!APIinterface.empty(this.$refs.nscroll)) {
            this.$refs.nscroll.stop();
          }
        })
        .then((data) => {
          done();
          this.loading = false;
        });
    },
    resetPagination() {
      this.page = 0;
      this.data = [];
      this.order_meta = [];
      this.$refs.nscroll.reset();
      this.$refs.nscroll.resume();
      this.$refs.nscroll.trigger();
    },
    //
  },
};
</script>
