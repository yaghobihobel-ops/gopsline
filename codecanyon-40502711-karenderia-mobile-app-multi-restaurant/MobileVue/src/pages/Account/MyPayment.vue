<template>
  <q-pull-to-refresh @refresh="refresh" color="primary" bg-color="white">
    <q-header
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
        'border-bottom': !isScrolled,
        'shadow-bottom': isScrolled,
      }"
    >
      <q-toolbar>
        <q-btn
          @click="$router.back()"
          flat
          round
          dense
          icon="eva-arrow-back-outline"
          :color="$q.dark.mode ? 'white' : 'dark'"
        />
        <q-toolbar-title class="text-subtitle2 text-weight-bold">{{
          $t("Payment")
        }}</q-toolbar-title>
      </q-toolbar>
    </q-header>
    <q-page>
      <q-scroll-observer @scroll="onScroll" />

      <template v-if="loading">
        <div class="absolute-center flex flex-center q-gutter-x-sm">
          <q-spinner-ios size="sm" />
          <div class="text-subtitle1 text-grey">{{ $t("Loading") }}...</div>
        </div>
      </template>
      <template v-else>
        <NoResults
          v-if="!getPayment"
          :message="$t('No saved payment methods')"
          :description="
            $t('Add a new payment method for faster and easier checkout.')
          "
        ></NoResults>
      </template>

      <template v-for="(items, index) in getPayment" :key="items">
        <div class="q-pt-md q-pl-md q-pr-md text-weight-bold text-subtitle1">
          {{ $t(index) }}
        </div>
        <q-list separator class="q-pl-md q-pr-md">
          <template v-for="item in items" :key="item">
            <q-item
              @click="setItem(item)"
              class="q-pl-none q-pr-none"
              clickable
              v-ripple:purple
            >
              <q-item-section side v-if="item.logo_url">
                <q-responsive style="width: 40px; height: 30px">
                  <q-img :src="item.logo_url" fit="scale-down" loading="lazy">
                    <template v-slot:loading>
                      <div class="text-primary">
                        <q-spinner-ios size="xs" />
                      </div>
                    </template>
                  </q-img>
                </q-responsive>
              </q-item-section>
              <q-item-section>
                <q-item-label class="text-weight-medium text-subtitle2">
                  {{ item.attr1 }}
                  <q-badge
                    v-if="item.as_default == 1"
                    color="mygrey2"
                    rounded
                    text-color="blue-grey-6"
                    label="default"
                  />
                </q-item-label>
                <q-item-label caption>{{ item.attr2 }}</q-item-label>
              </q-item-section>
              <q-item-section side>
                <q-icon :name="iconRight"></q-icon>
              </q-item-section>
            </q-item>
          </template>
        </q-list>
      </template>

      <q-footer class="bg-white shadow-1 text-dark q-pa-md">
        <q-btn
          no-caps
          unelevated
          color="disabled"
          text-color="disabled"
          size="lg"
          rounded
          class="fit"
          @click="this.$refs.ref_paymentmethod.modal = true"
        >
          <div class="text-subtitle2 text-weight-bold">
            {{ $t("Add new payment") }}
          </div>
        </q-btn>
      </q-footer>

      <PaymentMethod
        ref="ref_paymentmethod"
        merchant_id=""
        method="fetchPayment"
        :is_login="false"
        @after-addpayment="refetchPayment"
      ></PaymentMethod>

      <PaymentDetails
        ref="ref_paymentdetails"
        @after-updatepayment="refetchPayment"
        @after-delete="afterDelete"
      ></PaymentDetails>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useClientStore } from "stores/ClientStore";
import { useDataStorePersisted } from "stores/DataStorePersisted";

export default {
  name: "MyPayment",
  components: {
    PaymentMethod: defineAsyncComponent(() =>
      import("components/PaymentMethod.vue")
    ),
    PaymentDetails: defineAsyncComponent(() =>
      import("components/PaymentDetails.vue")
    ),
    NoResults: defineAsyncComponent(() => import("components/NoResults.vue")),
  },
  setup() {
    const ClientStore = useClientStore();
    const DataStorePersisted = useDataStorePersisted();
    return { ClientStore, DataStorePersisted };
  },
  data() {
    return {
      loading: false,
    };
  },
  mounted() {
    this.fetchPayment();
  },
  computed: {
    getPayment() {
      return this.ClientStore.payment_data;
    },
    iconRight() {
      return this.DataStorePersisted.rtl
        ? "eva-chevron-left-outline"
        : "eva-chevron-right-outline";
    },
  },
  methods: {
    setItem(value) {
      this.$refs.ref_paymentdetails.show(value);
    },
    refresh(done) {
      done();
      this.refetchPayment();
    },
    onScroll(info) {
      this.isScrolled = info.position.top > 140;
    },
    refetchPayment() {
      this.ClientStore.payment_data = null;
      this.fetchPayment();
    },
    afterDelete(value) {
      if (Object.keys(this.ClientStore.payment_data).length > 0) {
        Object.entries(this.ClientStore.payment_data).forEach(
          ([key, items]) => {
            if (this.ClientStore.payment_data[key]) {
              this.ClientStore.payment_data[key] =
                this.ClientStore.payment_data[key].filter(
                  (item) => item.payment_uuid !== value
                );
            }
          }
        );
      }
    },
    async fetchPayment() {
      try {
        this.loading = true;
        if (!this.ClientStore.payment_data) {
          await this.ClientStore.fetchPayment();
        }
      } catch (error) {
        this.ClientStore.payment_data = null;
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>
