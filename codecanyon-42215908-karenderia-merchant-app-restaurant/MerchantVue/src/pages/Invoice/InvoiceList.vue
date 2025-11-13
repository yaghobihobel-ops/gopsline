<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page class="q-pa-md bg-grey-1">
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
                <q-item clickable>
                  <q-item-section avatar top>
                    <div class="flex flex-center text-center">
                      <div>
                        <div
                          class="radius8 bg-green-10 text-white q-pa-xs text-center q-pl-sm q-pr-sm"
                        >
                          <div class="font14 text-weight-bold">
                            #{{ item.invoice_number }}
                          </div>
                        </div>

                        <template v-if="item.has_proof_uploaded">
                          <q-space class="q-pa-xs"></q-space>
                          <q-btn
                            dense
                            color="green-12"
                            round
                            icon="las la-check"
                            unelevated
                            size="sm"
                          >
                          </q-btn>
                        </template>
                      </div>
                    </div>
                  </q-item-section>
                  <q-item-section top>
                    <q-item-label caption class="font12">
                      {{ item.date_created }}
                    </q-item-label>
                    <q-item-label>
                      {{ $t("Commission") }} ({{ item.date_from }} -
                      {{ item.date_to }})

                      <q-badge
                        :color="
                          DataStore.status_color[item.status]
                            ? DataStore.status_color[item.status]
                            : 'amber'
                        "
                      >
                        <template v-if="DataStore.status_list_raw[item.status]">
                          {{ DataStore.status_list_raw[item.status] }}
                        </template>
                        <template v-else>
                          {{ item.status }}
                        </template>
                      </q-badge>
                    </q-item-label>
                    <q-item-label class="text-darkx">
                      {{ item.total }}
                    </q-item-label>
                  </q-item-section>
                  <q-item-section side class="row items-stretch" top>
                    <div class="column items-center col-12 q-gutter-y-md">
                      <div class="col">
                        <q-btn
                          round
                          :color="$q.dark.mode ? 'grey500' : 'primary'"
                          :text-color="$q.dark.mode ? 'grey300' : 'white'"
                          icon="las la-eye"
                          size="sm"
                          unelevated
                          :to="{
                            path: '/inv/view',
                            query: { id: item.id },
                          }"
                        />
                      </div>
                      <div class="col">
                        <q-btn
                          round
                          :color="$q.dark.mode ? 'grey500' : 'mygrey'"
                          :text-color="$q.dark.mode ? 'grey300' : 'dark'"
                          icon="las la-cloud-upload-alt"
                          size="sm"
                          unelevated
                          :to="{
                            path: '/invoice/upload',
                            query: { id: item.id },
                          }"
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
        <div class="full-width text-center flex flex-center">
          <p class="text-grey q-ma-none">{{ $t("No available data") }}</p>
        </div>
      </template>

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
  name: "InvoiceList",
  components: {
    TableSkeleton: defineAsyncComponent(() =>
      import("components/TableSkeleton.vue")
    ),
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  mounted() {
    this.DataStore.page_title = this.$t("Invoice");
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
    onRight(reset) {
      if (!APIinterface.empty(this.handle)) {
        try {
          this.handle.reset();
        } catch (err) {}
      }
      this.handle = reset;
    },
    refresh(done) {
      this.resetPagination();
      this.is_refresh = done;
    },
    close() {
      this.handle.reset();
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
      APIinterface.fetchDataByTokenPost("deleteCoupon", "id=" + id)
        .then((response) => {
          data.splice(index, 1);
        })
        .catch((error) => {})
        .then((data) => {
          this.$q.loading.hide();
        });
    },
    List(index, done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("invoiceList", "&page=" + index)
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
