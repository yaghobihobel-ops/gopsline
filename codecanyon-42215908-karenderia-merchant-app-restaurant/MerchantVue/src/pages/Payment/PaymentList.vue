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
          {{ $t("All Payment") }}
        </q-toolbar-title>
      </q-toolbar>
      <q-separator></q-separator>
    </q-header>
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
        'flex flex-center': !hasData && !loading,
      }"
      class="q-pr-md q-pl-md q-pt-md"
    >
      <q-infinite-scroll ref="nscroll" @load="List" :offset="250">
        <template v-slot:default>
          <q-list separator class="bg-white">
            <template v-for="items in data" :key="items">
              <template v-for="item in items" :key="item">
                <q-item clickable>
                  <q-item-section avatar>
                    <template v-if="item.logo_type == 'icon'">
                      <q-avatar
                        color="green-12"
                        text-color="white"
                        icon="payment"
                      />
                    </template>
                    <template v-else>
                      <q-avatar>
                        <!-- <q-img
                          :src="item.logo"
                          style="width: 40px; height: 40px"
                          spinner-size="sm"
                          spinner-color="primary"
                        ></q-img> -->
                        <img
                          :src="item.logo"
                          style="width: 40px; height: 40px"
                        />
                      </q-avatar>
                    </template>
                  </q-item-section>
                  <q-item-section>
                    <q-item-label caption class="font12">
                      {{ item.date_created }}
                    </q-item-label>
                    <q-item-label>
                      {{ item.payment_name }}

                      <q-badge
                        :color="item.status_raw == 'active' ? 'green' : 'amber'"
                      >
                        {{ item.status }}
                      </q-badge>
                    </q-item-label>
                  </q-item-section>
                  <q-item-section side class="row items-stretch">
                    <div class="column items-center col-12 q-gutter-y-md">
                      <div class="col">
                        <q-btn
                          round
                          :color="$q.dark.mode ? 'grey600' : 'primary'"
                          :text-color="$q.dark.mode ? 'grey300' : 'white'"
                          icon="las la-edit"
                          size="sm"
                          unelevated
                          :to="{
                            path: '/payments/update-payment',
                            query: { id: item.payment_uuid },
                          }"
                        />
                      </div>
                      <div class="col">
                        <q-btn
                          round
                          :color="$q.dark.mode ? 'grey600' : 'mygrey'"
                          :text-color="$q.dark.mode ? 'grey300' : 'dark'"
                          icon="o_delete"
                          size="sm"
                          unelevated
                          @click.stop="
                            deleteItems(item.payment_uuid, items, index)
                          "
                        />
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
        <div class="full-width text-center flex flex-center">
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
          to="/payments/create-payment"
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

export default {
  name: "PaymentList",
  components: {
    TableSkeleton: defineAsyncComponent(() =>
      import("components/TableSkeleton.vue")
    ),
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
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
          this.close();
        });
    },
    deleteRecords(id, data, index) {
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });
      APIinterface.fetchDataByTokenPost("deletePayment", "id=" + id)
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
      APIinterface.fetchDataByTokenPost("paymentlist", "&page=" + index)
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
