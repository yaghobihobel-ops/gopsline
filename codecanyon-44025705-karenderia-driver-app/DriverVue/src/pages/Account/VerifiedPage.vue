<template>
  <q-page class="flex flex-center q-pl-md q-pr-md">
    <div class="full-width text-center">
      <div class="text-h6 text-weight-bold line-normal">
        {{ $t("Thank you for signing up") }}!
      </div>
      <div class="font14 text-grey">
        {{
          $t(
            "Your registration is now complete. allow us to review your account 1 to 2 business day"
          )
        }},
        {{
          $t("you will receive email from us after your account is activated")
        }}.
      </div>
    </div>

    <q-footer
      class="q-pa-md text-black text-center"
      :class="{
        'bg-mydark ': $q.dark.mode,
        'bg-white ': !$q.dark.mode,
      }"
    >
      <q-btn
        unelevated
        color="primary"
        :label="$t('Close Application')"
        no-caps
        class="text-weight-bold font17"
        size="lg"
        @click="closeApp"
      />
      <q-space class="q-pa-md"></q-space>

      <q-btn dense no-caps flat text-color="text=dark" to="/user/login">
        {{ $t("Already have an account") }}?
        <span class="q-ml-sm text-weight-bold">{{ $t("SIGN IN") }}</span>
      </q-btn>
    </q-footer>
  </q-page>
</template>

<script>
import { App } from "@capacitor/app";

export default {
  name: "VerifiedPage",
  methods: {
    closeApp() {
      App.exitApp();
    },
  },
};
</script>
