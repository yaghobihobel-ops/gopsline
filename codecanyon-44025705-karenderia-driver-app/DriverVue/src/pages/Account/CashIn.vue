<template>
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
        $t("Cash In")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page class="q-pa-md">
    <div class="text-center">
      <div>{{ $t("Cash In Amount") }}</div>
      <div class="text-h5">
        <NumberFormat :amount="amount"></NumberFormat>
      </div>
    </div>

    <div class="font15 q-mt-md">{{ $t("Saved Payment Methods") }}</div>
    <SavedPaymentlist
      ref="saved_payment"
      @set-paymentuuid="setPaymentuuid"
    ></SavedPaymentlist>
    <template v-if="!has_data && !loading_paymentlist">
      <p class="text-grey font12">{{ $t("you have not added payment yet") }}</p>
    </template>

    <div class="font15 q-mt-md q-mb-sm">{{ $t("Add New Payment Method") }}</div>
    <PaymentList
      ref="payment"
      @after-selectpayment="afterSelectpayment"
      @set-credentials="setCredentials"
      @after-getpayment="afterGetpayment"
      @set-loading="setLoading"
    ></PaymentList>

    <q-footer class="transparent text-dark">
      <q-btn
        type="submit"
        class="fit"
        unelevated
        color="primary"
        :label="$t('Submit')"
        no-caps
        size="lg"
        :disable="!hasPayment"
        @click="onSubmit"
        :loading="loading"
      />
    </q-footer>
  </q-page>

  <StripeComponents
    ref="stripe"
    payment_code="stripe"
    :title="$t('Add Stripe')"
    :label="{
      submit: this.$t('Add Stripe'),
      notes: this.$t('Add your card account'),
    }"
    :payment_credentials="credentials"
    :reference="driver_id"
    @after-addpayment="afterAddpayment"
    @after-payment="afterPayment"
  />

  <PaypalComponents
    ref="paypal"
    payment_code="paypal"
    :title="$t('Add Paypal')"
    :label="{
      submit: this.$t('Add Paypal'),
      notes: this.$t('Pay using your paypal account'),
      payment_title: this.$t('Pay using Paypal'),
      payment_subtitle: this.$t(
        'You will re-direct to paypal account to login to your account.'
      ),
    }"
    :payment_credentials="credentials"
    :reference="driver_id"
    @after-addpayment="afterAddpayment"
    @after-payment="afterPayment"
  />
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import auth from "src/api/auth";

export default {
  name: "CashIn",
  components: {
    PaymentList: defineAsyncComponent(() =>
      import("components/PaymentList.vue")
    ),
    SavedPaymentlist: defineAsyncComponent(() =>
      import("components/SavedPaymentlist.vue")
    ),
    NumberFormat: defineAsyncComponent(() =>
      import("components/NumberFormat.vue")
    ),
    StripeComponents: defineAsyncComponent(() =>
      import("components/StripeComponents.vue")
    ),
    PaypalComponents: defineAsyncComponent(() =>
      import("components/PaypalComponents.vue")
    ),
  },
  data() {
    return {
      loading: false,
      amount: 0,
      data: [],
      credentials: [],
      driver_id: 0,
      payment_uuid: "",
      has_data: false,
      loading_paymentlist: false,
    };
  },
  created() {
    this.amount = this.$route.query.amount;
    let $data = auth.getUser();
    this.driver_id = $data.driver_id;
  },
  computed: {
    hasPayment() {
      if (!APIinterface.empty(this.payment_uuid)) {
        return true;
      }
      return false;
    },
  },
  methods: {
    setCredentials(credentials) {
      this.credentials = credentials;
    },
    afterSelectpayment(data, credentials) {
      try {
        this.$refs[data.payment_code].showPaymentForm();
      } catch (error) {
        APIinterface.notify("dark", error, "error_outline", this.$q);
      }
    },
    afterAddpayment() {
      console.log("afterAddpayment");
      this.$refs.saved_payment.getPaymentSaved();
    },
    setPaymentuuid(data) {
      this.payment_uuid = data;
    },
    onSubmit() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "getPaymentDetails",
        "payment_uuid=" + this.payment_uuid
      )
        .then((data) => {
          let $data = data.details;
          $data.amount = this.amount;
          this.$refs[data.details.payment_code].PaymentRender($data);
        })
        .catch((error) => {})
        .then((data) => {
          this.loading = false;
        });
    },
    afterPayment(data) {
      this.$router.push({
        path: "/account/cashin-successful",
        query: { id: data.transaction_id },
      });
    },
    afterGetpayment(data) {
      this.has_data = data;
    },
    setLoading(data) {
      this.loading_paymentlist = data;
    },
    //
  },
};
</script>
