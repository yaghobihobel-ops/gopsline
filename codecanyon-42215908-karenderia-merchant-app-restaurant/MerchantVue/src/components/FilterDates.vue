<template>
  <q-dialog v-model="dialog" full-width persistent>
    <q-card>
      <q-form @submit="formSubmit">
        <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
          <q-toolbar-title
            class="text-darkx text-weight-bold"
            style="overflow: inherit"
            :class="{
              'text-white': $q.dark.mode,
              'text-dark': !$q.dark.mode,
            }"
          >
            {{ $t("Filter") }}
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
        <q-card-section>
          <q-input
            v-model="date_start"
            stack-label
            outlined
            color="grey-5"
            :label="$t('Date start')"
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          >
            <template v-slot:append>
              <q-icon name="event" class="cursor-pointer">
                <q-popup-proxy
                  cover
                  transition-show="scale"
                  transition-hide="scale"
                >
                  <q-date v-model="date_start" color="blue" mask="YYYY-MM-DD">
                    <div class="row items-center justify-end">
                      <q-btn
                        v-close-popup
                        :label="$t('Close')"
                        color="dark"
                        flat
                        no-caps
                      />
                    </div>
                  </q-date>
                </q-popup-proxy>
              </q-icon>
            </template>
          </q-input>

          <q-input
            v-model="date_end"
            stack-label
            outlined
            color="grey-5"
            :label="$t('Date end')"
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          >
            <template v-slot:append>
              <q-icon name="event" class="cursor-pointer">
                <q-popup-proxy
                  cover
                  transition-show="scale"
                  transition-hide="scale"
                >
                  <q-date v-model="date_end" color="blue" mask="YYYY-MM-DD">
                    <div class="row items-center justify-end">
                      <q-btn
                        v-close-popup
                        :label="$t('Close')"
                        color="dark"
                        flat
                        no-caps
                      />
                    </div>
                  </q-date>
                </q-popup-proxy>
              </q-icon>
            </template>
          </q-input>
        </q-card-section>
        <q-separator></q-separator>
        <q-card-actions align="right" class="q-pt-md q-pb-md">
          <q-btn
            rounded
            color="dark"
            no-caps
            unelevated
            v-close-popup
            class="q-pl-md q-pr-md"
            >{{ $t("Close") }}</q-btn
          >
          <q-btn
            rounded
            color="green"
            no-caps
            unelevated
            type="submit"
            class="q-pl-md q-pr-md"
            >{{ $t("Apply Filter") }}</q-btn
          >
        </q-card-actions>
      </q-form>
    </q-card>
  </q-dialog>
</template>

<script>
export default {
  name: "FilterDates",
  data() {
    return {
      dialog: false,
      date_start: "",
      date_end: "",
    };
  },
  setup() {
    return {};
  },
  methods: {
    formSubmit() {
      this.dialog = false;
      this.$emit("afterFilter", {
        date_start: this.date_start,
        date_end: this.date_end,
      });
    },
  },
};
</script>
