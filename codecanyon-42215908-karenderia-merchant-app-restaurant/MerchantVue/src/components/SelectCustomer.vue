<template>
  <template v-if="template == 2">
    <q-select
      v-model="CartStore.customer_id"
      :options="options"
      outlined
      color="grey-5"
      use-input
      behavior="dialog"
      input-debounce="0"
      emit-value
      map-options
      @filter="filterFn"
      @update:model-value="afterSelectcustomer"
      :label="$t('Customer')"
      stack-label
      clearable
      multiple
    >
    </q-select>
  </template>
  <template v-else>
    <q-select
      v-model="CartStore.customer_id"
      :options="options"
      dense
      outlined
      label-color="dark"
      color="grey600"
      bg-color="yellow-7"
      fill-inputx
      use-input
      behavior="dialog"
      input-debounce="0"
      emit-value
      map-options
      @filter="filterFn"
      @update:model-value="afterSelectcustomer"
      :label="$t('Customer')"
      stack-label
      clearable
    >
      <template v-slot:after>
        <QrcodeScanner ref="qr_scanner" @after-scan="afterScan"></QrcodeScanner>
        <q-btn
          @click="this.$emit('createCustomer')"
          dense
          icon="las la-user-plus"
          color="blue"
          class="radius8"
        />
      </template>
    </q-select>
  </template>
</template>

<script>
import { useCartStore } from "stores/CartStore";
import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";
import { defineAsyncComponent } from "vue";

export default {
  name: "SelectCustomer",
  props: ["options_data", "template"],
  components: {
    QrcodeScanner: defineAsyncComponent(() =>
      import("components/QrcodeScanner.vue")
    ),
  },
  data() {
    return {
      options: [],
      initial_data: [],
    };
  },
  created() {
    //this.getInitial();
  },
  setup() {
    const CartStore = useCartStore();
    const DataStore = useDataStore();
    return { CartStore, DataStore };
  },
  watch: {
    options_data(newval, oldval) {
      //console.log("options_data xx", newval);
      this.CartStore.customer_id = newval.id;
      this.options = newval.data;
    },
  },
  methods: {
    afterSelectcustomer(client_id) {
      this.CartStore.afterSelectcustomer(this.DataStore.cart_uuid, client_id);
    },
    filterFn(val, update, abort) {
      if (val === "") {
        update(() => {
          this.options = this.initial_data;
        });
      }

      APIinterface.fetchDataByTokenPost("searchCustomer", "q=" + val + "&POS=1")
        .then((data) => {
          update(() => {
            this.options = data.details.data;
          });
        })
        .catch((error) => {
          console.debug(error);
        })
        .then((data) => {});
    },
    async afterScan(data) {
      console.log("afterScan", data);
      try {
        APIinterface.showLoadingBox("", this.$q);
        const results = await APIinterface.fetchDataByTokenPost(
          "searchCustomerByUUID",
          "qrcode_value=" + data
        );
        this.CartStore.customer_id = results.details.id;
        this.options = results.details.data;
        this.CartStore.afterSelectcustomer(
          this.DataStore.cart_uuid,
          results.details.id
        );
      } catch (error) {
        APIinterface.notify("dark", error, "error", this.$q);
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
  },
};
</script>
