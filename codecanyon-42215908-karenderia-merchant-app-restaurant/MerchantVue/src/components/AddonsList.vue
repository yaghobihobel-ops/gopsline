<template>
  <q-inner-loading
    :showing="MenuStore.loading_addon"
    color="primary"
    size="md"
    label-class="dark"
  />
  <q-space class="q-pa-xs"></q-space>
  <template v-if="MenuStore.addon.length <= 0 && !MenuStore.loading_addon">
    <ListNoData
      :title="$t('No available data')"
      :subtitle="$t('Addons and addon item will show here')"
      set_height="min-height: calc(70vh)"
    ></ListNoData>
  </template>
  <template v-else>
    <q-list separator v-if="AccessStore.hasAccess('food.addoncategory')">
      <q-expansion-item v-for="category in MenuStore.addon" :key="category">
        <template v-slot:header>
          <q-item-section avatar>
            <q-img
              :src="category.url_image"
              lazy
              fit="cover"
              style="height: 60px; width: 60px"
              class="radius8"
              spinner-color="secondary"
              spinner-size="sm"
            />
          </q-item-section>

          <q-item-section>
            <q-item-label>{{ category.subcategory_name }}</q-item-label>
            <q-item-label v-if="category.subcategory_description" caption>
              <div class="text-grey ellipsis-2-lines font12 line-normal">
                <span v-html="category.subcategory_description"> </span>
              </div>
            </q-item-label>
            <q-item-label>
              <q-btn
                v-if="category.subcat_id > 0"
                flat
                :label="$t('Edit Addon')"
                no-caps
                size="sm"
                color="primary"
                class="q-pa-none min-height text-weight-bold"
                :to="{
                  path: '/addcategory/edit',
                  query: {
                    subcat_id: category.subcat_id,
                  },
                }"
              ></q-btn>
            </q-item-label>
          </q-item-section>

          <q-item-section side>
            <q-item-label caption>
              {{ Object.keys(category.items).length }}
              <template v-if="Object.keys(category.items).length > 0">{{
                $t("Items")
              }}</template>
              <template v-else>{{ $t("Item") }}</template>
            </q-item-label>
          </q-item-section>
        </template>

        <q-card v-if="AccessStore.hasAccess('food.addonitem')">
          <template v-if="Object.keys(category.items).length <= 0">
            <q-card-section class="text-center">
              <p class="text-grey">{{ $t("No available items") }}</p>
            </q-card-section>
          </template>
          <q-list v-else separator>
            <template v-for="subcat_id in category.items" :key="subcat_id">
              <q-item clickable v-if="MenuStore.addon_items[subcat_id]">
                <q-item-section
                  avatar
                  v-if="MenuStore.addon_items[subcat_id].has_photo"
                >
                  <q-img
                    :src="MenuStore.addon_items[subcat_id].url_image"
                    lazy
                    fit="cover"
                    style="height: 60px; width: 60px"
                    class="radius8"
                    spinner-color="secondary"
                    spinner-size="sm"
                  />
                </q-item-section>
                <q-item-section>
                  <q-item-label>
                    <div class="text-subtitle2 no-margin line-normal">
                      {{ MenuStore.addon_items[subcat_id].sub_item_name }}
                    </div>

                    <div
                      class="text-grey ellipsis-2-lines text-caption line-normal"
                    >
                      <span
                        v-html="
                          MenuStore.addon_items[subcat_id].item_description
                        "
                      >
                      </span>
                    </div>

                    <!-- PRICE -->
                    <div
                      v-if="MenuStore.addon_items[subcat_id].price"
                      class="text-grey-7 font12 text-weight-medium"
                    >
                      {{ MenuStore.addon_items[subcat_id].price }}
                    </div>
                    <!-- PRICE -->
                  </q-item-label>
                  <q-item-label
                    class="q-gutter-sm"
                    v-if="AccessStore.hasAccess('food.addonitem_update')"
                  >
                    <q-toggle
                      :label="$t('Available')"
                      v-model="MenuStore.addon_items[subcat_id].available"
                      @update:model-value="
                        (v, evt) =>
                          setAvailable(
                            v,
                            evt,
                            MenuStore.addon_items[subcat_id].sub_item_id
                          )
                      "
                    />
                    <!-- @update:model-value="setAvailable" -->
                  </q-item-label>
                </q-item-section>
                <q-item-section side class="row items-stretch">
                  <div class="column items-center col-12">
                    <div class="col">
                      <q-btn
                        round
                        :color="$q.dark.mode ? 'grey600' : 'primary'"
                        :text-color="$q.dark.mode ? 'grey300' : 'white'"
                        icon="las la-edit"
                        size="sm"
                        unelevated
                        :to="{
                          path: '/addonitems/edit',
                          query: {
                            id: MenuStore.addon_items[subcat_id].sub_item_id,
                          },
                        }"
                      />
                    </div>
                    <div class="col">
                      <q-btn
                        v-if="AccessStore.hasAccess('food.addonitem_delete')"
                        round
                        :color="$q.dark.mode ? 'grey600' : 'mygrey'"
                        :text-color="$q.dark.mode ? 'grey300' : 'dark'"
                        icon="las la-trash"
                        size="sm"
                        unelevated
                        @click="
                          confirmDelete(
                            MenuStore.addon_items[subcat_id].sub_item_id
                          )
                        "
                      />
                    </div>
                  </div>
                </q-item-section>
              </q-item>
            </template>
          </q-list>
        </q-card>
      </q-expansion-item>
    </q-list>
  </template>
  <ConfirmDialog
    ref="confirm_dialog"
    :data="DataStore.data_dialog"
    @after-confirm="afterConfirm"
  ></ConfirmDialog>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useMenuStore } from "stores/MenuStore";
import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";
import { useAccessStore } from "stores/AccessStore";

export default {
  name: "AddonsList",
  components: {
    ConfirmDialog: defineAsyncComponent(() =>
      import("components/ConfirmDialog.vue")
    ),
    ListNoData: defineAsyncComponent(() => import("components/ListNoData.vue")),
  },
  data() {
    return {
      subitem_id: 0,
    };
  },
  setup() {
    const MenuStore = useMenuStore();
    const DataStore = useDataStore();
    const AccessStore = useAccessStore();
    return { MenuStore, DataStore, AccessStore };
  },
  created() {
    if (!this.MenuStore.hadAddonCategory()) {
      this.MenuStore.geStoreAddonMenu();
    } else {
      const refresh = this.$route.query.refresh;
      if (refresh == 1) {
        this.MenuStore.geStoreAddonMenu();
      }
    }
  },
  methods: {
    confirmDelete(subItemId) {
      this.subitem_id = subItemId;
      this.$refs.confirm_dialog.dialog = true;
    },
    afterConfirm() {
      this.$refs.confirm_dialog.dialog = false;
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        "deleteAddonItem",
        "id=" + this.subitem_id
      )
        .then((data) => {
          this.$emit("afterDeleteitem");
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    setAvailable(data, evt, subItemId) {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        "setAddonItemAvailable",
        "id=" + subItemId + "&active=" + data
      )
        .then((data) => {
          //
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
