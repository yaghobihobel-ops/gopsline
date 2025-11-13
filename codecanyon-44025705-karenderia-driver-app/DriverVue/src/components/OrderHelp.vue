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
          <div class="text-weight-bold">{{ title }}</div>
        </div>

        <template v-if="reason == 'others'">
          <q-btn dense flat icon="las la-undo" @click="reason = ''"> </q-btn>
        </template>
        <template v-else>
          <q-btn dense flat icon="close" v-close-popup>
            <q-tooltip class="bg-white text-primary">{{
              $t("Close")
            }}</q-tooltip>
          </q-btn>
        </template>
      </q-bar>
      <q-space
        class="q-pa-xs"
        :class="{
          '': $q.dark.mode,
          'bg-grey-1': !$q.dark.mode,
        }"
      ></q-space>
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

        <q-list v-else separator class="q-pa-none q-ma-none">
          <q-item-label header class="text-grey font12"
            >{{ $t("Need help") }}?</q-item-label
          >
          <q-item v-ripple clickable>
            <q-item-section avatar>
              <q-icon name="las la-phone" size="sm" color="blue" />
            </q-item-section>
            <q-item-section avatar>{{ $t("Call Support") }} </q-item-section>
          </q-item>

          <q-item v-ripple clickable>
            <q-item-section avatar>
              <q-icon name="las la-comment" size="sm" color="cyan" />
            </q-item-section>
            <q-item-section avatar>{{ $t("Chat Support") }} </q-item-section>
          </q-item>

          <q-item-label header class="text-grey font12"
            >{{ $t("What is the issue") }}?</q-item-label
          >

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
              <q-item-label>Others</q-item-label>
            </q-item-section>
          </q-item>
        </q-list>

        <q-space class="q-pa-lg"> </q-space>
      </q-card-section>
      <q-card-actions
        class="fixed-bottom"
        :class="{
          'bg-mydark ': $q.dark.mode,
          'bg-white ': !$q.dark.mode,
        }"
      >
        <q-btn
          :label="$t('Submit')"
          color="primary"
          unelevated
          class="fit font17 text-weight-bold"
          no-caps
          :disable="!hasData"
          @click="submit"
        ></q-btn>
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "OrderHelp",
  props: ["list_type", "title"],
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
    show() {
      this.dialog = true;
      this.reason = "";
      this.reason_others = "";
    },
    hide() {
      this.dialog = false;
      this.reason = "";
      this.reason_others = "";
    },
    getList() {
      APIinterface.fetchData(this.list_type, "")
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
