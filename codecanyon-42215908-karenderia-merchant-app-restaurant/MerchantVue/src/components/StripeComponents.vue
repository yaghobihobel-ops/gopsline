<template>
  <q-dialog v-model="dialog" position="bottom" @show="whenShow">
    <q-card class="rounded-borders-top">
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <q-toolbar-title
          class="text-darkx text-weight-bold"
          style="overflow: inherit"
          :class="{
            'text-white': $q.dark.mode,
            'text-dark': !$q.dark.mode,
          }"
        >
          {{ $t("Enter your card details") }}
        </q-toolbar-title>
        <q-space></q-space>
        <q-btn
          @click="dialog = !true"
          color="white"
          square
          unelevated
          text-color="grey"
          icon="las la-times"
          dense
          no-caps
          size="sm"
          class="border-grey radius8"
        />
      </q-toolbar>

      <q-form @submit="Subscribe">
        <div class="q-pl-md q-pr-md q-mb-sm">
          <q-input
            v-model="full_name"
            :label="$t('Card name')"
            outlined
            stack-label
            color="grey-5"
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <div
            class="q-mb-lg q-pt-sm q-pa-md"
            :class="{
              'bg-mygrey text-dark': $q.dark.mode,
              'bg-white text-black': !$q.dark.mode,
            }"
          >
            <div ref="card_element" id="card-element"></div>
          </div>

          <!-- <ListLoading v-if="render_loading"></ListLoading> -->
          <template v-if="render_loading">
            <div class="flex flex-center text-center">
              <q-spinner color="primary" size="2em" />
            </div>
          </template>
          <q-btn
            v-else
            type="submit"
            color="primary"
            text-color="white"
            :label="$t('Subscribe')"
            unelevated
            class="full-width"
            size="lg"
            no-caps
            :loading="loading"
          />
        </div>
      </q-form>
    </q-card>
  </q-dialog>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { loadScript } from "vue-plugin-load-script";

export default {
  name: "StripeComponents",
  // components: {
  //   ListLoading: defineAsyncComponent(() => import("components/ListLoading.vue")),
  // },
  data() {
    return {
      loading: false,
      data: [],
      customer_id: "",
      client_secret: "",
      dialog: false,
      render_loading: true,
      publish_key: "",
      return_url: location.host,
      stripe: undefined,
      elements: undefined,
      cardElement: undefined,
      full_name: "",
    };
  },
  setup() {
    return {};
  },
  created() {},
  methods: {
    PaymentRender(data) {
      this.data = data;
      this.createAccount();
    },
    createAccount() {
      APIinterface.showLoadingBox(this.$t("Creating accont"), this.$q);
      APIinterface.PaymentPost("createMerchantAccount", this.data)
        .then((data) => {
          this.customer_id = data.details.customer_id;
          this.subscribeAccount();
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    subscribeAccount() {
      APIinterface.showLoadingBox(this.$t("Subscribing"), this.$q);
      APIinterface.PaymentPost("Stripeubscribeaccount", {
        customer_id: this.customer_id,
        merchant_uuid: this.data.merchant_uuid,
        payment_code: this.data.payment_code,
        package_uuid: this.data.package_uuid,
      })
        .then((data) => {
          this.client_secret = data.details.client_secret;
          this.publish_key = data.details.publish_key;
          this.return_url = data.details.origin + "/#/signup/validate-payment";
          this.dialog = true;
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    whenShow() {
      this.initStripe();
    },
    initStripe() {
      loadScript("https://js.stripe.com/v3/")
        .then(() => {
          this.renderCard();
        })
        .catch(() => {
          //console.debug("failed loading realtime script");
        });
    },
    renderCard() {
      console.log("renderCard");
      this.render_loading = true;
      this.stripe = Stripe(this.publish_key);
      this.elements = this.stripe.elements();

      let style = {};
      let card = this.elements.create("card", { style: style });
      this.cardElement = card;
      setTimeout(() => {
        card.mount(this.$refs.card_element);
      }, 100);
      setTimeout(() => {
        this.render_loading = false;
      }, 500);
    },
    Subscribe() {
      this.loading = true;
      var elements = this.elements;
      console.log(this.client_secret);
      this.stripe
        .confirmCardPayment(this.client_secret, {
          payment_method: {
            card: this.cardElement,
            billing_details: {
              name: this.full_name,
            },
          },
        })
        .then((result) => {
          this.loading = false;
          console.log(result);
          if (result.error) {
            APIinterface.notify("dark", result.error.message, "error", this.$q);
          } else {
            this.validatePayment(result.paymentIntent.id);
          }
        });
    },
    validatePayment(payment_intent) {
      APIinterface.showLoadingBox(this.$t("Validating payment"), this.$q);
      APIinterface.PaymentPost("Stripevalidatepayment", {
        payment_intent: payment_intent,
        merchant_uuid: this.data.merchant_uuid,
        payment_code: this.data.payment_code,
        package_uuid: this.data.package_uuid,
      })
        .then((data) => {
          let $status = data.details.status;
          let $message = data.details.message;
          if ($status == "succeeded") {
            this.$router.push("/signup/thankyou");
          } else if ($status == "processing") {
            this.$router.push("/signup/payment-processing");
          } else if ($status == "requires_payment_method") {
            APIinterface.notify("dark", $message, "error", this.$q);
          }
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
  },
};
</script>
