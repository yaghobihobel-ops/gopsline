<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page class="q-pa-md">
      <template v-if="loading">
        <div
          class="row q-gutter-x-sm justify-center q-my-md absolute-center text-center full-width"
        >
          <q-circular-progress
            indeterminate
            rounded
            size="sm"
            color="primary"
          />
          <div class="text-subtitle1 text-grey">{{ $t("Loading") }}...</div>
        </div>
      </template>

      <template v-else>
        <template v-if="hasData && !loading">
          <div class="text-center">
            <q-img
              :src="data.customer.avatar"
              style="height: 70px; width: 70px"
              loading="lazy"
              fit="cover"
              class="radius10"
            >
              <template v-slot:loading>
                <q-skeleton
                  height="70px"
                  width="70px"
                  square
                  class="bg-grey-2"
                />
              </template>
            </q-img>

            <div class="text-weight-bold text-body2">
              {{ data.customer.first_name }} {{ data.customer.last_name }}
            </div>

            <div>
              <q-btn
                no-caps
                size="sm"
                flat
                :label="
                  block_from_ordering == true
                    ? this.$t('Unblock Customer')
                    : this.$t('Block Customer')
                "
                color="blue-grey-4"
                class="q-pa-none"
                @click="confirmBlock"
              ></q-btn>
            </div>

            <q-chip size="sm" :color="$q.dark.mode ? 'grey600' : 'white'">
              <q-avatar icon="phone" color="red" text-color="white" />
              {{ data.customer.contact_phone }}
            </q-chip>
            <q-chip size="sm" :color="$q.dark.mode ? 'grey600' : 'white'">
              <q-avatar icon="email" color="blue" text-color="white" />
              {{ data.customer.email_address }}
            </q-chip>
          </div>

          <q-space class="q-pa-sm"></q-space>

          <template v-if="loading_summary">
            <q-skeleton height="50px" square class="radius8" />
          </template>
          <template v-else>
            <div
              class="q-pa-sm radius8 row"
              :class="{
                'bg-grey600 text-white': $q.dark.mode,
                'bg-grey-1 text-dark': !$q.dark.mode,
              }"
            >
              <div class="col-2 text-center">
                <div class="text-weight-bold font16 ellipsis">
                  {{ data_summary.orders }}
                </div>
                <div class="font12 text-blue-grey-2">{{ $t("Orders") }}</div>
              </div>
              <div class="col text-center">
                <div class="text-weight-bold font16 ellipsis">
                  {{ data_summary.order_cancel }}
                </div>
                <div class="font12 text-blue-grey-2">{{ $t("Cancel") }}</div>
              </div>
              <div class="col text-center">
                <div class="text-weight-bold font16 ellipsis">
                  {{ data_summary.total_refund }}
                </div>
                <div class="font12 text-blue-grey-2">{{ $t("Refund") }}</div>
              </div>
              <div class="col text-center">
                <div class="text-weight-bold font16 ellipsis">
                  {{ data_summary.total }}
                </div>
                <div class="font12 text-blue-grey-2">{{ $t("Total") }}</div>
              </div>
            </div>
          </template>

          <q-space class="q-pa-sm"></q-space>
          <q-tabs
            v-model="tab"
            dense
            no-caps
            active-color="primary"
            :indicator-color="$q.dark.mode ? 'mydark' : 'white'"
            align="justify"
            narrow-indicator
            shrink
            switch-indicator="false"
            class="text-grey"
          >
            <q-tab
              v-for="items in tab_menu"
              :key="items"
              :name="items.value"
              no-caps
              class="no-wrap q-pa-none"
            >
              <q-btn
                :label="items.label"
                unelevated
                no-caps
                :color="tab == items.value ? 'primary' : 'mygrey'"
                :text-color="tab == items.value ? 'white' : 'dark'"
                class="radius28"
              ></q-btn>
            </q-tab>
          </q-tabs>
          <q-space class="q-pa-xs"></q-space>

          <q-tab-panels
            v-model="tab"
            animated
            transition-prev="fade"
            transition-next="fade"
          >
            <template v-for="items in tab_menu" :key="items">
              <q-tab-panel :name="items.value" class="q-pa-none">
                <template v-if="items.value == 'order_history'">
                  <ListLoading v-if="loading_orders"></ListLoading>
                  <ListNoData
                    v-else-if="!loading_orders && !hasOrders"
                    :title="$t('No transactions')"
                    :subtitle="$t('new transactions will show here')"
                  ></ListNoData>
                  <q-list v-else separator>
                    <template v-for="items in data_orders" :key="items">
                      <q-item
                        clickable
                        :to="{
                          path: '/orderview',
                          query: { order_uuid: items.order_uuid },
                        }"
                      >
                        <q-item-section>
                          <q-item-label class="text-weight-medium"
                            >Order #{{ items.order_id }}</q-item-label
                          >
                          <q-item-label caption class="font11">
                            {{ items.date_created }}
                          </q-item-label>
                        </q-item-section>
                        <q-item-section side class="text-weight-medium">
                          <q-item-label>{{ items.total }}</q-item-label>

                          <q-item-label>
                            <q-chip
                              size="xs"
                              color="primary"
                              text-color="white"
                              :style="`color:${items.status.font_color_hex} !important; background-color:${items.status.background_color_hex} !important; `"
                            >
                              {{ items.status.status }}</q-chip
                            >
                          </q-item-label>
                        </q-item-section>
                      </q-item>
                    </template>
                  </q-list>
                </template>
                <template v-else>
                  <ListLoading v-if="loading"></ListLoading>
                  <ListNoData
                    v-else-if="!loading && !hasData"
                    :title="$t('No available data')"
                    :subtitle="$t('if there is address it will show here')"
                  ></ListNoData>
                  <q-list v-else separator>
                    <q-item v-for="items in data.addresses" :key="items">
                      <q-item-section>
                        <q-item-label caption>{{ items.address }}</q-item-label>
                      </q-item-section>
                    </q-item>
                  </q-list>
                </template>
              </q-tab-panel>
            </template>
          </q-tab-panels>
        </template>
        <ListNoData
          v-else
          :title="$t('No available data')"
          :subtitle="$t('Customer information not found')"
        ></ListNoData>
      </template>
    </q-page>
    <ConfirmDialog
      ref="confirm_dialog"
      :data="{
        title: this.$t('Block Customer'),
        subtitle: this.$t('block_user'),
        cancel: this.$t('Cancel'),
        confirm: this.$t('Confirm'),
      }"
      @after-confirm="afterConfirm"
    ></ConfirmDialog>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";

