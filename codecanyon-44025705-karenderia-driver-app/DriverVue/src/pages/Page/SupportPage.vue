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
      <q-toolbar-title class="text-grey-10">{{
        $t("Support")
      }}</q-toolbar-title>
    </q-toolbar>
  </q-header>
  <q-space class="q-pa-xs bg-grey-1"></q-space>
  <q-page padding>
    <!-- content -->
  </q-page>
</template>

<script>
export default {
  // name: 'PageName',
};
</script>
