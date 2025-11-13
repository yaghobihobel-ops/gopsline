<template>
  <q-dialog
    v-model="dialog"
    persistent
    maximized
    transition-show="slide-up"
    transition-hide="slide-down"
    @before-show="beforeShow"
  >
    <q-card>
      <q-form @submit="onSubmit">
        <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
          <q-toolbar-title class="text-dark text-weight-bold">
            {{ $t("Delay order") }}
          </q-toolbar-title>
          <q-space></q-space>
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
          <p class="line-normal q-ma-none">
            {{ $t("How much additional time you need") }}?
          </p>
          <p class="line-normal q-ma-none">
            {{ $t("We'll notify the customer about the delay") }}.
          </p>

          <q-space class="q-pa-md"></q-space>

          <div class="row item-center justify-between">
            <q-btn-toggle
              v-model="additional_time"
              toggle-color="secondary"
              :color="$q.dark.mode ? 'grey600' : 'mygrey'"
              :text-color="$q.dark.mode ? 'grey300' : 'dark'"
              no-caps
              no-wrap
              unelevated
              class="rounded-group2 text-weight-bold line-1"
              :options="DataStore.delayed_min_list"
            />
          </div>
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
            :label="$t('Cancel')"
            :text-color="$q.dark.mode ? 'grey300' : 'dark'"
            v-close-popup
            no-caps
            class="col"
          />
          <q-btn
            type="submit"
            :label="$t('Confirm')"
            no-caps
            flat
            color="primary"
            unelevated
            class="col"
            :disable="!hasData"
          />
        </q-footer>
      </q-form>
    </q-card>
  </q-dialog>
</template>

<script>
import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";

export default {
  name: "DelayOrder",
  data() {
    return {
      dialog: false,
      additional_time: "",
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    return { DataStore };
  },
  computed: {
    hasData() {
      if (!APIinterface.empty(this.additional_time)) {
        return true;
      }
      return false;
    },
  },
  methods: {
    beforeShow() {
      this.additional_time = "";
    },
    onSubmit() {
      this.dialog = false;
      this.$emit("afterSelect", this.additional_time);
    },
  },
};
</script>
