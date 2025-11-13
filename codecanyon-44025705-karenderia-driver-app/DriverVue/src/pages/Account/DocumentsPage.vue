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
        $t("Documents")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page>
    <template v-if="loading">
      <div
        class="flex flex-center full-width q-pa-xl"
        style="min-height: calc(50vh)"
      >
        <q-spinner color="primary" size="2em" />
      </div>
    </template>
    <template v-else>
      <q-card class="no-shadow">
        <q-card-section>
          <div class="row items-start q-gutter-sm">
            <div class="col-4">
              <div
                class="bg-orange-7 text-white flex flex-center rounded-borders"
                style="min-height: 90px"
              >
                <q-icon name="las la-user" size="5em" />
              </div>
            </div>
            <div class="col">
              <q-skeleton type="rect" animation="none" class="bg-grey-2" />
              <q-space class="q-pa-xs"></q-space>
              <q-skeleton type="text" animation="none" class="bg-grey-2" />
              <q-skeleton type="text" animation="none" class="bg-grey-2" />
              <q-skeleton type="text" animation="none" class="bg-grey-2" />
            </div>
          </div>

          <q-btn
            dense
            no-caps
            flat
            color="primary"
            class="full-width q-mt-md"
            to="/account/license-photo"
            size="lg"
          >
            {{ $t("Update Photo") }}
          </q-btn>
        </q-card-section>
      </q-card>

      <q-form @submit="onSubmit" class="q-pa-md q-pt-md">
        <q-input
          v-model="license_number"
          :label="$t('License number')"
          outlined
          color="grey-5"
          lazy-rules
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        >
        </q-input>

        <q-input
          v-model="license_expiration"
          :label="$t('Expiration date')"
          outlined
          color="grey-5"
          mask="####/##/##"
          lazy-rules
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        >
        </q-input>

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
            :label="$t('Update')"
            unelevated
            class="full-width"
            size="lg"
            no-caps
            :loading="loading"
          />
        </q-footer>
      </q-form>
    </template>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  // name: 'PageName',
  data() {
    return {
      license_number: "",
      license_expiration: "",
      loading: false,
    };
  },
  created() {
    this.getLicense();
  },
  methods: {
    getLicense() {
      this.loading = true;
      APIinterface.fetchDataByToken("getlicense", {})
        .then((data) => {
          this.license_number = data.details.license_number;
          this.license_expiration = data.details.license_expiration;
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    onSubmit() {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByToken("updatelicense", {
        license_number: this.license_number,
        license_expiration: this.license_expiration,
      })
        .then((data) => {
          APIinterface.notify("green-5", data.msg, "check_circle", this.$q);
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
  },
};
</script>
