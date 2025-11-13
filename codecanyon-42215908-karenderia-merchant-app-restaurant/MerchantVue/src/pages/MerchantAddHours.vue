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
        $t("Add Store Hours")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page padding>
    <template v-if="loading">
      <q-inner-loading
        :showing="true"
        color="primary"
        size="md"
        label-class="dark"
        class="transparent"
      />
    </template>

    <q-form v-else @submit="onSubmit">
      <div class="q-pa-md q-gutter-md">
        <q-toggle v-model="status" :label="$t('Open/Close')" />

        <q-btn-toggle
          v-model="day"
          toggle-color="secondary"
          :color="$q.dark.mode ? 'grey600' : 'mygrey'"
          :text-color="$q.dark.mode ? 'grey300' : 'dark'"
          no-caps
          unelevated
          :options="DataStore.day_list"
          class="rounded-group2 text-weight-bold line-1"
        />

        <div class="row items-center">
          <q-input
            outlined
            v-model="start_time"
            :label="$t('From')"
            stack-label
            color="grey-5"
            lazy-rules
            mask="##:## AA"
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
            class="col q-mr-sm"
          >
            <template v-slot:append>
              <q-icon name="access_time" class="cursor-pointer">
                <q-popup-proxy
                  cover
                  transition-show="scale"
                  transition-hide="scale"
                >
                  <q-time v-model="start_time" mask="hh:mm A">
                    <div class="row items-center justify-end">
                      <q-btn v-close-popup label="Close" color="primary" flat />
                    </div>
                  </q-time>
                </q-popup-proxy>
              </q-icon>
            </template>
          </q-input>

          <q-input
            outlined
            v-model="end_time"
            :label="$t('To')"
            stack-label
            color="grey-5"
            lazy-rules
            mask="##:## AA"
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
            class="col"
          >
            <template v-slot:append>
              <q-icon name="access_time" class="cursor-pointer">
                <q-popup-proxy
                  cover
                  transition-show="scale"
                  transition-hide="scale"
                >
                  <q-time v-model="end_time" mask="hh:mm A">
                    <div class="row items-center justify-end">
                      <q-btn
                        v-close-popup
                        :label="$t('Close')"
                        color="primary"
                        flat
                      />
                    </div>
                  </q-time>
                </q-popup-proxy>
              </q-icon>
            </template>
          </q-input>
        </div>

        <div class="row items-center">
          <q-input
            outlined
            v-model="start_time_pm"
            :label="$t('From')"
            stack-label
            color="grey-5"
            lazy-rules
            mask="##:## AA"
            class="col q-mr-sm"
          >
            <template v-slot:append>
              <q-icon name="access_time" class="cursor-pointer">
                <q-popup-proxy
                  cover
                  transition-show="scale"
                  transition-hide="scale"
                >
                  <q-time v-model="start_time_pm" mask="hh:mm A">
                    <div class="row items-center justify-end">
                      <q-btn v-close-popup label="Close" color="primary" flat />
                    </div>
                  </q-time>
                </q-popup-proxy>
              </q-icon>
            </template>
          </q-input>

          <q-input
            outlined
            v-model="end_time_pm"
            :label="$t('To')"
            stack-label
            color="grey-5"
            lazy-rules
            mask="##:## AA"
            class="col q-mr-sm"
          >
            <template v-slot:append>
              <q-icon name="access_time" class="cursor-pointer">
                <q-popup-proxy
                  cover
                  transition-show="scale"
                  transition-hide="scale"
                >
                  <q-time v-model="end_time_pm" mask="hh:mm A">
                    <div class="row items-center justify-end">
                      <q-btn
                        v-close-popup
                        :label="$t('Close')"
                        color="primary"
                        flat
                      />
                    </div>
                  </q-time>
                </q-popup-proxy>
              </q-icon>
            </template>
          </q-input>
        </div>

        <q-input
          outlined
          v-model="custom_text"
          :label="$t('Custom Message')"
          stack-label
          color="grey-5"
          lazy-rules
        />
      </div>

      <q-footer>
        <q-btn
          type="submit"
          color="primary"
          text-color="white"
          :label="$t('Save')"
          unelevated
          class="full-width radius8"
          size="lg"
          no-caps
          :loading="loading2"
        />
      </q-footer>
    </q-form>
  </q-page>
</template>

<script>
import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";

export default {
  name: "MerchantAddHours",
  data() {
    return {
      id: 0,
      loading: false,
      loading2: false,
      status: true,
      day: "",
      start_time: "",
      end_time: "",
      start_time_pm: "",
      end_time_pm: "",
      custom_text: "",
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    return { DataStore };
  },
  created() {
    this.id = this.$route.query.id;
    if (this.id > 0) {
      this.getHours();
    }
  },
  computed: {
    isEdit() {
      if (this.id > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    getHours() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getHours", "id=" + this.id)
        .then((data) => {
          this.day = data.details.day;
          this.status = data.details.status;
          this.start_time = data.details.start_time;
          this.end_time = data.details.end_time;
          this.start_time_pm = data.details.start_time_pm;
          this.end_time_pm = data.details.end_time_pm;
          this.custom_text = data.details.custom_text;
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    onSubmit() {
      this.loading2 = true;
      APIinterface.fetchDataByToken("createHours", {
        id: this.id,
        day: this.day,
        status: this.status,
        start_time: this.start_time,
        end_time: this.end_time,
        start_time_pm: this.start_time_pm,
        end_time_pm: this.end_time_pm,
        custom_text: this.custom_text,
      })
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
          this.$router.replace({
            path: "/restaurant/store-hours",
          });
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading2 = false;
        });
    },
  },
};
</script>
