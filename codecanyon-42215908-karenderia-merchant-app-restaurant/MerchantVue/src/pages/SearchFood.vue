<template>
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
        $t("Search Food Items")
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
    <div class="q-pa-md">
      <q-input
        outlined
        v-model="q"
        :label="$t('Search')"
        color="grey-5"
        lazy-rules
      >
        <template v-slot:prepend>
          <q-icon name="search" />
        </template>
        <template v-slot:append>
          <q-icon
            v-if="hasFilter"
            class="cursor-pointer"
            name="close"
            color="grey"
            @click="this.q = ''"
          />
        </template>
      </q-input>
    </div>

    <template v-if="hasFilter && awaitingSearch">
      <q-list>
        <q-item v-for="i in 5" :key="i">
          <q-item-section avatar>
            <q-skeleton width="80px" height="80px" />
          </q-item-section>
          <q-item-section>
            <q-skeleton type="text" />
            <q-skeleton type="text" class="w-50" />
            <q-skeleton type="text" class="w-70" />
            <q-skeleton type="text" class="w-25" />
          </q-item-section>
        </q-item>
      </q-list>
    </template>
    <template v-else-if="hasResults && !awaitingSearch && q">
      <div class="q-pl-md q-pr-md">
        <q-tabs
          v-model="tab"
          dense
          no-caps
          active-color="primary"
          indicator-color="grey-1"
          align="justify"
          narrow-indicator
          shrink
          switch-indicator="false"
          class="text-grey"
        >
          <q-tab
            v-for="items in tab_menu"
            :key="items"
            :name="items.value"
            no-caps
            class="no-wrap q-pa-none"
          >
            <q-btn
              :label="items.label"
              unelevated
              no-caps
              :color="tab == items.value ? 'primary' : 'mygrey'"
              :text-color="tab == items.value ? 'white' : 'dark'"
              class="radius28 q-mr-sm"
            ></q-btn>
          </q-tab>
        </q-tabs>
      </div>

      <q-space class="q-pa-xs"></q-space>

      <q-tab-panels
        v-model="tab"
        animated
        transition-next="fade"
        transition-prev="fade"
        :class="{
          'bg-mydark ': $q.dark.mode,
          'bg-white ': !$q.dark.mode,
        }"
      >
        <q-tab-panel name="all" class="q-pa-none">
          <SearchItemList :data="data"></SearchItemList>
        </q-tab-panel>
        <q-tab-panel name="category" class="q-pa-none">
          <SearchItemList :data="category"></SearchItemList>
        </q-tab-panel>
        <q-tab-panel name="items" class="q-pa-none">
          <SearchItemList :data="items"></SearchItemList>
        </q-tab-panel>
        <q-tab-panel name="addons" class="q-pa-none">
          <SearchItemList :data="addons"></SearchItemList>
        </q-tab-panel>
        <q-tab-panel name="addon_item" class="q-pa-none">
          <SearchItemList :data="addon_item"></SearchItemList>
        </q-tab-panel>
      </q-tab-panels>
    </template>

    <template v-else>
      <template v-if="hasFilter && !awaitingSearch">
        <div class="flex flex-center" style="height: calc(70vh)">
          <div class="full-width text-center">
            <div class="text-weight-bold">{{ $t("No item found") }}</div>
            <div class="text-weight-light text-grey">
              {{ $t("Sorry, we couldn't find any results") }}
            </div>
          </div>
        </div>
      </template>
      <div v-else class="q-pl-md q-pr-md">
        <template v-if="hasHistory">
          <div class="row item-center justify-between">
            <div class="font13 text-weight-bold text-h5">
              {{ $t("Recently Search") }}
            </div>
            <div>
              <q-btn
                @click="removeHistory"
                round
                color="grey"
                icon="las la-times"
                size="xs"
                flat
              />
            </div>
          </div>

          <q-btn-toggle
            v-model="search_history"
            toggle-color="secondary"
            :color="$q.dark.mode ? 'grey600' : 'mygrey'"
            :text-color="$q.dark.mode ? 'grey300' : 'dark'"
            no-caps
            no-wrap
            unelevated
            class="rounded-group2 text-weight-bold line-1"
            :options="data_recent"
            @click="this.q = this.search_history"
          />
        </template>
        <template v-else>
          <div class="flex flex-center" style="height: calc(70vh)">
            <div class="full-width text-center">
              <div class="text-weight-bold">{{ $t("Search food items") }}</div>
              <div class="text-weight-light text-grey">
                {{ $t("Search category,items,addon and addon items") }}.
              </div>
            </div>
          </div>
        </template>
      </div>
      <!-- q-pl -->
    </template>

    <!-- end page -->
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";

