<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page>
      <div class="q-pa-md q-gutter-y-md">
        <q-virtual-scroll
          v-if="hasCategory"
          :items="category"
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
      <!-- q-pa-md -->

      <q-space class="q-pa-md"></q-space>

      <q-infinite-scroll
        ref="nscroll"
        @load="fetchItems"
        :offset="250"
        :disable="scroll_disabled"
      >
        <template v-slot:default>
          <NoData v-if="!hasItems && !loading1" />
        </template>
        <template v-slot:loading>
          <LoadingData :page="page"></LoadingData>
        </template>
      </q-infinite-scroll>

      <ItemInformation
        ref="ref_items"
        @after-update="resetPagination"
      ></ItemInformation>

      <q-page-sticky position="bottom-right" :offset="[18, 18]">
        <q-btn
          fab
          icon="add"
          color="amber-6"
          unelevated
          class="myshadow"
          padding="10px"
          to="/item/add"
        />
      </q-page-sticky>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { defineAsyncComponent } from "vue";
import { useDataStore } from "src/stores/DataStore";
import { useMenuStore } from "src/stores/MenuStore";

export default {
  name: "FoodItems",
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
      category: null,
      data: [],
      cat_id: null,
      page: 1,
      scroll_disabled: true,
      hasMore: true,
    };
  },
  setup() {
    const DataStore = useDataStore();
    const MenuStore = useMenuStore();
    return {
      DataStore,
      MenuStore,
    };
  },
  mounted() {
    this.MenuStore.page_title = this.$t("Food Items");

    if (this.DataStore.dataList?.food_data) {
      this.category = this.DataStore.dataList?.food_data?.category;
      this.data = this.DataStore.dataList?.food_data?.data;
      this.page = this.DataStore.dataList?.food_data?.page;
      this.hasMore = this.DataStore.dataList?.food_data?.hasMore;
      this.cat_id = this.DataStore.dataList?.food_data?.cat_id ?? null;
    } else {
      this.fetchCategory();
    }
    this.scroll_disabled = false;
  },
  computed: {
    chunkedData() {
      return this.chunk(this.data, 2);
    },
    hasItems() {
      if (!this.data) {
        return false;
      }
      return this.data.length > 0;
    },
    hasCategory() {
      if (!this.category) {
        return false;
      }
      return this.category.length > 0;
    },
  },
  beforeUnmount() {
    this.DataStore.dataList.food_data = {
      category: this.category,
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
      return Array.from({ length: Math.ceil(array.length / size) }, (_, i) =>
        array.slice(i * size, i * size + size)
      );
    },
    refresh(done) {
      setTimeout(() => {
        done();
      }, 100);
      this.refreshAll();
    },
    refreshAll() {
      this.resetPagination();
      setTimeout(() => {
        this.fetchCategory();
      }, 100);
    },
    async fetchCategory() {
      try {
        this.loading = true;
        const response = await APIinterface.fetchGet("CategoryList");
        this.category = response.details.data;
      } catch (error) {
        this.category = null;
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
  },
};
</script>
