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
        <q-toolbar-title class="text-weight-bold">
          <template v-if="isEdit"> {{ $t("Edit Price") }} </template>
          <template v-else> {{ $t("Add Price") }} </template>
        </q-toolbar-title>
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
          <q-input
            outlined
            v-model="price"
            :label="$t('Price')"
            stack-label
            color="grey-5"
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <q-select
            outlined
            v-model="size_id"
            :label="$t('Unit')"
            color="grey-5"
            :options="MenuStore.unit"
            stack-label
            behavior="dialog"
            transition-show="fade"
            transition-hide="fade"
            :loading="MenuStore.priceatt_loading"
          />

          <q-input
            outlined
            v-model="cost_price"
            :label="$t('Cost Price')"
            stack-label
            color="grey-5"
            lazy-rules
          />
          <q-input
            outlined
            v-model="discount"
            :label="$t('Discount')"
            stack-label
            color="grey-5"
            lazy-rules
          />

          <q-input
            outlined
            v-model="discount_start"
            :label="$t('Discount Start')"
            stack-label
            color="grey-5"
            readonly
          >
            <template v-slot:append>
              <q-icon name="event" class="cursor-pointer">
                <q-popup-proxy
                  cover
                  transition-show="scale"
                  transition-hide="scale"
                >
                  <q-date v-model="discount_start">
                    <div class="row items-center justify-end">
                      <q-btn
                        v-close-popup
                        :label="$t('Close')"
                        color="primary"
                        flat
                        no-caps
                      />
                    </div>
                  </q-date>
                </q-popup-proxy>
              </q-icon>
            </template>
          </q-input>

          <q-input
            outlined
            v-model="discount_end"
            :label="$t('Discount Start')"
            stack-label
            color="grey-5"
            readonly
          >
            <template v-slot:append>
              <q-icon name="event" class="cursor-pointer">
                <q-popup-proxy
                  cover
                  transition-show="scale"
                  transition-hide="scale"
                >
                  <q-date v-model="discount_end">
                    <div class="row items-center justify-end">
                      <q-btn
                        v-close-popup
                        :label="$t('Close')"
                        color="primary"
                        flat
                        no-caps
                      />
                    </div>
                  </q-date>
                </q-popup-proxy>
              </q-icon>
            </template>
          </q-input>

          <!-- <q-input
            filled
            v-model="discount_start"
            mask="date"
            :rules="['date']"
            stack-label
            color="grey-5"
          >
            <template v-slot:append>
              <q-icon name="event" class="cursor-pointer">
                <q-popup-proxy cover transition-show="scale" transition-hide="scale">
                  <q-date v-model="discount_start">
                    <div class="row items-center justify-end">
                      <q-btn v-close-popup label="Close" color="primary" flat />
                    </div>
                  </q-date>
                </q-popup-proxy>
              </q-icon>
            </template>
          </q-input> -->

          <q-select
            outlined
            v-model="discount_type"
            :label="$t('Discount Type')"
            color="grey-5"
            :options="MenuStore.discount_type"
            stack-label
            behavior="dialog"
            transition-show="fade"
            transition-hide="fade"
            :loading="MenuStore.priceatt_loading"
          />

          <q-input
            outlined
            v-model="sku"
            :label="$t('SKU')"
            stack-label
            color="grey-5"
            lazy-rules
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
  name: "ItemAddPrice",
  data() {
    return {
      dialog_price: false,
      item_uuid: "",
      id: "",
      loading: true,
      loading_get: false,
      price: 0,
      size_id: "",
      cost_price: 0,
      discount: 0,
      discount_type: "",
      discount_start: "",
      discount_end: "",
      sku: "",
      item_size_id: 0,
    };
  },
  setup(props) {
    const MenuStore = useMenuStore();
    return { MenuStore };
  },
  created() {
    this.MenuStore.getPriceAttributes();
    this.item_uuid = this.$route.query.item_uuid;
    this.item_size_id = this.$route.query.item_size_id;
    if (this.item_size_id > 0) {
      this.getPrice();
    }
  },
  computed: {
    isEdit() {
      if (this.item_size_id > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    refresh(done) {
      if (this.item_size_id > 0) {
        this.getPrice(done);
      } else {
        done();
      }
    },
    getPrice(done) {
      this.loading_get = true;
      APIinterface.fetchDataByTokenPost(
        "getPrice",
        "item_size_id=" + this.item_size_id
      )
        .then((data) => {
          this.price = data.details.price;
          this.cost_price = data.details.cost_price;
          this.discount = data.details.discount;
          this.sku = data.details.sku;
          this.size_id = data.details.size_id;
          this.discount_type = data.details.discount_type;
          this.discount_start = data.details.discount_start;
          this.discount_end = data.details.discount_end;
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
      let $item_unit = "";
      if (!APIinterface.empty(this.size_id)) {
        $item_unit = this.size_id.value ? this.size_id.value : this.size_id;
      }

      let $discount_type = "";
      if (!APIinterface.empty(this.discount_type)) {
        $discount_type = this.discount_type.value
          ? this.discount_type.value
          : this.discount_type;
      }

      APIinterface.fetchDataByToken("createItemPrice", {
        item_uuid: this.item_uuid,
        item_size_id: this.item_size_id,
        price: this.price,
        size_id: $item_unit,
        cost_price: this.cost_price,
        discount: this.discount,
        discount_type: $discount_type,
        discount_start: this.discount_start,
        discount_end: this.discount_end,
        sku: this.sku,
      })
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);

          this.$router.replace({
            path: "/item/pricelist",
            query: { item_uuid: this.item_uuid },
          });
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
