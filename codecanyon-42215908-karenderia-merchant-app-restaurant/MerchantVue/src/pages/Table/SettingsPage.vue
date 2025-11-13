<template>
  <q-page
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-grey-1 text-dark': !$q.dark.mode,
    }"
    class="q-pr-md q-pl-md"
  >
    <div class="q-mt-md q-mb-md">
      <TabsRouterMenu :tab_menu="GlobalStore.TableMenu"></TabsRouterMenu>
    </div>

    <template v-if="loading">
      <q-inner-loading :showing="true" color="primary" size="md" />
    </template>
    <q-card class="q-pa-none no-shadow" v-else>
      <q-card-section class="q-pa-sm">
        <q-form @submit="formSubmit">
          <q-toggle
            v-model="booking_enabled"
            :label="$t('Enabled Reservation')"
            color="primary"
          />
          <q-toggle
            v-model="booking_enabled_capcha"
            :label="$t('Enabled Captcha')"
            color="primary"
          />
          <q-toggle
            v-model="booking_allowed_choose_table"
            :label="$t('Allowed guest choose table')"
            color="primary"
          />

          <q-space class="q-pa-sm"></q-space>

          <p>
            {{ $t("Online booking custom confirmation message (optional)") }}
          </p>
          <q-input
            v-model="booking_reservation_custom_message"
            type="textarea"
            outlined
            autogrow
            stack-label
            color="grey-5"
          />

          <q-space class="q-pa-sm"></q-space>

          <p>{{ $t("Online booking T&C (optional)") }}</p>
          <q-input
            v-model="booking_reservation_terms"
            type="textarea"
            outlined
            autogrow
            stack-label
            color="grey-5"
          />
          <q-space class="q-pa-md"></q-space>
          <q-btn
            type="submit"
            color="primary"
            text-color="white"
            :label="$t('Save')"
            unelevated
            class="full-width radius8"
            size="lg"
            no-caps
            :loading="loading_submit"
          />
        </q-form>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { defineAsyncComponent } from "vue";
import { useGlobalStore } from "stores/GlobalStore";

export default {
  name: "SettingsPage",
  components: {
    TabsRouterMenu: defineAsyncComponent(() =>
      import("components/TabsRouterMenu.vue")
    ),
  },
  data() {
    return {
      loading: true,
      loading_submit: false,
      data: [],
      booking_enabled: false,
      booking_enabled_capcha: false,
      booking_allowed_choose_table: false,
      booking_reservation_custom_message: "",
      booking_reservation_terms: "",
    };
  },
  setup(props) {
    const GlobalStore = useGlobalStore();
    return { GlobalStore };
  },
  mounted() {
    this.getBookingSettings();
  },
  computed: {
    getData() {
      return this.data;
    },
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    getBookingSettings() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("BookingSettings")
        .then((data) => {
          this.booking_enabled = data.details.data.booking_enabled;
          this.booking_enabled_capcha =
            data.details.data.booking_enabled_capcha;
          this.booking_allowed_choose_table =
            data.details.data.booking_allowed_choose_table;
          this.booking_reservation_custom_message =
            data.details.data.booking_reservation_custom_message;
          this.booking_reservation_terms =
            data.details.data.booking_reservation_terms;
        })
        .catch((error) => {})
        .then((data) => {
          this.loading = false;
        });
    },
    formSubmit() {
      this.loading_submit = true;
      APIinterface.fetchDataByTokenPost("SaveBookingSettings", {
        booking_enabled: this.booking_enabled,
        booking_enabled_capcha: this.booking_enabled_capcha,
        booking_allowed_choose_table: this.booking_allowed_choose_table,
        booking_reservation_custom_message:
          this.booking_reservation_custom_message,
        booking_reservation_terms: this.booking_reservation_terms,
      })
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading_submit = false;
        });
    },
  },
};
</script>
