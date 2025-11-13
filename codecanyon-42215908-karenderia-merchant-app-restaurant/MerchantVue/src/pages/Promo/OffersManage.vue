<template>
  <q-page class="q-pa-md">
    <template v-if="loading">
      <div
        class="row q-gutter-x-sm justify-center q-my-md absolute-center text-center full-width"
      >
        <q-circular-progress indeterminate rounded size="sm" color="primary" />
        <div class="text-subtitle1 text-grey">{{ $t("Loading") }}...</div>
      </div>
    </template>
    <q-form v-else @submit="formSubmit" class="q-gutter-y-md">
      <q-input
        v-model="offer_name"
        :label="$t('Offer name')"
        stack-label
        outlined
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
        hide-bottom-space
      />

      <q-input
        v-model="offer_percentage"
        :label="$t('Offer Percentage')"
        type="number"
        step="any"
        stack-label
        outlined
        :rules="[
          (val) => (val && val > 0) || this.$t('This field is required'),
        ]"
        hide-bottom-space
      />

      <q-input
        v-model="offer_price"
        :label="$t('Orders Over')"
        type="number"
        step="any"
        stack-label
        outlined
        :rules="[
          (val) => (val && val > 0) || this.$t('This field is required'),
        ]"
        hide-bottom-space
      />

      <q-input
        v-model="min_order"
        :label="$t('Minimum Order')"
        type="number"
        step="any"
        stack-label
        outlined
      />

      <q-input
        v-model="max_discount_cap"
        :label="$t('Maximum Discount Cap')"
        type="number"
        step="any"
        stack-label
        outlined
      />

      <q-input
        v-model="valid_from"
        mask="date"
        :rules="['date']"
        stack-label
        outlined
        :label="$t('Expiration')"
        hide-bottom-space
      >
        <q-popup-proxy
          cover
          transition-show="scale"
          transition-hide="scale"
          ref="datePopup"
        >
          <q-date
            v-model="valid_from"
            color="disabled"
            text-color="dark"
            @update:model-value="() => $refs.datePopup.hide()"
          >
            <div class="row items-center justify-end">
              <q-btn
                v-close-popup
                :label="$t('Close')"
                color="dark"
                flat
                no-caps
              />
            </div>
          </q-date>
        </q-popup-proxy>
      </q-input>

      <q-input
        v-model="valid_to"
        mask="date"
        :rules="['date']"
        stack-label
        outlined
        :label="$t('Expiration')"
        hide-bottom-space
      >
        <q-popup-proxy
          cover
          transition-show="scale"
          transition-hide="scale"
          ref="datePopup"
        >
          <q-date
            v-model="valid_to"
            color="disabled"
            text-color="dark"
            @update:model-value="() => $refs.datePopup.hide()"
          >
            <div class="row items-center justify-end">
              <q-btn
                v-close-popup
                :label="$t('Close')"
                color="dark"
                flat
                no-caps
              />
            </div>
          </q-date>
        </q-popup-proxy>
      </q-input>

      <q-select
        v-model="applicable_selected"
        :options="DriverStore.getPromoAttributes?.services"
        :label="$t('Applicable to')"
        stack-label
        behavior="menu"
        outlined
        emit-value
        map-options
        multiple
      />

      <q-select
        v-model="status"
        :options="DataStore.status_list"
        :label="$t('Status')"
        stack-label
        behavior="menu"
        outlined
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
        emit-value
        map-options
      />

      <q-footer class="q-pa-md bg-white myshadow">
        <q-btn
          type="submit"
          color="amber-6"
          text-color="disabled"
          unelevated
          class="full-width radius8"
          size="lg"
          no-caps
          :loading="loading1"
        >
          <div class="text-weight-bold text-subtitle2">{{ $t("Save") }}</div>
        </q-btn>
      </q-footer>
    </q-form>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import { useDriverStore } from "stores/DriverStore";
import { useCartStore } from "stores/CartStore";

export default {
  name: "OffersManage",
  data() {
    return {
      id: "",
      data: [],
      loading: false,
      loading1: false,
      status: "publish",
      offer_name: null,
      offer_percentage: 0,
      offer_price: 0,
      valid_from: "",
      valid_to: "",
      applicable_selected: [],
      min_order: null,
      max_discount_cap: null,
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    const DriverStore = useDriverStore();
    const CartStore = useCartStore();
    return { DataStore, DriverStore, CartStore };
  },
  mounted() {
    this.DriverStore.PromoAttributes();
    this.id = this.$route.query.id;

    this.DataStore.page_title = this.id
      ? this.$t("Update Offers")
      : this.$t("Add Offers");

    if (!APIinterface.empty(this.id)) {
      this.getData();
    }
  },
  computed: {
    isEdit() {
      if (!APIinterface.empty(this.id)) {
        return true;
      }
      return false;
    },
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
    CheckData() {
      if (!APIinterface.empty(this.id)) {
        if (Object.keys(this.data).length <= 0) {
          return true;
        }
      }
      return false;
    },
  },
  methods: {
    getData() {
      this.loading = true;

      APIinterface.fetchDataByTokenPost("getOffers", "id=" + this.id)
        .then((data) => {
          this.data = data.details;
          this.offer_name = this.data.offer_name;
          this.offer_percentage = data.details.offer_percentage;
          this.offer_price = data.details.offer_price;
          this.min_order = data.details.min_order;
          this.max_discount_cap = data.details.max_discount_cap;
          this.valid_from = data.details.valid_from;
          this.valid_to = data.details.valid_to;
          this.applicable_selected = data.details.applicable_to;
          this.status = data.details.status;
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    afterInput(data) {
      this.phone = data;
    },
    formSubmit() {
      let params = {
        id: this.id,
        offer_name: this.offer_name,
        offer_percentage: this.offer_percentage,
        offer_price: this.offer_price,
        min_order: this.min_order,
        max_discount_cap: this.max_discount_cap,
        valid_from: this.valid_from,
        valid_to: this.valid_to,
        applicable_selected: this.applicable_selected,
        status: this.status,
      };
      this.loading1 = true;
      APIinterface.fetchDataByTokenPost(
        !APIinterface.empty(this.id) ? "UpdateOffers" : "AddOffers",
        params
      )
        .then((data) => {
          APIinterface.ShowSuccessful(data.msg, this.$q);
          this.DataStore.cleanData("offer_list");
          this.$router.replace({
            path: "/promo/offers-list",
          });
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading1 = false;
        });
    },
    //
  },
};
</script>
