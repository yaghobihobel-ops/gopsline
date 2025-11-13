<template>
  <q-header
    reveal
    :class="{
      'bg-custom-grey text-dark': !$q.dark.mode,
      'bg-grey600 text-grey300': $q.dark.mode,
    }"
  >
    <!-- MOBILE VIEW -->
    <template v-if="$q.screen.lt.md">
      <q-toolbar style="border-bottom-right-radius: 25px">
        <q-btn
          @click="$router.back()"
          flat
          round
          dense
          icon="eva-arrow-ios-back-outline"
          :color="$q.dark.mode ? 'grey300' : 'custom-grey3'"
        />
        <q-toolbar-title style="font-size: 14px">{{ title }}</q-toolbar-title>
        <q-space></q-space>
        <div class="q-gutter-x-md">
          <NotificationComponents></NotificationComponents>
        </div>
      </q-toolbar>
    </template>
    <template v-else>
      <!-- DESKTOP VIEW -->
      <div class="flex justify-between q-pa-md items-center">
        <div>
          <template v-if="!KitchenStore.miniState">
            <q-btn
              dense
              round
              unelevated
              color="accent"
              icon="chevron_left"
              :text-color="$q.dark.mode ? 'grey300' : 'white'"
              @click="KitchenStore.miniState = true"
              size="13px"
            />
          </template>
          <q-btn
            :color="$q.dark.mode ? 'grey300' : 'dark'"
            :label="title"
            no-caps
            unelevated
            flat
          />
        </div>
        <div>
          <q-btn
            :color="$q.dark.mode ? 'grey300' : 'dark'"
            icon-right="eva-settings-outline"
            no-caps
            unelevated
            flat
            rounded
            to="/settings"
          />

          <NotificationComponents></NotificationComponents>
        </div>
      </div>
    </template>
  </q-header>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useKitchenStore } from "stores/KitchenStore";
export default {
  name: "TopNav",
  props: ["title"],
  components: {
    NotificationComponents: defineAsyncComponent(() =>
      import("components/NotificationComponents.vue")
    ),
  },
  setup() {
    const KitchenStore = useKitchenStore();
    return { KitchenStore };
  },
};
</script>
