<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
      }"
    >
      <q-tabs
        v-model="tab"
        dense
        no-caps
        active-color="primary"
        :indicator-color="$q.dark.mode ? 'mydark' : 'grey-1'"
        align="justify"
        narrow-indicator
        shrink
        switch-indicator="false"
        class="text-grey q-ml-sm"
        stretch
      >
        <template v-for="items in tab_menu" :key="items">
          <q-tab
            v-if="AccessStore.hasAccess(items.permission)"
            :name="items.value"
            no-caps
            class="no-wrap q-pa-none"
          >
            <q-btn
              :label="items.label"
              unelevated
              no-caps
              :color="
                tab == items.value
                  ? 'primary'
                  : $q.dark.mode
                  ? 'grey600'
                  : 'mygrey'
              "
              :text-color="
                tab == items.value ? 'white' : $q.dark.mode ? 'grey300' : 'dark'
              "
              class="radius28 q-mr-sm"
            ></q-btn>
          </q-tab>
        </template>
      </q-tabs>

      <q-space class="q-pa-xs"></q-space>

      <q-tab-panels
        v-model="tab"
        animated
        transition-prev="fade"
        transition-next="fade"
        class="row radius-top"
        style="min-height: calc(70vh)"
      >
        <q-tab-panel name="menu" class="q-pa-none">
          <q-inner-loading
            :showing="MenuStore.loading"
            color="primary"
            size="md"
            label-class="dark"
          />
          <q-space class="q-pa-xs"></q-space>

          <template v-if="MenuStore.category.length <= 0 && !MenuStore.loading">
            <ListNoData
              :title="$t('No available data')"
              :subtitle="$t('Category and item will show here')"
              set_height="min-height: calc(70vh)"
            ></ListNoData>
          </template>
          <q-list v-else separator>
            <template v-if="AccessStore.hasAccess('food.category')">
              <q-expansion-item
                v-for="category in MenuStore.category"
                :key="category"
              >
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
                    <q-item-label class="text-subtitle2">{{
                      category.category_name
                    }}</q-item-label>
                    <q-item-label v-if="category.category_description" caption>
                      <div
                        class="text-grey ellipsis-2-lines text-caption line-normal"
                      >
                        <span v-html="category.category_description"> </span>
                      </div>
                    </q-item-label>
                    <q-item-label>
                      <q-btn
                        v-if="category.cat_id > 0"
                        flat
                        :label="$t('Edit Category')"
                        no-caps
                        size="sm"
                        color="primary"
                        class="q-pa-none min-height text-weight-bold"
                        :to="{
                          path: '/category/edit',
                          query: {
                            cat_id: category.cat_id,
                          },
                        }"
                      ></q-btn>
                    </q-item-label>
                  </q-item-section>

                  <q-item-section side>
                    <q-item-label caption
                      >{{ Object.keys(category.items).length }}
                      <template v-if="Object.keys(category.items).length > 0">{{
                        $t("Items")
                      }}</template>
                      <template v-else>{{ $t("Item") }}</template>
                    </q-item-label>
                  </q-item-section>
                </template>

                <q-card v-if="AccessStore.hasAccess('food.items')">
                  <template v-if="Object.keys(category.items).length <= 0">
                    <q-card-section class="text-center">
                      <p class="text-grey">{{ $t("No available items") }}</p>
                    </q-card-section>
                  </template>
                  <q-list v-else separator>
                    <template v-for="item_id in category.items" :key="item_id">
                      <q-item clickable v-if="MenuStore.items[item_id]">
                        <q-item-section
                          avatar
                          v-if="MenuStore.items[item_id].has_photo"
                        >
                          <q-img
                            :src="MenuStore.items[item_id].url_image"
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
                              {{ MenuStore.items[item_id].item_name }}
                            </div>

                            <div
                              class="text-grey ellipsis-2-lines text-caption line-normal"
                            >
                              <span
                                v-html="
                                  MenuStore.items[item_id].item_description
                                "
                              >
                              </span>
                            </div>

                            <!-- PRICE -->
                            <div
                              v-if="MenuStore.items[item_id].price"
                              class="text-grey-7 font12 text-weight-medium"
                            >
                              <template
                                v-for="price in MenuStore.items[item_id].price"
                                :key="price"
                              >
                                <template v-if="price.discount > 0">
                                  {{ price.size_name }}
                                  <span class="text-strike">{{
                                    price.pretty_price
                                  }}</span>
                                  {{ price.pretty_price_after_discount }}
                                </template>
                                <template v-else>
                                  {{ price.size_name }}
                                  {{ price.pretty_price }}</template
                                ><span class="q-pr-sm"></span>
                              </template>
                            </div>
                            <!-- PRICE -->
                          </q-item-label>
                          <q-item-label
                            class="q-gutter-sm"
                            v-if="AccessStore.hasAccess('food.item_update')"
                          >
                            <q-toggle
                              :label="$t('Available')"
                              v-model="MenuStore.items[item_id].available"
                              @update:model-value="
                                (v, evt) =>
                                  setAvailable(
                                    v,
                                    evt,
                                    MenuStore.items[item_id].item_uuid
                                  )
                              "
                            />
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
                                  path: '/item/edit',
                                  query: {
                                    item_uuid:
                                      MenuStore.items[item_id].item_uuid,
                                  },
                                }"
                              />
                            </div>
                            <div class="col">
                              <q-btn
                                v-if="AccessStore.hasAccess('food.item_delete')"
                                round
                                :color="$q.dark.mode ? 'grey600' : 'mygrey'"
                                :text-color="$q.dark.mode ? 'grey300' : 'dark'"
                                icon="las la-trash"
                                size="sm"
                                unelevated
                                @click="
                                  confirmDelete(
                                    MenuStore.items[item_id].item_uuid
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
            </template>
          </q-list>

          <q-page-sticky position="bottom-right" :offset="[18, 18]">
            <q-fab
              v-model="fabItem"
              vertical-actions-align="right"
              :color="$q.dark.mode ? 'grey600' : 'mygrey'"
              :text-color="$q.dark.mode ? 'grey300' : 'dark'"
              icon="las la-plus"
              direction="up"
              unelevated
              padding="xs"
            >
              <q-fab-action
                label-position="left"
                :color="$q.dark.mode ? 'grey600' : 'secondary'"
                :text-color="$q.dark.mode ? 'grey300' : 'white'"
                :label="$t('Sort Item')"
                unelevated
                style="min-width: 120px"
                to="/item/sort"
              />
              <q-fab-action
                label-position="left"
                :color="$q.dark.mode ? 'grey600' : 'secondary'"
                :text-color="$q.dark.mode ? 'grey300' : 'white'"
                :label="$t('Sort Category')"
                unelevated
                style="min-width: 120px"
                to="/category/sort"
              />
              <q-fab-action
                label-position="left"
                :color="$q.dark.mode ? 'grey600' : 'secondary'"
                :text-color="$q.dark.mode ? 'grey300' : 'white'"
                :label="$t('Add Item')"
                unelevated
                style="min-width: 120px"
                to="/item/add"
              />
              <q-fab-action
                label-position="left"
                :color="$q.dark.mode ? 'grey600' : 'secondary'"
                :text-color="$q.dark.mode ? 'grey300' : 'white'"
                :label="$t('Add Category')"
                unelevated
                style="min-width: 120px"
                to="/category/add"
              />
            </q-fab>
          </q-page-sticky>
        </q-tab-panel>

        <q-tab-panel name="addons" class="q-pa-none">
          <!-- <div class="flex flex-center fit">
            <div class="full-width text-center">
              <div class="text-weight-bold">No addons</div>
              <div class="text-weight-light text-grey">addon will show here</div>
            </div>
          </div> -->
          <AddonsList
            ref="addon_list"
            @after-deleteitem="afterDeleteitem"
          ></AddonsList>
          <q-space class="q-pa-md"></q-space>

          <q-page-sticky position="bottom-right" :offset="[18, 18]">
            <q-fab
              v-model="fabaddon"
              vertical-actions-align="right"
              :color="$q.dark.mode ? 'grey600' : 'mygrey'"
              :text-color="$q.dark.mode ? 'grey300' : 'dark'"
              icon="las la-plus"
              direction="up"
              unelevated
              padding="xs"
            >
              <q-fab-action
                label-position="left"
                :color="$q.dark.mode ? 'grey600' : 'secondary'"
                :text-color="$q.dark.mode ? 'grey300' : 'white'"
                :label="$t('Sort Addon Item')"
                unelevated
                style="min-width: 170px"
                to="/addonitems/sort"
              />
              <q-fab-action
                label-position="left"
                :color="$q.dark.mode ? 'grey600' : 'secondary'"
                :text-color="$q.dark.mode ? 'grey300' : 'white'"
                :label="$t('Sort Addon Category')"
                unelevated
                style="min-width: 170px"
                to="/addcategory/sort"
              />
              <q-fab-action
                label-position="left"
                :color="$q.dark.mode ? 'grey600' : 'secondary'"
                :text-color="$q.dark.mode ? 'grey300' : 'white'"
                :label="$t('Add Addon Items')"
                unelevated
                style="min-width: 170px"
                to="/addonitems/add"
              />
              <q-fab-action
                label-position="left"
                :color="$q.dark.mode ? 'grey600' : 'secondary'"
                :text-color="$q.dark.mode ? 'grey300' : 'white'"
                :label="$t('Add Addon Category')"
                unelevated
                style="min-width: 170px"
                to="/addcategory/add"
              />
            </q-fab>
          </q-page-sticky>
        </q-tab-panel>

        <q-tab-panel name="size" class="q-pa-none">
          <SizeList ref="size_list" :is_refresh="is_refresh"></SizeList>
        </q-tab-panel>

        <q-tab-panel name="ingredients" class="q-pa-none">
          <IngredientsList
            ref="ingredients_list"
            :is_refresh="is_refresh"
          ></IngredientsList>
        </q-tab-panel>

        <q-tab-panel name="cooking_ref" class="q-pa-none">
          <CookingList
            ref="cooking_ref_list"
            :is_refresh="is_refresh"
          ></CookingList>
        </q-tab-panel>

        <q-tab-panel name="review" class="q-pa-none">
          <ReviewList ref="review_list" :is_refresh="is_refresh"></ReviewList>
        </q-tab-panel>
      </q-tab-panels>
    </q-page>
    <ConfirmDialog
      ref="confirm_dialog"
      :data="DataStore.data_dialog"
      @after-confirm="afterConfirm"
    ></ConfirmDialog>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useMenuStore } from "stores/MenuStore";
