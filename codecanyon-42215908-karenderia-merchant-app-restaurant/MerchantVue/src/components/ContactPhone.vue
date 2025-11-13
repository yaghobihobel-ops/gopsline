<template>
  <q-dialog
    v-model="dialog"
    persistent
    transition-show="slide-up"
    transition-hide="slide-down"
  >
    <q-card style="width: 300px">
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <q-toolbar-title class="text-dark text-weight-bold">
          {{ $t("Contact customer") }}
        </q-toolbar-title>
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
      <q-card-section class="q-pl-md q-pr-md">
        <q-btn
          flat
          :text-color="$q.dark.mode ? 'grey300' : 'blue'"
          :href="`tel:${data.contact_number}`"
          >{{ data.contact_number }}</q-btn
        >
      </q-card-section>
      <q-footer
        class="border-grey-top q-pa-sm row"
        :class="{
          'bg-mydark ': $q.dark.mode,
          'bg-white ': !$q.dark.mode,
        }"
      >
        <q-btn
          flat
          :label="$t('Close')"
          :text-color="$q.dark.mode ? 'grey300' : 'dark'"
          v-close-popup
          no-caps
          class="col"
        />
        <q-btn
          :label="$t('Copy to clipboard')"
          no-caps
          flat
          color="primary"
          unelevated
          class="col"
          @click="CopyPhone"
        />
      </q-footer>
    </q-card>
  </q-dialog>
</template>

<script>
import { copyToClipboard } from "quasar";
import APIinterface from "src/api/APIinterface";

export default {
  name: "ContactPhone",
  props: ["data"],
  data() {
    return {
      dialog: false,
      additional_time: "",
    };
  },
  setup(props) {},
  methods: {
    CopyPhone() {
      copyToClipboard(this.data.contact_number)
        .then(() => {
          APIinterface.notify(
            "positive",
            this.$t("Copy to clipboard"),
            "check",
            this.$q
          );
        })
        .catch(() => {
          APIinterface.notify(
            "negative",
            this.$t("Failed copying to clipboard"),
            "warning",
            this.$q
          );
        });
    },
  },
};
</script>
