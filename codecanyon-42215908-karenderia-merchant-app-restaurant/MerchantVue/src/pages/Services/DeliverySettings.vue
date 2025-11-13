<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page class="q-pa-md">
      <template v-if="loading">
        <div
          class="row q-gutter-x-sm justify-center absolute-center text-center full-width"
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
      <template v-else>
        <q-form @submit="onSubmit">
          <q-toggle
            v-model="merchant_opt_contact_delivery"
            :label="$t('Enabled Opt in for no contact delivery')"
            color="primary"
          />
          <q-toggle
            v-model="free_delivery_on_first_order"
            :label="$t('Free Delivery On First Order')"
            color="primary"
          />
          <q-space class="q-pa-sm"></q-space>

          <div class="q-gutter-y-md">
            <q-select
              v-model="merchant_delivery_charges_type"
              :label="$t('Charge type')"
              :options="charge_type_list"
              stack-label
              behavior="menu"
              outlined
              emit-value
              map-options
              :rules="[
                (val) =>
                  (val && val.length > 0) || this.$t('This field is required'),
              ]"
              hide-bottom-space
            />

            <template v-if="user_data.merchant_type == 1">
              <q-input
                v-model="merchant_service_fee"
                type="number"
                step="any"
                :label="$t('Service Fee')"
                stack-label
                outlined
              />

              <q-select
                v-model="merchant_charge_type"
                :label="$t('Small order fee charge type')"
                :options="small_order_charge_type"
                stack-label
                behavior="dialog"
                outlined
                emit-value
                map-options
              />

              <q-input
                v-model="merchant_small_order_fee"
                type="number"
                step="any"
                :label="$t('Small order fee')"
                stack-label
                outlined
              />
              <q-input
                v-model="merchant_small_less_order_based"
                type="number"
                step="any"
                :label="$t('Less than subtotal')"
                stack-label
                outlined
              />
            </template>

            <q-input
              v-model="distance_price"
              type="number"
              step="any"
              :label="$t('Price')"
              stack-label
              outlined
              color="grey-5"
              :rules="[(val) => val > 0 || this.$t('This field is required')]"
              hide-bottom-space
            />

            <q-input
              v-model="estimation"
              :label="$t('Delivery estimation')"
              stack-label
              outlined
              color="grey-5"
              :rules="[
                (val) => val.length > 0 || this.$t('This field is required'),
              ]"
              mask="##-##"
              :hint="$t('in minutes example 10-20mins')"
              hide-bottom-space
            />

            <q-input
              v-model="minimum_order"
              type="number"
              step="any"
              :label="$t('Minimum Order')"
              stack-label
              outlined
              color="grey-5"
            />

            <q-input
              v-model="maximum_order"
              type="number"
              step="any"
              :label="$t('Maximum Order')"
              stack-label
              outlined
              color="grey-5"
            />
          </div>

          <q-space class="q-pa-sm"></q-space>

          <div class="flex justify-between items-center">
            <div class="text-body1 text-weight-bold">
              {{ $t("Delivery Charges Rates") }}
            </div>
            <div>
              <q-btn
                fab
                icon="add"
                color="amber-6"
                unelevated
                class="myshadow"
                padding="5px"
                to="/rates/create-rate"
              />
            </div>
          </div>

          <q-space class="q-pa-sm"></q-space>

          <q-virtual-scroll
            class="fit"
            separator
            :items="dataRates"
            :virtual-scroll-item-size="60"
            v-slot="{ item: items }"
          >
            <q-card flat class="box-shadow0 bg-white q-mb-md">
              <q-item>
                <q-item-section>
                  <q-item-label class="text-capitalize"
                    >{{ items.shipping_type }} -
                    {{ items.distance_price }}</q-item-label
                  >
                  <q-item-label caption> {{ items.distance }}</q-item-label>
                  <q-item-label caption> {{ items.estimation }}</q-item-label>

                  <q-item-label caption> {{ items.last_update }}</q-item-label>
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
                        path: '/rates/update-rate',
                        query: { id: items.id },
                      }"
                    ></q-btn>

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
                  </div>
                </q-item-section>
              </q-item>
            </q-card>
          </q-virtual-scroll>

          <q-infinite-scroll
            ref="nscroll"
            @load="fetchRates"
            :offset="250"
            :disable="scroll_disabled"
          >
            <template v-slot:default>
              <NoData v-if="!hasItems && !loading1" :isCenter="false" />
            </template>
            <template v-slot:loading>
              <LoadingData :page="2"></LoadingData>
            </template>
          </q-infinite-scroll>

          <q-space class="q-pa-md"></q-space>

          <q-footer class="q-pa-md bg-white myshadow">
            <q-btn
              type="submit"
              color="amber-6"
              text-color="disabled"
              unelevated
              class="full-width radius10"
              size="lg"
              no-caps
              :loading="loading_submit"
            >
              <div class="text-weight-bold text-subtitle2">
                {{ $t("Save") }}
              </div>
            </q-btn>
          </q-footer>
        </q-form>
      </template>

      <DeleteComponents ref="ref_delete" @after-confirm="afterConfirm">
      </DeleteComponents>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import auth from "src/api/auth";
import { useDataStore } from "src/stores/DataStore";
import { defineAsyncComponent } from "vue";

