<template>
  <q-header
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
  >
    <q-toolbar>
      <q-btn
        to="/login"
        flat
        round
        dense
        icon="las la-angle-left"
        :color="$q.dark.mode ? 'white' : 'dark'"
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
        {{ $t("Your registration is complete") }}!
      </div>
      <q-space class="q-pa-sm"></q-space>
      <div class="font12">
        {{ $t("You can login to merchant by") }}
        <q-btn
          :label="$t('clicking here')"
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
