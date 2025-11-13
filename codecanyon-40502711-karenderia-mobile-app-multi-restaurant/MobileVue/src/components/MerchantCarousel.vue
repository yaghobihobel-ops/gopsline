<template>
  <div v-if="loading" class="row q-gutter-sm items-center">
    <div v-for="i in 3" :key="i" class="col">
      <q-skeleton height="90px" class="full-width" />
      <q-skeleton type="text" class="w-75" />
      <q-skeleton type="text" class="w-100" />
    </div>
  </div>
  <template v-else>
    <div v-if="hasResults" class="row q-mb-sm">
      <div class="col">
        <div class="text-h6 text-weight-medium">
          {{ title }}
        </div>
      </div>
      <div class="col text-right">
        <q-btn
          :to="{
            name: 'feed',
            query: { query: 'featured', featured_id: featured_id },
          }"
          :color="$q.dark.mode ? 'grey300' : 'orange-5'"
          icon="eva-arrow-forward-outline"
          no-caps
          dense
          unelevated
          round
        />
      </div>
    </div>

    <swiper
      :slidesPerView="$q.screen.lt.sm ? 2.3 : 3.3"
      :spaceBetween="10"
      :loop="false"
      @swiper="onSwiper"
    >
      <swiper-slide v-for="items in getData" :key="items">
        <router-link
          :to="{ name: 'menu', params: { slug: items.restaurant_slug } }"
          class="text-dark"
        >
          <div class="relative-position q-mb-sm">
            <q-responsive style="height: 120px">
              <q-img
                :src="items.url_logo"
                class="radius8"
                spinner-color="primary"
                spinner-size="xs"
              />
            </q-responsive>

            <template v-if="items.open_status == 0">
              <div
                class="absolute-top light-dimmed"
                style="height: 120px"
              ></div>
            </template>
          </div>

          <div class="text-subtitle1 ellipsis">{{ items.restaurant_name }}</div>

          <div class="text-grey text-caption line-normal line-1 ellipsis">
            <template
              v-for="(cuisine_name, index) in items.cuisine"
              :key="cuisine_name"
            >
              {{ cuisine_name
              }}<span v-if="index < items.cuisine.length - 1">, </span>
            </template>
          </div>

          <div class="flex items-center justify-between">
            <div>
              <template v-if="DataStore.enabled_review">
                <q-chip
                  size="sm"
                  color="secondary"
                  :text-color="$q.dark.mode ? 'grey300' : 'primary'"
                  icon="star_border"
                  class="no-padding q-ma-none transparent"
                >
                  <span
                    class="text-caption"
                    :class="{
                      'text-grey300': $q.dark.mode,
                      'text-dark': !$q.dark.mode,
                    }"
                  >
                    <template v-if="items.reviews">
                      {{ items.reviews.ratings }}
                    </template>
                    <template v-else> 0.0 </template>
                  </span>
                </q-chip>
              </template>
            </div>

            <div>
              <template v-if="items.estimation">
                <q-chip
                  size="xs"
                  :text-color="$q.dark.mode ? 'grey300' : 'primary'"
                  icon="schedule"
                  class="no-padding transparent"
                >
                  <span
                    class="text-caption"
                    :class="{
                      'text-grey300': $q.dark.mode,
                      'text-dark': !$q.dark.mode,
                    }"
                  >
                    {{ items.estimation }} {{ $t("min") }}</span
                  >
                </q-chip>
              </template>
            </div>

            <div class="text-caption">
              <div>{{ items.distance_short }}</div>
            </div>
          </div>

          <template v-if="items?.promo_list">
            <div class="ellipsis q-gutter-x-sm">
              <template v-for="promo in items.promo_list" :key="promo">
                <q-badge
                  color="orange-1"
                  text-color="orange-5"
                  rounded
                  style="font-size: 0.7em"
                >
                  {{ promo?.discount || "" }}
                </q-badge>
              </template>
            </div>
          </template>
        </router-link>
      </swiper-slide>
    </swiper>
  </template>
</template>

<script>
import { Swiper, SwiperSlide } from "swiper/vue";
import "swiper/css";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";

export default {
  props: [
    "list_type",
    "featured_id",
    "filters",
    "index",
    "title",
    "coordinates",
  ],
  name: "MerchantCarousel",
  components: {
    Swiper,
    SwiperSlide,
  },
  data() {
    return {
      loading: false,
      slide: 0,
      data: [],
      cuisine: [],
      reviews: [],
      estimation: [],
      services: [],
      items_min_max: [],
    };
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  mounted() {
    if (
      !this.DataStore.car_data?.[this.index] ||
      Object.keys(this.DataStore.car_data[this.index]).length === 0
    ) {
      this.fetchData();
    }
  },
  computed: {
    hasResults() {
      return this.DataStore.car_data?.[this.index]?.length > 0;
    },
    getData() {
      return this.DataStore.car_data?.[this.index] ?? null;
    },
  },
  methods: {
    refreshData(coordinates) {
      console.log("refreshData1 carousel");
      this.DataStore.car_data[this.index] = null;
      this.fetchData();
    },
    async fetchData() {
      try {
        this.loading = true;
        const params = {
          list_type: this.list_type,
          featured_id: this.featured_id,
          coordinates: this.coordinates,
          rows: 0,
          payload: [
            "cuisine",
            "reviews",
            "estimation",
            "services",
            "items_min_max",
            "promo",
          ],
          filters: this.filters,
        };
        const response = await APIinterface.getMerchantFeed(params);
        this.DataStore.car_data[this.index] = response.details.data;
      } catch (error) {
        console.log("error merchant carousel ", error);
        this.DataStore.car_data[this.index] = null;
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>
