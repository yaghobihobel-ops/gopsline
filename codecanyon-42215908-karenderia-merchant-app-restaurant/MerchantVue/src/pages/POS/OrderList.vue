<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
        //'flex flex-center': !hasData && !loading,
      }"
      class="q-pr-md q-pl-md"
    >
      <div class="q-mt-md q-mb-md">
        <TabsRouterMenu :tab_menu="GlobalStore.PosMenu"></TabsRouterMenu>
      </div>

      <q-infinite-scroll ref="nscroll" @load="List" :offset="250">
        <template v-slot:default>
          <template v-if="!hasData && !loading">
            <div class="text-grey text-center flex flex-center absolute-center">
              <p class="text-grey q-ma-none">{{ $t("No available data") }}</p>
            </div>
          </template>

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
                <q-item clickable @click="showPreview(item)">
                  <q-item-section avatar top>
                    <div class="flex flex-center text-center">
                      <div>
                        <div
                          class="radius8 bg-green-10 text-white q-pa-xs text-center q-pl-sm q-pr-sm"
                        >
                          <div class="font14 text-weight-bold">
                            #{{ item.order_id_raw }}
                          </div>
                        </div>
                        <q-space class="q-pa-xs"></q-space>
                        <q-btn
                          dense
                          color="green-12
"
                          round
                          icon="o_shopping_bag"
                          unelevated
                        >
                          <q-badge color="primary" floating>
                            {{ item.total_items }}
                          </q-badge>
                        </q-btn>
                      </div>
                    </div>
                  </q-item-section>
                  <q-item-section top>
                    <q-item-label class="text-darkx">
                      {{ item.customer_name }}

                      <template v-if="status_list[item.status_raw]">
                        <q-badge
                          color="amber"
                          text-color="white"
                          :style="`color:${
                            status_list[item.status_raw].font_color_hex
                          } !important; background-color:${
                            status_list[item.status_raw].background_color_hex
                          } !important; `"
                        >
                          {{ item.status }}
                        </q-badge>
                      </template>
                    </q-item-label>

                    <q-item-label
                      class="text-darkx"
                      v-if="services_list[item.order_type]"
                    >
                      {{ services_list[item.order_type].service_name }}
                    </q-item-label>
                    <q-item-label caption>
                      <span>{{ item.total }}</span> -
                      {{ item.payment_status_name }}
                    </q-item-label>
                    <q-item-label caption>
                      {{ item.date_created }}
                    </q-item-label>
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

  <OrderPreview
    ref="order_preview"
    :data="order_items"
    :items_details="item_details"
    :settings_tabs="settings_tabs"
    :order_group_buttons="order_group_buttons"
    :order_buttons="order_buttons"
    @after-updatestatus="afterUpdatestatus"
  ></OrderPreview>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import { useGlobalStore } from "stores/GlobalStore";

export default {
  name: "PageName",
  components: {
    TableSkeleton: defineAsyncComponent(() =>
      import("components/TableSkeleton.vue")
    ),
    OrderPreview: defineAsyncComponent(() =>
      import("components/OrderPreview.vue")
    ),
    TabsRouterMenu: defineAsyncComponent(() =>
      import("components/TabsRouterMenu.vue")
    ),
  },
  setup() {
    const DataStore = useDataStore();
    const GlobalStore = useGlobalStore();
    return { DataStore, GlobalStore };
  },
  data() {
    return {
      loading: false,
      data: [],
      page: 0,
      limit: 10,
      status: [],
      is_refresh: undefined,
      handle: undefined,
      services_list: {},
      status_list: {},
      order_items: [],
      item_details: {},
      settings_tabs: [],
      order_group_buttons: [],
      order_buttons: [],
    };
  },
  mounted() {
    console.log("hasData");
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
      APIinterface.fetchDataByTokenPost("deleteRooms", "id=" + id)
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
      APIinterface.fetchDataByTokenPost(
        "OrderList",
        "&limit=" + this.limit + "&page=" + index + "&request_from=pos"
      )
        .then((data) => {
          if (data.code == 1) {
            this.page = index;
            this.data.push(data.details.data);

            if (Object.keys(data.details.status_list).length > 0) {
              Object.entries(data.details.status_list).forEach(
                ([key, items]) => {
                  this.status_list[items.status] = items;
                }
              );
            }

            if (Object.keys(data.details.item_details).length > 0) {
              Object.entries(data.details.item_details).forEach(
                ([key, items]) => {
                  this.item_details[key] = items;
                }
              );
            }

            if (Object.keys(data.details.services_list).length > 0) {
              Object.entries(data.details.services_list).forEach(
                ([key, items]) => {
                  this.services_list[key] = items;
                }
              );
            }

            this.settings_tabs = data.details.settings_tabs;
            this.order_group_buttons = data.details.order_group_buttons;
            this.order_buttons = data.details.order_buttons;
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
      this.status_list = {};
      this.item_details = {};

      this.$refs.nscroll.reset();
      this.$refs.nscroll.resume();
      this.$refs.nscroll.trigger();
    },
    showPreview(data) {
      this.order_items = data;
      this.$refs.order_preview.dialog = true;
    },
    afterUpdatestatus() {
      this.resetPagination();
    },
  },
};
</script>
