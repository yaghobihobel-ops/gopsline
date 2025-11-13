<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-header class="bg-white text-dark q-pl-sm q-pr-sm">
      <q-toolbar v-if="!isScrolled">
        <q-toolbar-title shrink class="text-subtitle2 text-weight-bold">{{
          $t("Offers")
        }}</q-toolbar-title>
      </q-toolbar>
      <q-space class="q-pa-xs"></q-space>

      <div
        class="q-pl-md q-pr-sm"
        :class="{
          'text-grey': !isScrolled,
          'text-subtitle1 text-weight-bold q-pb-sm ': isScrolled,
        }"
      >
        <template v-if="hasData">
          {{ total_found }} {{ $t("restaurant") }}
        </template>
      </div>
    </q-header>
    <q-page>
      <q-scroll-observer @scroll="onScroll" />
      <DIV class="q-pl-md q-pr-md">
        <div v-if="loading && page <= 0" class="text-grey q-pt-sm q-pb-xs">
          <q-skeleton type="text" style="width: 100px" />
        </div>
        <div v-else class="text-grey q-pt-sm q-pb-xs">
          <template v-if="!hasData">
            <NoResults
              :message="$t('Oops! No Offers Right Now')"
              :description="
                $t(
                  'It looks like there are no offers available at the moment. Check back soon for exciting deals and discounts from your favorite restaurants!'
                )
              "
            ></NoResults>
          </template>
        </div>
      </DIV>

      <q-infinite-scroll ref="nscroll" @load="getMerchantFeed" :offset="250">
        <q-list class="no-wrap">
          <template v-for="itemsdata in data" :key="itemsdata">
            <q-item
              v-for="items in itemsdata"
              :key="items.merchant_id"
              clickable
              v-ripple
              @click.stop="
                this.$router.push({
                  name: 'menu',
                  params: {
                    slug: items.restaurant_slug,
                  },
                })
              "
            >
              <MerchantListTpl
                :items="items"
                :cuisine="cuisine"
                :reviews="reviews"
                :estimation="estimation"
                :services="services"
                :items_min_max="items_min_max"
                :promos="promos"
                :enabled_review="DataStore.enabled_review"
              />
            </q-item>
          </template>
        </q-list>

        <template v-slot:loading>
          <div class="q-pl-md q-pr-md">
            <template v-if="page <= 0">
              <MerchantListSkeleton />
            </template>
            <template v-else>
              <div
                class="row q-gutter-x-sm justify-center q-my-md absolute-bottom-left text-center full-width"
              >
                <q-spinner-dots color="secondary" size="40px" />
              </div>
            </template>
          </div>
        </template>
      </q-infinite-scroll>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { defineAsyncComponent, ref } from "vue";
import { useCartStore } from "stores/CartStore";
import { useDataStore } from "stores/DataStore";
import { useDataStorePersisted } from "stores/DataStorePersisted";
import auth from "src/api/auth";

