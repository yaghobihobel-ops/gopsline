<template>
  <template v-if="loading">
    <div class="flex flex-center full-width" style="height: calc(40vh)">
      <q-spinner color="primary" size="2em" />
    </div>
  </template>
  <q-list v-else>
    <transition
      v-for="items in data"
      :key="items.payment_code"
      appear
      leave-active-class="animated fadeOut"
    >
      <q-item
        @click="onchoosePayment(items)"
        clickable
        v-ripple
        class="border-grey radius10 q-mb-sm"
      >
        <q-item-section avatar>
          <template v-if="items.logo_type === 'icon'">
            <q-icon color="warning" name="credit_card" />
          </template>
          <template v-else>
            <q-img
              :src="items.logo_image"
              fit="contain"
              style="height: 35px; max-width: 35px"
            />
          </template>
        </q-item-section>
        <q-item-section>{{ items.payment_name }}</q-item-section>
      </q-item>
    </transition>
  </q-list>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "PaymentList",
  data() {
    return {
      loading: false,
      data: [],
      credentials: [],
    };
  },
  created() {
    this.PaymentMethod();
  },
  methods: {
    PaymentMethod() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("PaymentMethod")
        .then((data) => {
          this.data = data.details.data;
          this.credentials = data.details.credentials;
          this.$emit("setCredentials", this.credentials);
        })
        .catch((error) => {})
        .then((data) => {
          this.loading = false;
        });
    },
    onchoosePayment(data) {
      this.$emit("afterSelectpayment", data, this.credentials);
    },
  },
};
</script>
