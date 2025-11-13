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
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-pull-to-refresh @refresh="refresh">
    <q-page
      class="q-pa-md"
      :class="{
        'flex flex-center': !hasData && !loading,
      }"
    >
      <template v-if="!loading">
        <div class="text-h7 text-weight-bold">
          {{ data.title }}
        </div>
        <div v-html="data.long_content"></div>
      </template>
      <template v-if="!hasData && !loading">
        <div class="text-center full-width">
          <div class="text-weight-bold">No results</div>
          <p class="text-grey font12">
            {{ $t("This page is not available please come back later") }}.
          </p>
        </div>
      </template>

      <q-inner-loading :showing="loading" color="primary" size="md" />
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "PageRender",
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
    this.getPage(this.$route.params.page_id, null);
  },
  methods: {
    getPage(page_id, done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getPage", "page_id=" + page_id)
        .then((data) => {
          this.data = data.details;
        })
        .catch((error) => {
          this.data = [];
        })
        .then((data) => {
          this.loading = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    refresh(done) {
      this.getPage(this.$route.params.page_id, done);
    },
  },
};
</script>
