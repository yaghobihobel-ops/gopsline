<template>
  <!-- LOADING -->
  <DIV v-if="CartStore.cart_loading">
    <q-list>
      <q-item v-for="items in 3" :key="items">
        <q-item-section avatar>
          <q-skeleton type="circle" />
        </q-item-section>
        <q-item-section>
          <q-skeleton type="text" style="width: 80%" />
          <q-skeleton type="text" />
          <q-skeleton type="text" style="width: 20%" />
        </q-item-section>
      </q-item>
    </q-list>
  </DIV>
  <!-- LOADING -->

  <DIV v-else>
    <template v-if="CartStore.hasItem">
      <q-list separator dense>
        <template v-for="(items, index) in getItems" :key="items.item_id">
          <q-slide-item
            @right="(opt) => onRight(opt, index)"
            left-color="white"
            :right-color="$q.dark.mode ? 'grey600' : 'white'"
          >
            <template v-slot:right>
              <div class="row items-center inline q-gutter-x-md">
                <q-btn
                  round
                  unelevated
                  color="lightprimary"
                  text-color="primary"
                  size="sm"
                  icon="las la-times"
                  @click="closeSlide(index)"
                />
                <FavsItem
                  ref="favs"
                  :layout="2"
                  :item_token="items.item_token"
                  :cat_id="items.cat_id"
                  :active="false"
                  size="md"
                  @after-savefav="afterSavefav(items)"
                />
                <q-btn
                  round
                  unelevated
                  color="lightprimary"
                  text-color="primary"
                  size="sm"
                  icon="las la-trash-alt"
                  @click="removeItem(items)"
                />
              </div>
            </template>
            <template v-slot:default>
              <q-item
                :class="{
                  //'bg-mydark text-white': $q.dark.mode,
                  'bg-white text-black': !$q.dark.mode,
                }"
                clickable
              >
                <q-item-section avatar top>
                  <template v-if="is_checkout">
                    <div class="relative-position">
                      <q-responsive style="width: 90px; height: 80px">
                        <q-img
                          :src="items.url_image"
                          lazy
                          fit="cover"
                          class="radius8"
                          spinner-color="secondary"
                          spinner-size="sm"
                          placeholder-src="placeholder.png"
                        />
                      </q-responsive>
                      <div class="absolute-bottom q-pa-xs">
                        <div
                          class="bg-white radius28 border-grey flex items-center justify-between"
                        >
                          <div>
                            <q-btn
                              v-if="items.qty == 1"
                              unelevated
                              dense
                              size="11px"
                              icon="eva-trash-outline"
                              flat
                              color="red"
                              @click="removeItem(items)"
                            />
                            <q-btn
                              v-else
                              unelevated
                              dense
                              size="11px"
                              icon="remove"
                              color="primary"
                              flat
                              @click="updateCartQty(-1, items.qty, items)"
                            />
                          </div>
                          <div class="text-weight-medium text-caption">
                            {{ items.qty }}
                          </div>
                          <div>
                            <q-btn
                              unelevated
                              dense
                              size="11px"
                              icon="add"
                              color="primary"
                              flat
                              @click="updateCartQty(1, items.qty, items)"
                            />
                          </div>
                        </div>
                      </div>
                    </div>
                  </template>
                  <template v-else>
                    <q-btn
                      outline
                      no-caps
                      size="12px"
                      padding="2px 5px"
                      color="grey-2"
                    >
                      <div class="text-blue-grey-6 text-weight-bold">
                        {{ items.qty }}x
                      </div>
                    </q-btn>
                  </template>
                </q-item-section>
                <q-item-section top>
                  <div class="text-subtitle2 line-normal">
                    {{ items.item_name }}
                  </div>
                  <div class="text-caption" v-if="items.price.size_name != ''">
                    ({{ items.price.size_name }})
                  </div>

                  <!-- details -->
                  <div class="text-caption text-grey-7">
                    <div v-if="items.attributes">
                      <template
                        v-for="attributes in items.attributes"
                        :key="attributes"
                      >
                        <template
                          v-for="attributes_data in attributes"
                          :key="attributes_data"
                        >
                          <span class="q-mr-xs">{{ attributes_data }},</span>
                        </template>
                      </template>
                    </div>

                    <template v-for="addons in items.addons" :key="addons">
                      <div
                        v-for="addon_items in addons.addon_items"
                        :key="addon_items"
                      >
                        {{ addon_items.sub_item_name }}
                      </div>
                    </template>

                    <div
                      v-if="items.special_instructions != ''"
                      class="text-blue-grey-6"
                    >
                      "{{ items.special_instructions }}"
                    </div>
                  </div>
                  <!-- details -->

                  <q-btn
                    :label="$t('Edit')"
                    no-caps
                    text-color="blue"
                    padding="5px 0px"
                    flat
                    align="left"
                    @click="editItems(items)"
                  ></q-btn>
                </q-item-section>
                <q-item-section side top>
                  {{ items.subtotal_pretty }}
                </q-item-section>
              </q-item>
            </template>
          </q-slide-item>
        </template>

        <q-separator v-if="CartStore.getCartCount > maxVisible"></q-separator>

        <q-item
          clickable
          v-if="CartStore.getCartItemsCount > maxVisible"
          @click="toggleShowMore"
        >
          <q-item-section>
            <q-item-label caption>
              {{ showMore ? $t("Show Less") : $t("Show More") }}
            </q-item-label>
          </q-item-section>
          <q-item-section side>
            <q-icon
              :name="
                showMore ? 'eva-chevron-up-outline' : 'eva-chevron-down-outline'
              "
              class="text-grey-4"
            ></q-icon>
          </q-item-section>
        </q-item>
      </q-list>
    </template>
    <!-- end items count -->

    <!-- <template v-else> You don't have any orders here! </template> -->
  </DIV>
  <!-- end loading card -->

  <ItemDetailsCheckbox
    ref="item_details2"
    :slug="CartStore.getMerchantId"
    :money_config="money_config"
    :currency_code="currency_code"
    :cart_uuid="CartStore.getCartID"
    @after-additems="afterAdditems"
  />
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useCartStore } from "src/stores/CartStore";

