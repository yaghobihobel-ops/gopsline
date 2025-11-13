<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page>
      <div class="q-pl-sm q-pr-sm q-pt-xs">
        <div class="row">
          <div class="col-11">
            <CalendarHalf
              ref="calendar"
              @after-selectdate="afterSelectdate"
              :today_date="date_selected"
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

        <div class="row q-mb-md items-center q-col-gutter-sm">
          <div class="col-7">
            <template v-if="loading">
              <q-skeleton height="60px" square />
            </template>
            <div
              v-else
              class="text-white q-pa-sm radius8 bg-blue row items-center cursor-pointer"
            >
              <div>
                <div class="font12">{{ $t("Available balance") }}</div>
                <div class="text-weight-bold text-h6">{{ balance.pretty }}</div>
              </div>
              <div class="q-pl-md">
                <i
                  class="las la-angle-right text-bold"
                  style="font-size: 18px"
                ></i>
              </div>
            </div>
          </div>
          <div class="col-5 text-center">
            <template v-if="loading"
              ><q-skeleton height="60px" square />
            </template>
            <q-btn v-else color="primary" outline no-caps @click="showCashin">{{
              $t("CASH IN")
            }}</q-btn>
          </div>
        </div>

        <div class="row items-center">
          <div class="text-h7 col">{{ $t("Wallet transactions") }}</div>
          <div class="col-3 text-right">
            <q-btn
              v-if="date_selected || date_start"
              round
              color="blue"
              icon="las la-sync-alt"
              size="sm"
              flat
              @click="resetFilter"
            />
          </div>
        </div>
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
              <template v-if="!loading_summary && !hasData">
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
                    <q-item-section>
                      <q-item-label>{{
                        items.transaction_amount
                      }}</q-item-label>
                      <q-item-label caption>{{
                        items.transaction_description
                      }}</q-item-label>
                      <q-item-label caption>{{
                        items.transaction_date
                      }}</q-item-label>
                    </q-item-section>
                    <q-item-section side>{{
                      items.running_balance
                    }}</q-item-section>
                  </q-item>
                </template>
              </q-list>
            </template>
          </q-infinite-scroll>
        </q-card>
      </div>
    </q-page>
    <CashinAmountselection ref="cashin"></CashinAmountselection>
  </q-pull-to-refresh>
</template>

<script>
import { useActivityStore } from "stores/ActivityStore";
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";

export default {
  name: "WalletHistory",
  data() {
    return {
      date_selected: "",
      date_start: "",
      date_end: "",
      loading: false,
      loading_summary: false,
      balance: [],
      data: [],
      page: 0,
      proxyDate: undefined,
      date_now: "",
    };
  },
  setup() {
    const Activity = useActivityStore();
    return { Activity };
  },
  created() {
    this.Activity.setTitle(this.$t("History"));
    this.date_now = APIinterface.getDateNow();
    this.getWalletBalance();
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  components: {
    CalendarHalf: defineAsyncComponent(() =>
      import("components/CalendarHalf.vue")
    ),
    CashinAmountselection: defineAsyncComponent(() =>
      import("components/CashinAmountselection.vue")
    ),
  },
  methods: {
    getWalletBalance(done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getWalletBalance")
        .then((data) => {
          this.balance = data.details.balance;
        })
        .catch((error) => {})
        .then((data) => {
          this.loading = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    afterSelectdate(data) {
      this.date_selected = data;
      this.resetPagination();
    },
    getHistory(index, done) {
      this.loading_summary = true;
      APIinterface.fetchDataByTokenPost(
        "walletHistory",
        "page=" +
          index +
          "&date=" +
          this.date_selected +
          "&date_start=" +
          this.date_start +
          "&date_end=" +
          this.date_end
      )
        .then((data) => {
          this.page = index;
          this.data.push(data.details.data);
        })
        .catch((error) => {
          if (!APIinterface.empty(this.$refs.nscroll)) {
            this.$refs.nscroll.stop();
          }
        })
        .then((data) => {
          done();
          this.loading_summary = false;
        });
    },
    refresh(done) {
      this.getWalletBalance(done);
      this.resetPagination();
    },
    resetPagination() {
      this.page = 0;
      this.data = [];
      this.$refs.nscroll.reset();
      this.$refs.nscroll.resume();
      this.$refs.nscroll.trigger();
    },
    resetFilter() {
      this.date_selected = "";
      this.date_start = "";
      this.resetPagination();
    },
    updateProxy() {
      console.log("updateProxy=>" + this.date_now);
      this.proxyDate = this.date_now;
    },
    filterByDate() {
      console.log(this.proxyDate);
      this.date_start = this.proxyDate.from;
      this.date_end = this.proxyDate.to;
      this.date_selected = "";
      this.resetPagination();
    },
    showCashin() {
      this.$refs.cashin.dialog = true;
    },
  },
};
</script>
