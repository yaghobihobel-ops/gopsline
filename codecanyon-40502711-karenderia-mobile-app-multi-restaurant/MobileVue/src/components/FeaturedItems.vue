<template>
  <div v-if="DataStore.featured_loading" class="row q-gutter-sm items-center">
    <div v-for="i in 3" :key="i" class="col">
      <q-skeleton height="90px" class="full-width" />
      <q-skeleton type="text" class="w-75" />
      <q-skeleton type="text" class="w-100" />
    </div>
  </div>

  <div v-if="DataStore.featured_items" class="row q-mb-sm">
    <div class="col">
      <div class="text-h6 text-weight-medium">
        {{ title }}
      </div>
    </div>
  </div>

  <swiper
    :slidesPerView="$q.screen.lt.sm ? 2.3 : 3.3"
    :spaceBetween="10"
    :loop="false"
  >
    <swiper-slide v-for="items in DataStore.featured_items" :key="items">
      <div @click.stop="handleClick(items)" class="text-dark cursor-pointer">
        <div
          class="border-grey2 radius8 relative-position"
          style="height: 240px"
        >
          <q-responsive style="height: 120px">
            <q-img
              :src="items.url_image"
              class="radius-top10"
              fit="scale-down"
              spinner-color="primary"
              spinner-size="xs"
            />
          </q-responsive>

          <div class="q-pa-sm">
            <div class="text-subtitle1 ellipsis">
              {{ items.item_name }}
            </div>
            <div
              class="ellipsis-2-lines line-normal text-caption text-grey"
              v-html="items.item_description"
            ></div>

            <div class="absolute-bottom-left full-width">
              <div class="flex items-center justify-between q-pa-sm">
                <div class="text-subtitle2">{{ items.lowest_price }}</div>
                <div>
                  <q-btn
                    color="primary"
                    :label="$t('Add')"
                    no-caps
                    unelevated
                    rounded
                    padding="2px 10px"
                    @click.stop="handleClick(items)"
                  ></q-btn>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </swiper-slide>
  </swiper>

  <component
    :is="ItemComponents"
    ref="item_details"
    :slug="merchant_id"
    :money_config="DataStore.money_config"
    :currency_code="DataStorePersisted.useCurrency"
    :cart_uuid="DataStorePersisted.cart_uuid"
    @after-additems="afterAdditems"
    @afterSavefav="afterSavefav"
  />
</template>

<script>
import { defineAsyncComponent } from "vue";
import { Swiper, SwiperSlide } from "swiper/vue";
import "swiper/css";
import { useDataStore } from "stores/DataStore";
import { useDataStorePersisted } from "stores/DataStorePersisted";
import { useCartStore } from "stores/CartStore";

export default {
  name: "FeaturedItems",
  props: ["title", "featured_id"],
  components: {
    Swiper,
    SwiperSlide,
  },
  data() {
    return {
      merchant_id: null,
      payload: [
        "items",
        "subtotal",
        "items_count",
        "merchant_info",
        "transaction_info",
      ],
    };
  },
  setup() {
    const DataStore = useDataStore();
    const DataStorePersisted = useDataStorePersisted();
    const CartStore = useCartStore();

    const addons_use_checkbox = DataStore.addons_use_checkbox ?? true;
    const ItemComponents = defineAsyncComponent(() =>
      addons_use_checkbox
        ? import("components/ItemDetailsCheckbox.vue")
        : import("components/ItemDetails.vue")
    );

    return { DataStore, DataStorePersisted, CartStore, ItemComponents };
  },
  mounted() {
    this.loadData();
  },
  methods: {
    afterSavefav() {
      console.log("afterSavefav xx");
      // CLEAR HOME PAGE FILTER AND FAV
      this.DataStore.fav_saved_data = null;
    },
    loadData() {
      const currency_params = {
        currency_code: this.DataStorePersisted.useCurrency,
      };
      const params = {
        ...this.DataStorePersisted.coordinates,
        ...currency_params,
      };
      console.log("Fatured items load data");
      this.DataStore.fetchFeaturedItems(new URLSearchParams(params).toString());
    },
    handleClick(data) {
      const params = { cat_id: data.cat_id, item_uuid: data.item_uuid };
      this.merchant_id = data.merchant_id;
      this.$refs.item_details.showItem2(params, this.merchant_id);
    },
    afterAdditems(cart_uuid) {
      this.DataStorePersisted.cart_uuid = cart_uuid;
      this.CartStore.getCart(true, this.payload);
    },
  },
};
</script>
