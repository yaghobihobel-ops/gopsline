<template>
  <q-dialog
    v-model="dialog"
    position="bottom"
    @before-show="getCustomerReply"
    @before-hide="whenHide"
  >
    <q-card class="rounded-borders-top">
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <q-toolbar-title
          class="text-darkx text-weight-bold"
          style="overflow: inherit"
          :class="{
            'text-white': $q.dark.mode,
            'text-dark': !$q.dark.mode,
          }"
        >
          {{ $t("Add reply") }}
        </q-toolbar-title>
        <q-space></q-space>
        <div class="q-gutter-x-sm">
          <q-btn
            icon="las la-times"
            color="grey"
            flat
            round
            dense
            v-close-popup
          />
        </div>
      </q-toolbar>
      <q-card-section class="bg-grey-1 scroll" style="max-height: calc(50vh)">
        <template v-if="loading_reply">
          <div
            class="row q-gutter-x-sm justify-center q-my-md text-center full-width"
          >
            <q-circular-progress
              indeterminate
              rounded
              size="sm"
              color="primary"
            />
            <div class="text-subtitle1 text-grey">{{ $t("Loading") }}...</div>
          </div>
        </template>
        <template v-else>
          <q-chat-message
            :name="data?.customer_fullname"
            :text="[data.review]"
            :avatar="data.avatar"
            sent
            text-color="text"
            bg-color="white"
          />
          <template v-for="items in reply_data" :key="items">
            <q-chat-message
              :name="merchant?.restaurant_name"
              :text="[items?.review]"
              :avatar="merchant.avatar"
              text-color="white"
              bg-color="red"
            />
          </template>
        </template>
      </q-card-section>
      <q-card-actions
        class="footer-shadow row q-gutter-x-sm q-pa-md"
        v-if="!loading_reply"
      >
        <q-input
          v-model="reply_comment"
          :placeholder="$t('Enter your message here')"
          outlined
          autogrow
          class="col"
        >
        </q-input>
        <q-btn
          round
          size="18px"
          unelevated
          class="footer-shadow"
          color="red"
          text-color="white"
          :disabled="!reply_comment"
          @click="onSubmit"
          :loading="loading"
        >
          <img src="/svg/mynaui--send.svg" height="25" />
        </q-btn>
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "ReviewReply",
  props: ["data"],
  data() {
    return {
      dialog: false,
      reply_comment: "",
      loading: false,
      loading_reply: false,
      reply_data: [],
      merchant: null,
    };
  },
  computed: {
    hasData() {
      if (Object.keys(this.reply_data).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    whenHide() {
      this.reply_comment = "";
      this.reply_data = [];
    },
    onSubmit() {
      this.loading = true;
      APIinterface.fetchDataByToken("reviewAddreply", {
        id: this.data.id,
        reply_comment: this.reply_comment,
      })
        .then((data) => {
          APIinterface.ShowSuccessful(data.msg, this.$q);
          console.log("data", data);
          this.reply_data = [...this.reply_data, ...data.details.data];
          this.reply_comment = "";
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    getCustomerReply() {
      this.loading_reply = true;
      APIinterface.fetchDataByTokenPost(
        "getCustomerReply",
        "id=" + this.data.id
      )
        .then((data) => {
          this.reply_data = data.details.data;
          this.merchant = data.details.merchant;
        })
        .catch((error) => {
          this.reply_data = [];
        })
        .then((data) => {
          this.loading_reply = false;
        });
    },
    deleteReply(id) {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost("reviewDeleteReply", "id=" + id)
        .then((data) => {
          this.getCustomerReply();
        })
        .catch((error) => {
          //
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
  },
};
</script>
