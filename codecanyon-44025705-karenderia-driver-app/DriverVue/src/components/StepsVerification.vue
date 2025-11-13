<template>
  <q-dialog v-model="show_modal" persistent position="bottom">
    <q-card class="relative-position">
      <div class="text-right">
        <q-btn icon="eva-close-outline" flat round dense v-close-popup />
      </div>

      <q-form @submit="onSubmit">
        <q-card-section class="text-center">
          <div class="text-weight-bold text-h5 q-mb-md">
            {{ $t("2-Step Verification") }}
          </div>
          <p class="text-weight-medium">
            {{ $t("For your security, we want to make sure it's really you") }}.
          </p>
          <q-input
            bg-color="mygrey"
            color="warning"
            outlined
            v-model="code"
            :label="$t('Code')"
            maxlength="6"
            lazy-rules
            :rules="[(val) => (val && val.length > 0) || 'Code is required']"
            mask="######"
          />

          <div class="text-left q-mt-md">
            <p class="text-weight-bold font12">{{ sent_message2 }}</p>
            <q-btn
              @click="resendCode"
              v-if="counter === 0"
              flat
              dense
              color="dark"
              no-caps
              class="font12 q-ma-none"
              ><u>{{ $t("Resend") }}</u></q-btn
            >
            <p v-else class="font11 q-ma-none">
              <u>{{ $t("Resend Code in") }} {{ counter }}</u>
            </p>
          </div>
        </q-card-section>

        <q-separator spaced />
        <q-card-actions>
          <q-btn
            type="submit"
            unelevated
            color="primary"
            text-color="white"
            no-caps
            class="full-width text-weight-bold font17"
            :label="$t('Submit')"
            :disabled="hasCode"
            :loading="loading"
          >
          </q-btn>
        </q-card-actions>
      </q-form>

      <q-inner-loading
        :showing="visible"
        :label="$t('Please wait...')"
        label-class="text-warning"
        label-style="font-size: 1.1em"
        color="primary"
      />
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "StepsVerification",
  props: ["sent_message"],
  data() {
    return {
      show_modal: false,
      loading: false,
      visible: false,
      code: "",
      counter: 20,
      timer: undefined,
      sent_message2: "",
    };
  },
  computed: {
    hasCode() {
      if (!APIinterface.empty(this.code)) {
        return false;
      }
      return true;
    },
  },
  watch: {
    counter(newval, oldval) {
      if (newval <= 0) {
        this.stopTimer();
      }
    },
    show_modal(newval, oldval) {
      if (newval) {
        this.startTimer();
      }
    },
    sent_message(newval, oldval) {
      this.sent_message2 = newval;
    },
  },
  methods: {
    onSubmit() {
      this.$emit("afterVerifycode", this.code);
    },
    stopTimer() {
      clearInterval(this.timer);
    },
    startTimer() {
      this.stopTimer();
      this.counter = 20;
      this.timer = setInterval(() => {
        this.counter--;
      }, 1000);
    },
    resendCode() {
      this.loading = true;
      APIinterface.fetchDataByToken("requestcode2", {})
        .then((data) => {
          this.sent_message2 = data.msg;
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
