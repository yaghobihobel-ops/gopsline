<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page>
      <q-header v-if="isScrolled" class="bg-white text-dark beautiful-shadow">
        <q-toolbar class="q-pl-md">
          <q-toolbar-title>
            <div class="text-subtitle2 text-weight-bold line-normal">
              {{ merchant_data?.merchant_info?.restaurant_name }}
            </div>
            <div class="text-caption ellipsis line-normal">
              {{ merchant_data?.merchant_info?.merchant_address }}
            </div>
          </q-toolbar-title>
          <q-space></q-space>
          <q-btn
            round
            unelevated
            color="blue-grey-1"
            text-color="blue-grey-8"
            to="/restaurant/information"
          >
            <img src="/svg/edit-resto.svg" width="25" height="25" />
          </q-btn>
        </q-toolbar>
      </q-header>
      <q-scroll-observer @scroll="onScroll" scroll-target="body" />

      <div class="relative-position" style="height: 25vh">
        <q-responsive :ratio="16 / 9" style="max-height: 25vh">
          <q-img
            :src="
              merchant_data?.merchant_info?.has_header
                ? merchant_data?.merchant_info?.url_header
                : 'sample-bg.png'
            "
            fit="cover"
            spinner-color="transparent"
            loading="lazy"
          />
        </q-responsive>

        <div class="absolute-bottom q-pl-md q-pr-md" style="bottom: -60px">
          <q-card flat class="beautiful-shadow radius10" style="z-index: 2">
            <q-skeleton v-if="loading" height="80px" class="bg-grey-1" square />
            <q-item v-else>
              <q-item-section avatar>
                <q-img
                  :src="merchant_data?.merchant_info?.url_logo"
                  style="height: 70px; width: 70px"
                  loading="lazy"
                  fit="cover"
                  class="radius8"
                >
                  <template v-slot:loading>
                    <q-skeleton
                      height="70px"
                      width="70px"
                      square
                      class="bg-grey-2"
                    />
                  </template>
                </q-img>
              </q-item-section>
              <q-item-section to>
                <q-item-label caption lines="1">
                  <span v-html="merchant_data?.merchant_info?.cuisine2"></span>
                </q-item-label>
                <q-item-label class="text-weight-bold text-body1">{{
                  merchant_data?.merchant_info?.restaurant_name
                }}</q-item-label>
                <q-item-label class="q-gutter-x-sm" lines="2">
                  <template
                    v-for="discount in merchant_data?.promo_list"
                    :key="discount"
                  >
                    <q-badge color="green-1" text-color="green-8">
                      <q-icon
                        name="o_local_offer"
                        color="green-9"
                        class="q-mr-xs"
                      />
                      <span>{{ discount.title }}</span>
                    </q-badge>
                  </template>
                </q-item-label>
              </q-item-section>
              <q-item-section side top>
                <q-btn
                  unelevated
                  color="oranges"
                  text-color="primary"
                  no-caps
                  dense
                  class="beautiful-shadow"
                  to="/restaurant/information"
                >
                  <img src="/svg/edit-resto.svg" width="25" height="25" />
                </q-btn>
              </q-item-section>
            </q-item>
          </q-card>

          <q-card
            flat
            class="bg-indigo-1 radius10"
            style="z-index: 1; margin-top: -15px"
          >
            <q-skeleton v-if="loading" height="50px" class="bg-grey-1" square />
            <q-item v-else class="q-pt-lg">
              <q-item-section>
                <div class="flex items-center q-gutter-x-sm">
                  <div class="relative-position" style="margin-top: -1px">
                    <q-icon name="star" color="primary"></q-icon>
                  </div>
                  <div class="text-weight-bold">
                    {{ merchant_data?.merchant_info?.ratings }}
                  </div>
                  <div class="text-caption">
                    ({{ merchant_data?.merchant_info?.review_words }})
                  </div>
                </div>
              </q-item-section>

              <q-item-section>
                <div class="flex items-start q-gutter-x-sm">
                  <div class="relative-position" style="margin-top: -1px">
                    <q-icon name="fmd_good" color="red"></q-icon>
                  </div>
                  <div class="text-weight-bold">
                    {{ merchant_data?.merchant_info?.distance_covered }}
                  </div>
                </div>
              </q-item-section>
            </q-item>
          </q-card>
        </div>
      </div>

      <div style="padding-top: 70px"></div>

      <div class="q-pa-md q-gutter-y-md">
        <q-virtual-scroll
          :items="merchant_data?.category"
          virtual-scroll-horizontal
          v-slot="{ item }"
        >
          <div class="q-mr-md">
            <q-btn
              :color="item.cat_id == cat_id ? 'primary' : 'oranges'"
              :text-color="item.cat_id == cat_id ? 'white' : 'primary'"
              unelevated
              no-caps
              class="radius10"
              @click="loadItemsCategory(item.cat_id)"
            >
              <div>{{ item.category_name }}</div>
            </q-btn>
          </div>
        </q-virtual-scroll>

        <q-list>
          <q-virtual-scroll
            class="fit"
            separator
            :items="chunkedData"
            :virtual-scroll-item-size="200"
            v-slot="{ item: row }"
          >
            <div class="hidden">{{ row }}</div>
            <FoodItem ref="ref_foodlist" :row="row" @on-showitem="onShowitem">
            </FoodItem>
          </q-virtual-scroll>
        </q-list>
      </div>

      <q-infinite-scroll
        ref="nscroll"
        @load="fetchItems"
        :offset="250"
        :disable="scroll_disabled"
      >
        <template v-slot:default>
          <NoData
            v-if="!hasItems && !loading1"
            class="q-mt-xl"
            message="No food items available yet."
            :isCenter="false"
          />
        </template>
        <template v-slot:loading>
          <LoadingData :page="page"></LoadingData>
        </template>
      </q-infinite-scroll>

      <ItemInformation
        ref="ref_items"
        @after-update="resetPagination"
      ></ItemInformation>
      <q-space class="q-pa-lg"></q-space>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { defineAsyncComponent } from "vue";
