<template>
  <q-header class="bg-white text-dark">
    <q-toolbar>
      <q-btn
        round
        icon="keyboard_arrow_left"
        color="blue-grey-1"
        text-color="blue-grey-8"
        unelevated
        dense
        @click="$router.back()"
      ></q-btn>
      <q-toolbar-title>{{ $t("Forgot Password") }}</q-toolbar-title>
    </q-toolbar>
  </q-header>
  <q-page class="flex flex-center q-pl-md q-pr-md">
    <div class="full-width text-center">
      <h6 class="text-weight-bold no-margin">
        {{ $t("Let's Get your account back") }}!
      </h6>

      <p class="text-weight-medium q-ma-none text-grey" v-if="steps == 1">
        {{
          $t(
            "Enter your email to receive instructions for resetting your password"
          )
        }}.
      </p>
      <p v-else class="rounded-borders border-green q-pa-sm">
        {{ data.msg }}
      </p>
      <q-space class="q-pa-sm"></q-space>

      <q-form @submit="onSubmit" v-if="steps == 1">
        <q-input
          v-model="email_address"
          :placeholder="$t('Email')"
          outlined
          lazy-rules
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        >
          <template v-slot:prepend>
            <q-icon name="las la-envelope" color="grey" />
          </template>
        </q-input>

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
          <div class="text-weight-bold text-subtitle2">
            {{ $t("Reset Password") }}
          </div>
        </q-btn>
      </q-form>

      <template v-else>
        <q-space class="q-pa-xs"></q-space>
        <template v-if="counter === 0">
          <q-btn
            @click="resendEmail"
            flat
            dense
            color="myblue"
            no-caps
            class="font13 q-ma-none"
            ><u>{{ $t("Resend reset email") }}</u></q-btn
          >
          <q-btn
            @click="steps = 1"
            flat
            dense
            color="secondary"
            no-caps
            class="font13 q-ma-none"
            ><u>{{ $t("Enter email again") }}</u></q-btn
          >
        </template>
        <p v-else class="font11 q-ma-none">
          <u>{{ $t("Resend Code in") }} {{ counter }}</u>
        </p>
      </template>
    </div>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "ForgotPassword",
  data() {
    return {
      loading: false,
      email_address: "",
      steps: 1,
      data: [],
      maxCounter: 20,
      counter: this.maxCounter,
      timer: undefined,
    };
  },
  watch: {
    counter(newval, oldval) {
      if (newval <= 0) {
        this.stopTimer();
      }
    },
  },
  beforeUnmount() {
    this.stopTimer();
  },
  methods: {
    onSubmit() {
      this.loading = true;
      APIinterface.fetchDataPost(
        "ForgotPassword",
        "email_address=" + this.email_address
      )
        .then((data) => {
          this.steps = 2;
          this.startTimer();
          this.data = data;
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    stopTimer() {
      clearInterval(this.timer);
    },
    startTimer() {
      this.stopTimer();
      this.counter = this.maxCounter;
      this.timer = setInterval(() => {
        this.counter--;
      }, 1000);
    },
    resendEmail() {
      this.loading = true;
      APIinterface.fetchDataPost(
        "resendResetEmail",
        "uuid=" + this.data.details.uuid
      )
        .then((data) => {
          this.steps = 2;
          this.startTimer();
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
