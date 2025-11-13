<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page class="q-pa-md bg-grey-1">
      <q-list>
        <q-virtual-scroll
          class="fit"
          separator
          :items="data"
          :virtual-scroll-item-size="60"
          v-slot="{ item: items }"
        >
          <q-card flat class="myshadow bg-white q-mb-md">
            <q-item
              clickable
              v-ripple:purple
              :to="{
                path: '/customer/details',
                query: { client_id: items.client_id },
              }"
            >
              <q-item-section avatar top>
                <q-img
                  :src="items.avatar"
                  style="height: 60px; width: 60px"
                  loading="lazy"
                  fit="cover"
                  class="radius10"
                >
                  <template v-slot:loading>
                    <q-skeleton
                      height="60px"
                      width="60px"
                      square
                      class="bg-grey-2"
                    />
                  </template>
                </q-img>
              </q-item-section>
              <q-item-section>
                <q-item-label class="text">
                  {{ items.name }}
                </q-item-label>
                <q-item-label caption> {{ items.email_address }}</q-item-label>
                <q-item-label caption> {{ items.contact_phone }}</q-item-label>
              </q-item-section>
            </q-item>
          </q-card>
        </q-virtual-scroll>
      </q-list>

      <q-infinite-scroll
        ref="nscroll"
        @load="fetchCategory"
        :offset="250"
        :disable="scroll_disabled"
      >
        <template v-slot:default>
          <NoData v-if="!hasItems && !loading" />
        </template>
        <template v-slot:loading>
          <LoadingData :page="page"></LoadingData>
        </template>
      </q-infinite-scroll>

      <q-space class="q-pa-lg"></q-space>

      <DeleteComponents ref="ref_delete" @after-confirm="afterConfirm">
      </DeleteComponents>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "src/stores/DataStore";
import { useAccessStore } from "stores/AccessStore";
import { useOrderStore } from "src/stores/OrderStore";
import { defineAsyncComponent } from "vue";

export default {
  name: "SizeList",
  components: {
    NoData: defineAsyncComponent(() => import("components/NoData.vue")),
    LoadingData: defineAsyncComponent(() =>
      import("components/LoadingData.vue")
    ),
  },
  data() {
    return {
      scroll_disabled: true,
      hasMore: true,
      loading: false,
      page: 1,
      data: [],
      id: null,
      selected_items: [],
      total_items: null,
    };
  },
  setup() {
    const DataStore = useDataStore();
    const AccessStore = useAccessStore();
    const OrderStore = useOrderStore();
    return {
      DataStore,
      AccessStore,
      OrderStore,
    };
  },
  mounted() {
    this.DataStore.page_title = this.$t("Customer");

    if (this.DataStore.dataList?.customer_list) {
      this.data = this.DataStore.dataList?.customer_list?.data;
      this.page = this.DataStore.dataList?.customer_list?.page;
      this.hasMore = this.DataStore.dataList?.customer_list?.hasMore;
    } else {
      setTimeout(() => {
        this.$refs.nscroll?.trigger();
      }, 200);
    }
    this.scroll_disabled = false;
  },
  beforeUnmount() {
    this.DataStore.dataList.customer_list = {
      data: this.data,
      page: this.page,
      hasMore: this.hasMore,
    };
  },
  computed: {
    hasItems() {
      if (!this.data) {
        return false;
      }
      return this.data.length > 0;
    },
  },
  methods: {
    async fetchCategory(index, done) {
      try {
        if (this.loading) {
          return;
        }

        if (!this.hasMore) {
          this.scroll_disabled = true;
          done(true);
          return;
        }
        this.loading = true;
        const params = new URLSearchParams({
          page: this.page,
        }).toString();

        const response = await APIinterface.fetchGet(
          `fetchCustomelist?${params}`
        );
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
        done(true);
      } finally {
        this.loading = false;
      }
    },
    refresh(done) {
      setTimeout(() => {
        done();
      }, 100);
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
