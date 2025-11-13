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
        $t("Colors")
      }}</q-toolbar-title>
    </q-toolbar>
  </q-header>
  <q-page padding>
    <div class="text-subtitle1 text-weight-medium q-pl-md">
      {{ $t("Status Colors") }}
    </div>
    <q-list separator>
      <q-item tag="label" v-ripple>
        <q-item-section>
          <q-item-label>{{ $t("On Time") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-avatar
            :style="`background-color: ${SettingStore.color_ontime}`"
            text-color="white"
            size="lg"
          />
          <ColorSelection
            is_array="false"
            v-model:colors="SettingStore.color_ontime"
          ></ColorSelection>
        </q-item-section>
      </q-item>
      <q-item tag="label" v-ripple>
        <q-item-section>
          <q-item-label>{{ $t("Caution") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-avatar
            :style="`background-color: ${SettingStore.color_caution}`"
            text-color="white"
            size="lg"
          />
          <ColorSelection
            is_array="false"
            v-model:colors="SettingStore.color_caution"
          ></ColorSelection>
        </q-item-section>
      </q-item>
      <q-item tag="label" v-ripple>
        <q-item-section>
          <q-item-label>{{ $t("Late") }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-avatar
            :style="`background-color: ${SettingStore.color_late}`"
            text-color="white"
            size="lg"
          />
          <ColorSelection
            is_array="false"
            v-model:colors="SettingStore.color_late"
          ></ColorSelection>
        </q-item-section>
      </q-item>
    </q-list>

    <q-space class="q-pa-sm"></q-space>

    <div class="text-subtitle1 text-weight-medium q-pl-md">
      {{ $t("Order Type") }}
    </div>
    <q-list separator>
      <template
        v-for="items in KitchenStore.getTransactionList"
        v-bind:key="items"
      >
        <q-item tag="label" v-ripple>
          <q-item-section>
            <q-item-label>{{ items.label }}</q-item-label>
          </q-item-section>
          <q-item-section side>
            <q-avatar
              :style="`background-color: ${
                SettingStore.color_status[items.value]
              }`"
              text-color="white"
              size="lg"
            />
            <ColorSelection
              is_array="true"
              v-model:colors="SettingStore.color_status[items.value]"
            ></ColorSelection>
          </q-item-section>
        </q-item>
      </template>
    </q-list>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useKitchenStore } from "stores/KitchenStore";
import { useIdentityStore } from "stores/IdentityStore";
import { useSettingStore } from "stores/SettingStore";

export default {
  name: "ColorsSettings",
  components: {
    ColorSelection: defineAsyncComponent(() =>
      import("components/ColorSelection.vue")
    ),
  },
  setup() {
    const KitchenStore = useKitchenStore();
    const IdentityStore = useIdentityStore();
    const SettingStore = useSettingStore();
    return { KitchenStore, IdentityStore, SettingStore };
  },
};
</script>
