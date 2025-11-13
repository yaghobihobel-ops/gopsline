<template>
  <q-header
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
  >
    <q-toolbar>
      <q-btn
        flat
        round
        dense
        icon="las la-angle-left"
        :color="$q.dark.mode ? 'white' : 'dark'"
        to="/login"
      />
      <q-toolbar-title class="text-weight-bold">{{
        $t("Thank You")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page class="q-pa-md flex flex-center">
    <div class="full-width text-center">
      <div class="text-weight-medium text-grey">
        {{ $t("THANKS FOR JOINING") }}
      </div>
      <div class="text-weight-bold text-h6">
        {{ $t("You'll be contacted soon") }}!
      </div>
      <q-space class="q-pa-sm"></q-space>
      <p>
        {{
          $t(
            "We will contact you for more information. You can expect a phone call or email in 1-3 business days"
          )
        }}
      </p>

      <div>
        <q-btn
          :label="$t('Go back to login page')"
          no-caps
          flat
          color="blue"
          class="q-pa-none font12"
          to="/login"
        ></q-btn>
      </div>
    </div>
  </q-page>
</template>

<script>
export default {
  // name: 'PageName',
};
</script>
