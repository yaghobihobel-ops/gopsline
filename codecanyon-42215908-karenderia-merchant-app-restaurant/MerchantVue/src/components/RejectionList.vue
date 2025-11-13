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
            {{ $t("Select Reason") }}
          </q-toolbar-title>
          <q-space></q-space>
          <q-btn
            icon="las la-times"
            color="grey"
            flat
            round
            dense
            v-close-popup
          />
        </q-toolbar>
        <q-card-section class="scroll q-pa-none">
          <div class="q-pl-md q-pr-md">
            <q-input
              outlined
              v-model="reason"
              :label="$t('Reason')"
              stack-label
              color="grey-5"
              lazy-rules
              :rules="[
                (val) =>
                  (val && val.length > 0) || this.$t('This field is required'),
              ]"
            />
          </div>
          <q-list separator>
            <template v-for="items in DataStore.rejection_list" :key="items">
              <q-item
                clickable
                @click="this.reason = items"
                :class="{ 'bg-blue text-white': items == this.reason }"
              >
                <q-item-label class="text-body2">{{ items }}</q-item-label>
              </q-item>
            </template>
          </q-list>

          <q-space class="q-pa-lg"></q-space>
          <q-space class="q-pa-lg"></q-space>

          <q-footer class="bg-white row myshadow q-pa-md q-gutter-x-md">
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
            >
              <div class="text-weight-bold text-subtitle2">
                {{ $t("Reject Order") }}
              </div>
            </q-btn>
          </q-footer>
        </q-card-section>
      </q-form>
    </q-card>
  </q-dialog>
</template>

<script>
import { useDataStore } from "stores/DataStore";

export default {
  name: "RejectionList",
  data() {
    return {
      dialog: false,
      reason: "",
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    return { DataStore };
  },
  methods: {
    beforeShow() {
      this.reason = "";
    },
    onSubmit() {
      this.dialog = false;
      this.$emit("afterAddreason", this.reason);
    },
  },
};
</script>
