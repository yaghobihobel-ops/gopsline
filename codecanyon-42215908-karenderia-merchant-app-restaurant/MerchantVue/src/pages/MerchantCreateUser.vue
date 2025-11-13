<template>
  <q-header
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
  >
    <q-toolbar>
      <q-toolbar-title class="text-weight-bold">{{
        $t("Create Account")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page class="q-pa-md" :class="{ 'flex flex-center': loading_get }">
    <div v-if="loading_get">
      <div class="flex flex-center full-width">
        <q-spinner color="primary" size="2em" />
      </div>
    </div>
    <q-form v-else @submit="onSubmit">
      <q-input
        v-model="first_name"
        :label="$t('First name')"
        outlined
        stack-label
        color="grey-5"
        lazy-rules
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      />
      <q-input
        v-model="last_name"
        :label="$t('Last name')"
        outlined
        stack-label
        color="grey-5"
        lazy-rules
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      />
      <q-input
        v-model="contact_email"
        type="email"
        :label="$t('Contact email')"
        outlined
        stack-label
        color="grey-5"
        lazy-rules
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      />

      <MobilePhone ref="mobile_phone" @after-input="afterInput"></MobilePhone>

      <q-input
        v-model="username"
        :label="$t('Username')"
        outlined
        stack-label
        color="grey-5"
        lazy-rules
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      />

      <q-input
        v-model="password"
        :type="field_type"
        :label="$t('Password')"
        outlined
        color="grey-5"
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      >
        <template v-slot:prepend>
          <q-icon name="las la-lock" color="grey" />
        </template>
        <template v-slot:append>
          <q-icon
            @click="
              this.field_type =
                this.field_type == 'password' ? 'text' : 'password'
            "
            :name="password_icon"
            color="grey"
            class="cursor-pointer"
          />
        </template>
      </q-input>

      <q-input
        v-model="cpassword"
        :type="field_type2"
        :label="$t('Confirm password')"
        outlined
        color="grey-5"
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      >
        <template v-slot:prepend>
          <q-icon name="las la-lock" color="grey" />
        </template>
        <template v-slot:append>
          <q-icon
            @click="
              this.field_type2 =
                this.field_type2 == 'password' ? 'text' : 'password'
            "
            :name="password_icon2"
            color="grey"
            class="cursor-pointer"
          />
        </template>
      </q-input>

      <q-footer
        class="q-pa-md"
        :class="{
          'bg-mydark ': $q.dark.mode,
          'bg-white ': !$q.dark.mode,
        }"
      >
        <q-btn
          type="submit"
          color="primary"
          text-color="white"
          :label="$t('Submit')"
          unelevated
          class="full-width"
          size="lg"
          no-caps
          :loading="loading"
        />
      </q-footer>
    </q-form>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";

export default {
  name: "MerchantCreateUser",
  components: {
    MobilePhone: defineAsyncComponent(() =>
      import("components/MobilePhone.vue")
    ),
  },
  data() {
    return {
      loading: false,
      loading_get: false,
      first_name: "",
      last_name: "",
      contact_email: "",
      username: "",
      password: "",
      cpassword: "",
      phone: [],
      field_type: "password",
      field_type2: "password",
      password_icon: "las la-low-vision",
      password_icon2: "las la-low-vision",
      merchant_uuid: "",
    };
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  watch: {
    field_type(newval, oldval) {
      if (newval == "text") {
        this.password_icon = "las la-eye";
      } else {
        this.password_icon = "las la-low-vision";
      }
    },
    field_type2(newval, oldval) {
      if (newval == "text") {
        this.password_icon2 = "las la-eye";
      } else {
        this.password_icon2 = "las la-low-vision";
      }
    },
  },
  created() {
    this.merchant_uuid = this.$route.query.uuid;
    if (!APIinterface.empty(this.merchant_uuid)) {
      this.getMerchant();
    }
  },
  methods: {
    afterInput(data) {
      this.phone = data;
    },
    getMerchant() {
      this.loading_get = true;
      APIinterface.fetchDataPost(
        "getMerchant",
        "merchant_uuid=" + this.merchant_uuid
      )
        .then((data) => {
          //
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
      this.loading = true;
      APIinterface.fetchData("CreateMerchantUser", {
        merchant_uuid: this.merchant_uuid,
        first_name: this.first_name,
        last_name: this.last_name,
        contact_email: this.contact_email,
        username: this.username,
        password: this.password,
        cpassword: this.cpassword,
        phone: this.phone,
      })
        .then((data) => {
          if (data.details.redirect == "choose_plan") {
            this.$router.push({
              path: "/signup/chooseplan",
              query: { uuid: data.details.merchant_uuid },
            });
          } else {
            this.$router.push("/signup/getbacktoyou");
          }
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
