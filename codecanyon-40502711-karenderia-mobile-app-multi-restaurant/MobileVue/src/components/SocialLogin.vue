<template>
  <template v-if="hasSocialLogin">
    <div class="separator">
      <div class="line"></div>
      <span class="text">{{ $t("or") }}</span>
      <div class="line"></div>
    </div>
    <q-space class="q-pa-sm"></q-space>

    <div class="q-gutter-x-md">
      <template v-if="DataStore.google_login_enabled">
        <GoogleLogin
          :client_id="google_client_id"
          ref="google_login"
          @after-login="afterLogin"
        />
      </template>
      <template v-if="DataStore.fb_flag">
        <FacebookLogin
          ref="facebook_login"
          :app_id="facebook_app_id"
          @after-login="afterLogin"
        />
      </template>
    </div>
  </template>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useDataStore } from "stores/DataStore";
import { useClientStore } from "stores/ClientStore";
import { useDataStorePersisted } from "stores/DataStorePersisted";
import config from "src/api/config";
import APIinterface from "src/api/APIinterface";
import auth from "src/api/auth";

export default {
  name: "SocialLogin",
  props: ["redirect"],
  components: {
    GoogleLogin: defineAsyncComponent(() =>
      import("components/GoogleLogin.vue")
    ),
    FacebookLogin: defineAsyncComponent(() =>
      import("components/FacebookLogin.vue")
    ),
  },
  data() {
    return {
      google_client_id: null,
      facebook_app_id: "",
    };
  },
  setup() {
    const DataStore = useDataStore();
    const ClientStore = useClientStore();
    const DataStorePersisted = useDataStorePersisted();
    return { DataStore, ClientStore, DataStorePersisted };
  },
  mounted() {
    this.google_client_id = config.google_client_id;
    this.facebook_app_id = config.facebook_app_id;
  },
  computed: {
    hasSocialLogin() {
      return this.DataStore.google_login_enabled || this.DataStore.fb_flag;
    },
  },
  methods: {
    async afterLogin(data) {
      try {
        APIinterface.showLoadingBox("", this.$q);
        const response = await APIinterface.fetchData("SocialRegister", data);
        console.log("response", response);
        const isLogin = response?.details?.is_login ?? false;
        const verificationNeeded = response?.details?.verify ?? false;
        console.log("isLogin", isLogin);
        console.log("verificationNeeded", verificationNeeded);

        if (verificationNeeded) {
          this.$router.push({
            path: "/user/verify-otp",
            query: {
              uuid: response.details.uuid,
              msg: response.msg,
              action: "verifiySocialSignup",
              validation_type: "email",
            },
          });
          return;
        }

        if (!isLogin) {
          this.$router.push({
            path: "/account/complete-registration",
            query: { uuid: response.details.uuid },
          });
          return;
        }

        // USE SET DATA
        auth.setUser(response.details.user_data);
        auth.setToken(response.details.user_token);
        this.ClientStore.user_settings = response.details.user_settings;

        const coordinates = this.DataStorePersisted.coordinates;
        const searchMode = this.DataStore.getSearchMode;
        const locationData = this.DataStorePersisted.getLocation;

        if (searchMode == "location") {
          if (!locationData) {
            this.$router.push("/location/add-location");
            return;
          }
        } else {
          if (!coordinates) {
            this.$router.push("/location/map");
            return;
          }
        }

        if (this.redirect) {
          this.$router.push(this.redirect);
        } else {
          this.$router.push("/home");
        }
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
  },
};
</script>
