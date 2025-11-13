<template>
  <div class="flex justify-between items-center q-pa-sm">
    <div class="">
      <q-btn
        flat
        :label="$t('Close')"
        no-caps
        size="md"
        dense
        @click="CartStore.cart_drawer = !CartStore.cart_drawer"
      ></q-btn>
    </div>
    <div class="">
      <q-badge
        rounded
        color="red"
        class="q-pa-sm"
        :label="$t('Items in cart' + ' ' + this.CartStore.getCartCount)"
      />
    </div>
  </div>

  <div class="q-pl-sm q-pr-sm">
    <div class="bg-grey600 radius8">
      <SelectCustomer
        ref="customer"
        @create-customer="createCustomer"
        :options_data="
          CartStore.customer_data ? CartStore.customer_data : customer_data
        "
      ></SelectCustomer>
      <q-space class="q-pa-xs"></q-space>
      <q-btn-toggle
        v-model="DataStore.cart_transaction_type"
        toggle-color="green"
        unelevated
        no-caps
        :options="CartStore.getTransactionList"
        spread
        dense
        @click="setTransactionType"
        :disable="!CartStore.hasData"
      />
      <q-space class="q-pa-xs"></q-space>

      <div
        v-if="DataStore.cart_transaction_type == 'delivery'"
        class="flex flex-center justify-around bg-grey500 q-pt-xs q-pb-xs"
      >
        <div>
          <q-icon size="sm" name="las la-map-marker"></q-icon>
        </div>
        <div class="ellipsis" style="max-width: 180px">
          <template v-if="DataStore.hasPlaceData">
            {{ DataStore.place_data.address.address1 }}
            {{ DataStore.place_data.address.formatted_address }}
          </template>
          <template v-else>
            {{ $t("Delivery Infomation") }}
          </template>
        </div>
        <div>
          <q-btn
            size="sm"
            dense
            flat
            icon="las la-pencil-alt"
            color="orange"
            :disable="!CartStore.hasData || CartStore.customer_id <= 0"
            to="/pos-order/add-address"
          />
        </div>
      </div>
    </div>
  </div>

  <template v-if="!CartStore.hasData">
    <div class="flex flex-center" style="min-height: calc(40vh)">
      <p class="text-grey300 q-ma-none">{{ $t("No items added") }}</p>
    </div>
  </template>

  <q-space class="q-pa-sm"></q-space>

  <q-list separator dark>
    <template v-for="items in CartStore.getItems" :key="items">
      <q-item>
        <q-item-section avatar top>
          <div class="absolute-top-left q-pl-sm z-index1">
            <q-btn
              size="xs"
              icon="las la-times"
              dense
              color="red"
              round
              @click="removeCartItem(items.cart_row)"
            ></q-btn>
          </div>
          <q-avatar rounded>
            <q-img
              :src="items.url_image"
              fit="cover"
              spinner-size="sm"
              spinner-color="primary"
              style="height: 50px; width: 50px"
            ></q-img>
          </q-avatar>
        </q-item-section>
        <q-item-section top>
          <q-item-label class="text-weight-medium"
            >{{ items.item_name }}
            <template v-if="items.price.size_name != ''">
              ({{ items.price.size_name }})
            </template>
          </q-item-label>

          <q-item-label caption>
            <template v-if="items.price.discount > 0">
              <p class="no-margin">
                <del>{{ items.price.pretty_price }}</del>
                {{ items.price.pretty_price_after_discount }}
              </p>
            </template>
            <template v-else>
              <p class="no-margin">{{ items.price.pretty_price }}</p>
            </template>

            <p
              class="no-margin text-grey"
              v-if="items.special_instructions != ''"
            >
              {{ items.special_instructions }}
            </p>

            <template v-if="items.attributes != ''">
              <template
                v-for="attributes in items.attributes"
                :key="attributes"
              >
                <p class="no-margin">
                  <template
                    v-for="(attributes_data, attributes_index) in attributes"
                  >
                    {{ attributes_data
                    }}<template v-if="attributes_index < attributes.length - 1"
                      >,
                    </template>
                  </template>
                </p>
              </template>
            </template>

            <!-- addons -->
            <div v-for="addons in items.addons" :key="addons">
              <div class="row q-mt-xs">
                <div class="col">
                  <p class="no-margin text-weight-bold">
                    {{ addons.subcategory_name }}
                  </p>
                </div>
              </div>
              <!-- row -->
              <div
                v-for="addon_items in addons.addon_items"
                :key="addon_items"
                class="flex items-center q-mb-xs q-gutter-x-sm"
              >
                <div>{{ addon_items.sub_item_name }}</div>
                <div>
                  ({{ addon_items.qty }} x {{ addon_items.pretty_price }} =
                  {{ addon_items.pretty_addons_total }})
                </div>
              </div>
            </div>
            <!-- addons -->
          </q-item-label>

          <div class="flex items-center q-col-gutter-x-sm">
            <div class="borderx">
              <q-btn
                v-if="items.qty <= 1"
                :disable="add_item || CartStore.cart_loading"
                @click="removeCartItem(items.cart_row)"
                size="xs"
                icon="las la-trash"
                dense
                color="red"
              ></q-btn>
              <q-btn
                v-else
                @click="
                  updateCartItems(
                    items.cart_row,
                    items.qty > 1 ? items.qty-- : 1,
                    'minus'
                  )
                "
                :disable="add_item || CartStore.cart_loading"
                size="xs"
                icon="las la-minus"
                dense
                color="green"
              ></q-btn>
            </div>
            <div class="borderx font12">{{ items.qty }}</div>
            <div class="borderx">
              <q-btn
                @click="updateCartItems(items.cart_row, items.qty++, 'add')"
                :disable="add_item || CartStore.cart_loading"
                size="xs"
                icon="las la-plus"
                dense
                color="green"
              ></q-btn>
            </div>
            <div>
              <template v-if="items.price.discount <= 0">
                <p class="q-ma-none">{{ items.price.pretty_total }}</p>
              </template>
              <template v-else>
                <p class="q-ma-none">
                  {{ items.price.pretty_total_after_discount }}
                </p>
              </template>
            </div>
          </div>
        </q-item-section>
      </q-item>
    </template>

    <template v-for="summary in CartStore.getSummary" :key="summary">
      <q-item v-if="summary.type != 'total'">
        <q-item-section>
          <q-item-label class="font12"
            >{{ summary.name }}
            <template
              v-if="
                summary.type == 'voucher' || summary.type == 'manual_discount'
              "
            >
              <q-btn
                size="xs"
                icon="las la-trash"
                dense
                color="red"
                @click="removePromocode"
              ></q-btn>
            </template>
            <template v-else-if="summary.type == 'tip'">
              <q-btn
                size="xs"
                icon="las la-trash"
                dense
                color="red"
                @click="removeTips"
              ></q-btn>
            </template>
            <template v-else-if="summary.type == 'points_discount'">
              <q-btn
                size="xs"
                icon="las la-trash"
                dense
                color="red"
                @click="removePoints"
              ></q-btn>
            </template>
          </q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-item-label caption>{{ summary.value }}</q-item-label>
        </q-item-section>
      </q-item>
    </template>
  </q-list>

  <q-space class="q-pa-md"></q-space>
  <q-space class="q-pa-xl"></q-space>

  <div class="absolute-bottom bg-grey600 z-index2">
    <!-- =>{{ CartStore.customer_id }} -->

    <!-- <div class="q-pa-sm">
      <div class="flex items-center justify-between q-gutter-y-sm">
        <q-btn
          color="white"
          text-color="black"
          :label="$t('Enter total manually')"
          class="full-width"
          no-caps
          dense
          unelevated
        />
        <q-btn
          color="blue"
          text-color="white"
          unelevated
          :label="$t('Point Discount')"
          class="full-width"
          no-caps
          dense
        />
      </div>
    </div> -->

    <div class="flex items-center justify-between q-pa-sm">
      <div class="font12">{{ $t("Total Amount") }}</div>
      <div class="text-weight-medium">
        {{ CartStore.getCartTotal.value }}
      </div>
    </div>

    <q-btn-group outline flat spread>
      <q-btn
        color="grey500"
        :label="$t('Promo')"
        no-caps
        stack
        icon="las la-tag"
        class="font11"
        :disable="!CartStore.hasData"
        @click="this.$refs.promo_code.dialog = true"
      />
      <q-btn
        color="grey500"
        :label="$t('Discount')"
        no-caps
        icon="las la-percentage"
        class="font11"
        :disable="!CartStore.hasData"
        @click="this.$refs.discount_promo.dialog = true"
      />
      <q-btn
        v-if="DataStore.cart_transaction_type != 'dinein'"
        color="grey500"
        :label="$t('Tips')"
        no-caps
        icon="lab la-gratipay"
        class="font11"
        :disable="!CartStore.hasData"
        @click="this.$refs.tips.dialog = true"
      />
      <!-- <q-btn
        color="grey500"
        :label="$t('Hold')"
        no-caps
        icon="las la-pause-circle"
        class="font11"
        :disable="!CartStore.hasData"
        @click="this.$refs.hold.dialog = true"
      /> -->
      <!-- <q-btn
        color="grey500"
        :label="$t('Reset')"
        no-caps
        icon="las la-sync"
        class="font11"
        @click="resetCart()"
        :disable="!CartStore.hasData"
      /> -->
      <q-btn
        color="grey500"
        :label="$t('More')"
        no-caps
        icon="more_vert"
        class="font11"
      >
        <q-popup-proxy ref="popup_more">
          <q-banner style="min-width: 250px">
            <q-list separator>
              <q-item
                clickable
                v-ripple
                :disable="!CartStore.hasData"
                @click="cartHold"
              >
                <q-item-section avatar>
                  <q-icon color="primary" name="las la-pause-circle" />
                </q-item-section>

                <q-item-section>{{ $t("Hold") }}</q-item-section>
              </q-item>

              <q-item
                clickable
                v-ripple
                :disable="!CartStore.hasData"
                @click="cartReset"
              >
                <q-item-section avatar>
                  <q-icon color="primary" name="las la-sync" />
                </q-item-section>

                <q-item-section>{{ $t("Reset") }}</q-item-section>
              </q-item>

              <q-item clickable v-ripple @click="showAddTotal">
                <q-item-section avatar>
                  <q-icon color="primary" name="add" />
                </q-item-section>

                <q-item-section>{{ $t("Enter total") }}</q-item-section>
              </q-item>

              <q-item
                clickable
                v-ripple
                @click="CartDiscount"
                :disable="CartStore.customer_id > 0 ? false : true"
              >
                <q-item-section avatar>
                  <q-icon color="primary" name="loyalty" />
                </q-item-section>

                <q-item-section>{{ $t("Points Discount") }}</q-item-section>
              </q-item>
            </q-list>
          </q-banner>
        </q-popup-proxy>
      </q-btn>
    </q-btn-group>

    <div v-if="CartStore.hasError" class="q-pl-sm q-pr-sm bg-yellow-2">
      <template v-for="error in CartStore.getCartError" :key="error">
        <div class="text-dark">{{ error }}</div>
      </template>
    </div>
    <div>
      <q-btn
        color="green fit"
        no-caps
        :disable="canCheckout || canCheckout2"
        @click="this.$refs.create_payment.dialog = true"
        size="lg"
      >
        <div class="flex justify-between fit">
          <div>{{ $t("Proceed to pay") }}</div>
          <div>
            <q-icon name="chevron_right"></q-icon>
          </div>
        </div>
      </q-btn>
    </div>
  </div>
  <PromoCode ref="promo_code" @after-applypromo="afterApplypromo"></PromoCode>
  <DiscountPromo
    ref="discount_promo"
    @after-applydiscount="afterApplypromo"
  ></DiscountPromo>

  <TipsModal ref="tips" @after-applydiscount="afterApplypromo"></TipsModal>

  <CreateCustomer
    ref="create_customer"
    @after-createcustomer="afterCreatecustomer"
  ></CreateCustomer>

  <DeliveryInformation ref="delivery_info"></DeliveryInformation>

  <PosCreatePayment
    ref="create_payment"
    :total="CartStore.getCartTotal.raw"
    @after-placeorder="afterPlaceorder"
  ></PosCreatePayment>

  <HoldOrders ref="hold" @after-holdorders="afterHoldorders"></HoldOrders>

  <PointsModal
    ref="points_modal"
    @after-applypoints="afterApplypoints"
  ></PointsModal>

  <TotalManually
    ref="total_manually"
    @after-applytotal="loadCart"
  ></TotalManually>

  <q-ajax-bar ref="bar" position="top" color="primary" size="2px" skip-hijack />
