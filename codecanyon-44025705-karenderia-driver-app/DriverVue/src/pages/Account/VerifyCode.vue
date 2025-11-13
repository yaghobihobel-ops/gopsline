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
        $t("Verification")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page class="flex flex-center q-pl-md q-pr-md">
    <q-form @submit="onSubmit">
      <div class="q-pa-lg">
        <p class="text-verification line-normal">
          {{ $t("Enter verification code we've sent on given number") }}
        </p>
        <p class="no-margin font13 line-normal">{{ sent_message }}</p>

        <q-space class="q-pa-md"></q-space>

        <q-input
          ref="code"
          :label="$t('Enter verification code')"
          v-model="code"
          color="grey-5"
          mask="####"
          lazy-rules
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />
      </div>

      <q-footer
        class="q-pa-md"
        :class="{
          'bg-mydark ': $q.dark.mode,
          'bg-white ': !$q.dark.mode,
        }"
      >
        <div class="row items-center q-pa-sm">
          <div class="col">
            <div class="countdown text-black">
              {{ $t("Resend Code in") }} {{ counter }}
            </div>
          </div>
          <div class="col text-right">
            <q-btn
              :disable="counter != 0"
              @click="resendCode"
              flat
              class="btn-resend"
              :label="$t('Resend')"
              no-caps
            />
          </div>
        </div>

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
import APIinterface from "src/api/APIinterface";

export default {
  data() {
    return {
      loading: false,
      code: "",
      counter: 0,
      signup_resend_counter: 0,
      driver_uuid: "",
      sent_message: "",
      timer: undefined,
    };
  },
  created() {
    this.driver_uuid = this.$route.query.uuid;
  },
  mounted() {
    this.$refs.code.focus();
    //this.startTimer();
    this.getAccountStatus();
  },
  watch: {
    counter(newval, oldval) {
      if (newval <= 0) {
        this.stopTimer();
      }
    },
  },
  methods: {
    startTimer() {
      this.stopTimer();
      this.timer = setInterval(() => {
        this.counter--;
      }, 1000);
    },
    stopTimer() {
      clearInterval(this.timer);
    },
    getAccountStatus() {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.getAccountStatus(this.driver_uuid)
        .then((data) => {
          this.sent_message = data.msg;
          this.counter = data.details.settings.signup_resend_counter;
          this.signup_resend_counter = this.counter;
          console.debug(data.details.data.status);
          console.debug(data.details.data.account_verified);
          if (data.details.data.account_verified == 1) {
          }
          this.startTimer();
          if (!APIinterface.empty(data.details.otp)) {
            APIinterface.notify(
              "green-5",
              data.details.otp,
              "check_circle",
              this.$q
            );
          }
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading = false;
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    onSubmit() {
      this.loading = true;
      APIinterface.verifyCode({
        driver_uuid: this.driver_uuid,
        code: this.code,
      })
        .then((data) => {
          this.$router.push({
            path: "/account/attach_license",
            query: { uuid: this.driver_uuid },
          });
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    resendCode() {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.requestCode({
        driver_uuid: this.driver_uuid,
      })
        .then((data) => {
          this.counter = this.signup_resend_counter;
          this.startTimer();
          APIinterface.notify("green-5", data.msg, "check_circle", this.$q);
          if (!APIinterface.empty(data.details)) {
            if (!APIinterface.empty(data.details.otp)) {
              APIinterface.notify(
                "green-5",
                data.details.otp,
                "check_circle",
                this.$q
              );
            }
          }
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
  },
};
</script>

<style>
.text-verification {
  font-weight: 700;
  font-size: 18px;
}
.btn-resend {
  color: #e0b151;
  font-weight: 700;
}
.countdown {
  font-weight: 700;
}
</style>
