<template>
  <q-dialog
    v-model="modal"
    :maximized="this.$q.screen.lt.sm ? true : false"
    :position="this.$q.screen.lt.sm ? 'bottom' : 'standard'"
    persistent
    @before-show="beforeShow"
  >
    <q-card>
      <q-card-section class="row items-center q-pb-none">
        <q-space />
        <q-btn icon="close" flat round dense v-close-popup />
      </q-card-section>
      <q-card-section
        class="q-gutter-y-md text-center"
        :class="{
          'card-form-big': this.$q.screen.gt.sm,
        }"
      >
        <q-form @submit="onSubmit" @reset="onReset">
          <div class="text-h6">
            {{ $t("2-Step Verification") }}
          </div>
          <p class="text-body2">
            {{ $t("For your security, we want to make sure it's really you") }}.
          </p>
          <div class="text-body2 q-mb-md">
            {{ message }}
          </div>

          <q-input
            outlined
            v-model="code"
            :label="$t('Code')"
            :dense="$q.screen.lt.md"
            :bg-color="$q.dark.mode ? 'grey300' : 'secondary'"
            no-error-icon
            lazy-rules
            :rules="[
              (val) => (val && val.length > 0) || this.$t('Code is required'),
            ]"
            mask="######"
          >
          </q-input>

          <q-btn
            color="primary"
            :label="$t('Submit')"
            class="fit radius-10"
            unelevated
            :size="$q.screen.gt.sm ? 'lg' : '15px'"
            type="submit"
            no-caps
            :loading="loading"
          />

          <q-space class="q-pa-sm"></q-space>

          <template v-if="counter === 0">
            <q-btn
              flat
              :label="$t('Resend Code')"
              no-caps
              :color="$q.dark.mode ? 'grey300' : 'blue'"
              :disabled="loading"
              :loading="loading_resend"
              @click="resendCode"
            ></q-btn>
          </template>
          <template v-else>
            <p>
              <u>{{ $t("Resend Code in") }} {{ counter }}</u>
            </p>
          </template>
        </q-form>
      </q-card-section>
    </q-card>
  </q-dialog>
</template>

<script>
export default {
  name: "TwoStepsVerification",
  props: ["message", "loading", "loading_resend"],
  data() {
    return {
      modal: false,
      code: "",
      counter: 20,
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
  setup() {
    return {};
  },
  beforeUnmount() {
    this.stopTimer();
  },
  methods: {
    beforeShow() {
      this.code = "";
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
    onSubmit() {
      this.$emit("afterSubmitcode", this.code);
    },
    resendCode() {
      this.$emit("requestCode", this.code);
    },
  },
};
</script>
