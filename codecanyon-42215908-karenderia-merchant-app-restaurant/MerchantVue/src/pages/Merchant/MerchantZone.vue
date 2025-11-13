<template>
  <q-page
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-grey-1 text-dark': !$q.dark.mode,
    }"
    class="q-pr-md q-pl-md"
  >
    <template v-if="loading">
      <q-inner-loading :showing="true" color="primary" size="md" />
    </template>
    <q-card class="q-pa-none no-shadow" v-else>
      <q-card-section>
        <q-form @submit="onSubmit">
          <template v-if="!hasData">
            <div
              class="text-center flex flex-center"
              style="min-height: calc(50vh)"
            >
              <div class="text-grey">{{ $t("No available data") }}</div>
            </div>
          </template>
          <q-list separator v-else>
            <q-item
              tag="label"
              v-ripple
              v-for="items in zone_list"
              :key="items"
            >
              <q-item-section avatar>
                <q-checkbox v-model="zone" :val="items.value" color="green" />
              </q-item-section>
              <q-item-section>
                <q-item-label>{{ items.label }}</q-item-label>
              </q-item-section>
            </q-item>
          </q-list>

          <q-space class="q-pa-sm"></q-space>
          <q-btn
            type="submit"
            color="primary"
            text-color="white"
            :label="$t('Save')"
            unelevated
            class="full-width radius8"
            size="lg"
            no-caps
            :disable="!hasData"
          />
        </q-form>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "MerchantZone",
  data() {
    return {
      loading: false,
      zone: [],
      zone_list: [],
    };
  },
  created() {
    this.getTimezonedata();
  },
  computed: {
    hasData() {
      if (Object.keys(this.zone_list).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    getTimezonedata() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getMerchantzone")
        .then((data) => {
          this.zone = data.details.zone;
          this.zone_list = data.details.zone_list;
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    onSubmit() {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByToken("saveMerchantzone", {
        zone: this.zone,
      })
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
  },
};
</script>
