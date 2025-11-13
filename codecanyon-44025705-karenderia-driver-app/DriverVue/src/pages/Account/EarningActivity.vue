<template>
  <q-header
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
    reveal
    reveal-offset="50"
  >
    <q-toolbar>
      <q-btn
        @click="$router.back()"
        flat
        round
        dense
        icon="las la-angle-left"
        :color="$q.dark.mode ? 'white' : 'dark'"
      />
      <q-toolbar-title class="text-weight-bold">{{
        $t("Earnings Activity")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-pull-to-refresh @refresh="refresh">
    <q-page>
      <div class="q-pl-sm q-pr-sm q-pt-xs">
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
                      label="OK"
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
        <q-separator></q-separator>
      </div>

      <div v-if="date_range" class="q-pl-md q-pr-md">
        <div class="font12">Viewing</div>
        <div class="text-h7">{{ date_range }}</div>
      </div>

      <q-infinite-scroll ref="nscroll" @load="getEarningActivity" :offset="250">
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
                <p class="font11">{{ $t("Pull down the page to refresh") }}</p>
              </div>
            </div>
          </template>

          <q-list separator>
            <template v-for="itemdata in data" :key="itemdata">
              <q-item v-for="items in itemdata" :key="items">
                <q-item-section avatar style="min-width: 35px">
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
                  <q-item-label class="font12">
                    <span class="text-weight-bold q-mr-sm">{{
                      items.delivery_time
                    }}</span>
                    <span>#{{ items.order_id }}</span>
                  </q-item-label>
                  <q-item-label caption>{{
                    items.merchant.restaurant_name
                  }}</q-item-label>
                  <q-item-label caption>{{
                    items.merchant.address
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
              </q-item>
            </template>
          </q-list>
        </template>
      </q-infinite-scroll>

      <q-page-scroller
        position="bottom-right"
        :scroll-offset="150"
        :offset="[18, 18]"
      >
        <q-btn fab icon="keyboard_arrow_up" color="primary" dense unelevated />
      </q-page-scroller>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";

export default {
  name: "EarningActivity",
  components: {
    CalendarHalf: defineAsyncComponent(() =>
      import("components/CalendarHalf.vue")
    ),
  },
  data() {
    return {
      loading: false,
      date_start: "",
      date_end: "",
      data: [],
      page: 0,
      refresh_done: undefined,
      proxyDate: undefined,
      date_range: "",
    };
  },
  created() {
    this.date_start = this.$route.query.start;
    this.date_end = this.$route.query.end;
    this.chart_type = this.$route.query.chart_type;
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
    afterSelectdate(data) {
      this.date_start = data;
      this.date_end = data;
      this.resetPagination();
    },
    filterByDate() {
      this.date_start = this.proxyDate.from;
      this.date_end = this.proxyDate.to;
      this.resetPagination();
    },
    refresh(done) {
      this.refresh_done = done;
      this.resetPagination();
    },
    resetPagination() {
      this.page = 0;
      this.data = [];
      this.$refs.nscroll.reset();
      this.$refs.nscroll.resume();
      this.$refs.nscroll.trigger();
    },
    getEarningActivity(index, done) {
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
          this.date_range = data.details.date_range;
          this.data.push(data.details.data);
        })
        .catch((error) => {
          if (!APIinterface.empty(this.$refs.nscroll)) {
            this.$refs.nscroll.stop();
          }
          if (Object.keys(this.data).length > 0) {
          } else {
            this.date_range = "";
          }
        })
        .then((data) => {
          if (!APIinterface.empty(done)) {
            done();
          }
          if (!APIinterface.empty(this.refresh_done)) {
            this.refresh_done();
          }
          this.loading = false;
        });
    },
  },
};
</script>
