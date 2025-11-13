<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-header
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
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
          $t("Item Inventory")
        }}</q-toolbar-title>
      </q-toolbar>
      <q-separator></q-separator>
    </q-header>
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
    >
      <template v-if="loading_get">
        <q-inner-loading :showing="true" color="primary" size="md" />
      </template>

      <q-form v-else @submit="onSubmit">
        <div class="q-pa-md q-gutter-md">
          <div>
            <q-toggle v-model="track_stock" :label="$t('Track Stock')" dense />
          </div>
          <q-input
            outlined
            v-model="sku"
            :label="$t('SKU')"
            stack-label
            color="grey-5"
            lazy-rules
          />

          <q-select
            outlined
            v-model="supplier_id"
            :label="$t('Supplier')"
            color="grey-5"
            :options="MenuStore.supplier_data"
            stack-label
            behavior="dialog"
            transition-show="fade"
            transition-hide="fade"
            emit-value
            map-options
          />
        </div>
        <q-footer
          class="q-pl-md q-pr-md q-pb-xs"
          :class="{
            'bg-mydark ': $q.dark.mode,
            'bg-white ': !$q.dark.mode,
          }"
        >
          <q-btn
            type="submit"
            color="primary"
            text-color="white"
            :label="$t('Save')"
            unelevated
            class="full-width radius8"
            size="lg"
            no-caps
            :loading="loading"
          />
        </q-footer>
      </q-form>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useMenuStore } from "stores/MenuStore";

export default {
  name: "ItemInventory",
  data() {
    return {
      track_stock: false,
      sku: "",
      supplier_id: "",
      item_uuid: "",
      loading_get: false,
      loading: false,
    };
  },
  setup(props) {
    const MenuStore = useMenuStore();
    return { MenuStore };
  },
  created() {
    this.MenuStore.getSupplier();
    this.item_uuid = this.$route.query.item_uuid;
    if (!APIinterface.empty(this.item_uuid)) {
      this.getItem();
    }
  },
  methods: {
    refresh(done) {
      this.MenuStore.getSupplier();
      if (!APIinterface.empty(this.item_uuid)) {
        this.getItem(done);
      } else {
        done();
      }
    },
    getItem(done) {
      this.loading_get = true;
      APIinterface.fetchDataByTokenPost("getItem", "id=" + this.item_uuid)
        .then((data) => {
          this.track_stock = data.details.track_stock;
          this.sku = data.details.sku;
          this.supplier_id = data.details.supplier_id;
          //
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading_get = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    onSubmit() {
      this.loading = true;
      APIinterface.fetchDataByToken("saveInventory", {
        item_uuid: this.item_uuid,
        track_stock: this.track_stock,
        sku: this.sku,
        supplier_id: this.supplier_id,
      })
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
