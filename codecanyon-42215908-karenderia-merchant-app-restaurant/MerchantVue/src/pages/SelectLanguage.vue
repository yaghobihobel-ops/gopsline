<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-header
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
    >
      <q-toolbar>
        <q-toolbar-title class="text-weight-bold">{{
          $t("Select Language")
        }}</q-toolbar-title>
      </q-toolbar>
      <q-separator></q-separator>
    </q-header>
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
      class="q-pa-md"
    >
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
            <q-avatar square>
              <q-img
                :src="items.flag"
                spinner-color="secondary"
                style="height: 25px; max-width: 40px"
                spinner-size="sm"
              />
            </q-avatar>
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

    <q-footer
      reveal
      class="row q-gutter-sm q-pa-md"
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-black': !$q.dark.mode,
      }"
    >
      <q-btn
        color="dark"
        size="lg"
        rounded
        unelevated
        no-caps
        flat
        class="col"
        to="/login"
        >{{ $t("Skip") }}</q-btn
      >

      <q-btn
        color="primary"
        size="lg"
        rounded
        unelevated
        no-caps
        class="col"
        @click="setLanguage"
        :loading="loading"
        >{{ $t("Save") }}</q-btn
      >
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
  name: "SelectLanguage",
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
  created() {
    this.language = this.DataPersisted.app_language;
  },
  methods: {
    setData(data) {
      this.DataStore.selected_lang_data = data;
    },
    async setLanguage() {
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

      try {
        this.loading = true;
        await loadAppSettings();
      } catch (error) {
        console.error("Error loading settings:", error);
      } finally {
        this.loading = false;
      }

      this.DataStore.choose_language = true;
      this.$router.replace("/login");
    },
    async refresh(done) {
      try {
        await loadAppSettings();
        done();
      } catch (error) {
        console.error("Error loading settings:", error);
        done();
      } finally {
      }
    },
  },
};
</script>