const storageKey = "merchant_search_food";

export default {
  name: "SearchFood",
  components: {
    SearchItemList: defineAsyncComponent(() =>
      import("components/SearchItemList.vue")
    ),
  },
  data() {
    return {
      tab: "all",
      q: "",
      loading: false,
      awaitingSearch: false,
      data_recent: [],
      search_history: [],
      limit: 50,
      page: 1,
      data: [],
      category: [],
      items: [],
      addons: [],
      addon_item: [],
      tab_menu: [
        {
          label: this.$t("All"),
          value: "all",
        },
        {
          label: this.$t("Category"),
          value: "category",
        },
        {
          label: this.$t("Items"),
          value: "items",
        },
        {
          label: this.$t("Addons"),
          value: "addons",
        },
        {
          label: this.$t("Addon Item"),
          value: "addon_item",
        },
      ],
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    return { DataStore };
  },
  created() {
    this.q = this.DataStore.search_item;
    this.getSearchHistory();
  },
  watch: {
    q(newdata, oldata) {
      if (!this.awaitingSearch) {
        if (
          typeof this.q === "undefined" ||
          this.q === null ||
          this.q === "" ||
          this.q === "null" ||
          this.q === "undefined"
        ) {
          return false;
        }
        setTimeout(() => {
          this.saveHistory();
          this.DataStore.search_item = this.q;
          let $params = "q=" + this.q;
          $params += "&limit=" + this.limit;
          $params += "&page=" + this.page;

          APIinterface.fetchDataByTokenPost("SearchMenu", $params)
            .then((data) => {
              this.category = data.details.category;
              this.items = data.details.items;
              this.addons = data.details.addons;
              this.addon_item = data.details.addon_item;
              this.data = this.category.concat(
                this.items,
                this.addons,
                this.addon_item
              );
            })
            .catch((error) => {
              this.data = [];
              this.category = [];
              this.items = [];
              this.addons = [];
              this.addon_item = [];
            })
            .then((data) => {
              this.awaitingSearch = false;
            });
        }, 1000); // 1 sec delay
      }
      this.awaitingSearch = true;
    },
  },
  computed: {
    hasHistory() {
      if (Object.keys(this.data_recent).length > 0) {
        return true;
      }
      return false;
    },
    hasFilter() {
      if (!APIinterface.empty(this.q)) {
        return true;
      }
      return false;
    },
    hasResults() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    getSearchHistory() {
      const history = APIinterface.getStorage(storageKey);
      if (!APIinterface.empty(history)) {
        let dataRecent = JSON.parse(history);
        if (Object.keys(dataRecent).length > 0) {
          this.data_recent = [];
          Object.entries(dataRecent).forEach(([key, items]) => {
            this.data_recent.push({
              label: items,
              value: items,
            });
          });
        }
      }
    },
    saveHistory() {
      const history = APIinterface.getStorage(storageKey);
      let historyJson = [];
      let historyCount = 0;
      if (!APIinterface.empty(history)) {
        historyJson = JSON.parse(history);
        historyCount = historyJson.length;
        console.log(historyJson);
        if (historyCount > 4) {
          historyJson.splice(0, 1);
        }

        if (!historyJson.includes(this.q)) {
          historyJson.push(this.q);
          APIinterface.setStorage(storageKey, JSON.stringify(historyJson));
        }
        this.getSearchHistory();
      } else {
        historyJson.push(this.q);
        APIinterface.setStorage(storageKey, JSON.stringify(historyJson));
      }
    },
    showPreview(data) {
      this.order_items = data;
      this.$refs.order_preview.dialog = true;
    },
    afterUpdatestatus() {
      //
    },
    removeHistory() {
      this.data_recent = [];
      APIinterface.setStorage(storageKey, JSON.stringify(this.data_recent));
    },
  },
};
</script>
