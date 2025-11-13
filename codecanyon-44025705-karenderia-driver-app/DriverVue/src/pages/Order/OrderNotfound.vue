<template>
  <q-header class="bg-white" reveal reveal-offset="50">
    <q-toolbar>
      <q-btn
        @click="$router.back()"
        flat
        round
        dense
        icon="arrow_back"
        color="dark"
      />
    </q-toolbar>
  </q-header>
  <q-page padding class="flex flex-center">
    <div class="text-center">
      <div class="font16 text-weight-bold">
        {{ $t("Opps order details not available") }}
      </div>
      <p class="font11">
        {{ $t("The order your viewing is not available anymore") }}.
      </p>
    </div>
  </q-page>
</template>

<script>
export default {
  // name: 'PageName',
};
</script>
