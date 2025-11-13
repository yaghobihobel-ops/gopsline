<template>
  <q-header
    reveal
    reveal-offset="10"
    :class="{
      'bg-custom-grey text-dark': !$q.dark.mode,
      'bg-grey600 text-grey300': $q.dark.mode,
    }"
  >
    <q-toolbar style="border-bottom-right-radius: 25px">
      <q-btn
        @click="$router.back()"
        flat
        round
        dense
        icon="eva-arrow-ios-back-outline"
      />
      <q-toolbar-title style="font-size: 14px">{{
        $t("Delete Account")
      }}</q-toolbar-title>
    </q-toolbar>
  </q-header>
  <q-page padding>
    <div class="text-body2 text-weight-bold q-mb-sm">
      {{
        $t(
          "Your are requesting to have your account deleted and personal information removed"
        )
      }}.
    </div>
    <p class="text-body2">
      {{
        $t(
          "Your account will be deactivated and will permanently deleted after reviewed by admin"
        )
      }}.
    </p>

    <q-btn
      no-caps
      :label="$t('Confirm Deletion')"
      unelevated
      color="red-9"
      text-color="red-2"
      class="radius-10"
      @click="RequestCode"
      :loading="loading_code"
      :size="$q.screen.gt.sm ? 'lg' : '15px'"
    ></q-btn>

    <TwoStepsVerification
      ref="ref_twosteps"
      :loading="loading_delete"
      :loading_resend="loading_code"
      :message="sentcode_message"
      @after-submitcode="deleteAccount"
      @request-code="RequestCode"
    ></TwoStepsVerification>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useKitchenStore } from "stores/KitchenStore";

export default {
  name: "DeletesAccount",
  components: {
    TwoStepsVerification: defineAsyncComponent(() =>
      import("components/TwoStepsVerification.vue")
    ),
  },
  setup() {
    const KitchenStore = useKitchenStore();
    return { KitchenStore };
  },
  data() {
    return {
      loading_code: false,
      loading_delete: false,
      sentcode_message: "",
    };
  },
  methods: {
    async RequestCode() {
      this.loading_code = true;
      let response = await this.KitchenStore.requestCode();
      this.loading_code = false;
      if (response.code == 1) {
        this.sentcode_message = response.msg;
        this.$refs.ref_twosteps.startTimer();
        this.$refs.ref_twosteps.modal = true;
      } else {
        APIinterface.notify(
          this.$q,
          "",
          response.msg,
          "myerror",
          "highlight_off",
          "bottom"
        );
      }
    },
    async deleteAccount(value) {
      this.loading_delete = true;
      let response = await this.KitchenStore.deleteAccount(value);
      this.loading_delete = false;
      if (response.code == 1) {
        this.$refs.ref_twosteps.modal = false;
        this.$router.replace("/delete-account");
      } else {
        APIinterface.notify(
          this.$q,
          "",
          response.msg,
          "myerror",
          "highlight_off",
          "bottom"
        );
      }
    },
    //
  },
};
</script>
