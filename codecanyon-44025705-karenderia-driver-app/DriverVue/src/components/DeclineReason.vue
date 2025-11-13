<template>
  <q-dialog
    v-model="dialog"
    :maximized="true"
    transition-show="slide-up"
    transition-hide="slide-down"
  >
    <q-card>
      <q-bar class="transparent q-pa-sm" style="height: auto">
        <div class="col text-center">
          <div class="text-weight-bold">{{ $t("Tell us why") }}</div>
        </div>

        <template v-if="reason == 'others'">
          <q-btn dense flat icon="las la-undo" @click="reason = ''"> </q-btn>
        </template>
        <template v-else>
          <q-btn dense flat icon="close" v-close-popup>
            <q-tooltip class="bg-white text-primary">Close</q-tooltip>
          </q-btn>
        </template>
      </q-bar>
      <q-space class="q-pa-xs bg-grey-1"></q-space>
      <q-card-section>
        <div v-if="reason == 'others'">
          <p>{{ $t("Please specify the reason") }}</p>

          <q-input
            v-model="reason_others"
            autogrow
            dense
            stack-label
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          >
          </q-input>
        </div>

        <q-list separator v-else>
          <q-item v-for="item in data" :key="item" tag="label" v-ripple>
            <q-item-section avatar class="hidden">
              <q-radio v-model="reason" :val="item" color="primary" dense />
            </q-item-section>
            <q-item-section>
              <q-item-label :class="{ 'text-green': reason == item }">{{
                item
              }}</q-item-label>
            </q-item-section>
            <q-item-section side v-if="reason == item">
              <q-icon name="check" color="green" />
            </q-item-section>
          </q-item>

          <q-item tag="label" v-ripple>
            <q-item-section avatar class="hidden">
              <q-radio v-model="reason" val="others" color="primary" dense />
            </q-item-section>
            <q-item-section>
              <q-item-label>{{ $t("Others") }}</q-item-label>
            </q-item-section>
          </q-item>
        </q-list>
      </q-card-section>
      <q-card-actions class="fixed-bottom">
        <q-btn
          :label="$t('Submit')"
          color="primary"
          unelevated
          class="fit font17 text-weight-bold"
          no-caps
          :disable="!hasData"
          @click="submit"
          size="lg"
        ></q-btn>
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "DeclineReason",
  data() {
    return {
      loading: false,
      dialog: false,
      data: [],
      reason: "",
      reason_others: "",
    };
  },
  created() {
    this.getList();
  },
  computed: {
    hasData() {
      if (Object.keys(this.reason).length > 0) {
        if (this.reason == "others") {
          if (APIinterface.empty(this.reason_others)) {
            return false;
          }
        }
        return true;
      }
      return false;
    },
  },
  methods: {
    getList() {
      APIinterface.fetchData("declineReasonList", "")
        .then((result) => {
          this.data = result.details;
        })
        .catch((error) => {
          this.data = [];
        })
        .then((data) => {});
    },
    submit() {
      let data = this.reason == "others" ? this.reason_others : this.reason;
      this.$emit("afterSubmit", data);
    },
  },
};
</script>
