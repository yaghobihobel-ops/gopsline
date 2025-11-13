<template>
  <q-page class="q-pl-md q-pr-md flex flex-center">
    <div class="full-width text-center">
      <q-img
        src="access-denied.png"
        fit="fill"
        style="max-width: 150px"
        spinner-color="transparent"
        loading="lazy"
      />
      <q-space class="q-pa-sm"></q-space>
      <div class="text-h6 text-weight-bold">
        {{ $t("oops something went wrong") }}
      </div>
      <div class="text-grey text-body2">
        {{ $t("You are not authorized to perform this action") }}
      </div>
      <q-space class="q-pa-sm"></q-space>
      <q-btn
        @click="$router.back()"
        :label="$t('Go back')"
        no-caps
        color="red-9"
        text-color="red-2"
        size="lg"
        unelevated
        class="radius10 fit"
      />
    </div>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "AccessDenied",
  methods: {
    Back() {
      console.log("Back");
    },
  },
};
</script>
