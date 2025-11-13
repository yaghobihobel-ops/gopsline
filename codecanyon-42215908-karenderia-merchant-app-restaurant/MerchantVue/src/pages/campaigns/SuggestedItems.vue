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
            <q-item>
              <q-item-section>
                <q-item-label>{{ items.item_name }}</q-item-label>
                <q-item-label caption lines="2">
                  {{ items.created_at }}</q-item-label
                >
              </q-item-section>
              <q-item-section side top>
                <q-item-label>
                  <q-badge
                    class="text-capitalize"
                    :color="OrderStore.suggestedStatus[items.status_raw]?.bg"
                    :text-color="
                      OrderStore.suggestedStatus[items.status_raw]?.text
                    "
                    rounded
                    >{{ items.status }}</q-badge
                  >
                </q-item-label>
                <q-item-label>
                  <q-btn
                    icon="o_delete_outline"
                    color="red-1"
                    text-color="red-9"
                    no-caps
                    unelevated
                    round
                    size="sm"
                    @click="confimDelete(items.id)"
                  ></q-btn>
                </q-item-label>
              </q-item-section>
            </q-item>
          </q-card>
        </q-virtual-scroll>
      </q-list>

      <q-infinite-scroll
        ref="nscroll"
        @load="fetchFromApi"
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

      <q-page-sticky position="bottom-right" :offset="[18, 18]">
        <q-btn
          fab
          icon="add"
          color="amber-6"
          unelevated
          class="myshadow"
          padding="10px"
          to="/campaigns/add_suggested_items"
        />
      </q-page-sticky>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "src/stores/DataStore";
import { defineAsyncComponent } from "vue";
import { useOrderStore } from "src/stores/OrderStore";

export default {
  name: "SuggestedItems",
  components: {
    DeleteComponents: defineAsyncComponent(() =>
      import("components/DeleteComponents.vue")
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
    };
  },
  setup() {
    const DataStore = useDataStore();
    const OrderStore = useOrderStore();
    return {
      DataStore,
      OrderStore,
    };
  },
  mounted() {
    this.DataStore.page_title = this.$t("Suggested Items");

    if (this.DataStore.dataList?.suggested_items) {
      this.data = this.DataStore.dataList?.suggested_items?.data;
      this.page = this.DataStore.dataList?.suggested_items?.page;
      this.hasMore = this.DataStore.dataList?.suggested_items?.hasMore;
    } else {
      setTimeout(() => {
        this.$refs.nscroll?.trigger();
      }, 200);
    }
    this.scroll_disabled = false;
  },
  beforeUnmount() {
    this.DataStore.dataList.suggested_items = {
      data: this.data,
      page: this.page,
      hasMore: this.hasMore,
    };
  },
  computed: {
    hasItems() {
      return this.data.length > 0;
    },
  },
  methods: {
    async setAvailable(value) {
      try {
        APIinterface.showLoadingBox("", this.$q);
        const available = value?.available ? 1 : 0;
        const params = new URLSearchParams({
          id: value.id,
          available: available,
        }).toString();
        await APIinterface.fetchDataByTokenPost("setSizeStatus", params);
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
    async fetchFromApi(index, done) {
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
          `SuggestedItems?${params}`
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
          id: this.id,
        }).toString();
        await APIinterface.fetchDataByTokenPost("deletesuggested", params);
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
