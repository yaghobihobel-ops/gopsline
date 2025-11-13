<template>
  <q-dialog
    v-model="dialog"
    class="rounded-borders-top"
    @before-show="beforeShow"
    :maximized="true"
    persistent
    transition-show="fade"
  >
    <q-card>
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <q-toolbar-title
          class="text-darkx text-weight-bold"
          style="overflow: inherit"
          :class="{
            'text-white': $q.dark.mode,
            'text-dark': !$q.dark.mode,
          }"
        >
          {{ $t("Customer") }}
        </q-toolbar-title>
        <q-space></q-space>
        <q-btn
          @click="dialog = !true"
          color="white"
          square
          unelevated
          text-color="grey"
          icon="las la-times"
          dense
          no-caps
          size="sm"
          class="border-grey radius8"
        />
      </q-toolbar>
      <q-card-section>
        <q-form @submit="onSubmit">
          <q-input
            outlined
            v-model="first_name"
            :label="$t('First name')"
            stack-label
            color="grey-5"
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <q-input
            outlined
            v-model="last_name"
            :label="$t('Last name')"
            stack-label
            color="grey-5"
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <q-input
            outlined
            v-model="email_address"
            :label="$t('Email address')"
            stack-label
            color="grey-5"
            lazy-rules
            :rules="[
              (val, rules) =>
                rules.email(val) ||
                this.$t('Please enter a valid email address'),
            ]"
          />

          <q-input
            outlined
            v-model="contact_number"
            :label="$t('Contact number')"
            stack-label
            color="grey-5"
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <q-footer>
            <q-btn
              type="submit"
              color="primary"
              text-color="white"
              :label="$t('Submit')"
              unelevated
              class="full-width"
              size="lg"
              no-caps
              :loading="loading"
            />
          </q-footer>
        </q-form>
      </q-card-section>
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "CreateCustomer",
  data() {
    return {
      dialog: false,
      first_name: "",
      last_name: "",
      email_address: "",
      contact_number: "",
      loading: false,
    };
  },
  setup() {
    return {};
  },
  methods: {
    onSubmit() {
      this.loading = true;
      let params = "";
      params = "first_name=" + this.first_name;
      params += "&last_name=" + this.last_name;
      params += "&email_address=" + this.email_address;
      params += "&contact_number=" + this.contact_number;

      APIinterface.fetchDataByTokenPost("createCustomer", params)
        .then((data) => {
          this.dialog = false;
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
          this.$emit("afterCreatecustomer", {
            id: data.details.client_id,
            data: [
              {
                label: data.details.client_name,
                value: data.details.client_id,
              },
            ],
          });
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
