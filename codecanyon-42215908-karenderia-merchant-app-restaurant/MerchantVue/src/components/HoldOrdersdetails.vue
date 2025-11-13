<template>
  <q-dialog
    v-model="dialog"
    :maximized="false"
    position="bottom"
    persistent
    transition-show="fade"
  >
    <q-card>
      <template v-if="loading">
        <div style="min-height: 50vh">
          <q-inner-loading :showing="true" size="md" color="primary">
          </q-inner-loading>
        </div>
      </template>

      <template v-else>
        <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
          <q-toolbar-title
            class="text-dark text-weight-bold"
            style="overflow: inherit"
          >
            {{ title }}
          </q-toolbar-title>
          <q-space></q-space>
          <q-btn
            @click="dialog = !true"
            color="white"
            square
            unelevated
            text-color="grey"
            icon="las la-times"
            dense
            no-caps
            size="sm"
            class="border-grey radius8"
          />
        </q-toolbar>
        <q-separator></q-separator>
        <q-card-section style="min-height: 50vh" class="scroll q-pa-none">
          <template v-if="!hasData">
            <div
              class="flex flex-center"
              style="min-height: calc(50vh); max-height: 50vh"
            >
              <div class="text-grey">{{ $t("No data available") }}</div>
            </div>
          </template>
          <q-list v-else separator>
            <q-item v-for="items in data" :key="items">
              <q-item-section>
                <q-item-label>
                  {{ items.item_name }}
                  <template v-if="items.price.size_name != ''">
                    ({{ items.price.size_name }})
                  </template>
                </q-item-label>
                <q-item-label>
                  <template v-if="items.price.discount > 0">
                    <p class="no-margin">
                      <del>{{ items.price.pretty_price }}</del>
                      {{ items.price.pretty_price_after_discount }}
                      (x{{ items.qty }})
                    </p>
                  </template>
                  <template v-else>
                    <p class="no-margin">
                      {{ items.price.pretty_price }} (x{{ items.qty }})
                    </p>
                  </template>
                </q-item-label>
                <q-item-label caption>
                  <template v-for="addons in items.addons" :key="addons">
                    {{ addons.subcategory_name }}

                    <div
                      v-for="addon_items in addons.addon_items"
                      :key="addon_items"
                      class="flex items-center q-mb-xs q-gutter-x-sm"
                    >
                      <div>{{ addon_items.sub_item_name }}</div>
                      <div>
                        ({{ addon_items.qty }} x
                        {{ addon_items.pretty_price }} =
                        {{ addon_items.pretty_addons_total }})
                      </div>
                    </div>
                  </template>
                </q-item-label>
              </q-item-section>
              <q-item-section side>
                <q-item-label class="text-weight-bold text-overline">
                  <template v-if="items.price.discount <= 0">
                    <p class="q-ma-none">{{ items.price.pretty_total }}</p>
                  </template>
                  <template v-else>
                    <p class="q-ma-none">
                      {{ items.price.pretty_total_after_discount }}
                    </p>
                  </template>
                </q-item-label>
              </q-item-section>
            </q-item>
          </q-list>
        </q-card-section>
      </template>

      <template v-if="!loading && hasData">
        <q-separator></q-separator>
        <q-card-actions align="right">
          <q-btn
            unelevated
            color="dark"
            :label="$t('Close')"
            class="radius28 q-pl-lg q-pr-lg q-pt-sm q-pb-sm"
            style="height: 40px"
            no-caps
            v-close-popup
          />

          <q-btn
            unelevated
            color="green"
            :label="$t('Open')"
            class="radius28 q-pl-lg q-pr-lg q-pt-sm q-pb-sm"
            style="height: 40px"
            no-caps
            @click="openOrder()"
          />
        </q-card-actions>
      </template>
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useCartStore } from "stores/CartStore";
import { useDataStore } from "stores/DataStore";

export default {
  name: "HoldOrdersdetails",
  data() {
    return {
      loading: false,
      dialog: false,
      order_reference: "",
      payload: ["items", "summary", "total", "subtotal", "items_count"],
      data: [],
      cart_uuid: "",
      transaction_type: "",
    };
  },
  setup(props) {
    const CartStore = useCartStore();
    const DataStore = useDataStore();
    return { CartStore, DataStore };
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    getCart(order_reference, cart_uuid, transaction_type) {
      this.cart_uuid = cart_uuid;
      this.transaction_type = transaction_type;
      this.title = order_reference;

      this.dialog = true;
      this.loading = true;

      APIinterface.fetchDataByTokenPost("getCart", {
        cart_uuid: cart_uuid,
        payload: this.payload,
      })
        .then((data) => {
          this.data = data.details.data.items;
        })
        .catch((error) => {
          this.data = [];
        })
        .then((data) => {
          this.loading = false;
        });
    },
    openOrder() {
      this.DataStore.cart_uuid = this.cart_uuid;

      let place_id = this.DataStore.place_data
        ? this.DataStore.place_data.place_id
        : "";

      this.DataStore.cart_transaction_type = this.transaction_type;

      this.CartStore.getCart(this.cart_uuid, place_id);

      this.$router.push({ path: "/pos/create", query: { cart: "open" } });
    },
  },
};
</script>
