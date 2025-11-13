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
          {{ $t("Time logs") }}
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
    >
      <q-infinite-scroll ref="nscroll" @load="List" :offset="250">
        <template v-slot:default>
          <q-list separator>
            <template v-for="items in data" :key="items">
              <q-item v-for="item in items" :key="item">
                <q-item-section>
                  <q-item-label v-if="item.date_created" caption>{{
                    item.date_created
                  }}</q-item-label>
                  <q-item-label>{{ item.zone_id }}</q-item-label>
                </q-item-section>
                <q-item-section side>
                  <q-item-label>
                    <div class="text-green" v-if="item.time_start">
                      {{ item.time_start }} - {{ item.time_end }}
                    </div>
                    <div class="text-blue" v-if="item.shift_time_started">
                      {{ item.shift_time_started }} -
                      {{ item.shift_time_ended }}
                    </div>
                  </q-item-label>
                </q-item-section>
              </q-item>
            </template>
          </q-list>
        </template>
        <template v-slot:loading>
          <TableSkeleton v-if="page <= 0" :rows="10"></TableSkeleton>
          <TableSkeleton v-else-if="data.length > 1" :rows="1"></TableSkeleton>
        </template>
      </q-infinite-scroll>

      <template v-if="!hasData && !loading">
        <div class="full-width text-center flex flex-center">
          <p class="text-grey q-ma-none">{{ $t("No available data") }}</p>
        </div>
      </template>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";

export default {
  name: "TimeLogs",
  components: {
    TableSkeleton: defineAsyncComponent(() =>
      import("components/TableSkeleton.vue")
    ),
  },
  data() {
    return {
      loading: false,
      id: "",
      data: [],
      page: 0,
      is_refresh: undefined,
    };
  },
  computed: {
    hasBalance() {
      if (Object.keys(this.balance_data).length > 0) {
        return true;
      }
      return false;
    },
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  created() {
    this.id = this.$route.query.id;
  },
  methods: {
    refresh(done) {
      this.is_refresh = done;
      this.resetPagination();
    },
    List(index, done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "timeLogs",
        "&page=" + index + "&id=" + this.id
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
  },
};
</script>
