<template>
  <q-page class="bg-white text-dark">
    <q-card
      flat
      class="col-12"
      :class="{
        'bg-mydark ': $q.dark.mode,
        'bg-white ': !$q.dark.mode,
      }"
    >
      <q-card-section>
        <div class="text-weight-bold text-body1">
          {{
            $t(
              "You are requesting to have your account deleted and personal information removed"
            )
          }}.
        </div>
        <q-space class="q-pa-sm"></q-space>
        <p class="text-body2 text-grey q-ma-none">
          {{
            $t(
              "Your account will be deactivated and will permanently deleted after reviewed by admin"
            )
          }}.
        </p>
      </q-card-section>
    </q-card>

    <q-footer class="bg-white q-pa-md text-dark myshadow">
      <q-btn
        unelevated
        no-caps
        color="amber-6"
        text-color="disabled"
        class="full-width text-weight-bold radius10"
        size="lg"
        :loading="loading"
        @click="RequestEmailCode"
      >
        <div class="text-weight-bold text-subtitle2">
          {{ $t("Confirm Deletion") }}
        </div>
      </q-btn>
    </q-footer>

    <StepsVerification
      ref="steps_verification"
      :sent_message="sent_message"
      @after-verifycode="afterVerifycode"
    />
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";

export default {
  name: "DeleteAccount",
  components: {
    StepsVerification: defineAsyncComponent(() =>
      import("components/StepsVerification.vue")
    ),
  },
  setup(props) {
    const DataStore = useDataStore();
    return { DataStore };
  },
  data() {
    return {
      loading: false,
      sent_message: "",
    };
  },
  mounted() {
    this.DataStore.page_title = this.$t("Delete Account");
  },
  methods: {
    RequestEmailCode() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("RequestEmailCode", "")
        .then((data) => {
          this.sent_message = data.msg;
          this.show_modal = false;
          this.$refs.steps_verification.show_modal = true;
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    afterVerifycode(code) {
      this.loading = true;
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost("deleteAccount", "code=" + code)
        .then((data) => {
          this.$refs.steps_verification.show_modal = false;
          this.$router.replace("/account/deletety");
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading = false;
          APIinterface.hideLoadingBox(this.$q);
        });
    },
  },
};
</script>
