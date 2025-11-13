<template>
  <q-header
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
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
        $t("Earnings")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-pull-to-refresh @refresh="refresh">
    <q-page>
      <div class="text-center q-pa-md">
        <q-btn-group unelevated>
          <q-btn
            :color="chart_type == 'daily' ? 'primary' : 'grey-1'"
            :text-color="chart_type == 'daily' ? 'white' : 'dark'"
            :label="$t('Daily')"
            no-caps
            size="sm"
            @click="setDate('daily')"
          />
          <q-btn
            :color="chart_type == 'daily' ? 'grey-1' : 'primary'"
            :text-color="chart_type == 'daily' ? 'dark' : 'white'"
            :label="$t('Weekly')"
            no-caps
            size="sm"
            @click="setDate('weekly')"
          />
        </q-btn-group>
      </div>

      <template v-if="loading">
        <div
          class="flex flex-center full-width q-pa-xl"
          style="min-height: calc(50vh)"
        >
          <q-spinner color="primary" size="2em" />
        </div>
      </template>
      <template v-else>
        <div class="q-pa-md">
          <div class="row justify-between items-center">
            <q-btn
              round
              color="dark"
              flat
              icon="las la-angle-left"
              unelevated
              size="sm"
              :disable="!canMovePrev"
              @click="PreviousEarnings"
            />
            <div class="text-weight-medium ellipsis" style="max-width: 250px">
              {{ date_range }}
            </div>
            <q-btn
              round
              color="dark"
              flat
              icon="las la-angle-right"
              unelevated
              size="sm"
              :disable="!canMoveNext"
              @click="NextEarnings"
            />
          </div>
          <div class="text-center q-mt-sm">
            <div class="text-h5 q-ma-none text-weight-bold">{{ balance }}</div>
            <div class="font12">{{ $t("Total earnings") }}</div>
          </div>
          <apexchart
            type="bar"
            :options="chartOptions"
            :series="series"
            height="150"
          ></apexchart>
        </div>

        <div class="q-pl-md q-pr-md">
          <!-- <pre>{{ summary }}</pre> -->
          <q-list separator dense>
            <q-item>
              <q-item-section>{{ $t("Delivery pay") }}</q-item-section>
              <q-item-section side>{{ summary.total_delivery }}</q-item-section>
            </q-item>
            <q-item>
              <q-item-section>{{ $t("Tips") }}</q-item-section>
              <q-item-section side>{{ summary.total_tips }}</q-item-section>
            </q-item>
            <q-item>
              <q-item-section>{{ $t("Incentives") }}</q-item-section>
              <q-item-section side>{{
                summary.total_incentives
              }}</q-item-section>
            </q-item>
            <q-item>
              <q-item-section>{{ $t("Adjustment") }}</q-item-section>
              <q-item-section side>{{
                summary.total_adjustment
              }}</q-item-section>
            </q-item>
          </q-list>
          <q-space class="q-pa-md"></q-space>
          <q-btn
            class="fit"
            color="primary"
            size="lg"
            unelevated
            no-caps
            :to="{
              name: 'earning-activity',
              query: {
                start: date_start,
                end: date_end,
                chart_type: chart_type,
              },
            }"
            >{{ $t("View earnings activity") }}</q-btn
          >
          <q-space class="q-pa-md"></q-space>
        </div>
      </template>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import VueApexCharts from "vue3-apexcharts";
import { DateTime } from "luxon";

export default {
  name: "EarningDetails",
  components: {
    apexchart: VueApexCharts,
  },
  data() {
    return {
      loading: false,
      first_loading: false,
      date_start: "",
      date_end: "",
      chart_type: "",
      summary: [],
      balance: "",
      date_range: "",
      charts_data: [],
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
        dataLabels: {
          enabled: false,
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
          categories: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"],
        },
        yaxis: {
          show: false,
        },
      },
      series: [
        {
          name: "series-1",
          data: [1, 2, 3, 4, 5, 2, 10],
        },
      ],
    };
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
    canMoveNext() {
      const dateNow = APIinterface.getDateNow();
      var d1 = DateTime.fromISO(dateNow);
      var d2 = DateTime.fromISO(this.date_end);
      if (d1.equals(d2)) {
        return false;
      } else return true;
    },
    canMovePrev() {
      const dateNow = APIinterface.getDateNow();
      var d1 = DateTime.fromISO(dateNow);
      var d2 = DateTime.fromISO(this.date_end);
      return d2 <= d1;
    },
  },
  created() {
    this.date_start = this.$route.query.start;
    this.date_end = this.$route.query.end;
    this.chart_type = this.$route.query.chart_type;
    this.getEarningDetails(null);
  },
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
      this.getEarningDetails(done);
    },
    PreviousEarnings() {
      if (this.chart_type == "daily") {
        console.log("daily");
        let dateStart = DateTime.fromISO(this.date_start);
        dateStart = dateStart.minus({ days: 1 }).toFormat("yyyy-MM-dd");
        this.date_start = dateStart;
        this.date_end = dateStart;
      } else {
        let dateStart = DateTime.fromISO(this.date_start);
        let dateEnd = DateTime.fromISO(this.date_start).toFormat("yyyy-MM-dd");
        dateStart = dateStart.minus({ days: 6 }).toFormat("yyyy-MM-dd");
        this.date_start = dateStart;
        this.date_end = dateEnd;
      }
      this.refresh(null);
    },
    NextEarnings() {
      if (this.chart_type == "daily") {
        console.log("daily");
        let dateStart = DateTime.fromISO(this.date_start);
        dateStart = dateStart.plus({ days: 1 }).toFormat("yyyy-MM-dd");
        this.date_start = dateStart;
        this.date_end = dateStart;
      } else {
        let dateStart = DateTime.fromISO(this.date_end).toFormat("yyyy-MM-dd");
        let dateEnd = DateTime.fromISO(this.date_end);
        dateEnd = dateEnd.plus({ days: 6 }).toFormat("yyyy-MM-dd");
        this.date_start = dateStart;
        this.date_end = dateEnd;
      }
      this.refresh(null);
    },
    getEarningDetails(done) {
      if (this.first_loading) {
        APIinterface.showLoadingBox("", this.$q);
      } else {
        this.loading = true;
      }
      APIinterface.fetchDataByTokenPost(
        "getEarningDetails",
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
          this.balance = data.details.balance;
          this.summary = data.details.summary;
          this.charts_data = data.details.charts_data;
          this.plotChart();
        })
        .catch((error) => {
          this.summary = [];
        })
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
    plotChart() {
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
          name: "Sale",
          data: this.charts_data.data,
        },
      ];
    },
  },
};
</script>