export default {
  name: "DeliverySettings",
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
      loading: false,
      loading_submit: false,
      merchant_opt_contact_delivery: false,
      free_delivery_on_first_order: false,
      merchant_delivery_charges_type: "fixed",
      distance_price: 0,
      estimation: 0,
      minimum_order: 0,
      maximum_order: 0,
      charge_type_list: [
        {
          value: "fixed",
          label: this.$t("Fixed"),
        },
        {
          value: "dynamic",
          label: this.$t("Dynamic Rates"),
        },
      ],
      data: [],
      user_data: [],
      merchant_charge_type: "fixed",
      merchant_service_fee: "",
      merchant_small_order_fee: "",
      merchant_small_less_order_based: "",
      small_order_charge_type: [
        {
          value: "fixed",
          label: this.$t("Fixed"),
        },
        {
          value: "percentage",
          label: this.$t("Percentage"),
        },
      ],
      scroll_disabled: true,
      hasMore: true,
      loading1: false,
      page: 1,
      dataRates: [],
      id: null,
    };
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  mounted() {
    this.DataStore.page_title = this.$t("Delivery");
    this.user_data = auth.getUser();

    if (this.DataStore.dataList?.delivery_settings) {
      this.data = this.DataStore.dataList?.delivery_settings?.data;
      this.dataRates = this.DataStore.dataList?.delivery_settings?.dataRates;
      this.page = this.DataStore.dataList?.delivery_settings?.page;
      this.hasMore = this.DataStore.dataList?.delivery_settings?.hasMore;
      this.setData();
    } else {
      this.getDeliverySettings();

      setTimeout(() => {
        this.$refs.nscroll?.trigger();
      }, 200);
    }

    this.scroll_disabled = false;
  },
  beforeUnmount() {
    this.DataStore.dataList.delivery_settings = {
      data: this.data,
      dataRates: this.dataRates,
      page: this.page,
      hasMore: this.hasMore,
    };
  },
  computed: {
    hasItems() {
      if (!this.dataRates) {
        return false;
      }
      return this.dataRates.length > 0;
    },
  },
  methods: {
    getDeliverySettings() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getDeliverySettings")
        .then((data) => {
          this.data = data.details;
          this.setData();
        })
        .catch((error) => {})
        .then((data) => {
          this.loading = false;
        });
    },
    setData() {
      this.merchant_opt_contact_delivery =
        this.data.merchant_opt_contact_delivery;
      this.free_delivery_on_first_order =
        this.data.free_delivery_on_first_order;

      this.merchant_delivery_charges_type =
        this.data.merchant_delivery_charges_type;

      this.distance_price = this.data.distance_price;
      this.estimation = this.data.estimation;
      this.minimum_order = this.data.minimum_order;
      this.maximum_order = this.data.maximum_order;

      this.merchant_charge_type = this.data.merchant_charge_type;
      this.merchant_service_fee = this.data.merchant_service_fee;
      this.merchant_small_order_fee = this.data.merchant_small_order_fee;
      this.merchant_small_less_order_based =
        this.data.merchant_small_less_order_based;
    },
    onSubmit() {
      this.loading_submit = true;
      APIinterface.fetchDataByTokenPost("SaveDeliverySettings", {
        merchant_opt_contact_delivery: this.merchant_opt_contact_delivery,
        free_delivery_on_first_order: this.free_delivery_on_first_order,
        merchant_delivery_charges_type: this.merchant_delivery_charges_type,
        distance_price: this.distance_price,
        estimation: this.estimation,
        minimum_order: this.minimum_order,
        maximum_order: this.maximum_order,
        merchant_charge_type: this.merchant_charge_type,
        merchant_service_fee: this.merchant_service_fee,
        merchant_small_order_fee: this.merchant_small_order_fee,
        merchant_small_less_order_based: this.merchant_small_less_order_based,
      })
        .then((data) => {
          APIinterface.ShowSuccessful(data.msg, this.$q);
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading_submit = false;
        });
    },
    async fetchRates(index, done) {
      try {
        if (this.loading1) {
          return;
        }

        if (!this.hasMore) {
          this.scroll_disabled = true;
          done(true);
          return;
        }
        this.loading1 = true;
        const params = new URLSearchParams({
          page: this.page,
        }).toString();

        const response = await APIinterface.fetchGet(
          `ShippingRateList?${params}`
        );
        this.page++;
        this.dataRates = [...this.dataRates, ...response.details.data];

        if (response.details?.is_last_page) {
          this.hasMore = false;
          this.scroll_disabled = true;
          done(true);
          return;
        }
        done();
      } catch (error) {
        this.dataRates = null;
        done(true);
      } finally {
        this.loading1 = false;
      }
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
        await APIinterface.fetchDataByTokenPost("deleteShippingRate", params);
        this.dataRates = this.dataRates.filter((item) => item.id !== this.id);
        this.id = null;
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
    refresh(done) {
      setTimeout(() => {
        done();
      }, 100);
      this.getDeliverySettings();
      this.resetPagination();
    },
    resetPagination() {
      this.page = 1;
      this.dataRates = [];
      this.hasMore = true;
      this.scroll_disabled = false;
      this.$nextTick(() => {
        this.$refs.nscroll?.resume?.();
        this.$refs.nscroll?.trigger?.();
      });
    },
  },
};
</script>
