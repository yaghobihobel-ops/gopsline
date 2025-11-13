<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page>
      <div class="q-pl-md q-pr-md q-pt-xs">
        <div class="row q-col-gutter-md">
          <div class="col">
            <q-btn-group unelevated>
              <q-btn
                :color="chart_type == 'daily' ? 'primary' : 'white'"
                :text-color="chart_type == 'daily' ? 'white' : 'dark'"
                :label="$t('Daily')"
                no-caps
                size="sm"
                @click="setDate('daily')"
              />
              <q-btn
                :color="chart_type == 'daily' ? 'white' : 'primary'"
                :text-color="chart_type == 'daily' ? 'dark' : 'white'"
                :label="$t('Weekly')"
                no-caps
                size="sm"
                @click="setDate('weekly')"
              />
            </q-btn-group>

            <q-space class="q-pa-xs"></q-space>

            <template v-if="loading_earnings">
              <q-skeleton height="65px" square />
            </template>
            <div
              v-else
              class="text-white q-pa-sm radius8 bg-blue row items-center cursor-pointer"
            >
              <div>
                <div class="font12">{{ $t("Total earnings") }}</div>
                <div class="text-weight-bold text-h6">
                  {{ earnings.pretty }}
                </div>
              </div>
            </div>
          </div>
          <div class="col text-right">
            <template v-if="loading_earnings">
              <div style="height: 34px"></div>
              <q-skeleton height="65px" square />
            </template>
            <template v-else>
              <apexchart
                type="bar"
                :options="chartOptions"
                :series="series"
                height="112"
              ></apexchart>
            </template>
          </div>
        </div>
      </div>

      <q-space class="q-pa-xs"></q-space>
      <div class="q-pl-md q-pr-md">
        <q-card class="no-shadow q-pt-sm">
          <template v-if="loading_earnings">
            <div
              class="flex flex-center full-width q-pa-xl"
              style="min-height: calc(25vh)"
            >
              <q-spinner color="primary" size="2em" />
            </div>
          </template>
          <template v-else>
            <div class="q-pl-md q-pr-md q-mt-sm">
              <div class="font12 text-dark">{{ date_range }}</div>
            </div>
            <q-list separator dense>
              <q-item>
                <q-item-section>{{ $t("Total Trips") }}</q-item-section>
                <q-item-section side>{{ summary.total_trip }}</q-item-section>
              </q-item>
            </q-list>

            <div class="text-center q-pa-md">
              <q-btn
                outline
                flat
                :label="$t('View details')"
                no-caps
                color="primary"
                :to="{
                  name: 'earning-details',
                  query: {
                    start: date_start,
                    end: date_end,
                    chart_type: chart_type,
                  },
                }"
              ></q-btn>
              <!-- to="/account/earning-details" -->
            </div>
          </template>

          <q-separator></q-separator>

          <q-card-section>
            <template v-if="loading_earnings">
              <div
                class="flex flex-center full-width q-pa-xl"
                style="min-height: calc(20vh)"
              >
                <q-spinner color="primary" size="2em" />
              </div>
            </template>
            <template v-else>
              <!-- <div class="text-h7 q-mb-sm">Balance : {{ balance.pretty }}</div> -->
              <q-list class="dense">
                <q-item
                  class="q-ma-none q-pa-none"
                  clickable
                  to="/account/cashout-history"
                >
                  <q-item-section
                    ><div class="text-h7">
                      {{ $t("Balance") }} : {{ balance.pretty }}
                    </div></q-item-section
                  >
                  <q-item-section side>
                    <q-btn
                      round
                      color="dark"
                      icon="las la-angle-right"
                      flat
                      size="sm"
                    />
                  </q-item-section>
                </q-item>
              </q-list>
              <q-btn
                :label="$t('Cash out')"
                no-caps
                color="primary"
                unelevated
                size="lg"
                to="/account/cashout"
                :disable="can_cashout"
                class="q-pl-lg q-pr-lg"
              ></q-btn>
              <q-space class="q-pa-xs"></q-space>
              <p class="font13">{{ max_cashout }}</p>
            </template>
          </q-card-section>
        </q-card>
      </div>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { useActivityStore } from "stores/ActivityStore";
import APIinterface from "src/api/APIinterface";
import VueApexCharts from "vue3-apexcharts";
import { DateTime } from "luxon";

