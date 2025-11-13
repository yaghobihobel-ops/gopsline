<template>
  <q-page
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-grey-1 text-dark': !$q.dark.mode,
    }"
    class="q-pr-md q-pl-md"
  >
    <div class="q-mt-md q-mb-md">
      <TabsRouterMenu :tab_menu="GlobalStore.merchantMenu"></TabsRouterMenu>
    </div>

    <template v-if="loading">
      <q-inner-loading :showing="true" color="primary" size="md" />
    </template>
    <q-card class="q-pa-none no-shadow" v-else>
      <q-card-section>
        <q-form @submit="onSubmit">
          <q-input
            v-model="first_name"
            :label="$t('First name')"
            stack-label
            outlined
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <q-input
            v-model="last_name"
            :label="$t('Last name')"
            stack-label
            outlined
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <q-input
            v-model="contact_email"
            :label="$t('Email address')"
            stack-label
            outlined
            :rules="[
              (val, rules) =>
                rules.email(val) ||
                this.$t('Please enter a valid email address'),
            ]"
          />

          <q-input
            v-model="contact_number"
            :label="$t('Contact number')"
            stack-label
            outlined
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <q-input
            v-model="username"
            :label="$t('Username')"
            stack-label
            outlined
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <div class="q-gutter-y-md">
            <q-input
              v-model="new_password"
              type="password"
              :label="$t('New Password')"
              stack-label
              outlined
            />
            <q-input
              v-model="repeat_password"
              type="password"
              :label="$t('Confirm Password')"
              stack-label
              outlined
            />
          </div>

          <q-space class="q-pa-sm"></q-space>
          <q-btn
            type="submit"
            color="primary"
            text-color="white"
            :label="$t('Save')"
            unelevated
            class="full-width radius8"
            size="lg"
            no-caps
          />
        </q-form>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useGlobalStore } from "stores/GlobalStore";

export default {
  name: "MerchantLogin",
  components: {
    TabsRouterMenu: defineAsyncComponent(() =>
      import("components/TabsRouterMenu.vue")
    ),
  },
  data() {
    return {
      loading: false,
      loading_submit: false,
      first_name: "",
      last_name: "",
      contact_email: "",
      contact_number: "",
      username: "",
      new_password: "",
      repeat_password: "",
    };
  },
  setup(props) {
    const GlobalStore = useGlobalStore();
    return { GlobalStore };
  },
  mounted() {
    this.getMerchantLogin();
  },
  methods: {
    getMerchantLogin() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getMerchantLogin")
        .then((data) => {
          if (Object.keys(data.details).length > 0) {
            this.first_name = data.details.first_name;
            this.last_name = data.details.last_name;
            this.contact_email = data.details.contact_email;
            this.contact_number = data.details.contact_number;
            this.username = data.details.username;
          }
        })
        .catch((error) => {})
        .then((data) => {
          this.loading = false;
        });
    },
    onSubmit() {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost("saveMerchantlogin", {
        first_name: this.first_name,
        last_name: this.last_name,
        contact_email: this.contact_email,
        contact_number: this.contact_number,
        username: this.username,
        new_password: this.new_password,
        repeat_password: this.repeat_password,
      })
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
  },
};
</script>
