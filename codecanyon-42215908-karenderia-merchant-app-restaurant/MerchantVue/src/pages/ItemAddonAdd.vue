<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-header
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
      class="myshadow"
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
        <q-toolbar-title class="text-weight-bold">
          <template v-if="isEdit"> {{ $t("Edit Addon") }} </template>
          <template v-else>{{ $t("Add Addon") }}</template>
        </q-toolbar-title>
      </q-toolbar>
    </q-header>
    <q-page>
      <template v-if="loading_get">
        <q-inner-loading :showing="true" color="primary" size="md" />
      </template>

      <q-form v-else @submit="onSubmit">
        <div class="q-pa-md q-gutter-md">
          <q-toggle
            v-model="require_addon"
            color="primary"
            :label="$t('Required')"
          />
          <q-toggle
            v-model="pre_selected"
            color="primary"
            :label="$t('Pre-selected')"
          />

          <q-select
            outlined
            v-model="item_size_id"
            :label="$t('Select Item Price')"
            color="grey-5"
            stack-label
            behavior="dialog"
            transition-show="fade"
            transition-hide="fade"
            :loading="MenuStore.loading_price"
            :options="MenuStore.price_data"
            :rules="[
              (val) =>
                (!!val && val !== '' && val !== null) ||
                $t('This field is required'),
            ]"
            emit-value
            map-options
          />

          <q-select
            outlined
            v-model="subcat_id"
            :label="$t('Addon Category')"
            :options="MenuStore.addon_category_list"
            color="grey-5"
            stack-label
            behavior="dialog"
            transition-show="fade"
            transition-hide="fade"
            :loading="MenuStore.loading_addoncategory"
            lazy-rules
            :rules="[
              (val) =>
                (!!val && val !== '' && val !== null) ||
                $t('This field is required'),
            ]"
            emit-value
            map-options
          />

          <q-select
            outlined
            v-model="multi_option"
            :label="$t('Select Type')"
            color="grey-5"
            stack-label
            behavior="dialog"
            transition-show="fade"
            transition-hide="fade"
            :options="DataStore.multi_option"
            emit-value
            map-options
          />

          <q-input
            v-if="multi_option == 'multiple' || multi_option == 'custom'"
            type="number"
            outlined
            v-model="multi_option_value"
            :label="$t('Enter how many can select')"
            stack-label
            color="grey-5"
            lazy-rules
            :rules="[
              (val) =>
                (val > 0 && val.length > 0) ||
                this.$t('This field is required'),
            ]"
          />

          <q-select
            v-if="multi_option == 'two_flavor'"
            outlined
            v-model="multi_option_value_selection"
            :label="$t('Select Two Flavor Properties')"
            color="grey-5"
            stack-label
            behavior="dialog"
            transition-show="fade"
            transition-hide="fade"
            :options="DataStore.two_flavor_properties"
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
            emit-value
            map-options
          />
        </div>

        <q-footer
          class="q-pl-md q-pr-md q-pb-xs"
          :class="{
            'bg-mydark ': $q.dark.mode,
            'bg-white ': !$q.dark.mode,
          }"
        >
          <q-btn
            type="submit"
            color="primary"
            text-color="white"
            :label="$t('Save')"
            unelevated
            class="full-width radius8"
            size="lg"
            no-caps
            :loading="loading"
          />
        </q-footer>
      </q-form>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useMenuStore } from "stores/MenuStore";
import { useDataStore } from "stores/DataStore";

export default {
  name: "ItemAddonAdd",
  data() {
    return {
      id: "",
      item_uuid: "",
      loading: false,
      loading_get: false,
      require_addon: false,
      pre_selected: false,
      item_size_id: "",
      subcat_id: "",
      multi_option: "one",
      multi_option_value: 0,
      multi_option_value_selection: "",
    };
  },
  setup(props) {
    const MenuStore = useMenuStore();
    const DataStore = useDataStore();
    return { MenuStore, DataStore };
  },
  computed: {
    isEdit() {
      if (this.id > 0) {
        return true;
      }
      return false;
    },
  },
  created() {
    this.item_uuid = this.$route.query.item_uuid;
    this.id = this.$route.query.id;

    this.MenuStore.getAddonCategoryList();
    this.MenuStore.getPriceList(this.item_uuid);

    if (this.id > 0) {
      this.getAddonItem();
    }
  },
  methods: {
    refresh(done) {
      if (this.id > 0) {
        this.getAddonItem(done);
      } else {
        done();
      }
    },
    getAddonItem(done) {
      this.loading_get = true;
      APIinterface.fetchDataByToken("getItemAddon", {
        id: this.id,
        item_uuid: this.item_uuid,
      })
        .then((data) => {
          this.item_size_id = data.details.item_size_id;
          this.subcat_id = data.details.subcat_id;
          this.multi_option = data.details.multi_option;
          this.multi_option_value = data.details.multi_option_value;
          this.multi_option_value_selection = data.details.multi_option_value;
          this.require_addon = data.details.require_addon;
          this.pre_selected = data.details.pre_selected;
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading_get = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    onSubmit() {
      this.loading = true;

      APIinterface.fetchDataByToken("itemAddonCreate", {
        id: this.id,
        item_uuid: this.item_uuid,
        item_size_id: this.item_size_id,
        subcat_id: this.subcat_id,
        multi_option_value: this.multi_option_value,
        multi_option: this.multi_option,
        multi_option_value_selection: this.multi_option_value_selection,
        pre_selected: this.pre_selected,
        require_addon: this.require_addon,
      })
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
          this.$router.replace({
            path: "/item/addonlist",
            query: { item_uuid: this.item_uuid },
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
