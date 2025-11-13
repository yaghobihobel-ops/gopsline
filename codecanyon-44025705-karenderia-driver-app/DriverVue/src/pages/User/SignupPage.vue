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
        $t("Signup")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page class="q-pt-md">
    <ListLoading v-if="inner_loading"></ListLoading>
    <q-form v-else @submit="onSubmit" class="q-pl-md q-pr-md">
      <h6 class="text-weight-bold no-margin font16">
        {{ $t("Become our delivery partner") }}
      </h6>
      <p class="text-weight-light q-ma-none">{{ $t("Get paid to deliver") }}</p>
      <q-space class="q-pa-sm"></q-space>

      <q-input
        v-model="first_name"
        :label="$t('First name')"
        outlined
        color="grey-5"
        lazy-rules
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      >
      </q-input>

      <q-input
        v-model="last_name"
        :label="$t('Last name')"
        outlined
        color="grey-5"
        lazy-rules
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      >
      </q-input>

      <q-input
        v-model="address"
        :label="$t('Complete address')"
        outlined
        color="grey-5"
        lazy-rules
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
        autogrow
      >
      </q-input>

      <q-input
        v-model="email"
        type="email"
        :label="$t('Email address')"
        outlined
        color="grey-5"
        lazy-rules
        :rules="[
          (val, rules) =>
            rules.email(val) || 'Please enter a valid email address',
        ]"
      >
      </q-input>

      <q-input
        v-model="phone"
        mask="##############"
        outlined
        lazy-rules
        color="grey-5"
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      >
        <template v-slot:prepend>
          <q-select
            dense
            v-model="phone_prefix"
            :options="options"
            @filter="filterFn"
            behavior="dialog"
            input-debounce="700"
            style="border: none"
            emit-value
            borderless
            class="myq-field"
          >
            <template v-slot:option="{ itemProps, opt }">
              <q-item v-bind="itemProps">
                <q-item-section avatar>
                  <q-img
                    :src="opt.flag"
                    style="height: 15px; max-width: 20px"
                  />
                </q-item-section>
                <q-item-section>
                  <q-item-label>{{ opt.label }}</q-item-label>
                </q-item-section>
              </q-item>
            </template>
            <template v-slot:no-option>
              <q-item>
                <q-item-section class="text-grey">
                  {{ $t("No results") }}
                </q-item-section>
              </q-item>
            </template>
          </q-select>
        </template>
      </q-input>

      <q-input
        v-model="password"
        :label="$t('Password')"
        :type="field_type"
        outlined
        color="grey-5"
        lazy-rules
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      >
        <template v-slot:prepend>
          <q-icon
            name="las la-lock"
            color="grey"
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />
        </template>
        <template v-slot:append>
          <q-icon
            @click="field_type = field_type == 'password' ? 'text' : 'password'"
            :name="FieldIcon"
            color="grey"
            class="cursor-pointer"
          />
        </template>
      </q-input>

      <q-input
        v-model="confirm_password"
        :label="$t('Confirm password')"
        :type="field_type2"
        outlined
        color="grey-5"
        lazy-rules
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      >
        <template v-slot:prepend>
          <q-icon
            name="las la-lock"
            color="grey"
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />
        </template>
        <template v-slot:append>
          <q-icon
            @click="
              field_type2 = field_type2 == 'password' ? 'text' : 'password'
            "
            :name="FieldIcon2"
            color="grey"
            class="cursor-pointer"
          />
        </template>
      </q-input>

      <p class="font11">
        <span v-html="terms"></span>
      </p>

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
          :label="$t('Submit')"
          unelevated
          class="full-width"
          size="lg"
          no-caps
          :loading="loading"
        />
      </q-footer>
    </q-form>
  </q-page>
</template>

<script>
import { defineComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { defineAsyncComponent } from "vue";

export default defineComponent({
  name: "SignupPage",
  data() {
    return {
      loading: false,
      inner_loading: true,
      first_name: "",
      last_name: "",
      email: "",
      address: "",
      phone_prefix: "",
      phone: "",
      field_type: "password",
      field_type2: "password",
      password: "",
      confirm_password: "",
      options: [],
      terms: this.$t(
        "By clicking submit you agree to our terms and conditions"
      ),
    };
  },
  components: {
    ListLoading: defineAsyncComponent(() =>
      import("components/ListLoading.vue")
    ),
  },
  computed: {
    FieldIcon() {
      return this.field_type === "password"
        ? "eva-eye-outline"
        : "eva-eye-off-outline";
    },
    FieldIcon2() {
      return this.field_type2 === "password"
        ? "eva-eye-outline"
        : "eva-eye-off-outline";
    },
  },
  mounted() {
    this.getLocationCountries();
  },
  methods: {
    getLocationCountries() {
      this.inner_loading = true;
      APIinterface.getLocationCountries()
        .then((data) => {
          this.phone_prefix = "+" + data.details.default_data.phonecode;
          if (Object.keys(data.details.data).length > 0) {
            Object.entries(data.details.data).forEach(([key, items]) => {
              this.options.push({
                label: "+" + items.phonecode + " " + items.country_name,
                value: "+" + items.phonecode,
                flag: items.flag,
              });
            });
          }
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.inner_loading = false;
        });
    },
    onSubmit() {
      this.loading = true;
      APIinterface.registerUser({
        first_name: this.first_name,
        last_name: this.last_name,
        email: this.email,
        address: this.address,
        phone_prefix: this.phone_prefix,
        phone: this.phone,
        password: this.password,
        confirm_password: this.confirm_password,
      })
        .then((data) => {
          this.$router.replace({
            path: "/account/verify",
            query: { uuid: data.details.uuid, msg: data.msg },
          });
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
});
</script>