import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";
import { useAccessStore } from "stores/AccessStore";

export default {
  name: "MenuAvailability",
  components: {
    AddonsList: defineAsyncComponent(() => import("components/AddonsList.vue")),
    ConfirmDialog: defineAsyncComponent(() =>
      import("components/ConfirmDialog.vue")
    ),
    ReviewList: defineAsyncComponent(() => import("components/ReviewList.vue")),
    ListNoData: defineAsyncComponent(() => import("components/ListNoData.vue")),
    SizeList: defineAsyncComponent(() => import("components/SizeList.vue")),
    IngredientsList: defineAsyncComponent(() =>
      import("components/IngredientsList.vue")
    ),
    CookingList: defineAsyncComponent(() =>
      import("components/CookingList.vue")
    ),
  },
  data() {
    return {
      available: true,
      fabItem: undefined,
      fabaddon: undefined,
      tab: "menu",
      is_refresh: undefined,
      tab_menu: [
        {
          label: this.$t("Menu Items"),
          value: "menu",
          permission: "food.items",
        },
        {
          label: this.$t("Addons"),
          value: "addons",
          permission: "food.addoncategory",
        },
        {
          label: this.$t("Size"),
          value: "size",
          permission: "attrmerchant.size_list",
        },
        {
          label: this.$t("Ingredients"),
          value: "ingredients",
          permission: "attrmerchant.ingredients_list",
        },
        {
          label: this.$t("Cooking Reference"),
          value: "cooking_ref",
          permission: "attrmerchant.cookingref_list",
        },
        // {
        //   label: "Reviews",
        //   value: "review",
        // },
      ],
    };
  },
  setup(props) {
    const MenuStore = useMenuStore();
    const DataStore = useDataStore();
    const AccessStore = useAccessStore();
    return { MenuStore, DataStore, AccessStore };
  },
  watch: {
    tab(newval, oldval) {
      this.DataStore.menu_tab = this.tab;
    },
  },
  created() {
    this.tab = this.DataStore.menu_tab;
    if (!this.MenuStore.hadCategory()) {
      this.MenuStore.geStoreMenu();
    } else {
      const refresh = this.$route.query.refresh;
      if (refresh == 1) {
        this.MenuStore.geStoreMenu();
      }
    }

    //this.MenuStore.getCategoryList();
  },
  methods: {
    refresh(done) {
      console.log(this.tab);
      if (this.tab == "menu") {
        this.MenuStore.geStoreMenu(done);
      } else if (this.tab == "addons") {
        this.MenuStore.geStoreAddonMenu(done);
      } else if (this.tab == "size") {
        this.is_refresh = done;
        this.$refs.size_list.resetPagination();
      } else if (this.tab == "ingredients") {
        this.is_refresh = done;
        this.$refs.ingredients_list.resetPagination();
      } else if (this.tab == "cooking_ref") {
        this.is_refresh = done;
        this.$refs.cooking_ref_list.resetPagination();
      } else if (this.tab == "review") {
        this.is_refresh = done;
        this.$refs.review_list.resetPagination();
      } else {
        done();
      }
    },
    confirmDelete(item_uuid) {
      this.item_uuid = item_uuid;
      this.$refs.confirm_dialog.dialog = true;
    },
    afterConfirm() {
      this.$refs.confirm_dialog.dialog = false;
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost("deleteItem", "id=" + this.item_uuid)
        .then((data) => {
          this.afterDeleteitem();
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    afterDeleteitem() {
      if (this.tab == "menu") {
        this.MenuStore.geStoreMenu();
      } else if (this.tab == "addons") {
        this.MenuStore.geStoreAddonMenu();
      }
    },
    setAvailable(data, evt, item_uuid) {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        "setItemAvailable",
        "item_uuid=" + item_uuid + "&active=" + data
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
