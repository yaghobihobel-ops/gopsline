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
        $t("Driving License")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page class="flex flex-center q-pl-md q-pr-md">
    <div class="full-width text-center">
      <q-form @submit="onSubmit">
        <div class="q-pa-md q-pt-md">
          <q-space class="q-pa-md"></q-space>

          <h6 class="text-weight-bold no-margin font16 line-normal">
            {{ $t("We need your driving license information") }}
          </h6>
          <p class="text-weight-light q-ma-none">
            {{ $t("Enter your license correctly") }}
          </p>
          <q-space class="q-pa-sm"></q-space>

          <q-input
            :label="$t('License number')"
            stack-label
            v-model="license_number"
            outlined
            color="grey-5"
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <q-input
            :label="$t('Expiration date')"
            stack-label
            v-model="license_expiration"
            outlined
            color="grey-5"
            mask="####/##/##"
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
            placeholder="YYYY/MM/DD"
          />
        </div>

        <q-footer
          class="q-pa-md"
          :class="{
            'bg-mydark ': $q.dark.mode,
            'bg-white ': !$q.dark.mode,
          }"
        >
          <q-btn
            type="submit"
            class="fit"
            unelevated
            color="primary"
            :label="$t('Continue')"
            no-caps
            size="lg"
          />
        </q-footer>
      </q-form>
    </div>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "DrivingLicense",
  data() {
    return {
      driver_uuid: "",
      license_number: "",
      license_expiration: "",
    };
  },
  created() {
    this.driver_uuid = this.$route.query.uuid;
  },
  methods: {
    onSubmit() {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.addLicense({
        driver_uuid: this.driver_uuid,
        license_number: this.license_number,
        license_expiration: this.license_expiration,
      })
        .then((data) => {
          this.$router.push({
            path: "/account/attach_license_photo",
            query: { uuid: this.driver_uuid },
          });
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
  },
};
</script>
