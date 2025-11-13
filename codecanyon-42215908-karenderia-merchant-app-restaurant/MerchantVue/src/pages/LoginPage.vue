<template>
  <q-header
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
  >
  </q-header>
  <q-page class="flex flex-center q-pl-md q-pr-md">
    <div class="full-width text-center">
      <q-form @submit="onSubmit">
        <div class="text-left" style="max-width: 30vh">
          <h5 class="text-weight-bold no-margin">
            {{ $t("Login to your account.") }}
          </h5>
        </div>
        <div class="text-left">
          <div class="text-body2 text-grey">
            {{ $t("Please sign in to your account") }}.
          </div>
        </div>
        <q-space class="q-pa-md"></q-space>
        <q-input
          v-model="username"
          :placeholder="$t('Username')"
          outlined
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        >
          <template v-slot:prepend>
            <img src="/svg/person.svg" width="25" />
          </template>
        </q-input>

        <q-input
          v-model="password"
          :type="field_type"
          :placeholder="$t('Password')"
          outlined
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        >
          <template v-slot:prepend>
            <img src="/svg/password.svg" width="25" />
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

        <div class="row justify-between q-mb-sm" style="margin-top: -15px">
          <div></div>
          <q-btn unelevated flat no-caps color="orange" to="/forgotpassword"
            >{{ $t("Forgot Password") }}?</q-btn
          >
        </div>

        <q-btn
          type="submit"
          color="primary"
          text-color="white"
          unelevated
          class="full-width"
          size="lg"
          rounded
          no-caps
          :loading="loading"
        >
          <div class="text-weight-bold text-subtitle2">{{ $t("Sign In") }}</div>
        </q-btn>

        <div class="q-pa-lg q-gutter-x-sm row items-center justify-center">
          <span class="text-grey">{{ $t("Don't have an account") }}?</span>
          <q-btn
            to="/signup"
            unelevated
            flat
            no-caps
            color="orange"
            padding="0"
            >{{ $t("Signup") }}</q-btn
          >
        </div>
      </q-form>
    </div>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import auth from "src/api/auth";
import { useDataStore } from "stores/DataStore";
import { useAccessStore } from "stores/AccessStore";
import { useOrderStore } from "stores/OrderStore";

export default {
  name: "LoginPage",
  data() {
    return {
      loading: false,
      username: "",
      password: "",
      field_type: "password",
      password_icon: "las la-low-vision",
      dark_mode: false,
      rtl: false,
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    const AccessStore = useAccessStore();
    const OrderStore = useOrderStore();
    return { DataStore, AccessStore, OrderStore };
  },
  created() {
    this.dark_mode = this.DataStore.dark_mode;
  },
  watch: {
    field_type(newval, oldval) {
      if (newval == "text") {
        this.password_icon = "las la-eye";
      } else {
        this.password_icon = "las la-low-vision";
      }
    },
    dark_mode(newval, oldval) {
      this.$q.dark.set(newval);
      this.DataStore.dark_mode = newval;
    },
    rtl(newval, oldval) {
      this.DataStore.rtl = newval;
      this.$q.lang.set({ rtl: newval });
    },
  },
  computed: {
    getDarkMode() {
      if (this.dark_mode) {
        return "las la-adjust";
      }
      return "las la-moon";
    },
    getRTLMode() {
      if (this.rtl) {
        return "format_textdirection_l_to_r";
      }
      return "format_textdirection_r_to_l";
    },
  },
  methods: {
    onSubmit() {
      this.loading = true;
      APIinterface.fetchDataPost(
        "Login",
        "username=" + this.username + "&password=" + this.password
      )
        .then((data) => {
          auth.setUser(data.details.user_data);
          auth.setToken(data.details.user_token);

          this.AccessStore.menu_access = data.details.menu_access;
          this.AccessStore.app_settings = data.details.app_settings;

          this.DataStore.cart_uuid = "";
          this.OrderStore.clearSavedOrderList();

          APIinterface.ShowSuccessful(data.msg, this.$q);
          this.$router.push("/dashboard");
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
