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
        $t("Forgot Password")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>

  <q-page class="flex flex-center q-pl-md q-pr-md">
    <div class="full-width text-center">
      <q-form @submit="onSubmit">
        <h6 class="text-weight-bold no-margin font16">
          {{ $t("Let's Get your account back") }}!
        </h6>
        <p class="text-weight-light q-ma-none">
          {{
            $t(
              "Enter your email to receive instructions for resetting your password"
            )
          }}
        </p>
        <q-space class="q-pa-sm"></q-space>

        <template v-if="steps == 2">
          <div class="rounded-borders border-green q-pa-sm font12">
            {{ data.msg }}
          </div>
        </template>

        <template v-else>
          <q-input
            v-model="email_address"
            :label="$t('Email address')"
            outlined
            color="grey-5"
            lazy-rules
            :rules="[
              (val, rules) =>
                rules.email(val) ||
                this.$t('Please enter a valid email address'),
            ]"
          >
            <template v-slot:prepend>
              <q-icon
                name="las la-envelope"
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
        </template>
        <q-space class="q-pa-xs"></q-space>

        <template v-if="steps == 1">
          <q-btn
            :loading="loading"
            type="submit"
            :label="$t('Reset Password')"
            unelevated
            color="primary"
            no-caps
            class="full-width text-weight-bold font17"
            size="lg"
          />
        </template>
        <template v-else>
          <template v-if="counter === 0">
            <div class="row items-center">
              <q-btn
                @click="resendEmail"
                :disable="loading"
                flat
                dense
                color="dark"
                no-caps
                class="q-ma-none col"
                size="md"
                ><u>{{ $t("Resend reset email") }}</u>
              </q-btn>
              <q-btn
                @click="steps = 1"
                :disable="loading"
                flat
                dense
                color="dark"
                no-caps
                class="q-ma-none col"
                size="md"
                ><u>{{ $t("Enter email again") }}</u>
              </q-btn>
            </div>
          </template>
          <template v-else>
            <p class="font11 q-ma-none">
              <u>{{ $t("Resend Code in") }} {{ counter }}</u>
            </p>
          </template>
        </template>
      </q-form>
    </div>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useActivityStore } from "stores/ActivityStore";

export default {
  name: "ForgotPassword",
  data() {
    return {
      loading: false,
      email_address: "",
      steps: 1,
      data: [],
      maxCounter: 10,
      counter: this.maxCounter,
      timer: undefined,
    };
  },
  setup() {
    const ActivityStore = useActivityStore();
    return { ActivityStore };
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
      APIinterface.requestResetPassword({
        email_address: this.email_address,
      })
        .then((data) => {
          this.steps = 2;
          this.counter = this.ActivityStore.settings_data.sendcode_interval;
          this.startTimer();
          this.data = data;
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
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
      //this.counter = this.maxCounter;
      this.timer = setInterval(() => {
        this.counter--;
      }, 1000);
    },
    resendEmail() {
      this.loading = true;
      APIinterface.resendResetPassword(this.data.details.uuid)
        .then((data) => {
          this.steps = 2;
          this.counter = this.ActivityStore.settings_data.sendcode_interval;
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
