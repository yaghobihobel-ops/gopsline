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
        $t("Payments")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-pull-to-refresh @refresh="refresh">
    <q-page class="q-pa-md" :class="{ 'flex flex-center': !has_data }">
      <SavedPaymentlist
        ref="saved_payment"
        @set-paymentuuid="setPaymentuuid"
        @after-getpayment="afterGetpayment"
        @set-loading="setLoading"
      ></SavedPaymentlist>

      <template v-if="!loading && !has_data">
        <div class="tex-center">
          <div class="text-h7 text-weight-bold">
            {{ $t("No Payment available") }}
          </div>
          <p class="text-grey font12">
            {{ $t("you have not added payment yet") }}
          </p>
        </div>
      </template>
      <q-footer
        class="q-pa-md"
        :class="{
          'bg-mydark ': $q.dark.mode,
          'bg-white ': !$q.dark.mode,
        }"
      >
        <q-btn
          color="primary"
          text-color="white"
          :label="$t('Add new payment')"
          unelevated
          class="full-width"
          size="lg"
          no-caps
          :loading="loading"
          to="/account/payment-add"
        />
      </q-footer>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
export default {
  name: "PaymentsList",
  data() {
    return {
      has_data: false,
      loading: false,
    };
  },
  components: {
    SavedPaymentlist: defineAsyncComponent(() =>
      import("components/SavedPaymentlist.vue")
    ),
  },
  methods: {
    refresh(done) {
      this.$refs.saved_payment.refreshList(done);
    },
    afterGetpayment(data) {
      this.has_data = data;
    },
    setLoading(data) {
      this.loading = data;
    },
  },
};
</script>
