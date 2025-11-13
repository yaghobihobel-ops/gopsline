<template>
  <q-list separator>
    <q-item
      clickable
      v-ripple:purple
      v-for="items in data"
      :key="items"
      @click.stop="onClickItem(category, items)"
    >
      <q-item-section top avatar>
        <q-responsive style="width: 110px; height: 90px">
          <q-img
            :src="items.url_image"
            placeholder-src="placeholder.png"
            lazy
            fit="scale-down"
            class="radius8"
            spinner-color="primary"
            spinner-size="sm"
          />
        </q-responsive>
      </q-item-section>
      <q-item-section>
        <q-item-label>
          <div
            class="text-weight-medium text-subtitle2"
            v-html="items.item_name"
          ></div>
        </q-item-label>
        <q-item-label>
          <div
            class="text-grey ellipsis-2-lines text-caption line-normal"
            v-html="items.item_description"
          ></div>

          <div class="q-mt-xs q-mb-xs q-gutter-x-sm">
            <template v-for="dish in items.dish_list" :key="dish">
              <q-avatar size="2em" class="bg-yellow-9">
                <img :src="dish.url_image" />
              </q-avatar>
            </template>
          </div>

          <div class="text-weight-bold text-overline letter-spacing-none">
            {{ items.lowest_price }}
          </div>

          <q-badge
            v-if="!items.available"
            color="disabled"
            text-color="disabled"
            :label="$t('Not available')"
            rounded
          />

          <q-tooltip
            v-model="item_tooltip[`${items.item_uuid}${category.cat_id}`]"
            :no-parent-event="true"
          >
            {{ items.item_unavailable }}</q-tooltip
          >
        </q-item-label>
      </q-item-section>
      <q-item-section side class="row items-stretch">
        <div class="column items-center col-12 q-gutter-y-sm">
          <div class="col">
            <FavsItem
              ref="favs"
              :layout="3"
              :item_token="items.item_uuid"
              :cat_id="category.cat_id"
              :active="items.is_favorite"
              :data="items"
              @after-savefav="afterSavefavItem"
              @on-saved="onSavedfavItem"
            />
          </div>
          <div class="col" v-if="items.total_allergens > 0">
            <q-btn
              round
              unelevated
              color="mygrey"
              text-color="dark"
              size="sm"
              icon="o_info"
              @click.stop="showAllergens(this.merchant_id, items.item_id)"
            />
          </div>
          <div class="col">
            <template v-if="findItem(items.item_uuid, category.cat_id)">
              <q-btn
                outline
                color="primary"
                round
                size="sm"
                @click.stop="
                  showOptions(findItem(items.item_uuid, category.cat_id))
                "
              >
                <div style="font-size: 14px">
                  {{ findItemQty(items.item_uuid, category.cat_id) }}
                </div>
              </q-btn>
            </template>
            <template v-else>
              <q-btn
                round
                unelevated
                color="primary"
                text-color="white"
                size="sm"
                icon="las la-plus"
                :disable="!items.available"
                @click.stop="onClickItem(category, items)"
              />
            </template>
          </div>
        </div>
      </q-item-section>
    </q-item>
  </q-list>
  <!-- end item list -->
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useCartStore } from "stores/CartStore";
import { useDataStore } from "stores/DataStore";

export default {
  name: "MenuList",
  props: ["data", "category", "merchant_id"],
  components: {
    FavsItem: defineAsyncComponent(() => import("src/components/FavsItem.vue")),
  },
  setup() {
    const CartStore = useCartStore();
    const DataStore = useDataStore();
    return { CartStore, DataStore };
  },
  data() {
    return {
      item_tooltip: {},
    };
  },
  methods: {
    onSavedfavItem(data, found) {
      data.is_favorite = found;
      // CLEAR HOME PAGE FILTER AND FAV
      this.DataStore.feed_filter = [];
      this.DataStore.fav_saved_data = null;
    },
    onClickItem(category, items) {
      if (!items.available) {
        this.item_tooltip[`${items.item_uuid}${category.cat_id}`] = true;
        setTimeout(() => {
          this.item_tooltip[`${items.item_uuid}${category.cat_id}`] = false;
        }, 2000);
        return false;
      }
      const find_item = this.findItem(items.item_uuid, category.cat_id);
      if (find_item) {
        this.showOptions(find_item);
        return;
      } else {
        this.$emit("onClickitems", {
          cat_id: category.cat_id,
          item_uuid: items.item_uuid,
        });
      }
    },
    showAllergens(merchant_id, item_id) {
      this.$emit("showAllergens", {
        merchant_id: merchant_id,
        item_id: item_id,
      });
    },
    showOptions(value) {
      this.$emit("showOptions", value);
    },
    findItem(value, cat_id) {
      const items = this.CartStore.getItems;
      if (!items || items.length === 0) {
        return false;
      }
      const foundItem = items.filter(
        (item) => item.item_token === value && item.cat_id == cat_id
      );
      return foundItem.length > 0 ? foundItem : false;
    },
    findItemQty(value, cat_id) {
      const items = this.CartStore.getItems;
      if (!items || items.length === 0) {
        return false;
      }
      const summedQty = items
        .filter((item) => item.item_token === value && item.cat_id == cat_id)
        .reduce((acc, item) => acc + item.qty, 0);

      return summedQty;
    },
  },
};
</script>
