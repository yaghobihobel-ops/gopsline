<template>
  <q-header class="bg-white" reveal reveal-offset="50">
    <q-toolbar>
      <q-btn
        @click="$router.back()"
        flat
        round
        dense
        icon="arrow_back"
        color="dark"
      />
      <q-toolbar-title class="text-grey-10">{{
        $t("Privacy Policy")
      }}</q-toolbar-title>
    </q-toolbar>
  </q-header>
  <q-page padding class="bg-grey-1" :class="{ 'flex flex-center': !hasData }">
    <q-card v-if="!loading && hasData">
      <q-card-section>
        <div v-html="data.long_content"></div>
      </q-card-section>
    </q-card>

    <div v-if="!loading && !hasData">
      <div class="font16 text-weight-bold">{{ $t("No available data") }}</div>
    </div>
  </q-page>
</template>

<script>
import { useActivityStore } from "stores/ActivityStore";
import APIinterface from "src/api/APIinterface";

export default {
  name: "PrivacyPolicy",
  setup() {
    const Activity = useActivityStore();
    return { Activity };
  },
  data() {
    return {
      data: [],
      loading: false,
    };
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  created() {
    this.Activity.setTitle(this.$t("Privacy Policy"));
    this.getPage();
  },
  methods: {
    getPage() {
      this.loading = true;
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByToken("getPage", {
        page: "page_driver_privacy",
      })
        .then((result) => {
          this.data = result.details;
          this.Activity.setTitle(this.data.title);
        })
        .catch((error) => {
          this.data = [];
        })
        .then((data) => {
          this.loading = false;
          APIinterface.hideLoadingBox(this.$q);
        });
    },
  },
};
</script>
