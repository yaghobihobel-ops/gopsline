<template>
  <q-dialog v-model="dialog" position="bottom" @before-show="beforeShow">
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
          {{ $t("Request Payout") }}
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

      <q-form @submit="onSubmit">
        <q-card-section>
          <template v-if="loading1">
            <div class="row q-gutter-x-sm justify-center q-my-md">
              <q-circular-progress
                indeterminate
                rounded
                size="sm"
                color="primary"
              />
              <div class="text-subtitle1 text-grey">{{ $t("Loading") }}...</div>
            </div>
          </template>
          <template v-else-if="!loading1 && !hasPayout">
            <ListNoData
              :title="$t('No payout account')"
              :subtitle="$t('you_dont_have_account')"
            ></ListNoData
          ></template>
          <template v-else>
            <q-item style="padding-left: 0">
              <q-item-section>
                <q-item-label class="text-body1">
                  {{ $t("Payout account") }}</q-item-label
                >
                <q-item-label class="text-body2">{{
                  data?.account
                }}</q-item-label>
              </q-item-section>
            </q-item>
            <q-space class="q-pa-sm"></q-space>

            <q-input
              outlined
              v-model="amount"
              step="any"
              type="number"
              :label="$t('Amount')"
              stack-label
              color="grey-5"
              lazy-rules
              :rules="[
                (val) =>
                  (val && val.length > 0) ||
                  this.$t('Please enter valid amount'),
              ]"
            />
          </template>
        </q-card-section>
        <q-card-actions v-if="!loading1 && hasPayout" class="row">
          <q-btn
            unelevated
            no-caps
            color="disabled"
            text-color="disabled"
            class="radius10 col"
            size="lg"
            v-close-popup
          >
            <div class="text-weight-bold text-subtitle2">
              {{ $t("Cancel") }}
            </div>
          </q-btn>
          <q-btn
            type="submit"
            unelevated
            no-caps
            color="amber-6"
            text-color="disabled"
            class="radius10 col"
            size="lg"
            :loading="loading"
            :disabled="!hasPayout"
          >
            <div class="text-weight-bold text-subtitle2">
              {{ $t("Submit") }}
            </div>
          </q-btn>
        </q-card-actions>
      </q-form>
    </q-card>
  </q-dialog>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";

export default {
  name: "SetAccount",
  data() {
    return {
      dialog: false,
      amount: 0,
      loading: false,
      data: [],
      loading1: false,
    };
  },
  components: {
    ListNoData: defineAsyncComponent(() => import("components/ListNoData.vue")),
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  computed: {
    hasData() {
      if (this.amount > 0) {
        return true;
      }
      return false;
    },
    hasPayout() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    getPayoutAccount() {
      this.loading1 = true;
      APIinterface.fetchDataByTokenPost("getPayoutAccount")
        .then((data) => {
          this.data = data.details;
        })
        .catch((error) => {
          this.data = [];
        })
        .then((data) => {
          this.loading1 = false;
        });
    },
    beforeShow() {
      if (Object.keys(this.data).length <= 0) {
        this.getPayoutAccount();
      }
      this.amount = 0;
    },
    onSubmit() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "requestPayout",
        "amount=" + this.amount
      )
        .then((data) => {
          this.dialog = false;
          APIinterface.ShowSuccessful(data.msg, this.$q);
          this.$emit("afterPayout");
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
