<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-header
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
      }"
      reveal
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
          $t("Select a driver to assign")
        }}</q-toolbar-title>
      </q-toolbar>
    </q-header>
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
        'flex flex-center': !DriverStore.hasDrivers,
      }"
      class="q-pl-md q-pr-md q-pb-md"
    >
      <template v-if="DriverStore.getLoading && !DriverStore.is_refresh">
        <q-inner-loading
          :showing="true"
          color="primary"
          size="md"
          label-class="dark"
          class="transparent"
        />
      </template>
      <template v-else>
        <template v-if="!DriverStore.hasDrivers">
          <p class="text-grey">{{ $t("No available drivers") }}</p>
        </template>
        <template v-else>
          <div class="flex flex-center q-gutter-sm q-mb-sm">
            <div class="col">
              <div class="border-grey bg-white radius8">
                <q-input
                  v-model="q"
                  flat
                  outlined
                  dense
                  :label="$t('Search driver by name')"
                >
                  <template v-slot:append>
                    <q-btn
                      round
                      dense
                      flat
                      icon="search"
                      @click="applyfilter"
                    />
                  </template>
                </q-input>
              </div>
            </div>
            <div class="col-1">
              <q-btn
                round
                icon="filter_list"
                unelevated
                color="primary"
                size="sm"
                @click="this.$refs.filter_zone.modal = true"
              ></q-btn>
            </div>
          </div>

          <template v-if="!DriverStore.hasDriverData">
            <div class="flex flex-center" style="min-height: 400px">
              <p class="text-grey">{{ $t("No available drivers") }}</p>
            </div>
          </template>

          <q-card flat>
            <q-list separator>
              <template v-for="items in DriverStore.getDrivers" :key="items">
                <q-item
                  clickable
                  :active="items.selected"
                  active-class="bg-teal-1 text-grey-8"
                  @click="setSelected(items)"
                >
                  <q-item-section avatar>
                    <q-avatar size="50px;">
                      <q-img
                        :src="items.photo_url"
                        sizes="width:50px; height:50px;"
                      >
                      </q-img>
                    </q-avatar>
                  </q-item-section>
                  <q-item-section>
                    <q-item-label>{{ items.name }}</q-item-label>
                    <q-item-label caption></q-item-label>
                    <q-item-label
                      caption
                      v-if="DriverStore.getActiveTask[items.driver_id]"
                    >
                      {{ DriverStore.getActiveTask[items.driver_id] }}
                      {{ $t("active orders") }}
                    </q-item-label>
                  </q-item-section>
                </q-item>
              </template>
            </q-list>
          </q-card>

          <q-footer
            class="q-gutter-sm q-pl-md q-pr-md q-pb-sm"
            :class="{
              'bg-mydark text-white': $q.dark.mode,
              'bg-white text-black': !$q.dark.mode,
            }"
          >
            <q-btn
              unelevated
              color="primary"
              no-caps
              class="radius8 fit"
              size="lg"
              :label="$t('Confirm')"
              :loading="loading"
              :disable="!hasSelected"
              @click="Assign"
            />
          </q-footer>
        </template>
      </template>
    </q-page>
    <FilterByZone ref="filter_zone" @after-applyfilter="afterApplyfilter">
    </FilterByZone>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useDriverStore } from "stores/DriverStore";
import APIinterface from "src/api/APIinterface";

export default {
  name: "AssignList",
  components: {
    FilterByZone: defineAsyncComponent(() =>
      import("components/FilterByZone.vue")
    ),
  },
  data() {
    return {
      selected_driver: [],
      order_uuid: "",
      loading: false,
      zone_id: "",
      group_selected: "",
      q: "",
    };
  },
  setup(props) {
    const DriverStore = useDriverStore();
    return { DriverStore };
  },
  created() {
    this.order_uuid = this.$route.query.order_uuid;
    this.refresh(null);
  },
  computed: {
    hasSelected() {
      if (Object.keys(this.selected_driver).length > 0) {
        return true;
      }
      return false;
    },
    hasFilter() {
      if (this.zone_id > 0) {
        return true;
      }
      if (this.group_selected > 0) {
        return true;
      }
      if (!APIinterface.empty(this.q)) {
        return true;
      }
      return false;
    },
  },
  methods: {
    refresh(done) {
      if (done) {
        this.q = "";
        this.zone_id = "";
        this.group_selected = "";
        this.DriverStore.is_refresh = true;
      }
      this.DriverStore.getAvailableDriver(
        "zone_id=" +
          this.zone_id +
          "&group_selected=" +
          this.group_selected +
          "&q=" +
          this.q +
          "&order_uuid=" +
          this.order_uuid,
        done
      );
    },
    afterApplyfilter(zone_id, group_selected) {
      this.zone_id = zone_id;
      this.group_selected = group_selected;
      this.refresh(null);
    },
    applyfilter() {
      if (APIinterface.empty(this.q)) {
      } else {
        this.refresh(null);
      }
    },
    setSelected(data) {
      this.selected_driver = !data.selected ? data : [];
      data.selected = !data.selected;
    },
    Assign() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "AssignDriver",
        "driver_id=" +
          this.selected_driver.driver_id +
          "&order_uuid=" +
          this.order_uuid
      )
        .then((data) => {
          APIinterface.notify(
            this.$q.dark.mode ? "grey600" : "light-green",
            data.msg,
            "check_circle",
            this.$q
          );
          this.$router.replace({
            path: "/orderview",
            query: { order_uuid: this.order_uuid },
          });
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
