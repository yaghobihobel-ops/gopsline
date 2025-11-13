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
          $t("Search Booking")
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
          <TableBookingList
            :data="SearchStore.data"
            :status="SearchStore.status"
            @confirm-delete="confirmDelete"
          ></TableBookingList>
        </template>
        <TableSkeleton v-if="loading" :rows="10"></TableSkeleton>
      </div>

      <div v-if="!SearchStore.is_submit" class="full-width text-center">
        <!-- <div class="text-weight-bold">{{ $t("Search for booking") }}</div>
        <div class="text-weight-light text-grey">
          {{ $t("Search by booking number or customer name") }}
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

export default {
  name: "SearchBooking",
  components: {
    TableBookingList: defineAsyncComponent(() =>
      import("components/TableBookingList.vue")
    ),
    TableSkeleton: defineAsyncComponent(() =>
      import("components/TableSkeleton.vue")
    ),
  },
  setup() {
    const SearchStore = useSearchStore();
    return { SearchStore };
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
      APIinterface.fetchDataByTokenPost("reservationList", "q=" + this.q)
        .then((data) => {
          this.SearchStore.data.push(data.details.data);
          this.SearchStore.status = data.details.status_list;
        })
        .catch((error) => {})
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
