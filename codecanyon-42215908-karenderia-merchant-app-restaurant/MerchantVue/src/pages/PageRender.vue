<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page class="q-pa-md">
      <template v-if="DataStore.loading_page">
        <div
          class="row q-gutter-x-sm justify-center absolute-center text-center full-width"
        >
          <q-circular-progress
            indeterminate
            rounded
            size="sm"
            color="primary"
          />
          <div class="text-subtitle1 text-grey">{{ $t("Loading") }}...</div>
        </div>
      </template>
      <template v-if="!DataStore.hasPage && !DataStore.loading_page">
        <div
          class="row q-gutter-x-sm justify-center items-center absolute-center text-center full-width"
        >
          <img src="/svg/no-data.svg" />
          <div class="text-body1 text-grey">
            {{ $t("Page is not available") }}
          </div>
        </div>
      </template>
      <template v-else>
        <div class="text-h6 text-weight-medium q-mb-sm">
          {{ DataStore.page_data.title }}
        </div>
        <div
          class="page-content"
          v-html="DataStore.page_data.long_content"
        ></div>
      </template>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { useDataStore } from "stores/DataStore";
export default {
  name: "PageRender",
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  mounted() {
    this.DataStore.page_title = null;
    this.DataStore.loading_page = true;
    this.DataStore.getPage(null, this.$route.params.page_id);
  },
  methods: {
    refresh(done) {
      this.DataStore.getPage(done, this.$route.params.page_id);
    },
  },
};
</script>