export default {
  // name: 'PageName',
  data() {
    return {
      loading: false,
      data: [],
      client_id: 0,
      tab: "",
      tab_menu: [
        {
          label: this.$t("Order History"),
          value: "order_history",
        },
        {
          label: this.$t("Addresses"),
          value: "address",
        },
      ],
      loading_summary: false,
      data_summary: [],
      data_orders: [],
      loading_orders: false,
      block_from_ordering: false,
    };
  },
  components: {
    ListNoData: defineAsyncComponent(() => import("components/ListNoData.vue")),
    ConfirmDialog: defineAsyncComponent(() =>
      import("components/ConfirmDialog.vue")
    ),
    ListLoading: defineAsyncComponent(() =>
      import("components/ListLoading.vue")
    ),
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  mounted() {
    this.DataStore.page_title = this.$t("Customer");
    this.client_id = this.$route.query.client_id;
    if (this.client_id > 0) {
      this.getCustomerDetails();
      this.getCustomerSummary();
      this.getCustomerOrders();
    }
    this.tab = this.DataStore.customer_tab;
  },
  watch: {
    tab(newval, oldval) {
      this.DataStore.customer_tab = this.tab;
    },
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
    hasOrders() {
      if (Object.keys(this.data_orders).length > 0) {
        return true;
      }
      return false;
    },
    hasAddress() {
      if (Object.keys(this.data).length > 0) {
        if (Object.keys(this.data.addresses).length > 0) {
          return true;
        }
      }
      return false;
    },
  },
  methods: {
    confirmBlock() {
      if (this.block_from_ordering) {
        this.blockCustomer(0);
      } else {
        this.$refs.confirm_dialog.dialog = true;
      }
    },
    refresh(done) {
      this.getCustomerDetails(done);
      this.getCustomerSummary(done);
      this.getCustomerOrders(done);
    },
    getCustomerDetails(done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "getCustomerDetails",
        "client_id=" + this.client_id
      )
        .then((data) => {
          this.data = data.details;
          this.block_from_ordering = data.details.block_from_ordering;
        })
        .catch((error) => {
          this.data = [];
        })
        .then((data) => {
          this.loading = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    getCustomerSummary(done) {
      this.loading_summary = true;
      APIinterface.fetchDataByTokenPost(
        "getCustomerSummary",
        "client_id=" + this.client_id
      )
        .then((data) => {
          this.data_summary = data.details;
        })
        .catch((error) => {
          this.data_summary = [];
        })
        .then((data) => {
          this.loading_summary = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    getCustomerOrders(done) {
      this.loading_orders = true;
      APIinterface.fetchDataByTokenPost(
        "getCustomerOrders",
        "client_id=" + this.client_id
      )
        .then((data) => {
          this.data_orders = data.details;
        })
        .catch((error) => {
          this.data_orders = [];
        })
        .then((data) => {
          this.loading_orders = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    afterConfirm() {
      this.blockCustomer(1);
    },
    blockCustomer(block) {
      this.$refs.confirm_dialog.dialog = false;
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        "blockCustomer",
        "client_id=" + this.client_id + "&block=" + block
      )
        .then((data) => {
          this.block_from_ordering = data.details;
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
  },
};
</script>
