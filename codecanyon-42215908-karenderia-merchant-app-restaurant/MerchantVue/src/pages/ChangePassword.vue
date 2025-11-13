<template>
  <q-page class="bg-white text-dark">
    <q-form @submit="onSubmit">
      <div class="q-pa-md q-gutter-sm">
        <q-input
          outlined
          v-model="old_password"
          :placeholder="$t('Old Password')"
          stack-label
          lazy-rules
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
          type="password"
          hide-bottom-space
          autocomplete="new-password"
        />

        <q-input
          outlined
          v-model="new_password"
          :placeholder="$t('New Password')"
          stack-label
          lazy-rules
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
          type="password"
          hide-bottom-space
        />

        <q-input
          outlined
          v-model="confirm_password"
          :placeholder="$t('Confirm Password')"
          stack-label
          lazy-rules
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
          type="password"
          hide-bottom-space
        />
      </div>

      <q-footer class="bg-white q-pa-md text-dark myshadow">
        <q-btn
          type="submit"
          color="amber-6"
          text-color="disabled"
          unelevated
          class="full-width radius10"
          size="lg"
          no-caps
        >
          <div class="text-weight-bold text-subtitle2">{{ $t("Update") }}</div>
        </q-btn>
      </q-footer>
    </q-form>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";

export default {
  name: "ChangePassword",
  data() {
    return {
      old_password: "",
      new_password: "",
      confirm_password: "",
      loading: false,
    };
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  mounted() {
    this.DataStore.page_title = this.$t("Change password");
  },
  methods: {
    onSubmit() {
      this.loading = true;
      APIinterface.fetchDataByToken("updatePassword", {
        old_password: this.old_password,
        new_password: this.new_password,
        confirm_password: this.confirm_password,
      })
        .then((data) => {
          APIinterface.ShowSuccessful(data.msg, this.$q);
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