export default {
  name: "CartDetails",
  props: [
    "payload",
    "is_checkout",
    "page",
    "item_visible",
    "money_config",
    "currency_code",
  ],
  components: {
    FavsItem: defineAsyncComponent(() => import("components/FavsItem.vue")),
    ItemDetailsCheckbox: defineAsyncComponent(() =>
      import("components/ItemDetailsCheckbox.vue")
    ),
  },
  data() {
    return {
      loading: false,
      items_count: 0,
      cart_loading: true,
      cart_reloading: false,
      cart_uuid: "",
      cart_items: [],
      cart_summary: [],
      cart_merchant: [],
      cart_total: [],
      cart_subtotal: [],
      error: [],
      qty_options: [1, 2, 3, 4, 5, 6, 7, 8, 9],
      transaction_data: [],
      delivery_option: [],
      services_list: [],
      out_of_range: false,
      is_close_slide: false,
      data_slide: {},
      maxVisible: this.item_visible,
      showMore: false,
    };
  },
  setup() {
    const CartStore = useCartStore();
    return { CartStore };
  },
  computed: {
    getItems() {
      if (this.CartStore.getItems) {
        return this.showMore
          ? this.CartStore.getItems
          : this.CartStore.getItems.slice(0, this.maxVisible);
      }
      return null;
    },
  },
  methods: {
    editItems(value) {
      const params = {
        cat_id: value.cat_id,
        item_uuid: value.item_token,
        cart_row: value.cart_row,
      };
      this.$refs.item_details2.showItem2(params, this.CartStore.getMerchantId);
    },
    afterAdditems() {
      this.CartStore.getCart(false, this.payload);
    },
    toggleShowMore() {
      this.showMore = !this.showMore;
    },
    updateCartQty(Qty, itemQty, item) {
      let QtyTotal = itemQty + Qty;
      item.qty = QtyTotal;
      this.updateCartItems(QtyTotal, item);
    },
    updateCartItems(itemQty, item) {
      this.loading = true;
      APIinterface.updateCartItems(
        this.CartStore.getCartID,
        item.cart_row,
        itemQty
      )
        .then((data) => {
          this.CartStore.getCart(false, this.payload);
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    closeSlide(index) {
      if (this.data_slide[index]) {
        console.log(this.data_slide[index]);
        this.data_slide[index].reset();
      }
    },
    onRight(details, index) {
      this.data_slide[index] = details;
    },
    removeItem(items) {
      this.loading = true;
      APIinterface.removeCartItem(this.CartStore.getCartID, items.cart_row)
        .then((data) => {
          this.CartStore.getCart(false, this.payload);
          this.$emit("afterRemoveitem");
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    clearCart() {
      this.loading = false;
      APIinterface.clearCart(APIinterface.getStorage("cart_uuid"))
        .then((data) => {
          this.CartStore.getCart(false, this.payload);
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    afterSavefav(item) {
      this.removeItem(item);
    },
    lineItemTotal(qty, price) {
      console.log(qty + "x" + price);
      return parseFloat(price) * parseInt(qty);
    },
  },
};
</script>
