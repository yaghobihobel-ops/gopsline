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
          to="/dashboard"
          flat
          round
          dense
          icon="las la-angle-left"
          :color="$q.dark.mode ? 'white' : 'dark'"
        />
        <q-toolbar-title class="text-weight-bold">
          {{ $t("Rates") }}
        </q-toolbar-title>
      </q-toolbar>
      <q-separator></q-separator>
    </q-header>
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
        'flex items-center': !loading && !hasData,
      }"
      class="q-pr-md q-pl-md q-pt-md"
    >
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
              <template v-for="(item, index) in items" :key="item">
                <q-item clickable>
                  <q-item-section avatar top>
                    <div class="flex flex-center text-center">
                      <div>
                        <div
                          class="radius8 bg-green-10 text-white q-pa-xs text-center q-pl-sm q-pr-sm"
                        >
                          <div class="font14 text-weight-bold">
                            #{{ item.id }}
                          </div>
                        </div>
                      </div>
                    </div>
                  </q-item-section>
                  <q-item-section top>
                    <q-item-label class="text-darkx">
                      {{ item.shipping_type }} - {{ item.distance_price }}
                    </q-item-label>
                    <q-item-label caption>
                      {{ item.distance }}
                    </q-item-label>
                    <q-item-label caption>
                      {{ item.estimation }}
                    </q-item-label>
                  </q-item-section>
                  <q-item-section side class="row items-stretch" top>
                    <div class="column items-center col-12 q-gutter-y-md">
                      <div class="col">
                        <q-btn
                          round
                          :color="$q.dark.mode ? 'grey500' : 'primary'"
                          :text-color="$q.dark.mode ? 'grey300' : 'white'"
                          icon="las la-edit"
                          size="sm"
                          unelevated
                          :to="{
                            path: '/rates/update-rate',
                            query: { id: item.id },
                          }"
                        />
                      </div>
                      <div class="col">
                        <q-btn
                          v-if="
                            AccessStore.hasAccess(
                              'services.chargestable_delete'
                            )
                          "
                          round
                          :color="$q.dark.mode ? 'grey500' : 'mygrey'"
                          :text-color="$q.dark.mode ? 'grey300' : 'dark'"
                          icon="o_delete"
                          size="sm"
                          unelevated
                          @click.stop="deleteItems(item.id, items, index)"
                        >
                        </q-btn>
                      </div>
                    </div>
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

      <q-page-sticky position="bottom-right" :offset="[18, 18]">
        <q-btn
          icon="las la-plus"
          round
          size="md"
          :color="$q.dark.mode ? 'grey600' : 'mygrey'"
          :text-color="$q.dark.mode ? 'grey300' : 'dark'"
          unelevated
          to="/rates/create-rate"
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
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import { useAccessStore } from "stores/AccessStore";

export default {
  name: "DynamicRates",
  components: {
    TableSkeleton: defineAsyncComponent(() =>
      import("components/TableSkeleton.vue")
    ),
  },
  setup() {
    const DataStore = useDataStore();
    const AccessStore = useAccessStore();
    return { DataStore, AccessStore };
  },
  data() {
    return {
      loading: false,
      data: [],
      page: 0,
      status: [],
      is_refresh: undefined,
      handle: undefined,
    };
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
    deleteItems(id, data, index) {
      APIinterface.dialog(
        this.$t("Delete Confirmation"),
        this.$t(
          "Are you sure you want to permanently delete the selected item?"
        ),
        this.$t("Okay"),
        this.$t("Cancel"),
        this.$q
      )
        .then((result) => {
          this.deleteRecords(id, data, index);
        })
        .catch((error) => {
          //this.close();
        });
    },
    deleteRecords(id, data, index) {
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });
      APIinterface.fetchDataByTokenPost("deleteShippingRate", "id=" + id)
        .then((response) => {
          data.splice(index, 1);
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.$q.loading.hide();
        });
    },
    refresh(done) {
      this.resetPagination();
      this.is_refresh = done;
    },
    List(index, done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("ShippingRateList", "&page=" + index)
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
