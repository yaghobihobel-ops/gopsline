<template>
  <div>
    <q-btn
      @click="pay"
      :loading="loading"
      unelevated
      color="primary"
      text-color="white"
      class="full-width"
      :label="$t('Pay with Zarinpal')"
    />
  </div>
</template>

<script>
export default {
  name: "ZarinpalComponents",
  props: ["payment_code", "order_uuid"],
  data() {
    return {
      loading: false,
    };
  },
  methods: {
    pay() {
      this.loading = true;
      window.location.href = `YOUR_BACKEND_URL/zarinpal/request?order_uuid=${this.order_uuid}`;
    },
  },
};
</script>
