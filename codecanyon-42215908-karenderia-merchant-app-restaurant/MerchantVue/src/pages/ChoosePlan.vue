<template>
  <q-header
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
  >
    <q-toolbar>
      <q-toolbar-title class="text-weight-bold">{{
        $t("Subscription Plans")
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
        <template v-for="items in data" :key="items">
          <q-item tag="label" v-ripple>
            <q-item-section avatar>
              <q-radio v-model="package_id" :val="items.package_uuid" />
            </q-item-section>
            <q-item-section>
              <q-item-label>{{ items.title }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-item-label caption
                >{{ items.price }} / {{ items.package_period }}</q-item-label
              >
            </q-item-section>
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
          :disable="hasPackage"
        />
      </q-footer>
    </q-form>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "ChoosePlan",
  data() {
    return {
      loading: false,
      loading_get: false,
      data: [],
      plan_details: [],
      package_id: "",
    };
  },
  created() {
    this.merchant_uuid = this.$route.query.uuid;
    if (!APIinterface.empty(this.merchant_uuid)) {
      this.getMerchant();
    }
  },
  computed: {
    hasPackage() {
      if (!APIinterface.empty(this.package_id)) {
        return false;
      }
      return true;
    },
  },
  methods: {
    getMerchant() {
      this.loading_get = true;
      APIinterface.fetchDataPost(
        "getPlan",
        "merchant_uuid=" + this.merchant_uuid
      )
        .then((data) => {
          this.data = data.details.data;
          this.plan_details = data.details.plan_details;
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
          this.$router.push("/signup");
        })
        .then((data) => {
          this.loading_get = false;
        });
    },
    onSubmit() {
      this.$router.push({
        path: "/signup/choose-payment",
        query: {
          package_uuid: this.package_id,
          uuid: this.merchant_uuid,
        },
      });
    },
  },
};
</script>
