<template>
  <q-header
    :class="{
      'bg-transparent text-grey300': $q.dark.mode,
      'bg-transparent text-dark': !$q.dark.mode,
    }"
  >
    <q-toolbar>
      <q-btn
        @click="$router.back()"
        flat
        round
        dense
        icon="chevron_left"
        :text-color="$q.dark.mode ? 'grey300' : 'dark'"
      />
      <q-toolbar-title class="text-body2">{{
        $t("Forgot Password")
      }}</q-toolbar-title>
    </q-toolbar>
  </q-header>
  <q-page padding class="flex flex-center">
    <q-card flat :class="{ 'bg-grey600': $q.dark.mode }">
      <q-card-section>
        <template v-if="steps == 1">
          <q-form @submit="onSubmit" @reset="onReset" class="text-center">
            <h6
              class="text-weight-regular no-margin"
              :class="{
                'text-subtitle1': this.$q.screen.lt.sm,
              }"
            >
              {{ $t("Let's Get your account back") }}!
            </h6>

            <p class="q-ma-none text-grey q-mb-md">
              {{
                $t(
                  "Enter your email to receive instructions for resetting your password"
                )
              }}.
            </p>

            <q-input
              v-model="email_address"
              :label="$t('Email')"
              outlined
              :bg-color="$q.dark.mode ? 'grey300' : 'secondary'"
              lazy-rules
              :rules="[
                (val) =>
                  (val && val.length > 0) || this.$t('Email is required'),
                (val) =>
                  /.+@.+\..+/.test(val) || this.$t('Invalid email format'),
              ]"
            >
              <template v-slot:prepend>
                <q-icon name="eva-email-outline" color="grey" />
              </template>
            </q-input>

            <q-btn
              color="primary"
              :label="$t('Reset Password')"
              class="fit radius-10"
              unelevated
              :size="$q.screen.gt.sm ? 'xl' : 'lg'"
              type="submit"
              no-caps
              :loading="loading"
            />
          </q-form>
        </template>
        <template v-else>
          <div class="text-center">
            <h6
              class="text-weight-regular no-margin"
              :class="{
                'text-subtitle1': this.$q.screen.lt.sm,
              }"
            >
              {{ $t("Let's Get your account back") }}!
            </h6>
            <div class="bg-mysuccess q-pa-sm box-shadow q-mt-sm radius-10">
              {{ data.msg }}
            </div>
          </div>

          <template v-if="counter === 0">
            <div class="flex justify-between q-mt-sm">
              <q-btn
                @click="resendEmail"
                flat
                dense
                color="accent"
                no-caps
                class="font13 q-ma-none"
                :loading="loading"
                ><u>{{ $t("Resend reset email") }}</u></q-btn
              >
              <q-btn
                @click="steps = 1"
                flat
                dense
                color="accent"
                no-caps
                class="font13 q-ma-none"
                ><u>{{ $t("Enter email again") }}</u></q-btn
              >
            </div>
          </template>
          <template v-else>
            <div class="text-center q-pa-md">
              <u>{{ $t("Resend Code in") }} {{ counter }}</u>
            </div>
          </template>
        </template>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "ForgotPassword",
  data() {
    return {
      loading: false,
      email_address: "mcuser@yahoo.com",
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
      APIinterface.fetchData(
        "ForgotPassword",
        "email_address=" + this.email_address
      )
        .then((data) => {
          this.steps = 2;
          this.startTimer();
          this.data = data;
        })
        .catch((error) => {
          APIinterface.notify(
            this.$q,
            this.$t("Error"),
            error,
            "myerror",
            "highlight_off",
            "bottom"
          );
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
      APIinterface.fetchData(
        "resendResetEmail",
        "uuid=" + this.data.details.uuid
      )
        .then((data) => {
          this.steps = 2;
          this.startTimer();
        })
        .catch((error) => {
          APIinterface.notify(
            this.$q,
            this.$t("Error"),
            error,
            "myerror",
            "highlight_off",
            "bottom"
          );
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
