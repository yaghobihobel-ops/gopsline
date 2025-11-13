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
          <template v-if="isEdit"> {{ $t("Edit Item Promo") }} </template>
          <template v-else> {{ $t("Add Item Promo") }} </template>
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
          <q-select
            outlined
            v-model="promo_type"
            :label="$t('Promo Type')"
            color="grey-5"
            stack-label
            behavior="dialog"
            transition-show="fade"
            transition-hide="fade"
            :options="DataStore.promo_type"
            :loading="DataStore.loading"
            map-options
            emit-value
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />
          <q-input
            outlined
            v-model="buy_qty"
            :label="$t('Buy(qty)')"
            stack-label
            color="grey-5"
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <q-input
            outlined
            v-model="get_qty"
            :label="$t('Get (qty)')"
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
            v-model="item_id_promo"
            :label="$t('Select Item')"
            color="grey-5"
            stack-label
            behavior="dialog"
            transition-show="fade"
            transition-hide="fade"
            emit-value
            map-options
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
            :options="DataStore.item_list"
            :loading="DataStore.loading"
            @virtual-scroll="onScroll"
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
            :label="$t('Discount End')"
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

          <!-- /// -->
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
import { useDataStore } from "stores/DataStore";
import { nextTick } from "vue";

export default {
  name: "ItemPromotionCreate",
  data() {
    return {
      dialog_price: false,
      item_uuid: "",
      promo_id: "",
      loading: false,
      loading_get: false,
      promo_type: "",
      buy_qty: 0,
      get_qty: 0,
      item_id_promo: "",
      discount_start: "",
      discount_end: "",
      page: 0,
    };
  },
  setup(props) {
    const MenuStore = useMenuStore();
    const DataStore = useDataStore();
    return { MenuStore, DataStore };
  },
  created() {
    this.DataStore.item_list = [];
    this.DataStore.getItemList(this.page);
    this.item_uuid = this.$route.query.item_uuid;
    this.promo_id = this.$route.query.promo_id;
    if (this.promo_id > 0) {
      this.getPromotion();
    }
  },
  computed: {
    isEdit() {
      if (this.promo_id > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    refresh(done) {
      this.page = 0;
      this.DataStore.getItemList(this.page);
      if (this.promo_id > 0) {
        this.getPromotion(done);
      } else {
        done();
      }
    },
    getPromotion(done) {
      this.loading_get = true;
      APIinterface.fetchDataByTokenPost(
        "getPromotion",
        "promo_id=" + this.promo_id
      )
        .then((data) => {
          this.promo_type = data.details.promo_type;
          this.buy_qty = data.details.buy_qty;
          this.get_qty = data.details.get_qty;
          this.item_id_promo = data.details.item_id_promo;
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
    onScroll(to, ref) {
      this.page++;
      if (this.DataStore.total_item > this.page) {
        this.DataStore.getItemList(this.page, ref);
      } else {
      }
    },
    onSubmit() {
      this.loading = true;
      let $item_unit = "";
      APIinterface.fetchDataByToken("createPromotion", {
        promo_id: this.promo_id,
        item_uuid: this.item_uuid,
        promo_id: this.promo_id,
        promo_type: this.promo_type,
        buy_qty: this.buy_qty,
        get_qty: this.get_qty,
        item_id_promo: this.item_id_promo,
        discount_start: this.discount_start,
        discount_end: this.discount_end,
      })
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);

          this.$router.replace({
            path: "/item/promotionlist",
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
