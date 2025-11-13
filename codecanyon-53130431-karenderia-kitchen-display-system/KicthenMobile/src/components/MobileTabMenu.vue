<template>
  <q-tabs
    v-model="tab"
    class="text-custom-grey4 border-bottom-200"
    no-caps
    indicator-color="primary"
    :active-color="$q.dark.mode ? 'grey300' : 'dark'"
    align="justify"
    :class="{
      'bg-custom-grey': !$q.dark.mode,
      'bg-grey600': $q.dark.mode,
    }"
  >
    <q-route-tab
      name="current"
      :label="$t('Current')"
      to="/current"
    ></q-route-tab>
    <q-route-tab
      name="alarms"
      :label="$t('Scheduled')"
      to="/scheduled"
    ></q-route-tab>
    <q-route-tab
      name="movies"
      :label="$t('History')"
      to="/history"
    ></q-route-tab>
  </q-tabs>
</template>

<script>
export default {
  name: "MobileTabMenu",
  data() {
    return {
      tab: "current",
    };
  },
  setup() {
    return {};
  },
};
</script>
