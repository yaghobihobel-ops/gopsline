<template>
  <q-dialog
    v-model="modal"
    transition-show="slide-up"
    transition-hide="slide-down"
    transition-duration="500"
    @before-show="onBeforeShow"
    maximized
    persistent
  >
    <q-card>
      <q-toolbar class="text-dark">
        <q-btn
          flat
          dense
          icon="close"
          v-close-popup
          :color="$q.dark.mode ? 'primary' : 'grey'"
        />
        <q-toolbar-title>
          <div class="text-subtitle1 text-weight-bold">
            {{ $t("Load Wallet") }}
          </div>
        </q-toolbar-title>
      </q-toolbar>
      <q-card-section>
        <q-input
          v-model="amount"
          borderless
          class="bg-mygrey1 radius28 q-pl-md"
          type="number"
          :placeholder="$t('Amount')"
        >
          <template v-slot:prepend>
            <div class="text-subtitle1">
              {{ currency_symbol }}
            </div>
          </template>
        </q-input>

        <div class="q-card myshadow-1 q-mt-md">
          <q-list class="myqlist">
            <q-item-label header class="text-weight-bold text-subtitle2">
              <div class="flex items-center justify-between">
                <div>{{ $t("Payment details") }}</div>
                <div>
                  <q-btn
                    :label="$t('Change')"
                    no-caps
                    unelevated
                    flat
                    color="blue"
                    padding="0"
                    class="text-weight-medium"
                    @click="this.$refs.ref_paymentmethod.modal = true"
                  ></q-btn>
                </div>
              </div>
            </q-item-label>

            <q-separator></q-separator>

            <template v-if="loading_payment">
              <q-item tag="label">
                <q-item-section>
                  <q-spinner-ios size="sm" />
                </q-item-section>
              </q-item>
            </template>
            <template v-else>
              <template v-for="items in getSavedpaymentlist" :key="items">
                <q-item clickable v-ripple:purple tag="label">
                  <q-item-section avatar>
                    <q-radio
                      v-model="payment_uuid"
                      :val="items.payment_uuid"
                      unchecked-icon="panorama_fish_eye"
                    />
                  </q-item-section>
                  <q-item-section>
                    <q-item-label>
                      <template v-if="items.payment_code == 'paydelivery'">
                        <div class="text-weight-medium text-subtitle2">
                          {{ items.attr2 }}
                        </div>
                        <div class="text-caption text-grey">
                          {{ items.payment_name }}
                        </div>
                      </template>
                      <template v-else>
                        <div class="text-weight-medium text-subtitle2">
                          {{ items.payment_name }}
                        </div>
                        <div class="text-caption text-grey">
                          {{ items.attr2 }}
                        </div>
                      </template>
                    </q-item-label>
                  </q-item-section>
                  <q-item-section side v-if="items.logo_image">
                    <q-responsive style="width: 40px; height: 30px">
                      <q-img
                        :src="items.logo_image"
                        fit="scale-down"
                        spinner-size="xs"
                        spinner-color="primary"
                        loading="lazy"
                      />
                    </q-responsive>
                  </q-item-section>
                </q-item>
              </template>
            </template>
          </q-list>
        </div>
        <div
          class="fixed-bottom q-pa-sm border-grey-top1 shadow-1 row q-gutter-x-sm items-center"
          :class="{
            'bg-dark': $q.dark.mode,
            'bg-white': !$q.dark.mode,
          }"
        >
          <q-btn
            class="col"
            no-caps
            unelevated
            color="mygrey"
            text-color="dark"
            size="lg"
            rounded
            :disable="loading"
            @click="modal = false"
          >
            <div class="text-subtitle2 text-weight-bold">
              {{ $t("Cancel") }}
            </div>
          </q-btn>
          <q-btn
            :disable="!isCanAdd"
            class="col"
            no-caps
            unelevated
            :color="!isCanAdd ? 'disabled' : 'secondary'"
            :text-color="!isCanAdd ? 'disabled' : 'white'"
            size="lg"
            rounded
            :loading="loading"
            @click="onSubmit"
          >
            <div class="text-subtitle2 text-weight-bold">
              {{ $t("Add") }}
            </div>
          </q-btn>
        </div>
      </q-card-section>
    </q-card>
  </q-dialog>

  <PaymentMethod
    ref="ref_paymentmethod"
    merchant_id=""
    method="fetchPayment"
    :is_login="false"
    @after-addpayment="onAfterAddpayment"
  ></PaymentMethod>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useClientStore } from "stores/ClientStore";
import { defineAsyncComponent } from "vue";

export default {
  name: "AddFunds",
  props: ["currency_code", "currency_symbol"],
  components: {
    PaymentMethod: defineAsyncComponent(() =>
      import("components/PaymentMethod.vue")
    ),
  },
  setup() {
    const ClientStore = useClientStore();
    return { ClientStore };
  },
  data() {
    return {
      modal: false,
      amount: 1,
      loading_payment: false,
      loading: false,
      payment_uuid: null,
    };
  },
  computed: {
    getPayment() {
      return this.ClientStore.default_payment;
    },
    defaultPayment() {
      return this.ClientStore?.saved_payment_list?.default_payment_uuid || null;
    },
    getSavedpaymentlist() {
      return this.ClientStore?.saved_payment_list?.data || null;
    },
    isWeb() {
      if (this.$q.platform.is.pwa) {
        return true;
      } else if (process.env.MODE === "spa") {
        return true;
      } else if (this.$q.platform.is.browser) {
        return true;
      }
      return false;
    },
    isCanAdd() {
      if (this.amount && this.payment_uuid) {
        return true;
      }
      return false;
    },
  },
  methods: {
    onBeforeShow() {
      this.loading = false;
      this.amount = 0;
      if (!this.ClientStore.saved_payment_list) {
        this.getDefaultpayment();
      } else {
        this.payment_uuid =
          this.ClientStore?.saved_payment_list?.default_payment_uuid || null;
      }
    },
    async getDefaultpayment() {
      try {
        this.loading_payment = true;
        const results = await this.ClientStore.getMypayments({
          exclude: "offline_payment",
        });
        console.log("results", results.default_payment_uuid);
        this.payment_uuid = results.default_payment_uuid;
      } catch (error) {
      } finally {
        this.loading_payment = false;
      }
    },
    onAfterAddpayment() {
      this.getDefaultpayment();
    },
    onSubmit() {
      this.loading = true;
      const baseURL =
        process.env.VUE_ROUTER_MODE === "history"
          ? window.location.origin + "/"
          : window.location.origin + "/#/";

      const params = {
        return_url: this.isWeb ? baseURL : null,
        amount: this.amount,
        payment_code: this.getPayment?.payment_code || "",
        payment_uuid: this.payment_uuid || "",
        currency_code: this.currency_code,
      };
      const parameters = new URLSearchParams(params).toString();
      APIinterface.fetchDataByTokenPost("prepareAddFunds", parameters)
        .then((data) => {
          // setTimeout(() => {
          //   this.loading = true;
          // }, 100);
          this.$emit("afterPreparepayment", data.details);
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
