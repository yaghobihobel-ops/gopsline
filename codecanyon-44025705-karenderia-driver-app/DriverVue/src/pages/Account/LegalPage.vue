<template>
  <q-header
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
  >
    <q-toolbar>
      <q-btn
        @click="$router.back()"
        flat
        round
        dense
        icon="las la-angle-left"
        :color="$q.dark.mode ? 'white' : 'dark'"
      />
      <q-toolbar-title class="text-weight-bold">{{
        $t("Legal")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page padding>
    <q-list separator>
      <template v-for="(items, index) in Activity.legal_menu" :key="items">
        <q-item
          clickable
          :to="{
            name: 'page',
            params: {
              page_id: index,
            },
          }"
        >
          <q-item-section>
            <q-item-label>{{ items }}</q-item-label>
          </q-item-section>
        </q-item>
      </template>
    </q-list>
  </q-page>
</template>

<script>
import { useActivityStore } from "stores/ActivityStore";
export default {
  name: "LegalPage",
  setup() {
    const Activity = useActivityStore();
    return { Activity };
  },
};
</script>
