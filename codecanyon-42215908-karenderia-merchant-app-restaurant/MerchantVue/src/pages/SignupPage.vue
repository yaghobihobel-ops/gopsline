<template>
  <q-header class="bg-white text-dark myshadow">
    <q-toolbar>
      <q-btn
        round
        icon="keyboard_arrow_left"
        color="blue-grey-1"
        text-color="blue-grey-8"
        unelevated
        dense
        @click="$router.back()"
      ></q-btn>
      <q-toolbar-title>{{ $t("Signup") }}</q-toolbar-title>
    </q-toolbar>
  </q-header>
  <q-page class="q-pt-md">
    <ListLoading v-if="DataStore.loading"></ListLoading>
    <q-form v-else @submit="onSubmit">
      <div class="q-pl-md q-pr-md">
        <h6 class="text-weight-bold no-margin">
          {{ $t("Become Restaurant partner") }}
        </h6>
        <p class="text-weight-light q-ma-none">
          {{ $t("Get a sales boost of up to 30% from takeaways") }}
        </p>
        <q-space class="q-pa-sm"></q-space>

        <q-input
          v-model="restaurant_name"
          :label="$t('Store name')"
          outlined
          stack-label
          color="grey-5"
          lazy-rules
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />

        <SearchAddress
          ref="search_address"
          @after-selectaddress="afterSelectaddress"
          :placeholder="$t('Store address')"
        />

        <q-space class="q-pa-sm"></q-space>

        <q-input
          v-model="contact_email"
          :label="$t('Email address')"
          outlined
          stack-label
          color="grey-5"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />

        <MobilePhone ref="mobile_phone" @after-input="afterInput"></MobilePhone>
      </div>

      <div
        v-if="DataStore.getRegistrationSettings.multicurrency_enabled"
        class="q-pl-md q-pr-md"
      >
        <div class="text-subtitle2">{{ $t("Select your currency") }}</div>

        <q-select
          v-model="currency"
          :label="$t('Currency')"
          :options="DataStore.getRegistrationSettings.currency_list"
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
      </div>

      <div class="q-pl-md q-pr-md">
        <p class="no-margin">{{ $t("Choose your membership program") }}</p>
      </div>

      <q-list dense class="q-mb-sm" v-if="hasData">
        <template
          v-for="items in DataStore.registration_settings.membership_list"
          :key="items"
        >
          <q-item
            tag="label"
            v-ripple
            v-if="
              DataStore.registration_settings.registration_program.includes(
                String(items.type_id)
              )
            "
          >
            <q-item-section avatar>
              <q-radio
                v-model="membership_type"
                :val="items.type_id"
                color="secondary"
              />
            </q-item-section>
            <q-item-section>
              <q-item-label>
                {{ items.type_name }}
              </q-item-label>
            </q-item-section>
          </q-item>
        </template>
      </q-list>

      <template v-if="membership_type == 1">
        <div class="q-pl-md q-pr-md q-mb-md">
          <div class="text-subtitle2 q-pb-sm">
            {{ $t("Choose your services") }}
          </div>

          <template
            v-for="item_service in DataStore.getRegistrationSettings
              .services_list"
            :key="item_service"
          >
            <q-checkbox
              v-model="services"
              :val="item_service.service_code"
              :label="item_service.service_name"
              color="primary"
            />
          </template>
        </div>
      </template>
      <template v-else>
        <div class="text-subtitle2 q-pl-md q-pr-md q-pb-sm">
          {{ $t("Choose your services") }}
        </div>
        <q-list dense>
          <q-item
            v-for="item_service in DataStore.getRegistrationSettings
              .services_list"
            :key="item_service"
            tag="label"
            v-ripple
            class="q-mb-sm"
          >
            <q-item-section avatar top>
              <q-checkbox
                v-model="services"
                :val="item_service.service_code"
                color="primary"
              />
            </q-item-section>
            <q-item-section top>
              <q-item-label>{{ item_service.service_name }}</q-item-label>
              <q-item-label caption>
                {{
                  $t(item_service.description, {
                    site_name: DataStore.getRegistrationSettings.site_name,
                    transaction_type: item_service.service_name,
                  })
                }}
              </q-item-label>
              <q-item-label
                caption
                v-if="
                  DataStore.getRegistrationSettings.membership_commission[
                    membership_type
                  ]
                "
              >
                <!-- {{
                  DataStore.getRegistrationSettings.membership_commission[
                    membership_type
                  ][item_service.service_code].commission
                }}%  -->
                <!-- {{ $t("fee per order") }} -->
              </q-item-label>
            </q-item-section>
          </q-item>
        </q-list>
        <q-space class="q-pa-sm"></q-space>
      </template>

      <div class="q-pl-md q-pr-md">
        <p class="font11">
          <span v-html="DataStore.registration_settings.terms"></span>
        </p>
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
          color="primary"
          text-color="white"
          unelevated
          class="full-width"
          size="lg"
          rounded
          no-caps
          :loading="loading"
        >
          <div class="text-weight-bold text-subtitle2">
            {{ $t("Submit") }}
          </div>
        </q-btn>
      </q-footer>
    </q-form>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";

export default {
  name: "SignupPage",
  data() {
    return {
      restaurant_name: "",
      loading: false,
      membership_type: "1",
      address: "",
      contact_email: "",
      phone: [],
      latitude: "",
      lontitude: "",
      services: [],
      currency: "",
    };
  },
  components: {
    ListLoading: defineAsyncComponent(() =>
      import("components/ListLoading.vue")
    ),
    SearchAddress: defineAsyncComponent(() =>
      import("components/SearchAddress.vue")
    ),
    MobilePhone: defineAsyncComponent(() =>
      import("components/MobilePhone.vue")
    ),
  },
  computed: {
    hasData() {
      if (!APIinterface.empty(this.DataStore.registration_settings)) {
        if (Object.keys(this.DataStore.registration_settings).length > 0) {
          return true;
        }
      }
      return false;
    },
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  methods: {
    afterSelectaddress(data) {
      this.address = data.address.formatted_address;
      this.latitude = data.latitude;
      this.lontitude = data.longitude;
    },
    afterInput(data) {
      this.phone = data;
    },
    onSubmit() {
      this.loading = true;
      APIinterface.fetchData("CreateAccountMerchant", {
        address: this.address,
        contact_email: this.contact_email,
        membership_type: this.membership_type,
        phone: this.phone,
        restaurant_name: this.restaurant_name,
        latitude: this.latitude,
        lontitude: this.lontitude,
        services: this.services,
        currency: this.currency,
      })
        .then((data) => {
          this.$router.push({
            path: "/signup/create-user",
            query: { uuid: data.details.merchant_uuid },
          });
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
