<template>
  <q-header
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
  >
    <q-toolbar>
      <q-space></q-space>
      <div>
        <q-icon :name="getDarkMode" size="sm" />
        <q-toggle v-model="dark_mode" color="primary" />
      </div>
      <!-- <div>
        <q-icon :name="getRTLMode" size="sm" />
        <q-toggle v-model="rtl" color="primary" />
      </div> -->

      <q-btn
        v-if="Activity.settings_data.enabled_language"
        to="/settings/language"
        flat
        round
        dense
        icon="las la-globe"
        class="q-mr-smx"
        :color="$q.dark.mode ? 'white' : 'grey'"
      />
    </q-toolbar>
  </q-header>
  <q-page class="flex flex-center q-pl-md q-pr-md">
    <div class="full-width text-center">
      <q-card flat>
        <div class="text-center">
          <div class="text-h6 text-weight-bold line-normal">
            {{ $t("Let's Sign You In") }}
          </div>
          <div class="font12 text-grey">
            {{ $t("Enter your username and password to sigin") }}
          </div>
          <q-space class="q-pa-xs"></q-space>
        </div>

        <q-form @submit="onSubmit" class="q-pa-md">
          <q-input
            v-model="username"
            :label="$t('Email address')"
            outlined
            color="grey-5"
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          >
            <template v-slot:prepend>
              <q-icon
                name="las la-user-alt"
                color="grey"
                lazy-rules
                :rules="[
                  (val) =>
                    (val && val.length > 0) ||
                    this.$t('This field is required'),
                ]"
              />
            </template>
          </q-input>

          <q-input
            v-model="password"
            :label="$t('Password')"
            outlined
            color="grey-5"
            :type="field_type"
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          >
            <template v-slot:prepend>
              <q-icon
                name="las la-lock"
                color="grey"
                lazy-rules
                :rules="[
                  (val) =>
                    (val && val.length > 0) ||
                    this.$t('This field is required'),
                ]"
              />
            </template>
            <template v-slot:append>
              <q-icon
                @click="
                  field_type = field_type == 'password' ? 'text' : 'password'
                "
                :name="FieldIcon"
                color="grey"
                class="cursor-pointer"
              />
            </template>
          </q-input>

          <div class="row justify-between q-mb-sm" style="margin-top: -15px">
            <div></div>
            <q-btn unelevated flat no-caps color="primary" to="/user/forgotpass"
              >{{ $t("Forgot Password") }}?</q-btn
            >
          </div>

          <q-btn
            :loading="loading"
            type="submit"
            :label="$t('Sign In')"
            unelevated
            color="primary"
            no-caps
            class="full-width"
            size="lg"
          />

          <div class="q-pa-sm row items-center justify-center">
            <span class="text-grey">{{ $t("Don't have an account") }}</span>
            <q-btn to="/user/signup" unelevated flat no-caps color="primary">{{
              $t("Signup")
            }}</q-btn>
          </div>
        </q-form>
      </q-card>
    </div>
  </q-page>
</template>

<script>
import { defineComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import auth from "src/api/auth";
import { useActivityStore } from "stores/ActivityStore";

export default defineComponent({
  name: "LoginPage",
  data() {
    return {
      loading: false,
      field_type: "password",
      username: "",
      password: "",
      dark_mode: false,
      rtl: false,
    };
  },
  created() {
    this.dark_mode = this.Activity.dark_mode;
    this.rtl = this.Activity.rtl;
  },
  setup() {
    const Activity = useActivityStore();
    return { Activity };
  },
  watch: {
    dark_mode(newval, oldval) {
      this.$q.dark.set(newval);
      this.Activity.dark_mode = newval;
    },
    rtl(newval, oldval) {
      this.Activity.rtl = newval;
      this.$q.lang.set({ rtl: newval });
    },
  },
  computed: {
    FieldIcon() {
      return this.field_type === "password"
        ? "eva-eye-outline"
        : "eva-eye-off-outline";
    },
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
      APIinterface.userLogin({
        username: this.username,
        password: this.password,
      })
        .then((data) => {
          APIinterface.notify("green-5", data.msg, "check_circle", this.$q);
          auth.setUser(data.details.user_data);
          auth.setToken(data.details.user_token);
          this.$router.replace("/home");
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
});
</script>
