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
        $t("Select Zone")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page class="q-pt-sm">
    <template v-if="loading">
      <q-inner-loading :showing="true" size="md" color="primary" />
    </template>
    <template v-else>
      <p class="q-pl-md q-pr-md text-body2">
        {{
          $t(
            "Before you start receiving orders, please choose your preferred zone. Select a zone to get started and receive orders from your desired location"
          )
        }}.
      </p>
      <q-list separator>
        <q-item tag="label" v-ripple v-for="items in getZone" :key="items">
          <q-item-section avatar>
            <q-checkbox v-model="zone_id" :val="items.zone_id" />
          </q-item-section>
          <q-item-section>
            <q-item-label>{{ items.zone_name }}</q-item-label>
          </q-item-section>
        </q-item>
      </q-list>
      <q-footer class="transparent">
        <q-btn
          label="Submit"
          size="lg"
          color="primary"
          unelevated
          no-caps
          class="fit"
          @click="onSubmit"
        ></q-btn>
      </q-footer>
    </template>
  </q-page>
</template>

<script>
import { useActivityStore } from "stores/ActivityStore";
import APIinterface from "src/api/APIinterface";

export default {
  name: "SelectZone",
  data() {
    return {
      zone_id: [],
      loading: false,
      data: [],
    };
  },
  setup(props) {
    const Activity = useActivityStore();
    return { Activity };
  },
  created() {
    this.getZoneList();
  },
  computed: {
    getZone() {
      return this.data;
    },
  },
  methods: {
    getZoneList() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getOndemanzone")
        .then((data) => {
          this.data = data.details.data;
          this.zone_id = data.details.driver_zone;
        })
        .catch((error) => {
          this.data = [];
          this.zone_id = [];
        })
        .then((data) => {
          this.loading = false;
        });
    },
    onSubmit() {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost2("setZone", {
        zone_id: this.zone_id,
      })
        .then((data) => {
          this.$router.push("/home");
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
        })
        .catch((error) => {
          console.log(error);
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
  },
};
</script>
