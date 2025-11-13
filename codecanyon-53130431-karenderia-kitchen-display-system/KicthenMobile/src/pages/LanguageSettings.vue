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
        $t("Language")
      }}</q-toolbar-title>
    </q-toolbar>
  </q-header>
  <q-page padding>
    <q-list separator>
      <q-item
        v-for="items_language in KitchenStore.languageList"
        :key="items_language"
        tag="label"
      >
        <q-item-section avatar>
          <q-avatar square>
            <q-img
              :src="items_language.flag_url"
              style="max-height: 25px"
              spinner-color="primary"
              spinner-size="sm"
            ></q-img>
          </q-avatar>
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ items_language.title }}</q-item-label>
          <q-item-label caption>{{ items_language.description }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-radio
            v-model="language"
            :val="items_language.code"
            color="yellow-9"
            checked-icon="check_circle"
            unchecked-icon="panorama_fish_eye"
            size="lg"
            @update:model-value="setLanguage"
          />
        </q-item-section>
      </q-item>
    </q-list>
  </q-page>
</template>

<script>
import { useKitchenStore } from "stores/KitchenStore";
import { useIdentityStore } from "stores/IdentityStore";
import { useSettingStore } from "stores/SettingStore";
import { api } from "boot/axios";

export default {
  name: "LanguageSettings",
  setup() {
    const KitchenStore = useKitchenStore();
    const IdentityStore = useIdentityStore();
    const SettingStore = useSettingStore();
    return { KitchenStore, IdentityStore, SettingStore };
  },
  data() {
    return {
      language: "",
    };
  },
  mounted() {
    this.language = this.SettingStore.app_language;
  },
  methods: {
    async setLanguage(value) {
      console.log("setLanguage", value);
      this.SettingStore.app_language = value;
      this.$i18n.locale = value;
      api.defaults.params = {};
      api.defaults.params["language"] = this.$i18n.locale;

      this.setRTL();
      await this.KitchenStore.refreshSettings();
    },
    setRTL() {
      if (Object.keys(this.KitchenStore.settings_data).length > 0) {
        Object.entries(
          this.KitchenStore.settings_data.language_list.list
        ).forEach(([key, items]) => {
          if (this.language == items.code) {
            if (items.rtl == 1) {
              this.$q.lang.set({ rtl: true });
              this.SettingStore.rtl = true;
            } else {
              this.$q.lang.set({ rtl: false });
              this.SettingStore.rtl = false;
            }
          }
        });
      }
    },
  },
};
</script>
