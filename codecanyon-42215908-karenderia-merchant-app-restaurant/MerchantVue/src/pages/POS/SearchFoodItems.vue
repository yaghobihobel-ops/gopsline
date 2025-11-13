<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-header
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
      reveal
      reveal-offset="50"
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
          $t("Search items")
        }}</q-toolbar-title>
      </q-toolbar>
      <q-separator></q-separator>
    </q-header>
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
      class="flex justify-start"
    >
      <div class="q-pa-md full-width">
        <q-input outlined v-model="q" :label="$t('Search')" color="grey-5">
          <template v-slot:append>
            <q-icon
              v-if="SearchStore.hasData"
              class="cursor-pointer"
              name="close"
              color="grey"
              @click="clearSearch"
            />
            <q-btn
              v-if="!SearchStore.hasData"
              icon="search"
              unelevated
              color="dark-grey"
              no-caps
              :loading="loading"
              round
              flat
              @click="doSearch"
              :disable="!hasSearch"
            ></q-btn>
          </template>
        </q-input>

        <template v-if="SearchStore.hasData">
          <q-space class="q-mt-md"></q-space>
          <q-list separator>
            <template v-for="item in SearchStore.data" :key="item">
              <q-item clickable @click="viewItems(item)">
                <q-item-section avatar top>
                  <q-avatar size="50px">
                    <q-img
                      :src="item.url_image"
                      style="width: 50px; height: 50px"
                    >
                    </q-img>
                  </q-avatar>
                </q-item-section>
                <q-item-section>
                  <q-item-label class="text-dark">
                    {{ item.item_name }}
                  </q-item-label>
                  <q-item-label caption lines="2">
                    {{ item.item_description }}
                  </q-item-label>
                  <q-item-label caption>
                    <template
                      v-for="(prices, index) in item.price"
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
            </template>
          </q-list>
        </template>
        <TableSkeleton v-if="loading" :rows="10"></TableSkeleton>
      </div>

      <div v-if="!SearchStore.is_submit" class="full-width text-center"></div>
      <div v-else class="full-width text-center">
        <template v-if="!SearchStore.hasData && !loading">
          <div class="text-weight-bold">{{ $t("No data available") }}</div>
          <div class="text-weight-light text-grey">
            {{ $t("Sorry, we couldn't find any results") }}
          </div>
        </template>
      </div>
      <ItemDetails
        ref="item_details"
        @after-addtocart="afterAddtocart"
      ></ItemDetails>
      <q-ajax-bar
        ref="bar"
        position="top"
        color="primary"
        size="2px"
        skip-hijack
      />
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useSearchStore } from "stores/SearchStore";
import { useDataStore } from "stores/DataStore";
import { useCartStore } from "stores/CartStore";

export default {
  name: "SearchTables",
  components: {
    TableSkeleton: defineAsyncComponent(() =>
      import("components/TableSkeleton.vue")
    ),
    ItemDetails: defineAsyncComponent(() =>
      import("components/ItemDetails.vue")
    ),
  },
  setup() {
    const SearchStore = useSearchStore();
    const DataStore = useDataStore();
    const CartStore = useCartStore();
    return { SearchStore, DataStore, CartStore };
  },
  data() {
    return {
      q: "",
      loading: false,
    };
  },
  created() {
    this.SearchStore.data = "";
  },
  computed: {
    hasSearch() {
      if (APIinterface.empty(this.q)) {
        return false;
      }
      return true;
    },
  },
  methods: {
    viewItems(data) {
      let ajaxbar = this.$refs.bar;
      this.$refs.item_details.getMenuItem(data, ajaxbar);
    },
    refresh(done) {
      this.clearSearch();
      done();
    },
    clearSearch() {
      this.SearchStore.is_submit = false;
      this.q = "";
      this.SearchStore.data = [];
    },
    doSearch() {
      this.loading = true;
      this.SearchStore.data = [];
      this.SearchStore.status = [];
      this.SearchStore.is_submit = true;
      APIinterface.fetchDataByTokenPost("searchfooditems", "q=" + this.q)
        .then((data) => {
          this.SearchStore.data = data.details.data;
        })
        .catch((error) => {})
        .then((data) => {
          this.loading = false;
        });
    },
    afterAddtocart() {
      this.CartStore.getCart(this.DataStore.cart_uuid);
    },
  },
};
</script>
