<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
        'flex items-center': !loading && !hasData,
      }"
      class="q-pr-md q-pl-md"
    >
      <div class="q-mt-md q-mb-md">
        <TabsRouterMenu :tab_menu="GlobalStore.TableMenu"></TabsRouterMenu>
      </div>

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
                            #{{ item.table_id }}
                          </div>
                        </div>
                        <q-space class="q-pa-xs"></q-space>
                        <q-btn
                          dense
                          color="green-12
"
                          round
                          icon="las la-user"
                          unelevated
                        >
                          <q-badge color="primary" floating>{{
                            item.max_covers
                          }}</q-badge>
                        </q-btn>
                      </div>
                    </div>
                  </q-item-section>
                  <q-item-section top>
                    <q-item-label class="text-darkx">
                      {{ item.table_name }}

                      <q-badge
                        :color="item.available_raw == 1 ? 'green' : 'amber'"
                      >
                        {{ item.available }}
                      </q-badge>
                    </q-item-label>
                    <q-item-label class="text-darkx">
                      <template
                        v-if="DataStore.table_room_list_raw[item.room_id]"
                      >
                        {{ DataStore.table_room_list_raw[item.room_id] }}
                      </template>
                      <template v-else>
                        {{ $t("Not available") }}
                      </template>
                    </q-item-label>
                    <q-item-label caption>
                      {{ item.min_covers }} - {{ item.max_covers }}
                      {{ $t("covers") }}
                    </q-item-label>
                    <q-item-label caption class="font12">
                      {{ item.date_created }}
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
                            path: '/tables/table_update',
                            query: { id: item.table_uuid },
                          }"
                        />
                      </div>
                      <div class="col">
                        <q-btn
                          v-if="AccessStore.hasAccess('booking.tables_delete')"
                          round
                          :color="$q.dark.mode ? 'grey500' : 'mygrey'"
                          :text-color="$q.dark.mode ? 'grey300' : 'dark'"
                          icon="o_delete"
                          size="sm"
                          unelevated
                          @click.stop="
                            deleteItems(item.table_uuid, items, index)
                          "
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
          to="/tables/table_create"
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
import { useGlobalStore } from "stores/GlobalStore";

export default {
  name: "TableList",
  components: {
    TableSkeleton: defineAsyncComponent(() =>
      import("components/TableSkeleton.vue")
    ),
    TabsRouterMenu: defineAsyncComponent(() =>
      import("components/TabsRouterMenu.vue")
    ),
  },
  setup() {
    const DataStore = useDataStore();
    const AccessStore = useAccessStore();
    const GlobalStore = useGlobalStore();
    return { DataStore, AccessStore, GlobalStore };
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
  created() {
    this.DataStore.TableRoomList();
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
      APIinterface.fetchDataByTokenPost("deleteTable", "id=" + id)
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
      APIinterface.fetchDataByTokenPost("tableList", "&page=" + index)
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
