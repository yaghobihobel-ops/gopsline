<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page
      :class="{
        'flex items-start': !loading && !hasData,
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
      }"
      class="q-pr-md q-pl-md"
    >
      <TableSummary
        ref="table_summary"
        :loading="loading_summary"
        :data="data_summary"
      ></TableSummary>

      <q-infinite-scroll ref="nscroll" @load="List" :offset="250">
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
                  @click="getPayoutDetails(item.transaction_uuid)"
                >
                  <q-item-section avatar top>
                    <q-avatar>
                      <q-img
                        :src="item.avatar"
                        style="width: 40px; height: 40px"
                      ></q-img>
                    </q-avatar>
                  </q-item-section>
                  <q-item-section top>
                    <q-item-label class="text-darkx">
                      {{ item.driver_name }}
                      <q-badge
                        :color="DataStore.status_payment_color[item.status]"
                        >{{ item.payment_status }}</q-badge
                      >
                    </q-item-label>
                    <q-item-label caption>
                      {{ item.transaction_date }}
                    </q-item-label>
                    <q-item-label class="text-darkx">
                      {{ item.transaction_amount }}
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
        <div class="full-width text-center">
          <p class="text-grey q-ma-none">{{ $t("No available data") }}</p>
        </div>
      </template>

      <q-space class="q-pa-lg"></q-space>

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
  <CashoutDetails ref="details" @after-update="afterUpdate"></CashoutDetails>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";

export default {
  name: "OrdersList",
  components: {
    TableSummary: defineAsyncComponent(() =>
      import("components/TableSummary.vue")
    ),
    TableSkeleton: defineAsyncComponent(() =>
      import("components/TableSkeleton.vue")
    ),
    CashoutDetails: defineAsyncComponent(() =>
      import("components/CashoutDetails.vue")
    ),
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  data() {
    return {
      loading: false,
      data: [],
      page: 0,
      is_refresh: undefined,
      data_done: false,
      fabaddon: undefined,
      status: [],
      loading_summary: true,
      data_summary: [],
    };
  },
  created() {
    this.Summary();
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
    refresh(done) {
      this.resetPagination();
      this.Summary();
      this.is_refresh = done;
    },
    List(index, done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("cashoutList", "&page=" + index)
        .then((data) => {
          if (data.code == 1) {
            this.page = index;
            this.data.push(data.details.data);
            //this.status = data.details.status_list;
          } else if (data.code == 3) {
            this.data_done = true;
            console.log("end 3");
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
      APIinterface.fetchDataByTokenPost("cashoutSummary")
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
    getPayoutDetails(transaction_uuid) {
      this.$refs.details.getPayoutDetails(transaction_uuid);
    },
    afterUpdate() {
      this.resetPagination();
    },
  },
};
</script>
