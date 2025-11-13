<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page class="q-pa-md bg-white text-dark">
      <q-list>
        <q-item
          v-for="items in DataStore.language_data.data"
          :key="items"
          tag="label"
          clickable
          v-ripple
          class="border-grey radius10 q-mb-sm"
          :class="{
            'bg-dark text-white': $q.dark.mode,
            'bg-white text-black': !$q.dark.mode,
          }"
        >
          <q-item-section avatar>
            <q-img
              :src="items.flag"
              style="height: 30px; width: 40px"
              loading="lazy"
              fit="cover"
            >
              <template v-slot:loading>
                <q-skeleton
                  height="30px"
                  width="40px"
                  square
                  class="bg-grey-2"
                />
              </template>
            </q-img>
          </q-item-section>
          <q-item-section>
            <q-item-label lines="1">{{ items.title }}</q-item-label>
            <q-item-label lines="1" caption>{{
              items.description
            }}</q-item-label>
          </q-item-section>
          <q-item-section side>
            <q-radio
              v-model="language"
              :val="items.code"
              @click="setData(items)"
            />
          </q-item-section>
        </q-item>
      </q-list>
    </q-page>

    <q-footer class="bg-white q-pa-md text-dark myshadow">
      <q-btn
        unelevated
        no-caps
        color="amber-6"
        text-color="disabled"
        class="full-width text-weight-bold radius10"
        size="lg"
        @click="setLanguage"
        :loading="loading"
      >
        <div class="text-weight-bold text-subtitle2">{{ $t("Save") }}</div>
      </q-btn>
    </q-footer>
  </q-pull-to-refresh>
</template>

<script>
import { useDataStore } from "stores/DataStore";
import { useDataPersisted } from "stores/DataPersisted";
import { api } from "boot/axios";
import APIinterface from "src/api/APIinterface";
import { loadAppSettings } from "src/api/SettingsLoader";

export default {
  name: "LanguageList",
  setup(props) {
    const DataStore = useDataStore();
    const DataPersisted = useDataPersisted();
    return { DataStore, DataPersisted };
  },
  data() {
    return {
      language: "",
      loading: false,
    };
  },
  mounted() {
    this.DataStore.page_title = this.$t("Select Language");
    this.language = this.DataPersisted.app_language;
  },
  methods: {
    setData(data) {
      this.DataStore.selected_lang_data = data;
    },
    async setLanguage() {
      console.log(this.DataStore.selected_lang_data);
      let RTL = false;
      if (Object.keys(this.DataStore.selected_lang_data).length > 0) {
        RTL = !APIinterface.empty(this.DataStore.selected_lang_data.rtl)
          ? this.DataStore.selected_lang_data.rtl
          : false;
      }
      this.DataPersisted.app_language = this.language;
      this.DataPersisted.rtl = RTL;
      this.$i18n.locale = this.language;
      this.$q.lang.set({ rtl: RTL });
      api.defaults.params = {};
      api.defaults.params["language"] = this.$i18n.locale;

      this.DataStore.page_title = this.$t("Select Language");

      try {
        this.loading = true;
        await loadAppSettings();
      } catch (error) {
        console.error("Error loading settings:", error);
      } finally {
        this.loading = false;
      }
    },
    async refresh(done) {
      try {
        await loadAppSettings();
        done();
      } catch (error) {
        done();
      } finally {
      }
    },
  },
};
</script>
