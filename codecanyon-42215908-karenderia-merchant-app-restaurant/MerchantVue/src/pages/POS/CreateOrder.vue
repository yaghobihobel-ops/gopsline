<template>
  <q-page
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-grey-1 text-dark': !$q.dark.mode,
    }"
    class=""
  >
    <div class="q-pr-md q-pl-md">
      <div class="q-mt-md">
        <TabsRouterMenu :tab_menu="GlobalStore.PosMenu"></TabsRouterMenu>
      </div>

      <div class="row justify-center items-center q-mt-sm q-mb-sm">
        <div class="col">
          <q-input
            outlined
            v-model="q_barcode"
            :label="$t('Search Items')"
            class="bg-white"
            dense
            color="grey"
            text-color="dark"
            :disable="loading_search"
            clearable
            clear-icon="cancel"
            @clear="onSearchClear"
          >
            <template v-slot:append>
              <q-btn
                v-if="hasSearch"
                @click="searchItem"
                no-caps
                icon="search"
                dense
                unelevated
                :loading="loading_search"
              ></q-btn>
            </template>
          </q-input>
        </div>
        <div class="col-2 text-center" v-if="this.$q.capacitor">
          <QrcodeScanner
            ref="ref_qrcode"
            @after-scan="afterScan"
          ></QrcodeScanner>
        </div>
      </div>
    </div>
    <div class="q-pr-md q-pl-md flex row items-stretch q-gutter-sm">
      <div
        class="col-md-1 col-sm-2 col-xs-3 bg-whitex radius8"
        :class="{
          'bg-grey600 text-white': $q.dark.mode,
          'bg-white': !$q.dark.mode,
        }"
      >
        <template v-if="category_loading">
          <q-list>
            <template v-for="items in 8" :key="items">
              <q-item>
                <q-skeleton type="circle" size="40px" />
              </q-item>
            </template>
          </q-list>
        </template>

        <q-list>
          <template v-for="items_category in getCategory" :key="items_category">
            <q-item clickable @click="loadItems(items_category.cat_id)">
              <q-item-section avatar>
                <q-avatar
                  :class="{
                    'bg-primary': items_category.cat_id == selected_category,
                  }"
                >
                  <q-img
                    :src="items_category.url_image"
                    fit="cover"
                    spinner-size="sm"
                    spinner-color="primary"
                    style="height: 30px; width: 30px"
                    class="radius28"
                  ></q-img>
                </q-avatar>
                <q-item-label
                  caption
                  class="text-center"
                  :class="{
                    'text-primary': items_category.cat_id == selected_category,
                  }"
                  >{{ items_category.category_name }}</q-item-label
                >
              </q-item-section>
            </q-item>
          </template>
        </q-list>
      </div>
      <div
        class="col bg-grey-1x radius8 q-pa-smx"
        :class="{
          'bg-grey600 text-white': $q.dark.mode,
          'bg-grey-1': !$q.dark.mode,
        }"
      >
        <div v-if="items_loading" class="row q-gutter-y-sm q-gutter-x-md">
          <template v-for="skeleton in 12" :key="skeleton">
            <div class="col-md-2 col-sm-3 col-xs-5">
              <q-skeleton
                height="50px"
                square
                class="radius8"
                animation="pulse"
              />
              <q-skeleton type="text" animation="fade" />
            </div>
          </template>
        </div>

        <template v-if="!hasItems && !items_loading">
          <div style="min-height: calc(70vh)" class="flex flex-center">
            <div class="text-grey">
              <p>{{ $t("No data available") }}</p>
            </div>
          </div>
        </template>
        <div class="row q-gutter-y-sm q-gutter-x-md">
          <template v-for="items in getItems" :key="items">
            <div class="col-md-2 col-sm-3 col-xs-5">
              <div
                class="bg-whitex radius8"
                :class="{
                  'bg-grey600 text-white': $q.dark.mode,
                  'bg-white': !$q.dark.mode,
                }"
              >
                <q-item clickable @click="viewItems(items)">
                  <q-item-section>
                    <q-item-label>
                      <q-img
                        :src="items.url_image"
                        fit="cover"
                        style="height: 50px"
                        spinner-size="sm"
                        spinner-color="primary"
                        class="full-width radius8"
                      ></q-img>
                    </q-item-label>
                    <q-item-label>{{ items.item_name }}</q-item-label>
                    <q-item-label caption>
                      <template
                        v-for="(prices, index) in items.price"
                        :key="prices"
                      >
                        <template v-if="index <= 0">
                          <template v-if="prices.discount > 0">{{
                            prices.pretty_price_after_discount
                          }}</template>
                          <template v-else>{{ prices.pretty_price }}</template>
                        </template>
                      </template>
                    </q-item-label>
                  </q-item-section>
                </q-item>
              </div>
            </div>
          </template>
        </div>

        <!-- </q-scroll-area> -->
        <q-space class="q-pa-xl"></q-space>
      </div>

      <q-page-scroller
        position="bottom-right"
        :scroll-offset="150"
        :offset="[18, 18]"
      >
        <q-btn
          fab
          icon="keyboard_arrow_up"
          color="mygrey"
          text-color="dark"
          dense
          padding="4px"
        />
      </q-page-scroller>
    </div>

    <q-page-sticky
      position="bottom-right"
      :offset="[18, 18]"
      class="pageSticky"
    >
      <template v-if="CartStore.cart_loading">
        <q-spinner color="primary" size="md" />
      </template>
      <template v-else>
        <q-btn
          fab
          icon="las la-shopping-cart"
          padding="8px"
          color="green"
          @click="CartStore.cart_drawer = true"
        >
          <q-badge color="red" rounded floating v-if="CartStore.hasData">
            {{ CartStore.getCartCount }}
          </q-badge>
        </q-btn>
      </template>
    </q-page-sticky>
  </q-page>
  <ItemDetails
    ref="item_details"
    @after-addtocart="afterAddtocart"
  ></ItemDetails>
  <q-ajax-bar ref="bar" position="top" color="primary" size="2px" skip-hijack />
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useMenuStore } from "stores/MenuStore";
import { useCartStore } from "stores/CartStore";
import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";
import { useGlobalStore } from "stores/GlobalStore";

