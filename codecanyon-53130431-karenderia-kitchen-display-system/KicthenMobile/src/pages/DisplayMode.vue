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
        $t("Display Mode")
      }}</q-toolbar-title>
    </q-toolbar>
  </q-header>
  <q-page padding>
    <q-list separator>
      <q-item tag="label" v-ripple>
        <q-item-section>
          <q-item-label>{{ $t("Dark Theme") }}</q-item-label>
        </q-item-section>
        <q-item-section avatar>
          <q-toggle
            v-model="SettingStore.dark_theme"
            val="1"
            @update:model-value="setDarkmode"
          />
        </q-item-section>
      </q-item>
      <q-item>
        <q-item-section>
          <q-item-label>{{ $t("Screen Options") }}</q-item-label>
        </q-item-section>
      </q-item>

      <template v-for="items in KitchenStore.screen_list" v-bind:key="items">
        <q-item tag="label" v-ripple>
          <q-item-section avatar>
            <q-radio v-model="SettingStore.screen_options" :val="items.value" />
          </q-item-section>
          <q-item-section>
            <q-item-label>
              {{ $t(items.label) }}
            </q-item-label>
          </q-item-section>
        </q-item>
      </template>
    </q-list>

    <template v-if="SettingStore.screen_options == 'split'">
      <q-separator class="q-mt-md"></q-separator>
      <q-list separator>
        <template v-for="items in KitchenStore.getTransactionList" :key="items">
          <q-item tag="label">
            <q-item-section>
              <q-item-label>
                {{ items.label }}
              </q-item-label>
            </q-item-section>
            <q-item-section side>
              <div class="q-gutter-sm">
                <q-radio
                  v-model="SettingStore.split_order_type[items.value]"
                  val="top"
                  label="Top"
                />
                <q-radio
                  v-model="SettingStore.split_order_type[items.value]"
                  val="bottom"
                  label="Bottom"
                />
              </div>
            </q-item-section>
          </q-item>
        </template>
      </q-list>
    </template>
  </q-page>
</template>

<script>
import { useKitchenStore } from "stores/KitchenStore";
import { useIdentityStore } from "stores/IdentityStore";
import { useSettingStore } from "stores/SettingStore";

export default {
  name: "DisplayMode",
  setup() {
    const KitchenStore = useKitchenStore();
    const IdentityStore = useIdentityStore();
    const SettingStore = useSettingStore();
    return { KitchenStore, IdentityStore, SettingStore };
  },
  methods: {
    setDarkmode(value) {
      this.$q.dark.set(value);
    },
  },
};
</script>
