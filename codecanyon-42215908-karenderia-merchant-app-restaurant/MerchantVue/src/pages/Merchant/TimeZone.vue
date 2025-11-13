<template>
  <q-page
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-grey-1 text-dark': !$q.dark.mode,
    }"
    class="q-pr-md q-pl-md"
  >
    <div class="q-mt-md q-mb-md">
      <TabsRouterMenu :tab_menu="GlobalStore.merchantMenu"></TabsRouterMenu>
    </div>

    <template v-if="loading">
      <q-inner-loading :showing="true" color="primary" size="md" />
    </template>
    <q-card class="q-pa-none no-shadow" v-else>
      <q-card-section>
        <q-form @submit="onSubmit">
          <q-select
            v-model="merchant_timezone"
            :options="timelist"
            :label="$t('Set Your Time Zone')"
            stack-label
            behavior="dialog"
            outlined
            color="grey-5"
            emit-value
            map-options
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <q-input
            outlined
            v-model="merchant_time_picker_interval"
            :label="$t('Time interval')"
            stack-label
            color="grey-5"
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <q-space class="q-pa-sm"></q-space>
          <q-btn
            type="submit"
            color="primary"
            text-color="white"
            :label="$t('Save')"
            unelevated
            class="full-width radius8"
            size="lg"
            no-caps
          />
        </q-form>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useGlobalStore } from "stores/GlobalStore";
import APIinterface from "src/api/APIinterface";

export default {
  name: "TimeZone",
  data() {
    return {
      loading: false,
      merchant_timezone: "",
      merchant_time_picker_interval: "",
      timelist: [],
    };
  },
  components: {
    TabsRouterMenu: defineAsyncComponent(() =>
      import("components/TabsRouterMenu.vue")
    ),
  },
  setup(props) {
    const GlobalStore = useGlobalStore();
    return { GlobalStore };
  },
  mounted() {
    this.getTimezonedata();
  },
  methods: {
    getTimezonedata() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getTimezonedata")
        .then((data) => {
          this.merchant_timezone = data.details.merchant_timezone;
          this.merchant_time_picker_interval =
            data.details.merchant_time_picker_interval;
          this.timelist = data.details.timelist;
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    onSubmit() {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByToken("saveTimezonedata", {
        merchant_timezone: this.merchant_timezone,
        merchant_time_picker_interval: this.merchant_time_picker_interval,
      })
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
  },
};
</script>
