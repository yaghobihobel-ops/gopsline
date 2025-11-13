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
        $t("Add payment")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page class="q-pa-md">
    <PaymentList
      ref="payment"
      @after-selectpayment="afterSelectpayment"
      @set-credentials="setCredentials"
    ></PaymentList>
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
  name: "PaymentAdd",
  components: {
    PaymentList: defineAsyncComponent(() =>
      import("components/PaymentList.vue")
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
      credentials: [],
      driver_id: 0,
    };
  },
  created() {
    let $data = auth.getUser();
    this.driver_id = $data.driver_id;
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
      this.$router.replace("/account/payments");
    },
  },
};
</script>
