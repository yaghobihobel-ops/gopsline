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
        $t("Cash out history")
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
        <q-separator></q-separator>
      </div>

      <q-infinite-scroll ref="nscroll" @load="getCashoutHistory" :offset="250">
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
          <template v-else>
            <q-list separator>
              <template v-for="itemdata in data" :key="itemdata">
                <q-item v-for="items in itemdata" :key="items">
                  <q-item-section>
                    <q-item-label class="font12">
                      <q-badge
                        :color="changeColor(items.status_raw)"
                        :text-color="changeTextColor(items.status_raw)"
                        :label="items.status"
                        class="text-weight-bold"
                      />
                    </q-item-label>
                    <q-item-label caption>{{ items.description }}</q-item-label>
                    <q-item-label caption class="font11">{{
                      items.date
                    }}</q-item-label>
                  </q-item-section>
                  <q-item-section side>
                    {{ items.amount }}
                  </q-item-section>
                </q-item>
              </template>
            </q-list>
          </template>
        </template>
      </q-infinite-scroll>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";

export default {
  name: "CashoutHistory",
  data() {
    return {
      loading: false,
      data: [],
      page: 0,
      refresh_done: undefined,
      date_start: "",
      date_end: "",
      proxyDate: undefined,
    };
  },
  components: {
    CalendarHalf: defineAsyncComponent(() =>
      import("components/CalendarHalf.vue")
    ),
  },
  created() {},
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
    getCashoutHistory(index, done) {
      this.loading = true;
      APIinterface.fetchDataByToken("getCashoutHistory", {
        page: index,
        date_start: this.date_start,
        date_end: this.date_end,
      })
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
          if (!APIinterface.empty(done)) {
            done();
          }
          if (!APIinterface.empty(this.refresh_done)) {
            this.refresh_done();
          }
          this.loading = false;
        });
    },
    changeColor(data) {
      if (data == "paid") {
        return "green-4";
      } else if (data == "cancelled") {
        return "red-4";
      }
      return "grey-2";
    },
    changeTextColor(data) {
      if (data == "paid") {
        return "white";
      } else if (data == "cancelled") {
        return "white";
      }
      return "dark";
    },
  },
};
</script>
