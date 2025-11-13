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
            <q-item clickable v-ripple:purple @click="initReply(items)">
              <q-item-section avatar top>
                <q-img
                  :src="items.avatar"
                  style="height: 60px; width: 60px"
                  loading="lazy"
                  fit="cover"
                  class="radius8"
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
                <q-item-label>
                  <div class="flex items-center justify-between">
                    <div>{{ items.customer_fullname }}</div>
                    <div>
                      <q-badge
                        :color="OrderStore.itemStatus[items.status_raw]?.bg"
                        :text-color="
                          OrderStore.itemStatus[items.status_raw]?.text
                        "
                        rounded
                        >{{ items.status }}</q-badge
                      >
                    </div>
                  </div>
                </q-item-label>
                <q-item-label line="3"> {{ items.review }}</q-item-label>
                <q-item-label caption> {{ items.date_created }}</q-item-label>
                <q-item-label>
                  <q-rating
                    v-model="rating"
                    :model-value="items.rating"
                    size="1.5em"
                    :max="5"
                    color="grey"
                    color-selected="yellow-14"
                    readonly
                    icon-selected="img:/svg/star-selected.svg"
                    icon="img:/svg/tabler--star-filled.svg"
                  />
                </q-item-label>
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

      <ReviewReply
        ref="review_reply"
        :data="selected_items"
        @after-reply="afterReply"
      >
      </ReviewReply>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "src/stores/DataStore";
import { defineAsyncComponent } from "vue";
import { useAccessStore } from "stores/AccessStore";
import { useOrderStore } from "src/stores/OrderStore";

export default {
  name: "SizeList",
  components: {
    DeleteComponents: defineAsyncComponent(() =>
      import("components/DeleteComponents.vue")
    ),
    ReviewReply: defineAsyncComponent(() =>
      import("components/ReviewReply.vue")
    ),
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
    this.DataStore.page_title = this.$t("Customer reviews");

    if (this.DataStore.dataList?.reviewlist) {
      this.data = this.DataStore.dataList?.reviewlist?.data;
      this.page = this.DataStore.dataList?.reviewlist?.page;
      this.hasMore = this.DataStore.dataList?.reviewlist?.hasMore;
      this.total_items = this.DataStore.dataList?.reviewlist?.total_items;
      this.DataStore.page_subtitle = this.total_items;
    } else {
      setTimeout(() => {
        this.$refs.nscroll?.trigger();
      }, 200);
    }
    this.scroll_disabled = false;
  },
  beforeUnmount() {
    this.DataStore.page_subtitle = null;
    this.DataStore.dataList.reviewlist = {
      data: this.data,
      page: this.page,
      hasMore: this.hasMore,
      total_items: this.total_items,
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
    afterReply() {
      this.resetPagination();
    },
    initReply(data) {
      console.log("initReply", data);
      this.selected_items = data;
      this.$refs.review_reply.dialog = true;
    },
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
          `getCustomerReview?${params}`
        );
        this.page++;
        this.data = [...this.data, ...response.details.data];
        this.total_items = response.details.total_reviews;
        this.DataStore.page_subtitle = this.total_items;

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
    confimDelete(value) {
      this.id = value;
      this.$refs.ref_delete.confirm();
    },
    async afterConfirm() {
      try {
        if (!this.id) {
          APIinterface.ShowAlert(
            this.$t("Invalid Id"),
            this.$q.capacitor,
            this.$q
          );
          return;
        }

        APIinterface.showLoadingBox("", this.$q);
        const params = new URLSearchParams({
          size_id: this.id,
        }).toString();
        await APIinterface.fetchDataByTokenPost("deleteSize", params);
        this.data = this.data.filter((item) => item.id !== this.id);
        this.id = null;
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
  },
};
</script>
