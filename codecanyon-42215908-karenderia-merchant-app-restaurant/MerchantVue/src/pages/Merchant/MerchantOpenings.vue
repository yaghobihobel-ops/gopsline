<template>
  <q-page
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-grey-1 text-dark': !$q.dark.mode,
    }"
    class="q-pr-md q-pl-md"
  >
    <div class="q-mt-md q-mb-md">
      <TabsRouterMenu :tab_menu="GlobalStore.merchantMenu"></TabsRouterMenu>
    </div>

    <template v-if="loading">
      <q-inner-loading :showing="true" color="primary" size="md" />
    </template>
    <q-card class="q-pa-none no-shadow" v-else>
      <q-card-section>
        <template v-if="hasData">
          <div class="row items-center justify-between">
            <div class="text-weight-bold">{{ $t("Manage Hours") }}</div>

            <template
              v-if="AccessStore.hasAccess('merchant.store_hours_delete')"
            >
              <q-btn
                v-if="hasData2"
                :label="edit ? this.$t('Done') : this.$t('Edit')"
                flat
                no-caps
                color="primary"
                @click="edit = !edit"
              />
            </template>
          </div>
          <q-separator class="q-mb-lg"></q-separator>

          <div class="row items-stretch items-center q-gutter-md">
            <div
              class="col-5 relative-position"
              v-for="items in data"
              :key="items"
            >
              <q-btn
                v-if="edit"
                round
                :color="$q.dark.mode ? 'grey600' : 'primary'"
                :text-color="$q.dark.mode ? 'grey300' : 'dark'"
                icon="las la-trash"
                dense
                unelevated
                size="sm"
                class="absolute-top-right z-tap"
                style="top: -10px; right: -10px"
                @click="confirmDelete(items, index)"
              />
              <q-btn
                :color="$q.dark.mode ? 'grey600' : 'mygrey'"
                :text-color="$q.dark.mode ? 'grey300' : 'dark'"
                class="line-normal radius8 font13"
                unelevated
                style="min-height: 70px"
                no-caps
                :to="{
                  path: '/restaurant/update-hours',
                  query: {
                    id: items.id,
                  },
                }"
              >
                <div>{{ items.day }}</div>
                <div class="font11 text-grey">{{ items.opening_hours }}</div>
                <q-chip
                  :color="items.status == 'open' ? 'yellow' : 'red'"
                  :text-color="items.status == 'open' ? 'dark' : 'white'"
                  size="sm"
                  >{{ items.status }}</q-chip
                >
              </q-btn>
            </div>
            <div class="col-3">
              <q-btn
                color="primary"
                text-color="white"
                class="line-normal radius8 font13"
                unelevated
                style="min-height: 70px"
                no-caps
                to="/restaurant/add-hours"
              >
                + {{ $t("Add") }}
              </q-btn>
            </div>
          </div>
        </template>
        <template v-else>
          <div class="flex flex-center" style="min-height: calc(30vh)">
            <div class="full-width text-center">
              <div class="text-weight-bold">
                {{ $t("No available data") }}
              </div>
              <p class="text-grey font12 q-mb-none">
                {{ $t("You haven't added your store opening hours") }}
              </p>
              <q-btn
                flat
                no-caps
                :label="$t('Click here to add')"
                color="blue"
                size="sm"
                to="/restaurant/add-hours"
              ></q-btn>
            </div>
          </div>
        </template>
      </q-card-section>
    </q-card>

    <ConfirmDialog
      ref="confirm_dialog"
      :data="DataStore.data_dialog"
      @after-confirm="afterConfirm"
    ></ConfirmDialog>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import { useAccessStore } from "stores/AccessStore";
import { useGlobalStore } from "stores/GlobalStore";

export default {
  name: "MerchantOpenings",
  components: {
    ConfirmDialog: defineAsyncComponent(() =>
      import("components/ConfirmDialog.vue")
    ),
    TabsRouterMenu: defineAsyncComponent(() =>
      import("components/TabsRouterMenu.vue")
    ),
  },
  data() {
    return {
      loading: false,
      data: [],
      edit: false,
      data_to_delete: [],
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    const AccessStore = useAccessStore();
    const GlobalStore = useGlobalStore();
    return { DataStore, AccessStore, GlobalStore };
  },
  created() {
    this.getOpeningHours();
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      if (!APIinterface.empty(this.id)) {
        return true;
      }
      return false;
    },
    hasData2() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    refresh(done) {
      this.getOpeningHours(done);
    },
    getOpeningHours(done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getOpeningHours")
        .then((data) => {
          this.edit = false;
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
    confirmDelete(data, index) {
      this.data_to_delete = data;
      this.data_to_delete.index = index;
      this.$refs.confirm_dialog.dialog = true;
    },
    afterConfirm() {
      this.$refs.confirm_dialog.dialog = false;
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        "deleteHours",
        "&id=" + this.data_to_delete.id
      )
        .then((data) => {
          this.data.splice(this.data_to_delete.index, 1);
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
  },
};
</script>
