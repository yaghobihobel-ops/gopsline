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
        $t("Language")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page class="q-pa-md">
    <q-list>
      <q-item
        v-for="items in Activity.lang_data.data"
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
          <q-item-label lines="1" caption>{{ items.description }}</q-item-label>
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

    <q-footer
      class="q-pa-md"
      :class="{
        'bg-mydark ': $q.dark.mode,
        'bg-white ': !$q.dark.mode,
      }"
    >
      <q-btn
        type="submit"
        color="primary"
        text-color="white"
        :label="$t('Save')"
        unelevated
        class="full-width"
        size="lg"
        no-caps
        :loading="loading"
        @click="setLanguage"
      />
    </q-footer>
  </q-page>
</template>

<script>
import { useActivityStore } from "stores/ActivityStore";
import { api } from "boot/axios";
import APIinterface from "src/api/APIinterface";

export default {
  name: "LanguageSelection",
  data() {
    return {
      language: "",
      selected_lang_data: [],
    };
  },
  created() {
    this.language = this.Activity.app_language;
  },
  setup() {
    const Activity = useActivityStore();
    return { Activity };
  },
  methods: {
    setData(data) {
      this.selected_lang_data = data;
    },
    async setLanguage() {
      let RTL = false;
      if (Object.keys(this.selected_lang_data).length > 0) {
        RTL = !APIinterface.empty(this.selected_lang_data.rtl)
          ? this.selected_lang_data.rtl
          : false;
      }

      this.Activity.rtl = RTL;
      this.$q.lang.set({ rtl: RTL });

      this.Activity.app_language = this.language;
      this.$i18n.locale = this.language;
      api.defaults.params = {};
      api.defaults.params["language"] = this.$i18n.locale;

      this.Activity.getSettings();
      this.$router.back();
    },
  },
};
</script>
