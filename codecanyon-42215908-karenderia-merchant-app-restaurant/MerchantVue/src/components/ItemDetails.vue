<template>
  <q-dialog v-model="dialog" position="bottom" @before-hide="beforeHide">
    <template v-if="loading">
      <q-card>
        <q-card-section style="min-height: calc(50vh)" class="border">
          <q-inner-loading :showing="true" color="primary" />
        </q-card-section>
      </q-card>
    </template>
    <template v-else>
      <q-card>
        <q-card-section
          class="no-wrap q-pa-none bg-mygreyx relative-position"
          :class="{
            'bg-grey600 ': $q.dark.mode,
            'bg-mygrey ': !$q.dark.mode,
          }"
          style="
            border-bottom-right-radius: 25px;
            border-bottom-left-radius: 25px;
          "
        >
          <q-img
            :src="items.url_image"
            placeholder-src="placeholder.png"
            style="height: 150px"
            fit="cover"
            spinner-color="primary"
            spinner-size="xs"
          ></q-img>
          <div class="q-pa-sm absolute-top-right">
            <q-btn icon="close" color="grey" flat round dense v-close-popup />
          </div>
        </q-card-section>
        <q-card-section>
          <div class="text-weight-medium font17 line-normal ellipsis">
            {{ items.item_name }}
          </div>
          <p class="ellipsis-3-lines text-grey font12">
            <span v-html="items.item_description"></span>
          </p>

          <div
            class="bg-mygreyx q-pa-sm radius10 q-mb-md"
            :class="{
              'bg-grey600 ': $q.dark.mode,
              'bg-mygrey ': !$q.dark.mode,
            }"
          >
            <div class="text-weight-medium font15 line-normal">
              {{ $t("Customize your Order") }}
            </div>
            <q-option-group
              v-model="item_size_id"
              :options="size_data"
              inline
              size="xs"
            />
          </div>

          <!-- COOKING REF -->
          <template v-if="cooking_data.length > 0">
            <div
              class="bg-mygreyx q-pa-sm radius10 q-mb-md"
              :class="{
                'bg-grey600 ': $q.dark.mode,
                'bg-mygrey ': !$q.dark.mode,
              }"
            >
              <div class="flex justify-between">
                <div class="text-weight-medium font15 line-normal">
                  {{ $t("Cooking Reference") }}
                </div>
                <div class="text-grey font12">
                  <template v-if="items.cooking_ref_required">
                    <span
                      class="bg-yellow-11 text-dark q-pa-xs rounded-borders"
                      >{{ $t("Required") }}</span
                    >
                  </template>
                  <template v-else>
                    <span>({{ $t("Optional") }})</span>
                  </template>
                </div>
              </div>
              <q-option-group
                v-model="cooking_ref"
                :options="cooking_data"
                inline
                size="xs"
              />
            </div>
          </template>
          <!-- COOKING REF -->

          <!-- Ingredients -->
          <template v-if="ingredients_data.length > 0">
            <div
              class="bg-mygreyx q-pa-sm radius10 q-mb-md"
              :class="{
                'bg-grey600 ': $q.dark.mode,
                'bg-mygrey ': !$q.dark.mode,
              }"
            >
              <div class="flex justify-between">
                <div>
                  <div class="text-weight-medium font15 line-normal">
                    {{ $t("Ingredients") }}
                  </div>
                </div>
              </div>
              <q-option-group
                v-model="ingredients"
                :options="ingredients_data"
                inline
                type="checkbox"
                size="xs"
                checked-icon="check_box"
                unchecked-icon="square"
              />
            </div>
          </template>
          <!-- Ingredients -->

          <!-- addons -->
          <template v-if="addons[item_size_id]">
            <template
              v-for="addons in addons[item_size_id]"
              :key="addons.subcat_id"
            >
              <div
                class="bg-mygreyx q-pa-sm radius10 q-mb-md"
                :class="{
                  'bg-grey600 ': $q.dark.mode,
                  'bg-mygrey ': !$q.dark.mode,
                }"
              >
                <div class="flex justify-between">
                  <div class="text-weight-medium font15 line-normal">
                    {{ addons.subcategory_name }}
                  </div>
                  <div class="text-grey font12">
                    <template v-if="addons.multi_option === 'one'">
                      {{ $t("Select 1") }}
                      <template v-if="addons.require_addon == 1">
                        <span
                          class="bg-yellow-11 text-dark q-pa-xs rounded-borders"
                          >{{ $t("Required") }}</span
                        >
                      </template>
                    </template>
                    <template v-else-if="addons.multi_option === 'multiple'">
                      <template v-if="addons.multi_option_min > 0">
                        {{
                          $t("Select minimum {min} to maximum {max}", {
                            min: addons.multi_option_min,
                            max: addons.multi_option_value,
                          })
                        }}
                      </template>
                      <template v-else>
                        {{ $t("Choose up to") }} {{ addons.multi_option_value }}
                      </template>

                      <template v-if="addons.require_addon == 1">
                        <span
                          class="bg-yellow-11 text-dark q-pa-xs rounded-borders"
                          >{{ $t("Required") }}</span
                        >
                      </template>
                    </template>
                    <template v-else-if="addons.multi_option === 'custom'">
                      <template v-if="addons.multi_option_min > 0">
                        {{
                          $t("Select minimum {min} to maximum {max}", {
                            min: addons.multi_option_min,
                            max: addons.multi_option_value,
                          })
                        }}
                      </template>
                      <template v-else>
                        {{ $t("Choose up to") }} {{ addons.multi_option_value }}
                      </template>

                      <template v-if="addons.require_addon == 1">
                        <span
                          class="bg-yellow-11 text-dark q-pa-xs rounded-borders"
                          >{{ $t("Required") }}</span
                        >
                      </template>
                    </template>
                    <template v-else> ({{ $t("Optional") }}) </template>
                  </div>
                </div>

                <q-list>
                  <q-item
                    v-for="sub_items in addons.sub_items"
                    :key="sub_items.sub_item_id"
                    v-ripple
                    :tag="addons.multi_option === 'multiple' ? 'div' : 'label'"
                  >
                    <template v-if="addons.multi_option === 'one'">
                      <q-item-section avatar>
                        <q-radio
                          v-model="addons.sub_items_checked"
                          :val="sub_items.sub_item_id"
                          color="primary"
                          size="sm"
                        />
                      </q-item-section>
                      <q-item-section>
                        <q-item-label>{{
                          sub_items.sub_item_name
                        }}</q-item-label>
                      </q-item-section>
                      <q-item-section side>
                        <q-item-label caption>{{
                          sub_items.pretty_price
                        }}</q-item-label>
                      </q-item-section>
                    </template>

                    <template v-else-if="addons.multi_option === 'custom'">
                      <q-item-section avatar>
                        <q-checkbox
                          v-model="sub_items.checked"
                          :val="sub_items.sub_item_id"
                          label=""
                          :disable="sub_items.disabled"
                          color="primary"
                          size="sm"
                        >
                        </q-checkbox>
                      </q-item-section>
                      <q-item-section>
                        <q-item-label>{{
                          sub_items.sub_item_name
                        }}</q-item-label>
                      </q-item-section>
                      <q-item-section side>
                        <q-item-label caption>{{
                          sub_items.pretty_price
                        }}</q-item-label>
                      </q-item-section>
                    </template>

                    <template v-else-if="addons.multi_option === 'multiple'">
                      <q-item-section :side="!sub_items.checked">
                        <div
                          v-if="sub_items.checked == true"
                          class="row items-center justify-center"
                        >
                          <div class="col no-padding text-center">
                            <q-btn
                              @click="
                                sub_items.qty > 1
                                  ? sub_items.qty--
                                  : (sub_items.checked = false)
                              "
                              round
                              unelevated
                              dense
                              size="11px"
                              color="darkgreen"
                              icon="remove"
                            />
                          </div>
                          <div class="col no-padding text-center">
                            {{ sub_items.qty }}
                          </div>
                          <div class="col no-padding text-center">
                            <q-btn
                              @click="sub_items.qty++"
                              round
                              unelevated
                              dense
                              size="11px"
                              color="darkgreen"
                              icon="add"
                              :disabled="sub_items.disabled"
                            />
                          </div>
                        </div>
                        <div v-else>
                          <q-btn
                            @click="sub_items.checked = true"
                            round
                            unelevated
                            dense
                            size="11px"
                            color="grey-4"
                            icon="add"
                            :disabled="sub_items.disabled"
                          />
                        </div>
                      </q-item-section>
                      <q-item-section>
                        <q-item-label>{{
                          sub_items.sub_item_name
                        }}</q-item-label>
                      </q-item-section>
                      <q-item-section side>
                        <q-item-label caption>{{
                          sub_items.pretty_price
                        }}</q-item-label>
                      </q-item-section>
                    </template>
                  </q-item>
                </q-list>
              </div>
            </template>
          </template>
          <!-- addons -->

          <div
            class="bg-mygreyx q-pa-sm radius10 q-mb-md"
            :class="{
              'bg-grey600 ': $q.dark.mode,
              'bg-mygrey ': !$q.dark.mode,
            }"
          >
            <div class="text-weight-medium font15 line-normal">
              {{ $t("Special Instructions") }}
            </div>
            <q-input
              v-model="special_instructions"
              autogrow
              class="q-mb-md full-width"
            />
            <div class="text-weight-medium font15 line-normal">
              {{ $t("If sold out") }}
            </div>
            <q-select
              dense
              v-model="if_sold_out"
              :options="sold_out_options"
              class="q-mb-md"
              transition-show="scale"
              transition-hide="scale"
            />
          </div>
          <q-space class="q-pa-xl"></q-space>
        </q-card-section>
      </q-card>

      <div
        class="fixed-bottom q-pa-md relative-position"
        :class="{
          'bg-grey600 ': $q.dark.mode,
          'bg-white ': !$q.dark.mode,
        }"
      >
        <template v-if="!loading && items.not_for_sale">
          <q-btn
            :label="$t('Not for sale')"
            color="blue-grey-6"
            no-caps
            unelevated
            rounded
            class="fit"
            size="lg"
            disabled
          />
        </template>
        <template v-else-if="!itemAvailable(items.item_id, items.cat_id)">
          <q-btn
            :label="$t('Not available')"
            color="blue-grey-6"
            no-caps
            unelevated
            rounded
            class="fit"
            size="lg"
            disabled
          />
        </template>
        <div v-else class="row items-center">
          <div class="col-4">
            <div class="text-weight-medium">{{ $t("Total Price") }}</div>
            <div class="text-weight-bold text-primary">
              <NumberFormat :amount="item_total"></NumberFormat>
            </div>
          </div>
          <div class="col input-center row items-center q-col-gutter-sm">
            <div class="col-7">
              <q-input
                v-model="item_qty"
                outlined
                color="green-5"
                bg-color="green-5"
                maxlength="14"
                dense
                class="input-to-white radius28"
                style="overflow: hidden"
              >
                <template v-slot:prepend>
                  <q-btn
                    color="green"
                    text-color="white"
                    icon="remove"
                    unelevated
                    dense
                    size="sm"
                    @click="item_qty > 1 ? item_qty-- : 1"
                  />
                </template>
                <template v-slot:append>
                  <q-btn
                    color="green"
                    text-color="white"
                    icon="add"
                    unelevated
                    dense
                    size="sm"
                    @click="item_qty++"
                  />
                </template>
              </q-input>
            </div>
            <!-- col -->

            <div class="col">
              <q-btn
                unelevated
                color="green"
                :label="$t('Add')"
                class="radius28 q-pl-lg q-pr-lg q-pt-sm q-pb-sm"
                no-caps
                @click="AddToCart()"
                :loading="loading_add"
                :disable="disabled_cart"
              />
            </div>
            <!-- col -->
          </div>
        </div>
      </div>
    </template>
  </q-dialog>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";

