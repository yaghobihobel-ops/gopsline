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
                <q-item-label>{{ items.name }}</q-item-label>
                <q-item-label caption lines="2">
                  {{ items.date_created }}</q-item-label
                >
                <q-item-label class="hidden">
                  <q-toggle
                    color="primary"
                    v-model="items.available"
                    @update:model-value="setAvailable(items)"
                    val="1"
                    class="fb-toggle"
                    keep-color
                    label="Available"
                    left-label
                  />
                </q-item-label>
              </q-item-section>
              <q-item-section side top>
                <div class="flex q-gutter-x-md">
                  <q-btn
                    icon="o_mode_edit"
                    color="indigo-1"
                    text-color="dark"
                    no-caps
                    unelevated
                    round
                    size="sm"
                    :to="{
                      path: '/ingredients/edit',
                      query: { id: items.id },
                    }"
                  ></q-btn>

                  <q-btn
                    v-if="AccessStore.hasAccess('food.category_delete')"
                    icon="o_delete_outline"
                    color="red-1"
                    text-color="red-9"
                    no-caps
                    unelevated
                    round
                    size="sm"
                    @click="confimDelete(items.id)"
                  ></q-btn>
                </div>
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

      <q-page-sticky position="bottom-right" :offset="[18, 18]">
        <q-btn
          fab
          icon="add"
          color="amber-6"
          unelevated
          class="myshadow"
          padding="10px"
          to="/ingredients/add"
        />
      </q-page-sticky>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useMenuStore } from "src/stores/MenuStore";
import { useDataStore } from "src/stores/DataStore";
import { defineAsyncComponent } from "vue";
import { useAccessStore } from "stores/AccessStore";

export default {
  name: "IngredientsList",
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
    const MenuStore = useMenuStore();
    const AccessStore = useAccessStore();
    return {
      DataStore,
      MenuStore,
      AccessStore,
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
  mounted() {
    this.MenuStore.page_title = this.$t("Ingredients");

    if (this.DataStore.dataList?.ingredient_list) {
      this.data = this.DataStore.dataList?.ingredient_list?.data;
      this.page = this.DataStore.dataList?.ingredient_list?.page;
      this.hasMore = this.DataStore.dataList?.ingredient_list?.hasMore;
    } else {
      setTimeout(() => {
        this.$refs.nscroll?.trigger();
      }, 200);
    }
    this.scroll_disabled = false;
  },
  beforeUnmount() {
    this.DataStore.dataList.ingredient_list = {
      data: this.data,
      page: this.page,
      hasMore: this.hasMore,
    };
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
          `IngredientList?${params}`
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
        await APIinterface.fetchDataByTokenPost("deleteIngredients", params);
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
