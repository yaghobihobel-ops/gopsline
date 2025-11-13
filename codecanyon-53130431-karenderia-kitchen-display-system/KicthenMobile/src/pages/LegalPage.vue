<template>
  <q-header
    reveal
    reveal-offset="10"
    :class="{
      'bg-custom-grey text-dark': !$q.dark.mode,
      'bg-grey600 text-grey300': $q.dark.mode,
    }"
  >
    <q-toolbar style="border-bottom-right-radius: 25px">
      <q-btn
        @click="$router.back()"
        flat
        round
        dense
        icon="eva-arrow-ios-back-outline"
      />
      <q-toolbar-title style="font-size: 14px">{{
        $t("Legal")
      }}</q-toolbar-title>
    </q-toolbar>
  </q-header>
  <q-page padding>
    <q-list separator>
      <template v-for="(items, index) in KitchenStore.legalMenu" :key="items">
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
          <q-item-section side>
            <q-icon name="eva-chevron-right-outline" color="grey-4"></q-icon>
          </q-item-section>
        </q-item>
      </template>
    </q-list>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useKitchenStore } from "stores/KitchenStore";
export default {
  name: "LegalPage",
  setup() {
    const KitchenStore = useKitchenStore();
    return { KitchenStore };
  },
};
</script>
