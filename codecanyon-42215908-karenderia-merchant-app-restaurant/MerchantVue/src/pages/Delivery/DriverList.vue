<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page
      :class="{
        'flex flex-center': !loading && !hasData,
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
      }"
      class="q-pr-md q-pl-md"
    >
      <q-infinite-scroll ref="nscroll" @load="List" :offset="250">
        <template v-slot:default>
          <q-list separator class="bg-white">
            <template v-for="items in data" :key="items">
              <q-slide-item
                @right="onRight"
                v-for="item in items"
                :key="item"
                right-color="grey-2"
              >
                <template v-slot:right>
                  <q-btn
                    @click="close"
                    icon="las la-window-close"
                    color="blue"
                    round
                    flat
                  ></q-btn>
                  <q-btn
                    v-if="AccessStore.hasAccess('merchantdriver.delete')"
                    @click="deleteItems(item.driver_uuid, items, index)"
                    icon="las la-trash-alt"
                    color="red"
                    round
                    flat
                  ></q-btn>
                </template>
                <q-item clickable @click.stop="showSubMenu(item.driver_uuid)">
                  <q-item-section avatar top>
                    <q-avatar>
                      <q-img
                        :src="item.avatar"
                        style="width: 40px; height: 40px"
                        spinner-size="sm"
                        spinner-color="primary"
                      ></q-img>
                    </q-avatar>
                  </q-item-section>
                  <q-item-section top>
                    <q-item-label class="text-darkx">
                      {{ item.first_name }} {{ item.last_name }}

                      <q-badge
                        :color="
                          DataStore.status_driver_color[item.status_raw]
                            ? DataStore.status_driver_color[item.status_raw]
                            : 'amber'
                        "
                        >{{ item.status }}</q-badge
                      >
                    </q-item-label>
                    <q-item-label caption>
                      {{ item.email }}
                    </q-item-label>
                    <q-item-label caption class="text-dark">
                      {{ item.phone }}
                    </q-item-label>
                    <q-item-label caption class="text-dark">
                      {{ item.employment_type }}
                    </q-item-label>
                  </q-item-section>
                  <q-item-section side class="row items-stretch">
                    <div class="column items-center col-12">
                      <div class="col">
                        <q-btn
                          round
                          :color="$q.dark.mode ? 'grey600' : 'primary'"
                          :text-color="$q.dark.mode ? 'grey300' : 'white'"
                          icon="las la-edit"
                          size="sm"
                          unelevated
                          @click.stop="edit(item.driver_uuid)"
                        />
                      </div>
                      <div class="col">
                        <q-btn
                          round
                          :color="$q.dark.mode ? 'grey600' : 'mygrey'"
                          :text-color="$q.dark.mode ? 'grey300' : 'dark'"
                          icon="o_more_vert"
                          size="sm"
                          unelevated
                          @click="showSubMenu(item.driver_uuid)"
                        >
                        </q-btn>
                      </div>
                    </div>
                  </q-item-section>
                </q-item>
              </q-slide-item>
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

      <q-page-sticky position="bottom-right" :offset="[18, 18]">
        <q-btn
          icon="las la-plus"
          round
          size="md"
          :color="$q.dark.mode ? 'grey600' : 'mygrey'"
          :text-color="$q.dark.mode ? 'grey300' : 'dark'"
          unelevated
          to="/driver/add"
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
  <q-dialog v-model="dialog" position="bottom">
    <q-card>
      <q-card-section class="row items-center q-pa-xs q-pb-none">
        <q-space />
        <q-btn icon="las la-times" flat round dense v-close-popup />
      </q-card-section>
      <q-list separator>
        <q-item
          clickable
          :to="{ path: '/driver/overview', query: { id: this.id } }"
        >
          {{ $t("Overview") }}
        </q-item>
        <q-item
          clickable
          :to="{ path: '/driver/license', query: { id: this.id } }"
        >
          {{ $t("License") }}
        </q-item>
        <q-item
          clickable
          :to="{ path: '/driver/vehicle', query: { id: this.id } }"
        >
          {{ $t("Vehicle") }}
        </q-item>
        <q-item
          clickable
          :to="{ path: '/driver/bank-information', query: { id: this.id } }"
        >
          {{ $t("Bank Information") }}
        </q-item>
        <q-item
          clickable
          :to="{ path: '/driver/wallet', query: { id: this.id } }"
        >
          {{ $t("Wallet") }}
        </q-item>
        <q-item
          clickable
          :to="{ path: '/driver/cashout_transactions', query: { id: this.id } }"
        >
          {{ $t("Cashout") }}
        </q-item>
        <q-item
          clickable
          :to="{
            path: '/driver/delivery_transactions',
            query: { id: this.id },
          }"
        >
          {{ $t("Delivery Transactions") }}
        </q-item>
        <q-item
          clickable
          :to="{ path: '/driver/order_tips', query: { id: this.id } }"
        >
          {{ $t("Order Tips") }}
        </q-item>
        <q-item
          clickable
          :to="{ path: '/driver/time_logs', query: { id: this.id } }"
        >
          {{ $t("Time Logs") }}
        </q-item>
        <q-item
          clickable
          :to="{ path: '/driver/reviews', query: { id: this.id } }"
        >
          {{ $t("Reviews") }}
        </q-item>
      </q-list>
    </q-card>
  </q-dialog>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import { useAccessStore } from "stores/AccessStore";

export default {
  name: "CollectCash",
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
      is_refresh: undefined,
      data_done: false,
      fabaddon: undefined,
      status: [],
      loading_summary: true,
      data_summary: [],
      handle: undefined,
      dialog: false,
      id: "",
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
    edit(data) {
      this.$router.push({ path: "/driver/update", query: { id: data } });
    },
    showSubMenu(id) {
      this.id = id;
      this.dialog = true;
    },
    onRight(reset) {
      if (!APIinterface.empty(this.handle)) {
        try {
          this.handle.reset();
        } catch (err) {}
      }
      this.handle = reset;
    },
    close() {
      this.handle.reset();
    },
    refresh(done) {
      this.resetPagination();
      this.is_refresh = done;
    },
    List(index, done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("driverList", "&page=" + index)
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
    getDetails(collection_uuid) {
      this.$refs.details.getPayoutDetails(collection_uuid);
    },
    afterUpdate() {
      this.resetPagination();
    },
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
          this.close();
        });
    },
    deleteRecords(id, data, index) {
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });
      APIinterface.fetchDataByTokenPost("deleteDriver", "id=" + id)
        .then((response) => {
          data.splice(index, 1);
        })
        .catch((error) => {})
        .then((data) => {
          this.$q.loading.hide();
        });
    },
  },
};
</script>
