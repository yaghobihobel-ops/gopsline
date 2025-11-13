<template>
  <q-dialog
    v-model="modal"
    maximized
    persistentx
    transition-show="slide-up"
    transition-hide="slide-down"
    transition-duration="500"
    @before-show="fetchItemDetails"
  >
    <q-card>
      <div v-if="loading">
        <div class="q-pa-xs q-gutter-y-sm">
          <q-skeleton height="200px" square class="bg-grey-2 radius10" />
          <q-skeleton height="30px" square class="bg-grey-2 radius10" />
          <q-skeleton type="QToolbar" class="bg-grey-2 radius10" />
          <q-skeleton
            v-for="items in 5"
            :key="items"
            type="text"
            class="bg-grey-2 radius10"
          />
          <q-skeleton
            v-for="items in 5"
            :key="items"
            type="QSlider"
            class="bg-grey-2 radius10"
          />
        </div>
      </div>

      <template v-else>
        <div class="relative-position q-pa-xs">
          <div class="absolute-right q-pt-sm" style="z-index: 9">
            <q-btn icon="close" flat v-close-popup></q-btn>
          </div>
          <q-responsive :ratio="16 / 9" style="max-height: 40vh">
            <q-img
              :src="data?.items?.url_image"
              fit="cover"
              spinner-color="transparent"
              loading="lazy"
              class="radius10"
            />
          </q-responsive>
        </div>
        <q-card-section class="q-pt-none q-gutter-y-xs ellipse-bg">
          <div class="text-subtitle1 text-weight-bold">
            {{ data?.items?.item_name }}
          </div>

          <div class="text-weight-bold text-subtitle2 text-primary">
            <template
              v-for="(price, index) in Object.values(data?.items?.price)"
              :key="price.item_size_id"
            >
              <div class="q-gutter-x-sm" v-if="index === 0">
                <span v-if="price.discount > 0" class="text-strike text-grey">
                  {{ price.pretty_price_after_discount }}
                </span>
                <span>{{ price.size_name }}</span>
                <span>{{ price.pretty_price }}</span>
              </div>
            </template>
          </div>

          <div class="bg-oranges radius8 text-caption q-mt-md">
            <q-item dense style="padding-left: 10px">
              <q-item-section>
                <div class="flex items-center q-gutter-x-xs">
                  <div class="relative-posotion" style="margin-top: -4px">
                    <q-icon
                      name="o_takeout_dining"
                      color="primary"
                      size="1.5em"
                    ></q-icon>
                  </div>
                  <div>{{ data?.items?.packaging_fee }}</div>
                </div>
              </q-item-section>

              <q-item-section>
                <div class="flex items-center q-gutter-x-xs">
                  <div class="relative-posotion" style="margin-top: -4px">
                    <q-icon
                      name="access_time"
                      color="primary"
                      size="1.5em"
                    ></q-icon>
                  </div>
                  <div>{{ data?.items?.preparation_time }}</div>
                </div>
              </q-item-section>

              <q-item-section side>
                <div class="flex items-center q-gutter-x-xs">
                  <div class="relative-posotion" style="margin-top: -4px">
                    <q-icon
                      name="star_border"
                      color="primary"
                      size="1.5em"
                    ></q-icon>
                  </div>
                  <div>0.0</div>
                </div>
              </q-item-section>
            </q-item>
          </div>

          <q-separator class="q-mt-md q-mb-md"></q-separator>

          <div class="text-weight-bold text-subtitle2">Description</div>
          <div class="text-caption text-grey line-normal ellipsis-3-lines">
            <span v-html="data?.items?.item_description"></span>
          </div>
          <q-space class="q-pa-sm"></q-space>
        </q-card-section>

        <q-card-section class="q-pa-none bg-grey-1 q-pa-sm q-gutter-y-md">
          <div class="myshadow bg-white q-pa-md radius10">
            <q-item tag="label" dense class="q-pa-none">
              <q-item-section>
                <q-item-label class="text-weight-bold text-subtitle2"
                  >Available</q-item-label
                >
              </q-item-section>
              <q-item-section side>
                <q-toggle
                  v-model="item_available"
                  @update:model-value="setItemavailable"
                />
              </q-item-section>
            </q-item>
          </div>

          <div class="myshadow bg-white q-pa-md radius10">
            <q-item tag="label" dense class="q-pa-none">
              <q-item-section>
                <q-item-label class="text-weight-bold text-subtitle2"
                  >Not for sale</q-item-label
                >
                <q-item-label caption>
                  {{
                    $t(
                      "The menu item will be visible in the menu but your customers will not be able to buy it."
                    )
                  }}
                </q-item-label>
              </q-item-section>
              <q-item-section side>
                <q-toggle
                  v-model="not_for_sale"
                  @update:model-value="setItemNotforsale"
                />
              </q-item-section>
            </q-item>
          </div>

          <div class="myshadow bg-white q-pa-sm radius10">
            <div class="text-weight-bold text-subtitle2">Price</div>
            <!-- <q-list separator dense>
              <template v-for="price in data?.items?.price" :key="price">
                <q-item tag="label" v-ripple style="padding-left: 0px">
                  <q-item-section class="itemsection-denses">
                    <q-item-label v-if="price.size_name">
                      {{ price.size_name }}
                    </q-item-label>
                    <q-item-label class="q-gutter-x-sm">
                      <span
                        v-if="price.discount > 0"
                        class="text-strike text-red"
                      >
                        {{ price.pretty_price_after_discount }}
                      </span>

                      <span>{{ price.pretty_price }}</span>
                    </q-item-label>
                  </q-item-section>
                </q-item>
              </template>
            </q-list> -->
            <div class="q-gutter-sm">
              <template v-for="price in data?.items?.price" :key="price">
                <q-btn no-caps unelevated class="myshadow radius10">
                  <div class="q-gutter-x-sm">
                    <span v-if="price.size_name">{{ price.size_name }}</span>
                    <span
                      v-if="price.discount > 0"
                      class="text-strike text-red"
                    >
                      {{ price.pretty_price_after_discount }}
                    </span>

                    <span>{{ price.pretty_price }}</span>
                  </div>
                </q-btn>
              </template>
            </div>
          </div>

          <template v-for="(meta, meta_name) in data?.meta_details" :key="meta">
            <div class="myshadow bg-white q-pa-md radius10">
              <div class="text-weight-bold text-subtitle2">
                {{ meta_label[meta_name] ?? meta_name }}
              </div>
              <q-item dense style="padding-left: 0px">
                <template v-for="(items, index) in meta" :key="items">
                  {{ items.meta_name
                  }}<span
                    class="q-mr-xs"
                    v-if="index < Object.keys(meta).length"
                    >,
                  </span>
                </template>
              </q-item>
            </div>
          </template>

          <template v-for="addons_list in data?.addons" :key="addons_list">
            <template v-for="addons in addons_list" :key="addons">
              <div class="myshadow bg-white q-pa-md q-pr-md radius10">
                <div class="text-weight-bold text-subtitle2">
                  {{ addons.subcategory_name.trim() }}
                </div>
                <template
                  v-for="addonitens in addons.sub_items"
                  :key="addonitens"
                >
                  <q-item class="q-pl-none" dense>
                    <q-item-section>
                      {{ data?.addon_items[addonitens]?.sub_item_name }}
                    </q-item-section>
                    <q-item-section side>
                      {{ data?.addon_items[addonitens]?.pretty_price }}
                    </q-item-section>
                  </q-item>
                </template>
              </div>
            </template>
          </template>

          <q-space class="q-pa-xl"></q-space>
        </q-card-section>

        <q-card-actions
          class="myshadow row items-center bg-white"
          :class="{
            'fixed-bottom ': !$q.platform.is.ios,
          }"
        >
          <div class="col q-pa-sm">
            <q-btn
              no-caps
              unelevated
              class="radius10 fit"
              size="lg"
              color="disabled"
              text-color="disabled"
              v-close-popup
            >
              <div class="text-weight-bold text-subtitle2">
                {{ $t("Close") }}
              </div>
            </q-btn>
          </div>
          <div class="col q-pa-sm">
            <q-btn
              no-caps
              unelevated
              class="radius10 fit"
              size="lg"
              color="amber-6"
              text-color="disabled"
              :to="{ path: '/item/edit', query: { item_uuid: item_uuid } }"
            >
              <div class="text-weight-bold text-subtitle2">
                {{ $t("Edit") }}
              </div>
            </q-btn>
          </div>
        </q-card-actions>
      </template>
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "ItemInformation",
  data() {
    return {
      modal: false,
      size: null,
      item_uuid: null,
      cat_id: null,
      loading: false,
      data: null,
      item_available: false,
      not_for_sale: false,
      meta_label: {
        cooking_ref: "Cooking Reference",
        ingredients: "Ingredients",
        dish: "Dish",
      },
    };
  },
  setup() {
    return {};
  },
  methods: {
    async setItemNotforsale(value) {
      try {
        APIinterface.showLoadingBox("", this.$q);
        const params = new URLSearchParams({
          item_uuid: this.item_uuid,
          value: value ? 1 : 0,
        }).toString();
        const response = await APIinterface.fetchDataByTokenPost(
          `setItemNotforsale`,
          params
        );
        this.$emit("afterUpdate");
        APIinterface.ShowSuccessful(response.msg, this.$q);
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
    async setItemavailable(value) {
      try {
        APIinterface.showLoadingBox("", this.$q);
        const params = new URLSearchParams({
          item_uuid: this.item_uuid,
          active: value,
        }).toString();
        const response = await APIinterface.fetchDataByTokenPost(
          `setItemavailable`,
          params
        );
        console.log("response", response);
        this.$emit("afterUpdate");
        APIinterface.ShowSuccessful(response.msg, this.$q);
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
    showItem(value) {
      this.item_uuid = value?.item_uuid;
      this.cat_id = value?.cat_id;
      this.modal = true;
    },
    async fetchItemDetails() {
      try {
        this.loading = true;
        const params = new URLSearchParams({
          item_uuid: this.item_uuid,
          cat_id: this.cat_id,
        }).toString();

        const response = await APIinterface.fetchGet(
          `fetchItemDetails?${params}`
        );
        this.data = response.details;
        this.item_available = this.data?.items?.available ?? false;
        this.not_for_sale = this.data?.items?.not_for_sale ?? false;
      } catch (error) {
        console.log("error", error);
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        this.data = null;
        this.modal = false;
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>
