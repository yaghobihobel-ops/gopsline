<template>
  <q-dialog
    v-model="dialog"
    position="standard"
    @before-show="beforeShow"
    persistent
    transition-show="fade"
    transition-hide="fade"
  >
    <q-card class="rounded-borders-top radius8">
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <q-toolbar-title
          class="text-weight-bold"
          :class="{
            'text-white': $q.dark.mode,
            'text-dark': !$q.dark.mode,
          }"
        >
          {{ $t("Add to your balance") }}
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
      <q-form @submit="onSubmit">
        <q-card-section class="q-pt-sm q-pb-sm">
          <p class="text-grey">
            {{ $t("how much do you want to add to your account") }}?
          </p>

          <q-btn-toggle
            v-model="amount"
            unelevated
            toggle-color="primary"
            no-caps
            :options="data"
          />
          <q-space class="q-pa-sm"></q-space>
          <q-input
            v-model="amount"
            type="number"
            :label="$t('Enter top up amount')"
            outlined
            color="grey-5"
            lazy-rules
            step="any"
            :rules="[
              (val) =>
                (val !== null && val !== '') ||
                this.$t('Please enter  valid amount'),
            ]"
          >
          </q-input>

          <q-card-actions class="row items-center q-pt-sm q-pb-sm">
            <q-btn
              :label="$t('Cancel')"
              outline
              :color="$q.dark.mode ? 'grey600' : 'grey'"
              :text-color="$q.dark.mode ? 'grey300' : 'dark'"
              no-caps
              class="radius8 col"
              @click="dialog = false"
            />
            <q-btn
              type="submit"
              :label="$t('Continue')"
              color="primary"
              text-color="white"
              no-caps
              class="radius8 col"
              unelevated
            />
          </q-card-actions>
        </q-card-section>
      </q-form>
    </q-card>
  </q-dialog>
</template>

<script>
import { useActivityStore } from "stores/ActivityStore";
import APIinterface from "src/api/APIinterface";

export default {
  name: "CashinAmountselection",
  data() {
    return {
      dialog: false,
      data: [],
      loading: false,
      amount: 10,
    };
  },
  setup() {
    const Activity = useActivityStore();
    return { Activity };
  },
  created() {
    this.getCashDomination();
  },
  methods: {
    getCashDomination(done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getCashDomination")
        .then((data) => {
          this.data = data.details.data;
          this.Activity.money_config = data.details.money_config;
        })
        .catch((error) => {})
        .then((data) => {
          this.loading = false;
        });
    },
    onSubmit() {
      if (parseFloat(this.amount) > 0) {
        this.$router.push({
          path: "/account/cashin",
          query: { amount: this.amount },
        });
      }
    },
  },
};
</script>
