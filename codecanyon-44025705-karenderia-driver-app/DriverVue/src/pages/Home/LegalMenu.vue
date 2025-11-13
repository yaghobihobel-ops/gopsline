<template>
  <q-page>
    <div class="q-pl-md q-pr-md">
      <div class="text-h7 text-weight-bold">{{ $t("Legal") }}</div>
    </div>
    <q-space class="q-pa-xs"></q-space>
    <div
      class="full-width radius-top q-pt-md"
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
    >
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
    </div>
  </q-page>
</template>

<script>
import { useActivityStore } from "stores/ActivityStore";
export default {
  name: "LegalMenu",
  setup() {
    const Activity = useActivityStore();
    return { Activity };
  },
  created() {
    this.Activity.setTitle(this.$t("Legal"));
  },
};
</script>
