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
        $t("Select Payment")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page :class="{ 'flex flex-center': loading_get }">
    <div v-if="loading_get">
      <div class="flex flex-center full-width">
        <q-spinner color="primary" size="2em" />
      </div>
    </div>

    <q-form v-else @submit="onSubmit">
      <q-list separator>
        <template v-for="items in payment_list" :key="items">
          <q-item tag="label" v-ripple>
            <q-item-section side>
              <q-radio v-model="payment_code" :val="items.payment_code" />
            </q-item-section>

            <template v-if="items.logo_type == 'image'">
              <q-item-section avatar>
                <q-avatar>
                  <q-img :src="items.logo_image"></q-img>
                </q-avatar>
              </q-item-section>
            </template>
            <template v-else>
              <q-item-section>
                {{ items.payment_name }}
              </q-item-section>
            </template>
          </q-item>
        </template>
      </q-list>
      <div class="border-grey-top"></div>

      <q-footer class="transparent q-pa-md">
        <q-btn
          type="submit"
          color="primary"
          text-color="white"
          :label="$t('Continue')"
          unelevated
          class="full-width"
          size="lg"
          no-caps
          :disable="hasSelectedPayment"
        />
      </q-footer>
    </q-form>
  </q-page>

  <StripeComponents
    ref="stripe"
    payment_code="stripe"
    @after-payment="afterPayment"
  />
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";

export default {
  name: "ChoosePayment",
  components: {
    StripeComponents: defineAsyncComponent(() =>
      import("components/StripeComponents.vue")
    ),
  },
  data() {
    return {
      merchant_uuid: "",
      loading_get: false,
      loading: false,
      payment_list: [],
      payment_code: "",
      package_uuid: "",
    };
  },
  created() {
    this.merchant_uuid = this.$route.query.uuid;
    this.package_uuid = this.$route.query.package_uuid;
    if (!APIinterface.empty(this.merchant_uuid)) {
      this.getMerchant();
    }
    this.PaymenPlanList();
  },
  computed: {
    hasSelectedPayment() {
      if (!APIinterface.empty(this.payment_code)) {
        return false;
      }
      return true;
    },
  },
  methods: {
    getMerchant() {
      APIinterface.fetchDataPost(
        "getMerchant",
        "merchant_uuid=" + this.merchant_uuid
      )
        .then((data) => {
          //
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {});
    },
    PaymenPlanList() {
      this.loading_get = true;
      APIinterface.fetchDataPost("PaymenPlanList")
        .then((data) => {
          this.payment_list = data.details;
        })
        .catch((error) => {
          this.payment_list = [];
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading_get = false;
        });
    },
    onSubmit() {
      try {
        let $data = {
          merchant_uuid: this.merchant_uuid,
          payment_code: this.payment_code,
          package_uuid: this.package_uuid,
        };
        this.$refs[this.payment_code].PaymentRender($data);
      } catch (error) {
        APIinterface.notify(
          "dark",
          "This payment method is not available in plans",
          "error",
          this.$q
        );
      }
    },
  },
};
</script>
