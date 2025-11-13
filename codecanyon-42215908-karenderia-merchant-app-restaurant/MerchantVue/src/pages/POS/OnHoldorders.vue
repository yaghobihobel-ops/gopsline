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
              {{ $t("No available data") }}
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
                <q-item
                  clickable
                  @click="
                    getCart(
                      item.order_reference,
                      item.cart_uuid,
                      item.transaction_type
                    )
                  "
                >
                  <q-item-section avatar top>
                    <div class="flex flex-center text-center">
                      <div>
                        <q-btn
                          dense
                          color="green-12
"
                          round
                          icon="o_shopping_bag"
                          unelevated
                        >
                          <q-badge color="primary" floating>
                            {{ item.qty }}
                          </q-badge>
                        </q-btn>
                      </div>
                    </div>
                  </q-item-section>
                  <q-item-section top>
                    <q-item-label
                      class="text-darkx"
                      :class="{
                        'text-white': $q.dark.mode,
                        'text-dark': !$q.dark.mode,
                      }"
                    >
                      {{ item.order_reference }}

                      <q-badge color="amber">
                        {{ item.transaction_name }}
                      </q-badge>
                    </q-item-label>
                    <q-item-label
                      class="text-darkx"
                      :class="{
                        'text-white': $q.dark.mode,
                        'text-dark': !$q.dark.mode,
                      }"
                    >
                      {{ item.customer_name }}
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
                          :color="$q.dark.mode ? 'grey600' : 'mygrey'"
                          :text-color="$q.dark.mode ? 'grey300' : 'dark'"
                          icon="o_delete"
                          size="sm"
                          unelevated
                          @click.stop="
                            deleteItems(item.cart_uuid, items, index)
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
  <HoldOrdersdetails ref="details"></HoldOrdersdetails>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import { useCartStore } from "stores/CartStore";
import { useGlobalStore } from "stores/GlobalStore";

export default {
  name: "OnHoldorders",
  components: {
    TableSkeleton: defineAsyncComponent(() =>
      import("components/TableSkeleton.vue")
    ),
    HoldOrdersdetails: defineAsyncComponent(() =>
      import("components/HoldOrdersdetails.vue")
    ),
    TabsRouterMenu: defineAsyncComponent(() =>
      import("components/TabsRouterMenu.vue")
    ),
  },
  // mounted() {
  //   this.$refs.bar.start();
  // },
  setup() {
    const DataStore = useDataStore();
    const CartStore = useCartStore();
    const GlobalStore = useGlobalStore();
    return { DataStore, CartStore, GlobalStore };
  },
  data() {
    return {
      loading: false,
      data: [],
      page: 0,
      status: [],
      is_refresh: undefined,
      handle: undefined,
      payload: ["items", "summary", "total", "subtotal", "items_count"],
      order_reference: "",
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
        .catch((error) => {});
    },
    deleteRecords(id, data, index) {
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });
      APIinterface.fetchDataByTokenPost("deleteHoldorder", "id=" + id)
        .then((response) => {
          data.splice(index, 1);
          this.loadCart();
        })
        .catch((error) => {})
        .then((data) => {
          this.$q.loading.hide();
        });
    },
    List(index, done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("onHoldOrders", "&page=" + index)
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
    getCart(order_reference, cart_uuid, transaction_type) {
      this.$refs.details.getCart(order_reference, cart_uuid, transaction_type);
    },
    loadCart() {
      let place_id = this.DataStore.place_data
        ? this.DataStore.place_data.place_id
        : "";
      this.CartStore.getCart(this.DataStore.cart_uuid, place_id);
    },
  },
};
</script>
