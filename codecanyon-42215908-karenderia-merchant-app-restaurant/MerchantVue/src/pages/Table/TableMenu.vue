<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page class="bg-white q-pt-md">
      <div class="q-pl-md q-pr-md">
        <div
          v-for="items in summary_rows"
          :key="items"
          class="row q-gutter-x-md q-mb-md"
        >
          <div v-for="item in items" :key="item" class="col">
            <q-card
              flat
              class="beautiful-shadow wborder-bottom"
              :class="item.class"
            >
              <q-item>
                <q-item-section>
                  <q-item-label class="text-weight-bold text-h6">
                    <q-spinner-ios size="xs" v-if="loading1" />
                    <template v-else>
                      {{ summary[item.key]?.value }}
                    </template>
                  </q-item-label>
                  <q-item-label class="text-caption">{{
                    item.label
                  }}</q-item-label>
                </q-item-section>
                <q-item-section side>
                  <img :src="item.icon" />
                </q-item-section>
              </q-item>
            </q-card>
          </div>
        </div>

        <q-space class="q-pa-sm"></q-space>

        <q-infinite-scroll
          ref="nscroll"
          @load="fetchReservation"
          :offset="250"
          :disable="scroll_disabled"
        >
          <template v-slot:default>
            <NoData v-if="!hasItems && !loading" :isCenter="false" />
          </template>
          <template v-slot:loading>
            <LoadingData :page="page"></LoadingData>
          </template>
        </q-infinite-scroll>

        <q-list>
          <q-virtual-scroll
            class="fit"
            separator
            :items="data"
            :virtual-scroll-item-size="48"
            v-slot="{ item: items, index }"
          >
            <BookingItem
              :items="items"
              :index="index"
              :statusColor="OrderStore.statusBookingColor"
              @after-update="afterUpdate"
            ></BookingItem>
          </q-virtual-scroll>
        </q-list>
      </div>
      <q-space class="q-pa-lg"></q-space>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import { useOrderStore } from "stores/OrderStore";
import { defineAsyncComponent } from "vue";

export default {
  name: "OrdersList",
  components: {
    BookingItem: defineAsyncComponent(() =>
      import("components/BookingItem.vue")
    ),
    LoadingData: defineAsyncComponent(() =>
      import("components/LoadingData.vue")
    ),
    NoData: defineAsyncComponent(() => import("components/NoData.vue")),
  },
  setup() {
    const DataStore = useDataStore();
    const OrderStore = useOrderStore();
    return { DataStore, OrderStore };
  },
  data() {
    return {
      isScrolled: false,
      summary: [],
      loading: false,
      loading1: false,
      page: 1,
      scroll_disabled: true,
      hasMore: true,
      data: [],
      summary_rows: [
        // Row 1
        [
          {
            key: "total_reservation",
            label: this.$t("Total"),
            icon: "/svg/ci--chart-line.svg",
            class: "wborder-primary",
          },
          {
            key: "total_upcoming",
            label: this.$t("Upcoming"),
            icon: "/svg/fluent-mdl2--line-chart.svg",
            class: "wborder-info",
          },
        ],

        // Row 2
        [
          {
            key: "total_waitlist",
            label: this.$t("Waitlist"),
            icon: "/svg/flowbite--chart-mixed-outline.svg",
            class: "wborder-waitlist",
          },
          {
            key: "total_noshow",
            label: this.$t("No Show"),
            icon: "/svg/lucide--chart-column.svg",
            class: "wborder-noshow",
          },
        ],

        // Row 3
        [
          {
            key: "total_denied",
            label: this.$t("Denied"),
            icon: "/svg/pixel--chart-line.svg",
            class: "wborder-failed",
          },
          {
            key: "total_cancelled",
            label: this.$t("Cancelled"),
            icon: "/svg/teenyicons--area-chart-alt-outline.svg",
            class: "wborder-failed1",
          },
        ],

        // Row 4
        [
          {
            key: "total_confirmed",
            label: this.$t("Confirm"),
            icon: "/svg/fluent-mdl2--chart.svg",
            class: "wborder-confirmed",
          },
          {
            key: "total_finished",
            label: this.$t("Finished"),
            icon: "/svg/grommet-icons--line-chart.svg",
            class: "wborder-finished",
          },
        ],
      ],
    };
  },
  mounted() {
    if (this.DataStore.dataList?.booking_data) {
      this.page = this.DataStore.dataList?.booking_data?.page;
      this.hasMore = this.DataStore.dataList?.booking_data?.hasMore;
      this.data = this.DataStore.dataList?.booking_data?.data;
      this.summary = this.DataStore.dataList?.booking_data?.summary;
    } else {
      this.fetchSummary();
      setTimeout(() => {
        this.$refs.nscroll?.trigger();
      }, 200);
    }
    this.scroll_disabled = false;

    this.$watch(
      () => this.OrderStore.$state.tableID,
      (newData) => {
        if (newData) {
          this.refreshAll();
        }
      }
    );
  },
  beforeUnmount() {
    this.DataStore.dataList.booking_data = {
      page: this.page,
      hasMore: this.hasMore,
      summary: this.summary,
      data: this.data,
    };
  },
  computed: {
    hasItems() {
      return this.data.length > 0;
    },
  },
  methods: {
    refresh(done) {
      setTimeout(() => {
        done();
      }, 100);
      this.refreshAll();
    },
    refreshAll() {
      this.resetPagination();
      setTimeout(() => {
        this.fetchSummary();
      }, 100);
    },
    async fetchSummary() {
      try {
        this.loading1 = true;
        const response = await APIinterface.fetchGet("reservationSummary");
        this.summary = response.details.data;
      } catch (error) {
        this.summary = null;
      } finally {
        this.loading1 = false;
      }
    },
    async fetchReservation(index, done) {
      try {
        if (this.loading) {
          return;
        }

        if (!this.hasMore) {
          this.scroll_disabled = true;
          done(true);
          return;
        }
        this.loading = true;

        const params = new URLSearchParams({
          page: this.page,
        }).toString();

        const response = await APIinterface.fetchGet(
          `reservationList?${params}`
        );
        console.log("response", response);
        this.page++;
        this.data = [...this.data, ...response.details.data];

        if (response.details?.is_last_page) {
          this.hasMore = false;
          this.scroll_disabled = true;
          done(true);
          return;
        }
        done();
      } catch (error) {
        done(true);
      } finally {
        this.loading = false;
      }
    },
    resetPagination() {
      this.page = 1;
      this.data = [];
      this.hasMore = true;
      this.scroll_disabled = false;
      this.$nextTick(() => {
        this.$refs.nscroll?.resume?.();
        this.$refs.nscroll?.trigger?.();
      });
    },
    afterUpdate(index, value) {
      this.data[index] = value;
      setTimeout(() => {
        this.fetchSummary();
      }, 500);

      setTimeout(() => {
        this.OrderStore.fetchReservationcount();
      }, 1000);
    },
  },
};
</script>
