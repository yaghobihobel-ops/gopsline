<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-header
      class="text-dark"
      reveal
      :class="{
        'bg-custom-grey': !$q.dark.mode,
        'bg-grey600': $q.dark.mode,
      }"
    >
      <!-- MOBILE VIEW -->
      <template v-if="$q.screen.lt.md">
        <q-toolbar style="border-bottom-right-radius: 25px">
          <q-btn
            color="dark"
            :text-color="$q.dark.mode ? 'grey300' : 'custom-grey3'"
            :label="$t('History')"
            no-caps
            unelevated
            flat
          />
          <q-space></q-space>

          <div class="q-gutter-x-md">
            <q-btn
              icon="eva-trash-2-outline"
              flat
              class="q-pa-none"
              color="red"
              @click="ConfirmClearOrder"
            />
            <q-btn
              icon="eva-settings-outline"
              flat
              class="q-pa-none"
              to="/settings"
              :color="$q.dark.mode ? 'grey300' : 'dark'"
            />
          </div>
        </q-toolbar>
      </template>
      <template v-else>
        <!-- DESKTOP VIEW -->
        <div class="flex justify-between q-pa-md items-center">
          <div>
            <template v-if="!KitchenStore.miniState">
              <q-btn
                dense
                round
                unelevated
                color="accent"
                :text-color="$q.dark.mode ? 'grey300' : 'white'"
                icon="chevron_left"
                @click="KitchenStore.miniState = true"
                size="13px"
              />
            </template>

            <q-btn
              :color="$q.dark.mode ? 'grey300' : 'dark'"
              :label="$t('History')"
              no-caps
              unelevated
              flat
            />
          </div>
          <div class="flex q-gutter-x-sm">
            <q-form @submit="onSearchSubmit">
              <q-input
                v-model="q"
                :placeholder="$t('Search reference #')"
                dense
                :bg-color="$q.dark.mode ? 'dark' : 'custom-grey1'"
                autocorrect="off"
                autocapitalize="off"
                autocomplete="off"
                spellcheck="false"
                class="no-border"
                rounded
                outlined
                clearable
                @clear="clearFilter"
                :loading="q ? KitchenStore.order_loading : false"
              >
                <template v-slot:prepend>
                  <q-icon name="eva-search-outline" />
                </template>
              </q-input>
            </q-form>

            <q-btn
              v-if="hasData"
              no-caps
              :label="$t('Clear Orders')"
              unelevated
              color="red"
              class="radius-10"
              @click="ConfirmClearOrder"
            ></q-btn>

            <q-btn
              :color="$q.dark.mode ? 'grey300' : 'dark'"
              icon-right="eva-funnel-outline"
              :label="$t('Filter')"
              no-caps
              unelevated
              flat
            >
              <q-menu ref="ref_filter_menu">
                <div class="card-form q-pa-md q-gutter-y-md">
                  <FilterSelect
                    ref="ref_order_type"
                    :data="KitchenStore.getTransactionList"
                    :label="$t('Order Type')"
                    @after-select="afterSelectOrderType"
                  ></FilterSelect>

                  <q-btn
                    no-caps
                    unelevated
                    color="primary"
                    class="fit radius-10"
                    :label="$t('Apply Filters')"
                    @click="applyFilters"
                    :size="$q.screen.gt.sm ? '17px' : '15px'"
                  >
                  </q-btn>
                </div>
              </q-menu>
            </q-btn>

            <q-btn
              :color="$q.dark.mode ? 'grey300' : 'dark'"
              icon-right="eva-settings-outline"
              no-caps
              unelevated
              flat
              rounded
              to="/settings"
            />

            <NotificationComponents></NotificationComponents>
          </div>
        </div>
      </template>
    </q-header>
    <q-page :class="{ 'bg-grey600': $q.dark.mode }">
      <!-- MOBILE VIEW -->
      <template v-if="$q.screen.lt.md">
        <MobileTabMenu></MobileTabMenu>
      </template>

      <div class="padding-8">
        <template v-if="$q.screen.lt.md">
          <div class="flex q-mb-sm">
            <div class="col">
              <q-form @submit="onSearchSubmit">
                <q-input
                  v-model="q"
                  :placeholder="$t('Search reference #')"
                  dense
                  :bg-color="$q.dark.mode ? 'dark' : 'custom-grey1'"
                  autocorrect="off"
                  autocapitalize="off"
                  autocomplete="off"
                  spellcheck="false"
                  class="no-border"
                  rounded
                  outlined
                  clearable
                  @clear="clearFilter"
                  :loading="q ? KitchenStore.order_loading : false"
                >
                  <template v-slot:prepend>
                    <q-icon name="eva-search-outline" />
                  </template>
                </q-input>
              </q-form>
            </div>
            <div class="q-pl-sm q-pr-sm">
              <q-btn
                icon="eva-options-2-outline"
                flat
                class="q-pa-none"
                :color="$q.dark.mode ? 'grey300' : 'dark'"
                @click="this.modal = true"
              />
            </div>
          </div>
        </template>

        <!-- DESKTOP VIEW -->
        <!-- <pre>{{ rows }}</pre> -->
        <q-table
          ref="tableRef"
          flat
          :rows="rows"
          :columns="columns"
          row-key="order_reference"
          v-model:pagination="pagination"
          :loading="loading"
          @request="onRequest"
          :filter="filter"
          :grid="$q.screen.lt.md"
          :bordered="$q.screen.lt.md"
          class="card-form-heightx"
          :rows-per-page-label="$t('Records per page')"
          :pagination-label="
            (start, end, total) => `${start}-${end} ${$t('of')} ${total}`
          "
        >
          <template v-slot:loading>
            <div class="flex flex-center card-form-height-50">
              <q-inner-loading showing color="primary"></q-inner-loading>
            </div>
          </template>

          <template v-slot:no-data>
            <template v-if="!loading && !hasData">
              <div class="text-body2 text-grey">
                {{ $t("No available data") }}
              </div>
            </template>
          </template>

          <template v-slot:header="props">
            <q-tr :props="props">
              <q-th auto-width />
              <q-th
                v-for="col in props.cols"
                :key="col.name"
                :props="props"
                :class="{
                  'text-grey300': $q.dark.mode,
                }"
              >
                {{ col.label }}
              </q-th>
              <q-th auto-width />
            </q-tr>
          </template>

          <template v-slot:body="props">
            <q-tr :props="props">
              <q-td auto-width>
                <div class="q-gutter-x-sm">
                  <q-btn
                    no-caps
                    unelevated
                    :label="$t('Recall')"
                    :color="props.row.can_recall ? 'primary' : 'accent'"
                    class="radius-10"
                    @click="onRowClick(props.row)"
                    :disable="!props.row.can_recall"
                  ></q-btn>
                </div>
              </q-td>
              <q-td key="order_reference" :props="props">
                {{ props.row.order_reference }}
              </q-td>
              <q-td key="customer_name" :props="props">
                {{ props.row.customer_name }}
              </q-td>
              <q-td key="transaction_type" :props="props">
                {{ props.row.transaction_type }}
              </q-td>
              <q-td key="created_at" :props="props">
                {{ props.row.created_at }}
              </q-td>
              <q-td auto-width>
                <q-btn
                  size="sm"
                  color="accent"
                  unelevated
                  round
                  dense
                  @click="props.expand = !props.expand"
                  :icon="
                    props.expand
                      ? 'eva-arrow-ios-upward-outline'
                      : 'eva-arrow-ios-downward-outline'
                  "
                />
              </q-td>
            </q-tr>
            <q-tr v-show="props.expand" :props="props">
              <q-td colspan="100%">
                <template v-for="items in props.row.items" :key="items">
                  <div class="flex q-gutter-x-sm">
                    <div>{{ items.qty }} x</div>
                    <div>{{ items.item_name }}</div>
                  </div>
                  <div class="q-pl-lg">
                    <template
                      v-for="(attributes, index) in items.attributes"
                      :key="attributes"
                    >
                      {{ attributes.value
                      }}<template v-if="index !== items.attributes.length - 1"
                        >,</template
                      >
                    </template>
                  </div>

                  <div class="q-pl-lg">
                    <template v-for="addons in items.addons" :key="addons">
                      - {{ addons.value }}
                    </template>
                  </div>
                </template>
              </q-td>
            </q-tr>
          </template>

          <!-- MOBILE VIEW -->
          <template v-slot:item="props">
            <div
              class="padding-8 col-xs-12 col-sm-6 col-md-4 col-lg-3 grid-style-transition"
            >
              <q-card bordered flat>
                <q-list dense>
                  <q-item
                    v-for="col in props.cols.filter(
                      (col) => col.name !== 'desc'
                    )"
                    :key="col.name"
                  >
                    <q-item-section>
                      <q-item-label>{{ col.label }}</q-item-label>
                    </q-item-section>
                    <q-item-section side>
                      <q-item-label caption>{{ col.value }}</q-item-label>
                    </q-item-section>
                  </q-item>
                </q-list>
                <div
                  class="q-pl-md q-pr-md q-pb-sm text-right q-gutter-x-sm"
                  v-if="props.row.can_recall"
                >
                  <q-btn
                    no-caps
                    unelevated
                    :label="$t('Recall')"
                    color="primary"
                    class="radius-10"
                    @click="onRowClick(props.row)"
                  ></q-btn>
                </div>
              </q-card>
            </div>
          </template>
        </q-table>
      </div>

      <FilterModal ref="ref_filter_modal"></FilterModal>

      <q-dialog
        v-model="modal"
        :maximized="this.$q.screen.lt.sm ? true : false"
        :position="this.$q.screen.lt.sm ? 'bottom' : 'standard'"
        persistent
        full-height
        full-width
      >
        <q-card>
          <q-card-section class="row items-center q-pb-none">
            <div class="text-h6">{{ $t("Filter") }}</div>
            <q-space />
            <q-btn icon="close" flat round dense v-close-popup />
          </q-card-section>
          <q-card-section class="q-gutter-y-md">
            <FilterSelect
              ref="ref_order_type"
              :data="KitchenStore.getTransactionList"
              :label="$t('Order Type')"
              @after-select="afterSelectOrderType"
            ></FilterSelect>

            <q-btn
              no-caps
              unelevated
              color="primary"
              class="fit radius-10"
              :label="$t('Apply Filters')"
              @click="applyFilters"
              :size="$q.screen.gt.sm ? '17px' : '15px'"
            >
            </q-btn>
          </q-card-section>
        </q-card>
      </q-dialog>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useKitchenStore } from "stores/KitchenStore";
