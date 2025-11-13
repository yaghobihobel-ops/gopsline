<template>
  <q-page class="flex flex-center q-pl-md q-pr-md">
    <div class="full-width text-center">
      <div class="text-h6 text-weight-bold line-normal">
        {{ $t("Thank you for signing up") }}!
      </div>
      <div class="font14 text-grey">
        {{ $t("Your registration is now complete") }}.
      </div>
      <q-space class="q-pa-md"></q-space>
      <q-btn
        unelevated
        color="primary"
        :label="$t('Click here to login')"
        no-caps
        class="text-weight-bold font17"
        size="lg"
        to="/user/login"
      />
    </div>
  </q-page>
</template>

<script>
export default {
  name: "SignupTy",
  methods: {
    closeApp() {
      //
    },
  },
};
</script>