import { useDataStore } from "src/stores/DataStore";

export default {
  name: "MenuPage",
  components: {
    ItemInformation: defineAsyncComponent(() =>
      import("components/ItemInformation.vue")
    ),
    FoodItem: defineAsyncComponent(() => import("components/FoodItem.vue")),
    NoData: defineAsyncComponent(() => import("components/NoData.vue")),
    LoadingData: defineAsyncComponent(() =>
      import("components/LoadingData.vue")
    ),
  },
  data() {
    return {
      isScrolled: false,
      loading: false,
      loading1: false,
      merchant_data: null,
      data: [],
      cat_id: null,
      page: 1,
      scroll_disabled: true,
      hasMore: true,
    };
  },
  setup() {
    const DataStore = useDataStore();
    return {
      DataStore,
    };
  },
  mounted() {
    if (this.DataStore.dataList?.menu_data) {
      this.merchant_data = this.DataStore.dataList?.menu_data?.merchant_data;
      this.data = this.DataStore.dataList?.menu_data?.data;
      this.page = this.DataStore.dataList?.menu_data?.page;
      this.hasMore = this.DataStore.dataList?.menu_data?.hasMore;
      this.cat_id = this.DataStore.dataList?.menu_data?.cat_id ?? null;
    } else {
      this.fetchMerchantInfo();
      setTimeout(() => {
        this.$refs.nscroll?.trigger();
      }, 200);
    }
    this.scroll_disabled = false;
  },
  computed: {
    chunkedData() {
      return this.chunk(this.data, 2);
    },
    hasItems() {
      return this.data.length > 0;
    },
  },
  beforeUnmount() {
    this.DataStore.dataList.menu_data = {
      merchant_data: this.merchant_data,
      data: this.data,
      page: this.page,
      hasMore: this.hasMore,
      cat_id: this.cat_id,
    };
  },
  methods: {
    onShowitem(value) {
      this.$refs.ref_items.showItem(value);
    },
    chunk(array, size) {
      if (!Array.isArray(array) || size <= 0) {
        return [];
      }
      return Array.from({ length: Math.ceil(array.length / size) }, (_, i) =>
        array.slice(i * size, i * size + size)
      );
    },
    refresh(done) {
      setTimeout(() => {
        done();
      }, 100);
      this.resetPagination();
    },
    async fetchMerchantInfo() {
      try {
        this.loading = true;
        const response = await APIinterface.fetchGet("fetchMerchantInfo");
        this.merchant_data = response.details;
      } catch (error) {
        this.merchant_data = null;
      } finally {
        this.loading = false;
      }
    },
    async fetchItems(index, done) {
      try {
        if (this.loading1) {
          return;
        }

        if (!this.hasMore) {
          this.scroll_disabled = true;
          done(true);
          return;
        }
        this.loading1 = true;
        const params = new URLSearchParams({
          page: this.page,
          cat_id: this.cat_id ?? "",
        }).toString();

        const response = await APIinterface.fetchGet(`fetchItems?${params}`);
        console.log("response", response);
        this.page++;
        this.data = [...this.data, ...response.details.data];

        if (response.details?.is_last_page) {
          this.hasMore = false;
          this.scroll_disabled = true;
          done(true);
          return;
        }
        done();
      } catch (error) {
        this.data = [];
        console.log("error", error);
        done(true);
      } finally {
        this.loading1 = false;
      }
    },
    loadItemsCategory(value) {
      console.log("loadItemsCategory", value);
      this.cat_id = value;
      this.resetPagination();
    },
    resetPagination() {
      this.page = 1;
      this.data = [];
      this.hasMore = true;
      this.scroll_disabled = false;
      this.$nextTick(() => {
        this.$refs.nscroll?.resume?.();
        this.$refs.nscroll?.trigger?.();
      });
    },
    onScroll(info) {
      if (!info) {
        return;
      }
      this.isScrolled = info.position.top > 20;
    },
  },
};
</script>