import { useIdentityStore } from "stores/IdentityStore";
import { api } from "src/boot/axios";

export default {
  name: "HistoryPage",
  components: {
    FilterModal: defineAsyncComponent(() =>
      import("components/FilterModal.vue")
    ),
    NotificationComponents: defineAsyncComponent(() =>
      import("components/NotificationComponents.vue")
    ),
    FilterSelect: defineAsyncComponent(() =>
      import("components/FilterSelect.vue")
    ),
    MobileTabMenu: defineAsyncComponent(() =>
      import("components/MobileTabMenu.vue")
    ),
  },
  setup() {
    const KitchenStore = useKitchenStore();
    const IdentityStore = useIdentityStore();
    return { KitchenStore, IdentityStore };
  },
  data() {
    return {
      modal: false,
      columns: [
        {
          name: "order_reference",
          field: "order_reference",
          label: this.$t("Order Refence"),
          align: "left",
          sortable: true,
        },
        {
          name: "customer_name",
          field: "customer_name",
          label: this.$t("Customer"),
          align: "left",
          sortable: true,
        },
        {
          name: "transaction_type",
          field: "transaction_type",
          label: this.$t("Order Type"),
          align: "left",
          sortable: true,
        },
        {
          name: "created_at",
          field: "created_at",
          label: this.$t("Date"),
          align: "left",
          sortable: true,
        },
      ],
      visibleColumns: [
        "order_reference",
        "customer_name",
        "transaction_type",
        "created_at",
      ],
      rows: [],
      pagination: {
        sortBy: "created_at",
        descending: true,
        page: 1,
        rowsPerPage: 10,
        rowsNumber: 50,
      },
      filters: {
        q: "",
        order_type: [],
      },
      filter: {},
      loading: false,
      awaitingSearch: false,
      q: "",
      is_done: null,
    };
  },
  mounted() {
    this.$refs.tableRef.requestServerInteraction();
  },
  computed: {
    hasData() {
      if (Object.keys(this.rows).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    afterSelectOrderType(value) {
      this.filters.order_type = value;
    },
    onSearchSubmit() {
      this.filters.q = this.q;
      this.applyFilters();
    },
    clearFilter() {
      this.filters.q = "";
      this.filters.order_type = [];
      this.applyFilters();
    },
    applyFilters() {
      this.modal = false;
      this.filter = this.filters;
      if (this.$refs.ref_filter_menu) {
        this.$refs.ref_filter_menu.hide();
      }
      this.$refs.tableRef.requestServerInteraction();
    },
    refresh(done) {
      this.clearFilter();
      this.is_done = done;
    },
    onRequest(props) {
      const { page, rowsPerPage, sortBy, descending } = props.pagination;
      const filter = props.filter;

      const fetchCount =
        rowsPerPage === 0 ? pagination.rowsNumber : rowsPerPage;
      const startRow = (page - 1) * rowsPerPage;

      this.loading = true;
      let postData = {
        startRow: startRow,
        fetchCount: fetchCount,
        filter: filter,
        sortBy: sortBy,
        descending: descending,
      };
      APIinterface.fetchDataPost("OrderHistory", postData)
        .then((response) => {
          if (response.code == 1) {
            this.rows = response.details.data;
            this.pagination.rowsNumber = response.details.total;
          } else {
            this.rows = [];
          }
          this.pagination.page = page;
          this.pagination.rowsPerPage = rowsPerPage;
          this.pagination.sortBy = sortBy;
          this.pagination.descending = descending;
        })
        .catch((error) => {
          this.rows = [];
        })
        .then((data) => {
          this.loading = false;
          this.awaitingSearch = false;
          if (this.is_done) {
            this.is_done();
          }
        });
    },
    onRowClick(row) {
      APIinterface.showLoadingBox(this.$t("Processing"), this.$q);
      APIinterface.fetchDataPost(
        "Recall",
        "order_reference=" + row.order_reference
      )
        .then((data) => {
          this.$refs.tableRef.requestServerInteraction();
          this.KitchenStore.refreshOrders(null);
          this.KitchenStore.refreshOrdersCount();
        })
        .catch((error) => {
          APIinterface.notify(
            this.$q,
            this.$t("Error"),
            error,
            "myerror",
            "highlight_off",
            "bottom"
          );
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    ConfirmClearOrder() {
      this.$q
        .dialog({
          class: "text-body1x",
          title: this.$t("Delete Confirmation"),
          message: this.$t(
            "Are you sure you want to permanently delete all completed items?"
          ),
          html: true,
          cancel: true,
          persistent: true,
          ok: {
            unelevated: true,
            color: "blue",
            rounded: false,
            "text-color": "white",
            label: this.$t("Yes"),
            "no-caps": true,
            size: "16px",
            class: "text-weight-bold radius-10",
          },
          cancel: {
            unelevated: true,
            color: "accent",
            flat: false,
            rounded: false,
            label: this.$t("No"),
            "no-caps": true,
            size: "16px",
            class: "text-weight-bold radius-10",
          },
        })
        .onOk(() => {
          this.clearOrders();
        })
        .onCancel(() => {})
        .onDismiss(() => {});
    },
    clearOrders() {
      APIinterface.showLoadingBox(this.$t("Processing"), this.$q);
      APIinterface.fetchDataGet("clearOrders")
        .then((data) => {
          this.$refs.tableRef.requestServerInteraction();
        })
        .catch((error) => {
          APIinterface.notify(
            this.$q,
            this.$t("Error"),
            error,
            "myerror",
            "highlight_off",
            "bottom"
          );
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
  },
};
</script>
