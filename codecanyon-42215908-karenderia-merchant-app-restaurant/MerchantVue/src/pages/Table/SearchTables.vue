<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-header
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
      reveal
      reveal-offset="50"
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
          $t("Search Tables")
        }}</q-toolbar-title>
      </q-toolbar>
      <q-separator></q-separator>
    </q-header>
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
      class="flex justify-start"
    >
      <div class="q-pa-md full-width">
        <q-input outlined v-model="q" :label="$t('Search')" color="grey-5">
          <template v-slot:append>
            <q-icon
              v-if="SearchStore.hasData"
              class="cursor-pointer"
              name="close"
              color="grey"
              @click="clearSearch"
            />
            <q-btn
              v-if="!SearchStore.hasData"
              icon="search"
              unelevated
              color="dark-grey"
              no-caps
              :loading="loading"
              round
              flat
              @click="doSearch"
              :disable="!hasSearch"
            ></q-btn>
          </template>
        </q-input>

        <template v-if="SearchStore.hasData">
          <q-space class="q-mt-md"></q-space>
          <!-- <pre>{{ SearchStore.data }}</pre> -->
          <q-list separator>
            <template v-for="item in SearchStore.data" :key="item">
              <q-item
                clickable
                :to="{
                  path: '/tables/table_update',
                  query: { id: item.table_uuid },
                }"
              >
                <q-item-section avatar top>
                  <div class="flex flex-center text-center">
                    <div>
                      <div
                        class="radius8 bg-green-10 text-white q-pa-xs text-center q-pl-sm q-pr-sm"
                      >
                        <div class="font14 text-weight-bold">
                          #{{ item.table_id }}
                        </div>
                      </div>
                      <q-space class="q-pa-xs"></q-space>
                      <q-btn
                        dense
                        color="green-12
"
                        round
                        icon="las la-user"
                        unelevated
                      >
                        <q-badge color="primary" floating>{{
                          item.max_covers
                        }}</q-badge>
                      </q-btn>
                    </div>
                  </div>
                </q-item-section>
                <q-item-section top>
                  <q-item-label class="text-dark">
                    {{ item.table_name }}

                    <q-badge
                      :color="item.available_raw == 1 ? 'green' : 'amber'"
                    >
                      {{ item.available }}
                    </q-badge>
                  </q-item-label>
                  <q-item-label class="text-dark">
                    <template
                      v-if="DataStore.table_room_list_raw[item.room_id]"
                    >
                      {{ DataStore.table_room_list_raw[item.room_id] }}
                    </template>
                    <template v-else>
                      {{ $t("Not available") }}
                    </template>
                  </q-item-label>
                  <q-item-label caption>
                    {{ item.min_covers }} - {{ item.max_covers }}
                    {{ $t("covers") }}
                  </q-item-label>
                  <q-item-label caption class="font12">
                    {{ item.date_created }}
                  </q-item-label>
                </q-item-section>
              </q-item>
            </template>
          </q-list>
        </template>
        <TableSkeleton v-if="loading" :rows="10"></TableSkeleton>
      </div>

      <div v-if="!SearchStore.is_submit" class="full-width text-center">
        <!-- <div class="text-weight-bold">{{ $t("Search for tables") }}</div>
        <div class="text-weight-light text-grey">
          {{ $t("Search by table name") }}
        </div> -->
      </div>
      <div v-else class="full-width text-center">
        <template v-if="!SearchStore.hasData && !loading">
          <div class="text-weight-bold">{{ $t("No data available") }}</div>
          <div class="text-weight-light text-grey">
            {{ $t("Sorry, we couldn't find any results") }}
          </div>
        </template>
      </div>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useSearchStore } from "stores/SearchStore";
import { useDataStore } from "stores/DataStore";

export default {
  name: "SearchTables",
  components: {
    TableSkeleton: defineAsyncComponent(() =>
      import("components/TableSkeleton.vue")
    ),
  },
  setup() {
    const SearchStore = useSearchStore();
    const DataStore = useDataStore();
    return { SearchStore, DataStore };
  },
  data() {
    return {
      q: "",
      loading: false,
    };
  },
  created() {
    this.SearchStore.data = "";
  },
  computed: {
    hasSearch() {
      if (APIinterface.empty(this.q)) {
        return false;
      }
      return true;
    },
  },
  methods: {
    refresh(done) {
      this.clearSearch();
      done();
    },
    clearSearch() {
      this.SearchStore.is_submit = false;
      this.q = "";
      this.SearchStore.data = [];
    },
    doSearch() {
      this.loading = true;
      this.SearchStore.data = [];
      this.SearchStore.status = [];
      this.SearchStore.is_submit = true;
      APIinterface.fetchDataByTokenPost("tableList", "q=" + this.q)
        .then((data) => {
          this.SearchStore.data = data.details.data;
        })
        .catch((error) => {})
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
