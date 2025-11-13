<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page class="q-pa-md bg-grey-1">
      <TableSummary
        ref="table_summary"
        :loading="loading_summary"
        :data="data_summary"
        :set_slide="2.5"
      ></TableSummary>

      <q-infinite-scroll ref="nscroll" @load="List">
        <template v-slot:default>
          <q-list
            separator
            class="bg-whitex"
            :class="{
              'bg-grey600 text-white': $q.dark.mode,
              'bg-white': !$q.dark.mode,
            }"
          >
            <template v-for="items in data" :key="items">
              <template v-for="item in items" :key="item">
                <q-item
                  clickable
                  :to="{
                    path: '/orderview',
                    query: { order_uuid: item.order_uuid },
                  }"
                >
                  <q-item-section avatar top>
                    <div class="flex flex-center text-center">
                      <div>
                        <div
                          class="radius8 bg-green-10 text-white q-pa-xs text-center q-pl-sm q-pr-sm"
                        >
                          <div class="font14 text-weight-bold">
                            #{{ item.order_id }}
                          </div>
                        </div>
                      </div>
                    </div>
                  </q-item-section>
                  <q-item-section top>
                    <q-item-label caption class="font12">
                      {{ item.date_created }}
                    </q-item-label>
                    <q-item-label>
                      {{ item.customer_name }}
                    </q-item-label>
                    <q-item-label caption>
                      {{ item.transaction_type }} - {{ item.payment_name }}
                    </q-item-label>
                    <q-item-label>
                      {{ item.total }}
                    </q-item-label>
                  </q-item-section>
                </q-item>
              </template>
            </template>
          </q-list>
        </template>
        <template v-slot:loading>
          <TableSkeleton v-if="page <= 0" :rows="10"></TableSkeleton>
          <TableSkeleton v-else-if="data.length > 1" :rows="1"></TableSkeleton>
        </template>
      </q-infinite-scroll>

      <template v-if="!hasData && !loading">
        <div
          class="full-width text-center flex flex-center"
          style="min-height: calc(50vh)"
        >
          <p class="text-grey q-ma-none">{{ $t("No available data") }}</p>
        </div>
      </template>

      <q-space class="q-pa-md"></q-space>
      <q-page-sticky position="bottom-right" :offset="[18, 18]">
        <q-btn
          icon="o_date_range"
          round
          size="md"
          color="amber-6"
          text-color="disabled"
          unelevated
          @click="this.$refs.filter_date.dialog = true"
        ></q-btn>
      </q-page-sticky>
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
    </q-page>
  </q-pull-to-refresh>
  <FilterDates ref="filter_date" @after-filter="afterFilter"></FilterDates>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";

export default {
  name: "SalesReport",
  components: {
    TableSkeleton: defineAsyncComponent(() =>
      import("components/TableSkeleton.vue")
    ),
    TableSummary: defineAsyncComponent(() =>
      import("components/TableSummary.vue")
    ),
    FilterDates: defineAsyncComponent(() =>
      import("components/FilterDates.vue")
    ),
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  mounted() {
    this.DataStore.page_title = this.$t("Sales Report");
    this.Summary();

    setTimeout(() => {
      this.$refs.nscroll?.trigger();
    }, 200);
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  data() {
    return {
      loading: false,
      data: [],
      page: 0,
      status: [],
      is_refresh: undefined,
      handle: undefined,
      date_start: "",
      date_end: "",
      printer_details: [],
      restaurant_name: "",
      loading_summary: false,
    };
  },
  methods: {
    refresh(done) {
      this.resetPagination();
      this.Summary();
      this.is_refresh = done;
    },
    afterFilter(data) {
      this.date_start = data.date_start;
      this.date_end = data.date_end;
      this.resetPagination();
    },
    List(index, done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "SaleReport",
        "&page=" +
          index +
          "&date_start=" +
          this.date_start +
          "&date_end=" +
          this.date_end
      )
        .then((data) => {
          if (data.code == 1) {
            this.page = index;
            this.data.push(data.details.data);
          } else if (data.code == 3) {
            this.data_done = true;
            if (!APIinterface.empty(this.$refs.nscroll)) {
              this.$refs.nscroll.stop();
            }
          }
        })
        .catch((error) => {
          this.data_done = true;
          if (!APIinterface.empty(this.$refs.nscroll)) {
            this.$refs.nscroll.stop();
          }
        })
        .then((data) => {
          done();
          this.loading = false;
          if (!APIinterface.empty(this.is_refresh)) {
            this.is_refresh();
          }
        });
    },
    resetPagination() {
      this.page = 0;
      this.data = [];
      this.$refs.nscroll.reset();
      this.$refs.nscroll.resume();
      this.$refs.nscroll.trigger();
    },
    Summary() {
      this.loading_summary = true;
      APIinterface.fetchDataByTokenPost("getOrderSummary")
        .then((data) => {
          this.data_summary = data.details.data;
        })
        .catch((error) => {
          //
        })
        .then((data) => {
          this.loading_summary = false;
        });
    },
  },
};
</script>