export default {
  name: "CreateOrder",
  components: {
    ItemDetails: defineAsyncComponent(() =>
      import("components/ItemDetails.vue")
    ),
    TabsRouterMenu: defineAsyncComponent(() =>
      import("components/TabsRouterMenu.vue")
    ),
    QrcodeScanner: defineAsyncComponent(() =>
      import("components/QrcodeScanner.vue")
    ),
  },
  data() {
    return {
      selected_category: undefined,
      category: [],
      category_loading: true,
      items: [],
      items_loading: true,
      dialog_items: true,
      loading_scan: false,
      q_barcode: null,
      loading_search: false,
      search_data: null,
    };
  },
  setup(props) {
    const MenuStore = useMenuStore();
    const CartStore = useCartStore();
    const DataStore = useDataStore();
    const GlobalStore = useGlobalStore();
    return { MenuStore, CartStore, DataStore, GlobalStore };
  },
  mounted() {
    this.CartStore.posAttributes();
    this.getCategoryList();
    if (!this.CartStore.hasData) {
      this.CartStore.getCart(this.DataStore.cart_uuid);
    }
  },
  computed: {
    getCategory() {
      return this.category;
    },
    getItems() {
      if (this.search_data) {
        return this.search_data;
      }
      return this.items;
    },
    hasItems() {
      if (Object.keys(this.items).length > 0) {
        return true;
      }
      return false;
    },
    hasSearch() {
      return this.q_barcode ? true : false;
    },
  },
  methods: {
    onSearchClear() {
      this.search_data = null;
    },
    async searchItem() {
      try {
        this.loading_search = true;
        const results = await APIinterface.fetchGet("findItem", {
          q: this.q_barcode,
        });
        this.search_data = results.details.data;
      } catch (error) {
        this.search_data = null;
        APIinterface.notify("dark", error, "error", this.$q);
      } finally {
        this.loading_search = false;
      }
    },
    async afterScan(value) {
      try {
        APIinterface.showLoadingBox("", this.$q);
        const results = await APIinterface.fetchGetRequest(
          "finditembarcode",
          "barcode=" + value
        );
        const data = results.details.data;
        const params = {
          cat_id: data.cat_id,
          item_uuid: data.item_uuid,
        };
        this.viewItems(params);
      } catch (error) {
        APIinterface.notify("dark", error, "error", this.$q);
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
    viewItems(data) {
      data.cat_id = data?.cat_id ? data.cat_id : this.selected_category;
      this.$refs.item_details.dialog = true;
      this.$refs.item_details.getMenuItem(data, null);
    },
    getCategoryList() {
      this.category_loading = true;
      APIinterface.fetchDataByTokenPost("CategoryList")
        .then((data) => {
          this.category = data.details.data;
          this.selected_category = this.category[0]["cat_id"];
          this.categoryItems();
        })
        .catch((error) => {
          this.category = [];
          this.selected_category = "";
          this.items_loading = false;
        })
        .then((data) => {
          this.category_loading = false;
        });
    },
    loadItems(data) {
      this.selected_category = data;
      this.categoryItems();
    },
    categoryItems() {
      this.search_data = null;
      this.q_barcode = "";
      this.items_loading = true;
      this.items = [];
      this.$refs.bar.start();
      APIinterface.fetchDataByTokenPost(
        "categoryItems",
        "cat_id=" + this.selected_category
      )
        .then((data) => {
          this.items = data.details.data;
        })
        .catch((error) => {
          this.items = [];
        })
        .then((data) => {
          this.items_loading = false;
          if (this.$refs.bar) {
            this.$refs.bar.stop();
          }
        });
    },
    afterAddtocart() {
      this.CartStore.getCart(this.DataStore.cart_uuid);
    },
  },
};
</script>
