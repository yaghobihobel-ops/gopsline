<template>
  <q-pull-to-refresh @refresh="refresh">
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
        <q-toolbar-title class="text-weight-bold">
          {{ $t("Overview") }}
          <template v-if="hasData">
            -
            {{ data.first_name }} {{ data.last_name }}
          </template>
        </q-toolbar-title>
      </q-toolbar>
      <q-separator></q-separator>
    </q-header>
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
        'flex flex-center': !hasData && !loading,
      }"
      class="q-pa-md"
    >
      <template v-if="loading">
        <q-inner-loading :showing="true" color="primary" size="md" />
      </template>

      <template v-else>
        <template v-if="hasData">
          <div
            class="radius8 bg-grey-1x q-pa-sm"
            :class="{
              'bg-grey600 text-white': $q.dark.mode,
              'bg-grey-1': !$q.dark.mode,
            }"
          >
            <div class="row q-gutter-sm">
              <div class="col-3">
                <div class="text-h5">{{ data.total }}</div>
                <div class="text-caption line-normal">
                  {{ $t("Total reviews") }}
                </div>
              </div>
              <div class="col q-gutter-y-sm">
                <template v-for="items in data.review_summary" :key="items">
                  <div class="flex justify-between font11">
                    <div>{{ items.count }} {{ $t("star") }}</div>
                    <div>{{ items.in_percent }}</div>
                  </div>
                  <q-linear-progress
                    size="md"
                    :value="items.review / 100"
                    color="green"
                    class="q-ma-none"
                  />
                </template>
              </div>
            </div>
          </div>

          <q-space class="q-pa-md"></q-space>

          <div class="border-grey radius8 q-mb-md">
            <TableSummary
              ref="table_summary"
              :loading="loading_summary"
              :data="data_summary"
              bg_color="bg-grey-1"
              :concat="false"
              :set_slide="2.6"
            ></TableSummary>
          </div>

          <div class="text-h6">{{ $t("Activities") }}</div>

          <q-list separator v-if="hasActivity">
            <q-item v-for="items in data_activity" :key="items">
              <q-item-section top>
                <q-item-label class="text-dark">{{
                  items.created_at
                }}</q-item-label>
                <q-item-label caption>{{ items.order_id }}</q-item-label>
                <q-item-label caption>{{ items.remarks }}</q-item-label>
              </q-item-section>
            </q-item>
          </q-list>
          <div v-else>
            <div class="text-center q-pa-lg">
              <div class="text-grey">{{ $t("No available data") }}</div>
            </div>
          </div>
        </template>
        <template v-else>
          <div class="text-grey">{{ $t("No available data") }}</div>
        </template>
      </template>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";

export default {
  name: "OverviewInfo",
  components: {
    TableSummary: defineAsyncComponent(() =>
      import("components/TableSummary.vue")
    ),
  },
  data() {
    return {
      id: "",
      loading: false,
      data: [],
      data_summary: [],
      loading_summary: false,
      data_activity: [],
      data_done: undefined,
    };
  },
  mounted() {
    this.id = this.$route.query.id;
    if (!APIinterface.empty(this.id)) {
      this.getDriverOverview();
      this.getDriverActivity();
    }
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
    hasActivity() {
      if (Object.keys(this.data_activity).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    refresh(done) {
      this.data_done = done;
      this.getDriverOverview();
    },
    getDriverActivity() {
      APIinterface.fetchDataByTokenPost("getDriverActivity", "id=" + this.id)
        .then((data) => {
          this.data_activity = data.details.data;
        })
        .catch((error) => {
          //
        })
        .then((data) => {});
    },
    getDriverOverview() {
      if (APIinterface.empty(this.data_done)) {
        this.loading = true;
      }
      APIinterface.fetchDataByTokenPost("getDriverOverview", "id=" + this.id)
        .then((data) => {
          this.data = data.details;
          this.data_summary.push({
            label: this.$t("Total earnings"),
            value: this.data.wallet_balance,
          });
          this.data_summary.push({
            label: this.$t("Total Delivered"),
            value: this.data.total_delivered,
          });
          this.data_summary.push({
            label: this.$t("Total Tips"),
            value: this.data.total_tip,
          });
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
          if (!APIinterface.empty(this.data_done)) {
            this.data_done();
          }
        });
    },
  },
};
</script>
