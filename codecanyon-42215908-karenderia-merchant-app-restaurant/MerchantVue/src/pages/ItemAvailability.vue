<template>
  <q-pull-to-refresh @refresh="refresh">
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
          $t("Item Availability")
        }}</q-toolbar-title>
      </q-toolbar>
      <q-separator></q-separator>
    </q-header>
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
    >
      <template v-if="loading_get">
        <q-inner-loading :showing="true" color="primary" size="md" />
      </template>

      <q-form v-else @submit="onSubmit">
        <div class="q-pa-md q-gutter-md">
          <div>
            <q-toggle v-model="available" :label="$t('Available')" dense />
          </div>
          <div>
            <q-toggle
              v-model="not_for_sale"
              :label="$t('Not for sale')"
              dense
            />
          </div>
          <div>
            <q-toggle
              v-model="available_at_specific"
              :label="$t('Available at specified times')"
              dense
            />
          </div>

          <div class="flex justify-end">
            <q-btn
              @click="modal = !modal"
              flat
              color="primary"
              label="Set Availability"
              no-caps
            />
          </div>
        </div>

        <q-list>
          <template v-for="items in available_days" :key="items">
            <q-item class="q-pl-xs">
              <q-item-section avatar class="text-center flex flex-center">
                <div class="text-capitalize font11">
                  {{ items.label }}
                </div>
                <q-toggle v-model="items.checked" color="primary" />
              </q-item-section>
              <q-item-section>
                <q-select
                  outlined
                  v-model="items.start"
                  :label="$t('From')"
                  color="grey-5"
                  stack-label
                  behavior="dialog"
                  transition-show="fade"
                  transition-hide="fade"
                  :options="DataStore.getTimeRange"
                  emit-value
                  map-options
                  dense
                  class="font12"
                />
              </q-item-section>
              <q-item-section>
                <q-select
                  outlined
                  v-model="items.end"
                  :label="$t('To')"
                  color="grey-5"
                  stack-label
                  behavior="dialog"
                  transition-show="fade"
                  transition-hide="fade"
                  :options="DataStore.getTimeRange"
                  emit-value
                  map-options
                  dense
                  class="font12"
                />
              </q-item-section>
            </q-item>
          </template>
        </q-list>

        <!-- <pre>{{ DataStore.getTimeRange }}</pre> -->
        <!-- <pre>{{ available_days }}</pre> -->
        <!-- <pre>{{ availability_data }}</pre> -->

        <q-space class="q-pa-md"></q-space>
        <q-footer
          class="q-pl-md q-pr-md q-pb-xs bg-whitex"
          :class="{
            'bg-mydark ': $q.dark.mode,
            'bg-white ': !$q.dark.mode,
          }"
        >
          <q-btn
            type="submit"
            color="primary"
            text-color="white"
            :label="$t('Save')"
            unelevated
            class="full-width radius8"
            size="lg"
            no-caps
            :loading="loading"
          />
        </q-footer>
      </q-form>
    </q-page>
  </q-pull-to-refresh>

  <q-dialog v-model="modal" full-width>
    <q-card>
      <q-form @submit="SetAvailability">
        <q-card-section class="row items-center q-pb-none">
          <div class="text-h6">{{ $t("Set Availability") }}</div>
          <q-space />
          <q-btn icon="close" flat round dense v-close-popup />
        </q-card-section>
        <q-card-section>
          <q-list dense>
            <q-item tag="label">
              <q-item-section avatar>
                <q-checkbox v-model="open_all" />
              </q-item-section>
              <q-item-section> {{ $t("Check All") }} </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-select
                  outlined
                  v-model="start_all"
                  :label="$t('From')"
                  color="grey-5"
                  stack-label
                  behavior="dialog"
                  transition-show="fade"
                  transition-hide="fade"
                  :options="DataStore.getTimeRange"
                  emit-value
                  map-options
                  :rules="[
                    (val) =>
                      (val && val.length > 0) ||
                      this.$t('This field is required'),
                  ]"
                />
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-select
                  outlined
                  v-model="to_all"
                  :label="$t('To')"
                  color="grey-5"
                  stack-label
                  behavior="dialog"
                  transition-show="fade"
                  transition-hide="fade"
                  :options="DataStore.getTimeRange"
                  emit-value
                  map-options
                  :rules="[
                    (val) =>
                      (val && val.length > 0) ||
                      this.$t('This field is required'),
                  ]"
                />
              </q-item-section>
            </q-item>
          </q-list>
        </q-card-section>
        <q-card-actions class="q-pa-none">
          <q-btn
            type="submit"
            color="primary"
            text-color="white"
            :label="$t('Apply')"
            unelevated
            class="full-width"
            size="lg"
            no-caps
          />
        </q-card-actions>
      </q-form>
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";

export default {
  name: "ItemAvailability",
  data() {
    return {
      modal: false,
      available: false,
      not_for_sale: false,
      available_at_specific: false,
      item_uuid: "",
      loading_get: false,
      loading: false,
      available_days: [],
      availability_data: [],
      open_all: false,
      start_all: "",
      to_all: "",
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    return { DataStore };
  },
  watch: {
    DataStore: {
      immediate: true,
      deep: true,
      handler(newValue, oldValue) {
        this.available_days = [];
        if (!newValue.loading) {
          Object.entries(newValue.day_week).forEach(([key, items]) => {
            this.available_days.push({
              label: items.label,
              value: items.value,
              checked: false,
              start: "",
              end: "",
            });
          });
        }
      },
    },
    availability_data(newval, oldval) {
      // console.log(this.available_days);
      //console.log(newval.day);
      if (Object.keys(this.available_days).length > 0) {
        Object.entries(this.available_days).forEach(([key, items]) => {
          if (Object.keys(newval.day).length > 0) {
            items.checked =
              newval.day.includes(items.value) === true ? true : false;
          }
          if (Object.keys(newval.start).length > 0) {
            items.start = !APIinterface.empty(newval.start[items.value])
              ? newval.start[items.value]
              : "";
          }
          if (Object.keys(newval.end).length > 0) {
            items.end = !APIinterface.empty(newval.end[items.value])
              ? newval.end[items.value]
              : "";
          }
        });
      }
    },
  },
  created() {
    this.item_uuid = this.$route.query.item_uuid;
    if (!APIinterface.empty(this.item_uuid)) {
      this.getItem();
    }
  },
  methods: {
    refresh(done) {
      if (!APIinterface.empty(this.item_uuid)) {
        this.getItem(done);
      } else {
        done();
      }
    },
    getItem(done) {
      this.loading_get = true;
      APIinterface.fetchDataByTokenPost("getItem", "id=" + this.item_uuid)
        .then((data) => {
          this.available = data.details.available;
          this.not_for_sale = data.details.not_for_sale;
          this.available_at_specific = data.details.available_at_specific;
          this.availability_data = data.details.availability_data;
          //
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading_get = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    onSubmit() {
      this.loading = true;
      APIinterface.fetchDataByToken("saveAvailability", {
        item_uuid: this.item_uuid,
        available: this.available,
        not_for_sale: this.not_for_sale,
        available_at_specific: this.available_at_specific,
        available_days: this.available_days,
      })
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    SetAvailability() {
      console.log("SetAvailability");
      console.log(this.open_all);
      console.log(this.start_all);
      console.log(this.to_all);
      if (Object.keys(this.available_days).length > 0) {
        Object.entries(this.available_days).forEach(([key, items]) => {
          console.log(items);
          items.checked = this.open_all;
          items.start = this.start_all;
          items.end = this.to_all;
        });
      }
      this.modal = false;
    },
  },
};
</script>