export default {
  name: "FeedPage",
  components: {
    MerchantListTpl: defineAsyncComponent(() =>
      import("components/MerchantListTpl.vue")
    ),
    MerchantListSkeleton: defineAsyncComponent(() =>
      import("components/MerchantListSkeleton.vue")
    ),
    NoResults: defineAsyncComponent(() => import("components/NoResults.vue")),
  },
  data() {
    return {
      loading: true,
      list_type: "promo",
      featured_id: "",
      data: [],
      cuisine: [],
      reviews: [],
      estimation: [],
      services: [],
      items_min_max: [],
      title: "",
      page: 0,
      sort_by: "",
      total_found: 0,
      filters: [],
      transactionType: "",
      menu_type: "column",
      cuisine_id: "",
      cuisine_name: "",
      page_title: "",
      promos: [],
      payload: [
        "cuisine",
        "reviews",
        "estimation",
        "services",
        "items_min_max",
        "offers",
        "promo",
      ],
      isScrolled: false,
    };
  },
  setup() {
    const CartStore = useCartStore();
    const DataStore = useDataStore();
    const DataStorePersisted = useDataStorePersisted();
    return { CartStore, DataStore, DataStorePersisted };
  },
  watch: {
    menu_type(newval, oldval) {
      console.log(newval);
      APIinterface.setStorage("listType", newval);
    },
  },
  created() {
    this.transactionType = APIinterface.getStorage("transaction_type");
    this.featured_id = this.$route.query.featured_id;
    this.cuisine_id = this.$route.query.cuisine_id;
    this.cuisine_name = this.$route.query.cuisine_name;
    this.page_title = this.$route.query.page_title;

    if (this.cuisine_id > 0) {
      this.filters = {
        cuisine: [this.cuisine_id],
      };
    }

    let listType = APIinterface.getStorage("listType");
    if (!APIinterface.empty(listType)) {
      this.menu_type = listType;
    }

    if (!this.DataStore.featured_data) {
      this.DataStore.getFeaturedList();
    }

    if (!this.DataStore.hasDataCuisine()) {
      this.DataStore.CuisineList();
    }
  },
  computed: {
    hasData() {
      if (this.data.length > 0) {
        return true;
      }
      return false;
    },
    switchIconList() {
      if (this.menu_type == "list") {
        return "grid_view";
      } else {
        return "reorder";
      }
    },
  },
  methods: {
    onScroll(info) {
      this.isScrolled = info.position.top > 140;
    },
    refresh(done) {
      done();
      this.resetPagination();
    },
    getMerchantFeed(index, done) {
      const $params = {
        list_type: this.list_type,
        featured_id: this.featured_id,
        place_id: APIinterface.getStorage("place_id"),
        coordinates: this.DataStorePersisted.coordinates,
        payload: this.payload,
        page: index,
        sort_by: this.sort_by,
        filters: this.filters,
      };
      if (this.list_type === "featured") {
        $params.featured_id = this.featured_id;
      }
      this.loading = true;

      if (auth.authenticated()) {
        APIinterface.fetchDataByToken("getMerchantFeed2", $params)
          .then((data) => {
            this.page = index;
            if (data.code == 1) {
              this.data.push(data.details.data);
              this.cuisine = data.details.cuisine;
              this.reviews = data.details.reviews;
              this.estimation = data.details.estimation;
              this.services = data.details.services;
              this.items_min_max = data.details.items_min_max;
              this.total_found = data.details.total_found;
              this.promos = data.details.promos;
            } else {
              this.total_found = data.details.total_found;
              if (this.$refs.nscroll) {
                this.$refs.nscroll.stop();
              }
            }
          })
          .catch((error) => {
            if (this.$refs.nscroll) {
              this.$refs.nscroll.stop();
            }
            this.total_found = 0;
          })
          .then((data) => {
            this.loading = false;
            done();
          });
      } else {
        APIinterface.getMerchantFeed($params)
          .then((data) => {
            this.page = index;
            if (data.code == 1) {
              this.data.push(data.details.data);
              this.cuisine = data.details.cuisine;
              this.reviews = data.details.reviews;
              this.estimation = data.details.estimation;
              this.services = data.details.services;
              this.items_min_max = data.details.items_min_max;
              this.total_found = data.details.total_found;
              this.promos = data.details.promos;
            } else {
              this.total_found = data.details.total_found;
              if (this.$refs.nscroll) {
                this.$refs.nscroll.stop();
              }
            }
          })
          .catch((error) => {
            if (this.$refs.nscroll) {
              this.$refs.nscroll.stop();
            }
            this.total_found = 0;
          })
          .then((data) => {
            this.loading = false;
            done();
          });
      }
    },
    afterSelectsort(data) {
      console.log("afterSelectsort=>" + data);
      this.sort_by = data;
      this.resetPagination();
      this.page = 0;
    },
    applyFilter(data) {
      this.filters = data;
      this.filters.transaction_type = this.transactionType;
      this.resetPagination();
      this.page = 0;
    },
    resetPagination() {
      this.page = 0;
      this.data = [];
      this.$refs.nscroll.reset();
      this.$refs.nscroll.resume();
      this.$refs.nscroll.trigger();
    },
    filterAgain() {
      console.log("filterAgain");
      this.$refs.merchant_filter.filter = true;
    },
  },
};
</script>
