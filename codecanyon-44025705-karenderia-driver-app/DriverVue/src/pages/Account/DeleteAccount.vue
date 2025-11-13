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
        $t("Delete account")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page class="row items-stretch">
    <template v-if="loading">
      <div
        class="flex flex-center full-width q-pa-xl"
        style="min-height: calc(50vh)"
      >
        <q-spinner color="primary" size="2em" />
      </div>
    </template>
    <template v-else>
      <div class="col-12">
        <div class="q-pa-md">
          <div class="text-weight-bold">
            {{
              $t(
                "You are requesting to have your account deleted and personal information removed"
              )
            }}.
          </div>
          <q-space class="q-pa-sm"></q-space>
          <p>
            {{
              $t(
                "You will permanently lose all your orders, reviews,favorites and profile information, there is no turning back"
              )
            }}.
          </p>
        </div>
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
          :label="$t('Confirm Deletion')"
          unelevated
          class="full-width"
          size="lg"
          no-caps
          :loading="loading"
          @click="confirmDeletion"
        />
      </q-footer>
    </template>
    <StepsVerification
      ref="steps_verify"
      :sent_message="sent_message"
      @after-verifycode="afterVerifycode"
    ></StepsVerification>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";

export default {
  // name: 'PageName',
  data() {
    return {
      loading: false,
      sent_message: "",
    };
  },
  components: {
    StepsVerification: defineAsyncComponent(() =>
      import("components/StepsVerification.vue")
    ),
  },
  created() {
    this.requestCode();
  },
  methods: {
    requestCode() {
      this.loading = true;
      APIinterface.fetchDataByToken("requestcode2", {})
        .then((data) => {
          this.sent_message = data.msg;
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    confirmDeletion() {
      this.$refs.steps_verify.show_modal = true;
    },
    afterVerifycode(data) {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost("deleteaccount", "code=" + data)
        .then((data) => {
          this.sent_message = data.msg;
          this.$refs.steps_verify.show_modal = false;
          this.$router.replace("/account/deletety");
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