</template>

<script>
import { defineComponent, defineAsyncComponent } from "vue";
import { useCartStore } from "stores/CartStore";
import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";

export default {
  name: "PosCart",
  components: {
    PromoCode: defineAsyncComponent(() => import("components/PromoCode.vue")),
    DiscountPromo: defineAsyncComponent(() =>
      import("components/DiscountPromo.vue")
    ),
    TipsModal: defineAsyncComponent(() => import("components/TipsModal.vue")),

    HoldOrders: defineAsyncComponent(() => import("components/HoldOrders.vue")),

    SelectCustomer: defineAsyncComponent(() =>
      import("components/SelectCustomer.vue")
    ),
    CreateCustomer: defineAsyncComponent(() =>
      import("components/CreateCustomer.vue")
    ),
    DeliveryInformation: defineAsyncComponent(() =>
      import("components/DeliveryInformation.vue")
    ),
    PosCreatePayment: defineAsyncComponent(() =>
      import("components/PosCreatePayment.vue")
    ),
    PointsModal: defineAsyncComponent(() =>
      import("components/PointsModal.vue")
    ),
    TotalManually: defineAsyncComponent(() =>
      import("components/TotalManually.vue")
    ),
  },
  setup() {
    const CartStore = useCartStore();
    const DataStore = useDataStore();
    return { CartStore, DataStore };
  },
  data() {
    return {
      add_item: false,
      customer_data: [],
      total_amount: 0,
    };
  },
  created() {
    this.loadCart();
  },
  updated() {
    let $open_cart = this.$route.query.cart;
    if ($open_cart == "open") {
      this.CartStore.cart_drawer = true;
    }
  },
  computed: {
    canCheckout() {
      if (
        !this.CartStore.hasData ||
        this.CartStore.hasError ||
        APIinterface.empty(this.CartStore.customer_id)
      ) {
        return true;
      }
      return false;
    },
    canCheckout2() {
      if (this.DataStore.cart_transaction_type == "delivery") {
        if (Object.keys(this.DataStore.place_data).length <= 0) {
          return true;
        }
      }
      return false;
    },
  },
  methods: {
    showAddTotal() {
      this.$refs.popup_more.toggle();
      this.$refs.total_manually.dialog = true;
    },
    cartReset() {
      this.$refs.popup_more.toggle();
      this.resetCart();
    },
    cartHold() {
      this.$refs.popup_more.toggle();
      this.$refs.hold.dialog = true;
    },
    CartDiscount() {
      this.$refs.popup_more.toggle();
      this.$refs.points_modal.dialog = true;
    },
    loadCart() {
      let place_id = this.DataStore.place_data
        ? this.DataStore.place_data.place_id
        : "";
      this.CartStore.getCart(this.DataStore.cart_uuid, place_id);
    },
    afterApplypromo() {
      this.loadCart();
    },
    afterApplypoints() {
      this.loadCart();
    },
    updateCartItems(row, item_qty, type) {
      item_qty = type == "add" ? item_qty + 1 : item_qty - 1;
      this.add_item = true;
      APIinterface.fetchDataByTokenPost(
        "updateCartItems",
        "cart_uuid=" +
          this.DataStore.cart_uuid +
          "&row=" +
          row +
          "&item_qty=" +
          item_qty
      )
        .then((data) => {
          this.loadCart();
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.add_item = false;
        });
    },
    removeCartItem(row) {
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });

      APIinterface.fetchDataByTokenPost(
        "removeCartItem",
        "cart_uuid=" + this.DataStore.cart_uuid + "&row=" + row
      )
        .then((data) => {
          this.loadCart();
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.$q.loading.hide();
        });
    },
    resetCart() {
      this.$q
        .dialog({
          title: this.$t("Clear all items"),
          message: this.$t("are you sure?"),
          transitionShow: "fade",
          transitionHide: "fade",
          cancel: true,
          ok: {
            unelevated: true,
            color: "primary",
            rounded: false,
            "text-color": "white",
            size: "md",
            label: this.$t("Confirm"),
            "no-caps": true,
          },
          cancel: {
            unelevated: true,
            color: "dark",
            "text-color": this.$q.dark.mode ? "white" : "dark",
            rounded: false,
            outline: true,
            size: "md",
            label: this.$t("Cancel"),
            "no-caps": true,
          },
        })
        .onOk(() => {
          this.DeleteCart();
        });
    },
    DeleteCart() {
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });

      APIinterface.fetchDataByTokenPost(
        "clearCart",
        "cart_uuid=" + this.DataStore.cart_uuid
      )
        .then((data) => {
          this.DataStore.place_data = [];
          this.loadCart();
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
          this.loadCart();
        })
        .then((data) => {
          this.$q.loading.hide();
        });
    },
    removePromocode() {
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });

      APIinterface.fetchDataByTokenPost(
        "removePromocode",
        "cart_uuid=" + this.DataStore.cart_uuid
      )
        .then((data) => {
          this.loadCart();
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.$q.loading.hide();
        });
    },
    setTransactionType() {
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });

      APIinterface.fetchDataByTokenPost(
        "setTransactionType",
        "cart_uuid=" +
          this.DataStore.cart_uuid +
          "&transaction_type=" +
          this.DataStore.cart_transaction_type
      )
        .then((data) => {
          this.loadCart();
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.$q.loading.hide();
        });
    },
    createCustomer() {
      this.$refs.create_customer.dialog = true;
    },
    afterCreatecustomer(data) {
      this.customer_data = data;
      this.CartStore.afterSelectcustomer(this.DataStore.cart_uuid, data.id);
    },
    afterPlaceorder() {
      this.CartStore.cart_drawer = false;
    },
    afterHoldorders() {
      console.log("afterHoldorders");
      this.CartStore.cart_drawer = false;
      this.loadCart();
    },
    removeTips() {
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });

      APIinterface.fetchDataByTokenPost(
        "removeTips",
        "cart_uuid=" + this.DataStore.cart_uuid
      )
        .then((data) => {
          this.loadCart();
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.$q.loading.hide();
        });
    },
    removePoints() {
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });

      APIinterface.fetchDataByTokenPost(
        "removePoints",
        "cart_uuid=" + this.DataStore.cart_uuid
      )
        .then((data) => {
          this.loadCart();
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.$q.loading.hide();
        });
    },
  },
};
</script>
