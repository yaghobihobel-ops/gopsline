<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page>
      <q-list>
        <q-virtual-scroll
          class="fit"
          separator
          :items="data"
          :virtual-scroll-item-size="60"
          v-slot="{ item: items }"
        >
          <q-item tag="label">
            <q-item-section avatar>
              <q-checkbox
                v-model="selected_items"
                :val="items.item_id"
                color="primary"
              />
            </q-item-section>
            <q-item-section>
              <q-item-label>{{ items.item_name }}</q-item-label>
            </q-item-section>
          </q-item>
        </q-virtual-scroll>
      </q-list>

      <q-infinite-scroll
        ref="nscroll"
        @load="fetchFromApi"
        :offset="250"
        :disable="scroll_disabled"
      >
        <template v-slot:loading>
          <div
            class="row q-gutter-x-sm justify-center q-my-md"
            :class="{
              'absolute-center text-center full-width q-mt-xl': page == 1,
            }"
          >
            <q-circular-progress
              indeterminate
              rounded
              size="sm"
              color="primary"
            />
            <div class="text-subtitle1 text-grey">{{ $t("Loading") }}...</div>
          </div>
        </template>
      </q-infinite-scroll>

      <q-space class="q-pa-lg"></q-space>

      <q-footer class="q-pa-md bg-white myshadow">
        <q-btn
          type="submit"
          color="amber-6"
          text-color="disabled"
          unelevated
          class="full-width radius8"
          size="lg"
          no-caps
          @click="SaveSuggestedItems"
        >
          <div class="text-weight-bold text-subtitle2">
            ({{ selected_items.length }}) {{ $t("Selected") }}
          </div>
        </q-btn>
      </q-footer>

      <DeleteComponents ref="ref_delete" @after-confirm="afterConfirm">
      </DeleteComponents>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "src/stores/DataStore";
import { defineAsyncComponent } from "vue";
import { useOrderStore } from "src/stores/OrderStore";

export default {
  name: "AddSuggestedItems",
  components: {
    DeleteComponents: defineAsyncComponent(() =>
      import("components/DeleteComponents.vue")
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
    this.DataStore.page_title = this.$t("Select Items");

    if (this.DataStore.dataList?.itemList) {
      this.data = this.DataStore.dataList?.itemList?.data;
      this.page = this.DataStore.dataList?.itemList?.page;
      this.hasMore = this.DataStore.dataList?.itemList?.hasMore;
    } else {
      setTimeout(() => {
        this.$refs.nscroll?.trigger();
      }, 200);
    }
    this.scroll_disabled = false;
  },
  beforeUnmount() {
    this.DataStore.dataList.itemList = {
      data: this.data,
      page: this.page,
      hasMore: this.hasMore,
    };
  },
  methods: {
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
          `fetchFoodItems?${params}`
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
        this.data = null;
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
    async SaveSuggestedItems() {
      try {
        APIinterface.showLoadingBox("", this.$q);
        const params = {
          items: this.selected_items,
        };
        const response = await APIinterface.fetchDataByToken(
          "SaveSuggestedItems",
          params
        );
        APIinterface.ShowSuccessful(response.msg, this.$q);
        this.DataStore.cleanData("suggested_items");
        this.$router.replace("/campaigns/suggested_items");
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
  },
};
</script>
