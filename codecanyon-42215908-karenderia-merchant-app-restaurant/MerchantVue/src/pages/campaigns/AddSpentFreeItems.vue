<template>
  <q-page class="q-pa-md">
    <template v-if="loading1">
      <div
        class="row q-gutter-x-sm justify-center absolute-center text-center full-width"
      >
        <q-circular-progress indeterminate rounded size="sm" color="primary" />
        <div class="text-subtitle1 text-grey">{{ $t("Loading") }}...</div>
      </div>
    </template>
    <q-form v-else @submit="onSubmit" class="q-gutter-y-md">
      <q-select
        outlined
        v-model="item_id"
        :label="$t('Food items')"
        @filter="filterItems"
        @clear="fetchItems"
        :options="data"
        option-value="item_id"
        option-label="item_name"
        stack-label
        behavior="menu"
        map-options
        emit-value
        hide-bottom-space
        :rules="[
          (val) => (val !== null && val !== '') || $t('This field is required'),
        ]"
        use-input
        hide-selected
        fill-input
        input-debounce="300"
        clearable
      />

      <q-input
        type="number"
        outlined
        v-model="minimum_cart_total"
        :label="$t('Minimum Cart Total')"
        step="any"
        stack-label
        lazy-rules
        :rules="[
          (val) =>
            (val !== null && val !== '' && !isNaN(val)) ||
            $t('This field is required'),
        ]"
        hide-bottom-space
      />

      <q-input
        type="number"
        outlined
        v-model="max_free_quantity"
        :label="$t('Max Free Quantity')"
        step="any"
        stack-label
        lazy-rules
        :rules="[
          (val) =>
            (val !== null && val !== '' && !isNaN(val)) ||
            $t('This field is required'),
        ]"
        hide-bottom-space
      />

      <q-toggle v-model="auto_add">
        <template v-slot:default>
          <div class="text-body2">
            {{ $t("Auto Add to Cart") }}
          </div>
        </template>
      </q-toggle>

      <q-select
        outlined
        v-model="status"
        :label="$t('Status')"
        color="grey-5"
        :options="DataStore.status_list"
        stack-label
        behavior="menu"
        transition-show="fade"
        transition-hide="fade"
        hide-bottom-space
      />

      <q-footer vif="!loading1" class="q-pa-md bg-white myshadow">
        <q-btn
          type="submit"
          color="amber-6"
          text-color="disabled"
          unelevated
          class="full-width radius8"
          size="lg"
          no-caps
          :loading="loading"
        >
          <div class="text-weight-bold text-subtitle2">
            {{ $t("Submit") }}
          </div>
        </q-btn>
      </q-footer>
    </q-form>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "src/stores/DataStore";

export default {
  name: "AddSpentFreeItems",
  setup(props) {
    const DataStore = useDataStore();
    return {
      DataStore,
    };
  },
  data() {
    return {
      id: null,
      data: [],
      item_id: null,
      minimum_cart_total: "",
      max_free_quantity: "",
      auto_add: false,
      status: "publish",
      loading: false,
      loading1: false,
    };
  },
  mounted() {
    this.id = this.$route.query.id;
    if (this.id) {
      this.DataStore.page_title = this.$t("Update Free Item");
      this.fetchFreeItems();
    } else {
      this.DataStore.page_title = this.$t("Add Free Item");
      this.fetchItems();
    }
  },
  methods: {
    setModel(value) {
      console.log("setModel", value);
    },
    async fetchFreeItems() {
      try {
        this.loading1 = true;
        const params = new URLSearchParams({
          id: this.id,
        }).toString();
        const response = await APIinterface.fetchGet(
          `fetchFreeItems?${params}`
        );
        console.log("response", response);
        this.item_id = response.details.data.item_id;
        this.minimum_cart_total = response.details.data.minimum_cart_total;
        this.max_free_quantity = response.details.data.max_free_quantity;
        this.auto_add = response.details.data.auto_add;
        this.status = response.details.data.status;
        this.data = response.details.data.items;
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        this.loading1 = false;
      }
    },
    async fetchItems() {
      try {
        const response = await APIinterface.fetchGet("fetchFoodItems");
        this.data = response.details.data;
      } catch (error) {
        this.data = [];
      } finally {
      }
    },
    async filterItems(val, update, abort) {
      if (val === "") {
        update(() => {
          this.data = this.data;
        });
        return;
      }
      try {
        const params = new URLSearchParams({
          q: val,
        }).toString();
        const response = await APIinterface.fetchGet(
          `fetchFoodItems?${params}`
        );
        update(() => {
          this.data = response.details.data;
        });
      } catch (error) {
        abort();
      } finally {
      }
    },
    async onSubmit() {
      try {
        this.loading = true;
        const params = new URLSearchParams({
          id: this.id ? this.id : "",
          item_id: this.item_id,
          minimum_cart_total: this.minimum_cart_total,
          max_free_quantity: this.max_free_quantity,
          auto_add: this.auto_add ? 1 : 0,
          status: this.status,
        }).toString();
        const response = await APIinterface.fetchDataByTokenPost(
          "SaveFreeSpentItems",
          params
        );
        APIinterface.ShowSuccessful(response.msg, this.$q);
        this.DataStore.cleanData("freeItemList");
        this.$router.replace("/campaigns/free_item");
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>
