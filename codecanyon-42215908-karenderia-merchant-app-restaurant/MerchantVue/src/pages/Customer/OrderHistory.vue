<template>
  <q-header
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-grey-1 text-dark': !$q.dark.mode,
    }"
    reveal
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
        $t("Order History")
      }}</q-toolbar-title>
    </q-toolbar>
  </q-header>
  <q-page
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-grey-1 text-dark': !$q.dark.mode,
    }"
    class="q-pl-md q-pr-md q-pb-md"
  >
    <q-card flat>
      <q-card-section>
        <div class="flex">
          <div>
            <q-avatar>
              <q-img src="https://cdn.quasar.dev/img/avatar.png" />
            </q-avatar>
          </div>
          <div class="q-ml-sm text-grey font13">
            <div>basti kikang</div>
            <div>+639995351202</div>
            <div>bastikikang@gmail.com</div>
            <div class="font11">21 Jun 2022 11:19 AM</div>
          </div>
        </div>
      </q-card-section>
    </q-card>
    <q-space class="q-pa-sm"></q-space>
    <div class="border-grey radius8 q-pa-xs q-mb-sm">
      <q-tabs
        v-model="tab"
        dense
        class="text-grey"
        active-color="primary"
        indicator-color="primary"
        align="justify"
        narrow-indicator
        no-caps
      >
        <q-tab name="orders" label="Orders" />
        <q-tab name="address" label="Addresses" />
      </q-tabs>
    </div>

    <q-tab-panels v-model="tab" animated class="radius8">
      <q-tab-panel name="orders" class="q-pa-none">
        <q-table
          flat
          bordered
          ref="tableRef"
          :rows="rows"
          :columns="columns"
          row-key="id"
          v-model:pagination="pagination"
          :loading="loading"
          :filter="filter"
          binary-state-sort
          @request="onRequest"
          no-data-label="No data available"
          rows-per-page-options="0"
        >
          <template v-slot:loading>
            <q-inner-loading showing color="primary" size="md" />
          </template>
          <template v-slot:body="props">
            <q-tr :props="props" @click="onRowClick(props.row)">
              <q-td key="order_id" :props="props">
                {{ props.row.order_id }}
              </q-td>
              <q-td key="total" :props="props">
                {{ props.row.total }}
              </q-td>
              <q-td key="status" :props="props">
                <q-badge color="amber">
                  {{ props.row.status }}
                </q-badge>
              </q-td>
            </q-tr>
          </template>
        </q-table>
      </q-tab-panel>

      <q-tab-panel name="address" class="q-pa-none">
        <q-list separator>
          <template v-for="items in 10" :key="items">
            <q-item clickable>
              <q-item-section>
                <q-item-label>
                  Guadalupe Nuevo, Makati, Metro Manila, Philippines
                </q-item-label>
                <q-item-label caption>House</q-item-label>
              </q-item-section>
            </q-item>
          </template>
        </q-list>
      </q-tab-panel>
    </q-tab-panels>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "OrderHistory",
  data() {
    return {
      tab: "orders",
      loading: false,
      filter: "",
      pagination: {
        sortBy: "desc",
        descending: false,
        page: 1,
        rowsPerPage: 5,
        rowsNumber: 10,
      },
      columns: [
        {
          name: "order_id",
          align: "center",
          label: "Order ID",
          field: "order_id",
          sortable: true,
        },
        {
          name: "total",
          align: "center",
          label: "Total",
          field: "total",
          sortable: true,
        },
        {
          name: "status",
          align: "center",
          label: "Status",
          field: "status",
          sortable: true,
        },
      ],
      rows: [],
    };
  },
  mounted() {
    this.$refs.tableRef.requestServerInteraction();
  },
  methods: {
    onRequest(props) {
      console.log("onRequest");
      const { page, rowsPerPage, sortBy, descending } = props.pagination;
      const fetchCount =
        rowsPerPage === 0 ? pagination.rowsNumber : rowsPerPage;
      const startRow = (page - 1) * rowsPerPage;

      console.log("startRow=>" + startRow);
      console.log("fetchCount=>" + fetchCount);

      // let returnedData = [
      //   {
      //     order_id: 1,
      //     total: 10,
      //     status: "pending",
      //   },
      // ];
      // this.rows.splice(0, this.rows.length, ...returnedData);

      APIinterface.fetchDataByToken("getCustomerOrders", {
        start: startRow,
        fetchCount: fetchCount,
      })
        .then((data) => {})
        .catch((error) => {})
        .then((data) => {});

      this.pagination.page = page;
      this.pagination.rowsPerPage = rowsPerPage;
      this.pagination.sortBy = sortBy;
      this.pagination.descending = descending;
    },
    onRowClick(row) {
      console.log(row);
    },
  },
};
</script>