export default {
  name: "EarningsDashboard",
  components: {
    apexchart: VueApexCharts,
  },
  data() {
    return {
      loading: false,
      first_loading: false,
      loading_earnings: false,
      date_start: "",
      date_end: "",
      chart_type: "",
      balance: [],
      can_cashout: true,
      earnings: [],
      charts_data: [],
      max_cashout: 0,
      summary: [],
      date_range: "",
      payload: [],
      chartOptions: {
        chart: {
          id: "vuechart",
          type: "bar",
          height: "auto",
          toolbar: {
            show: false,
          },
          parentHeightOffset: 0,
        },
        plotOptions: {
          bar: {
            colors: {
              ranges: [
                {
                  from: -999999,
                  to: 0,
                  color: "#f44336",
                },
              ],
            },
          },
        },
        dataLabels: {
          enabled: false,
          position: "bottom",
        },
        colors: ["#81c784"],
        axisBorder: {
          show: false,
        },
        grid: {
          show: false,
          padding: {
            left: 0,
            right: 0,
          },
        },
        xaxis: {
          categories: ["M", "T", "W", "T", "F"],
        },
        yaxis: {
          show: false,
        },
      },
      series: [
        {
          name: "series-1",
          data: [1, -2, 3, 4, 5],
        },
      ],
    };
  },
  setup() {
    const Activity = useActivityStore();
    return { Activity };
  },
  created() {
    this.date_start = APIinterface.getDateNow();
    this.date_end = APIinterface.getDateNow();
    this.chart_type = "daily";

    this.Activity.setTitle(this.$t("Earnings"));
    this.refresh(null);
  },
  computed: {},
  methods: {
    setDate(data) {
      this.chart_type = data;
      if (data == "daily") {
        this.date_start = APIinterface.getDateNow();
        this.date_end = APIinterface.getDateNow();
      } else {
        this.date_start = DateTime.now()
          .minus({ days: 6 })
          .toFormat("yyyy-MM-dd");
        this.date_end = APIinterface.getDateNow();
      }
      this.refresh(null);
    },
    refresh(done) {
      this.getWalletBalance(done);
      this.getEarning(done);
    },
    getEarning(done) {
      if (this.first_loading) {
        APIinterface.showLoadingBox("", this.$q);
      } else {
        this.loading_earnings = true;
      }
      APIinterface.fetchDataByTokenPost(
        "getEarnings",
        "date_start=" +
          this.date_start +
          "&date_end=" +
          this.date_end +
          "&chart_type=" +
          this.chart_type
      )
        .then((data) => {
          this.first_loading = true;
          this.date_range = data.details.date_range;
          this.earnings = data.details.balance;
          this.charts_data = data.details.charts_data;
          this.max_cashout = data.details.max_cashout;
          this.summary = data.details.summary;

          this.chartOptions = {
            chart: {
              id: "vuechart",
              type: "bar",
              height: "auto",
              toolbar: {
                show: false,
              },
              parentHeightOffset: 0,
            },
            plotOptions: {
              bar: {
                colors: {
                  ranges: [
                    {
                      from: -999999,
                      to: 0,
                      color: "#f44336",
                    },
                  ],
                },
              },
            },
            dataLabels: {
              enabled: false,
              position: "bottom",
            },
            colors: ["#81c784"],
            axisBorder: {
              show: false,
            },
            grid: {
              show: false,
              padding: {
                left: 0,
                right: 0,
              },
            },
            xaxis: {
              categories: this.charts_data.date_range,
            },
            yaxis: {
              show: false,
            },
          };

          this.series = [
            {
              name: this.$t("Sale"),
              data: this.charts_data.data,
            },
          ];
        })
        .catch((error) => {
          this.summary = [];
        })
        .then((data) => {
          if (this.first_loading) {
            APIinterface.hideLoadingBox(this.$q);
          }
          this.loading_earnings = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    getWalletBalance(done) {
      if (this.first_loading) {
        APIinterface.showLoadingBox("", this.$q);
      } else {
        this.loading = true;
      }
      APIinterface.fetchDataByTokenPost2("getWalletBalance", {
        payload: this.payload,
      })
        .then((data) => {
          this.balance = data.details.balance;
          this.cashout_miximum = data.details.cashout_miximum;
          if (this.balance.raw > 0) {
            this.can_cashout = false;
          }
        })
        .catch((error) => {})
        .then((data) => {
          if (this.first_loading) {
            APIinterface.hideLoadingBox(this.$q);
          }
          this.loading = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
  },
};
</script>
