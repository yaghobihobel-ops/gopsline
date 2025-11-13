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
          $t("Search Rooms")
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
                  path: '/tables/rooms_update',
                  query: { id: item.room_uuid },
                }"
              >
                <q-item-section avatar top>
                  <div class="flex flex-center text-center">
                    <div>
                      <div
                        class="radius8 bg-green-10 text-white q-pa-xs text-center q-pl-sm q-pr-sm"
                      >
                        <div class="font14 text-weight-bold">
                          #{{ item.room_id }}
                        </div>
                      </div>
                      <q-space class="q-pa-xs"></q-space>
                      <q-btn
                        dense
                        color="green-12
"
                        round
                        icon="las la-users"
                        unelevated
                      >
                        <q-badge color="primary" floating>{{
                          item.total_tables
                        }}</q-badge>
                      </q-btn>
                    </div>
                  </div>
                </q-item-section>
                <q-item-section top>
                  <q-item-label class="text-dark">
                    {{ item.room_name }}

                    <q-badge
                      :color="
                        DataStore.status_color[item.status]
                          ? DataStore.status_color[item.status]
                          : 'amber'
                      "
                    >
                      <template v-if="DataStore.status_list_raw[item.status]">
                        {{ DataStore.status_list_raw[item.status] }}
                      </template>
                      <template v-else>
                        {{ item.status }}
                      </template>
                    </q-badge>
                  </q-item-label>
                  <q-item-label class="text-dark">
                    <template v-if="item.capacity"
                      >{{ item.capacity }}
                    </template>
                    <template v-else
                      ><span class="text-grey">{{ $t("None") }}</span></template
                    >
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
        <!-- <div class="text-weight-bold">{{ $t("Search for room") }}</div>
        <div class="text-weight-light text-grey">
          {{ $t("Search by room name") }}
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
  name: "SearchBooking",
  components: {
    // TableBookingList: defineAsyncComponent(() =>
    //   import("components/TableBookingList.vue")
    // ),
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
      APIinterface.fetchDataByTokenPost("tableRoomList", "q=" + this.q)
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