const empty = function (data) {
  if (
    typeof data === "undefined" ||
    data === null ||
    data === "" ||
    data === "null" ||
    data === "undefined"
  ) {
    return true;
  }
  return false;
};

export default {
  name: "ItemDetails",
  components: {
    NumberFormat: defineAsyncComponent(() =>
      import("components/NumberFormat.vue")
    ),
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  data() {
    return {
      dialog: false,
      size: "",
      with_qty: false,
      qty: 1,
      item_qty: 1,
      morphGroupModel: "add",
      item_data: [],
      cat_id: 0,
      item_uuid: "",
      loading: false,
      loading_add: false,
      items: [],
      item_size_id: 0,
      size_data: [],
      size_datas: [],
      cooking_ref: 0,
      cooking_data: [],
      ingredients: [],
      ingredients_data: [],
      addons: {},
      special_instructions: "",
      transaction_type: "",
      if_sold_out: "",
      sold_out_options: [],
      item_total: 0,
      disabled_cart: true,
      slide_items: 0,
      favorites: [],
      number_config: [],
      meta: [],
      items_not_available: [],
      category_not_available: [],
    };
  },
  watch: {
    addons: {
      handler(newValue, oldValue) {
        this.ItemSummary();
      },
      deep: true,
    },
    item_size_id() {
      this.ItemSummary();
    },
    cooking_ref() {
      this.ItemSummary();
    },
    ingredients() {
      this.ItemSummary();
    },
    item_qty() {
      this.ItemSummary();
    },
  },
  methods: {
    showModal(show, data) {
      this.dialog = show;
      this.item_data = data;
    },
    itemAvailable(item_id, cat_id) {
      if (this.items_not_available.includes(item_id) === false) {
        if (this.category_not_available.includes(cat_id) === false) {
          return true;
        }
      }
      return false;
    },
    resetData() {
      this.item_qty = 1;
      this.items = [];
      this.item_size_id = 0;
      this.size_data = [];
      this.size_datas = [];
      this.cooking_ref = 0;
      this.cooking_data = [];
      this.ingredients = [];
      this.ingredients_data = [];
      this.addons = {};
      this.special_instructions = "";
      this.transaction_type = "";
      this.if_sold_out = "";
      this.sold_out_options = [];
      this.item_total = 0;
      this.disabled_cart = true;
      this.slide_items = 0;
    },
    getMenuItem(data, ajaxbar) {
      this.item_data = data;
      //ajaxbar.start();

      this.resetData();
      this.loading = true;
      let params = "";
      params =
        "cat_id=" +
        this.item_data.cat_id +
        "&item_uuid=" +
        this.item_data.item_uuid;

      APIinterface.fetchDataByTokenPost(
        "getMenuItem",
        "cat_id=" +
          this.item_data.cat_id +
          "&item_uuid=" +
          this.item_data.item_uuid
      )
        .then((data) => {
          //this.dialog = true;
          this.number_config = data.details.config;
          this.items = data.details.data.items;
          this.meta = data.details.data.meta;
          this.size_datas = data.details.data.items.price;
          const soldOutData = data.details.sold_out_options;

          this.if_sold_out = data.details.default_sold_out_options;

          this.items_not_available = data.details.data.items_not_available;
          this.category_not_available =
            data.details.data.category_not_available;

          const prices = data.details.data.items.price;
          const metaCookingRef = data.details.data.meta
            ? data.details.data.meta.cooking_ref
            : {};
          const metaCookingRefDetails = data.details.data.meta
            ? data.details.data.meta_details.cooking_ref
            : {};

          const metaIngredients = data.details.data.meta
            ? data.details.data.meta.ingredients
            : {};
          const metaIngredientsDetails = data.details.data.meta
            ? data.details.data.meta_details.ingredients
            : {};

          const addons = data.details.data ? data.details.data.addons : {};
          const addonItems = data.details.data
            ? data.details.data.addon_items
            : {};

          if (Object.keys(soldOutData).length > 0) {
            Object.entries(soldOutData).forEach(
              ([itemSoldKey, itemsSoldData]) => {
                this.sold_out_options.push({
                  label: itemsSoldData,
                  value: itemSoldKey,
                });
              }
            );
          }

          if (Object.keys(prices).length > 0) {
            Object.entries(prices).forEach(([key, items]) => {
              if (items.discount <= 0) {
                this.size_data.push({
                  label: items.size_name + " " + items.pretty_price,
                  value: parseInt(items.item_size_id),
                });
              } else {
                this.size_data.push({
                  label:
                    items.size_name + " " + items.pretty_price_after_discount,
                  value: parseInt(items.item_size_id),
                });
              }
            });
            this.item_size_id = parseInt(Object.keys(prices)[0]);
          }

          if (
            typeof metaCookingRef !== "undefined" &&
            metaCookingRef !== null
          ) {
            if (metaCookingRef.length > 0) {
              Object.entries(metaCookingRef).forEach(([key, value]) => {
                this.cooking_data.push({
                  label: metaCookingRefDetails[value].meta_name,
                  value: metaCookingRefDetails[value].meta_id,
                });
              });
            }
          }

          if (
            typeof metaIngredients !== "undefined" &&
            metaIngredients !== null
          ) {
            if (metaIngredients.length > 0) {
              Object.entries(metaIngredients).forEach(([key, value]) => {
                if (metaIngredientsDetails[value]) {
                  this.ingredients_data.push({
                    label: metaIngredientsDetails[value].meta_name,
                    value: metaIngredientsDetails[value].meta_id,
                  });
                  if (this.items.ingredients_preselected) {
                    this.ingredients.push(
                      metaIngredientsDetails[value].meta_id
                    );
                  }
                }
              });
            }
          }

          // addons
          if (Object.keys(addons).length > 0) {
            Object.entries(addons).forEach(([sizeId, Subcat]) => {
              const addOnsAdded = [];
              Object.entries(Subcat).forEach(([key, child]) => {
                const subItems = [];
                Object.entries(child.sub_items).forEach(
                  ([key2, subItemsID]) => {
                    if (addonItems[subItemsID]) {
                      const subItemsAdd = addonItems[subItemsID];
                      addonItems[subItemsID].checked = false;
                      addonItems[subItemsID].disabled = false;
                      addonItems[subItemsID].qty = 1;
                      subItems.push(subItemsAdd);
                    }
                  }
                );

                const subdata = {
                  subcat_id: child.subcat_id,
                  subcategory_name: child.subcategory_name,
                  subcategory_description: child.subcategory_description,
                  multi_option: child.multi_option,
                  multi_option_min: child.multi_option_min,
                  multi_option_value: child.multi_option_value,
                  require_addon: child.require_addon,
                  pre_selected: child.pre_selected,
                  sub_items_checked: "",
                  sub_items: subItems,
                };
                addOnsAdded.push(subdata);
              });
              this.addons[sizeId] = addOnsAdded;
            });
          }
          //
        })
        .catch((error) => {
          console.debug(error);
        })
        .then((data) => {
          this.loading = false;
          //ajaxbar.stop();
        });
    },
    beforeHide() {
      this.qty = 1;
    },
    ItemSummary() {
      let $itemTotal = 0;
      const $requiredAddon = [];
      const $requiredAddonAdded = [];
      let $min_addon = [];
      let $min_addon_added = [];

      if (!empty(this.size_datas[this.item_size_id])) {
        const item = this.size_datas[this.item_size_id];
        if (item.discount > 0) {
          $itemTotal += this.item_qty * parseFloat(item.price_after_discount);
        } else $itemTotal += this.item_qty * parseFloat(item.price);
      }

      if (!empty(this.addons[this.item_size_id])) {
        this.addons[this.item_size_id].forEach((item, index) => {
          if (item.require_addon === "1") {
            $requiredAddon.push(item.subcat_id);
          }

          if (item.multi_option === "custom") {
            let totalCheck = 0;
            const multiOptionValue = item.multi_option_value;
            let multi_option_min = item.multi_option_min;

            if (multiOptionValue > 0) {
              $min_addon.push({
                subcat_id: item.subcat_id,
                min: multi_option_min,
                max: multiOptionValue,
              });
            }

            const itemIndex = [];
            const itemIndex2 = [];
            item.sub_items.forEach((item2, index2) => {
              if (item2.checked === true) {
                totalCheck++;
                $itemTotal += this.item_qty * parseFloat(item2.price);
                $requiredAddonAdded.push(item.subcat_id);
              } else itemIndex.push(index2);

              if (item2.disabled === true) {
                itemIndex2.push(index2);
              }
            });

            $min_addon_added[item.subcat_id] = {
              total: totalCheck,
            };

            if (totalCheck >= multiOptionValue) {
              itemIndex.forEach((item3, index3) => {
                item.sub_items[item3].disabled = true;
              });
            } else {
              itemIndex2.forEach((item3, index3) => {
                item.sub_items[item3].disabled = false;
              });
            }
          } else if (item.multi_option === "one") {
            item.sub_items.forEach((item2, index2) => {
              if (item2.sub_item_id === item.sub_items_checked) {
                $itemTotal += this.item_qty * parseFloat(item2.price);
                $requiredAddonAdded.push(item.subcat_id);
              }
            });
          } else if (item.multi_option === "multiple") {
            var item_index = [];
            let multi_option_min = item.multi_option_min;
            var multi_option_value = item.multi_option_value;
            var limit = 0;

            if (multi_option_value > 0) {
              $min_addon.push({
                subcat_id: item.subcat_id,
                min: multi_option_min,
                max: multi_option_value,
              });
            }

            item.sub_items.forEach((item2, index2) => {
              if (item2.checked === true) {
                $itemTotal += item2.qty * parseFloat(item2.price);
                $requiredAddonAdded.push(item.subcat_id);
                limit += item2.qty;
              }
              item_index.push(index2);
            });

            $min_addon_added[item.subcat_id] = {
              total: limit,
            };

            this.addons[this.item_size_id][index].qty_selected = limit;
            if (
              this.addons[this.item_size_id][index].qty_selected >=
              multi_option_value
            ) {
              item_index.forEach((item3, index2) => {
                this.addons[this.item_size_id][index].sub_items[
                  item3
                ].disabled = true;
              });
            } else {
              item_index.forEach((item3, index2) => {
                this.addons[this.item_size_id][index].sub_items[
                  item3
                ].disabled = false;
              });
            }
          } /* endif custom */
        });
        // end loop addons
      }

      if ($itemTotal > 0) {
        this.item_total = $itemTotal;
      }

      let $requiredMeet = true;
      if ($requiredAddon.length > 0) {
        $requiredAddon.forEach((requiedItem, requiredIndex) => {
          if ($requiredAddonAdded.includes(requiedItem) === false) {
            $requiredMeet = false;
            return false;
          }
        });
      }

      // CHECK COOKING REF
      if (this.items.cooking_ref_required) {
        let $cooking_ref_check = false;
        if (this.cooking_ref > 0) {
          $cooking_ref_check = true;
        }
        if (!$cooking_ref_check) {
          $requiredMeet = false;
        }
      }

      // CHECK ADDON MINIMUM AND MAXIMUM
      if (Object.keys($min_addon).length > 0) {
        let min_value, min_selected;
        Object.entries($min_addon).forEach(
          ([key_min_addon, items_min_addon]) => {
            min_value = parseInt(items_min_addon.min);
            if ($min_addon_added[items_min_addon.subcat_id]) {
              min_selected = parseInt(
                $min_addon_added[items_min_addon.subcat_id].total
              );
            }
            if (min_selected > 0) {
              if (min_value > min_selected) {
                $requiredMeet = false;
              }
            }
          }
        );
      }

      if ($requiredMeet) {
        this.disabled_cart = false;
      } else this.disabled_cart = true;
    },
    AddToCart() {
      const $ingredients = [];
      if (this.ingredients.length > 0) {
        this.ingredients.forEach((ingredientsId, index) => {
          $ingredients.push({
            meta_id: ingredientsId,
            checked: true,
            meta_name: "",
          });
        });
      }

      const $meta = {
        cooking_ref: [
          {
            meta_id: this.cooking_ref,
            checked: this.cooking_ref,
            meta_name: "",
          },
        ],
        ingredients: $ingredients,
      };

      const $cartUuid = this.DataStore.cart_uuid;
      const $data = {
        cart_uuid: $cartUuid,
        cat_id: this.item_data.cat_id,
        item_size_id: this.item_size_id,
        item_token: this.item_data.item_uuid,
        item_qty: this.item_qty,
        special_instructions: this.special_instructions,
        if_sold_out: this.if_sold_out.value,
        transaction_type: this.DataStore.cart_transaction_type,
        meta: $meta,
        item_addons: !empty(this.addons[this.item_size_id])
          ? this.addons[this.item_size_id]
          : [],
      };

      this.loading_add = true;
      APIinterface.fetchDataByTokenPost("addCartItems", $data)
        .then((data) => {
          if (empty($cartUuid)) {
            this.DataStore.cart_uuid = data.details.cart_uuid;
          }
          this.dialog = false;
          this.$emit("afterAddtocart");
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading_add = false;
        });
    },
    //
  },
};
</script>
