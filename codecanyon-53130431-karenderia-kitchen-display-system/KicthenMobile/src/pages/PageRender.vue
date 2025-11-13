<template>
  <q-header
    reveal
    reveal-offset="10"
    :class="{
      'bg-custom-grey text-dark': !$q.dark.mode,
      'bg-grey600 text-grey300': $q.dark.mode,
    }"
  >
    <q-toolbar style="border-bottom-right-radius: 25px">
      <q-btn
        @click="$router.back()"
        flat
        round
        dense
        icon="eva-arrow-ios-back-outline"
      />
      <q-toolbar-title style="font-size: 14px">
        <template v-if="hasData">
          {{ data.title }}
        </template>
      </q-toolbar-title>
    </q-toolbar>
  </q-header>
  <q-page
    padding
    :class="{
      'bg-dark': $q.dark.mode && $q.screen.lt.md,
    }"
  >
    <q-card
      flat
      class="card-form-height"
      :class="{
        'box-shadow': !$q.screen.lt.md,
      }"
    >
      <q-card-section>
        <template v-if="loading">
          <q-skeleton height="170px" square animation="fade" />
          <div class="row items-start no-wrap q-mt-sm">
            <q-skeleton size="56px" square animation="fade" />
            <div class="col q-pl-sm">
              <q-skeleton type="text" square width="30%" animation="fade" />
              <q-skeleton type="text" square height="12px" animation="fade" />
              <q-skeleton
                type="text"
                square
                height="12px"
                width="75%"
                animation="fade"
              />
            </div>
          </div>
        </template>
        <template v-else>
          <template v-if="hasData">
            <div class="text-h6 q-mb-sm">{{ data.title }}</div>
            <div v-html="data.long_content"></div>
          </template>
          <template v-else>
            <div class="flex flex-center card-form-height">
              <div>
                {{ $t("This page is not available to view") }}
              </div>
            </div>
          </template>
        </template>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
export default {
  name: "PageRender",
  data() {
    return {
      page_id: null,
      loading: true,
      data: null,
    };
  },
  mounted() {
    this.getPage();
  },
  computed: {
    hasData() {
      if (this.data) {
        return true;
      }
      return false;
    },
  },
  methods: {
    getPage() {
      this.loading = true;
      APIinterface.fetchData("getPage", "page_id=" + this.$route.params.page_id)
        .then((data) => {
          this.data = data.details;
        })
        .catch((error) => {
          this.data = null;
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
