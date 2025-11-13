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
            path: 'feed/location',
            query: { featured_id: featured_id },
          }"
          color="orange-5"
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
                :src="items.logo"
                class="radius8"
                spinner-color="primary"
                spinner-size="sm"
              />
            </q-responsive>
            <template v-if="!items.open_status">
              <div
                class="absolute-top light-dimmed"
                style="height: 120px"
              ></div>
            </template>
          </div>

          <div class="text-subtitle1 ellipsis">{{ items.restaurant_name }}</div>
          <div class="text-grey text-caption line-normal line-1 ellipsis">
            {{ items.cuisines }}
          </div>

          <div class="flex items-center justify-between">
            <div v-if="DataStore.enabled_review">
              <q-chip
                size="sm"
                color="secondary"
                :text-color="$q.dark.mode ? 'grey300' : 'dark'"
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
                  <template v-if="items.review_count">
                    {{ items.review_count }}
                  </template>
                  <template v-else> 0.0 </template>
                </span>
              </q-chip>
            </div>
            <div v-if="items.estimated_time_min">
              <q-chip
                size="xs"
                :text-color="$q.dark.mode ? 'grey300' : 'dark'"
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
                  {{ items.estimated_time_min }}</span
                >
              </q-chip>
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
                  {{ promo?.discount || promo?.title }}
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
import { useDataStorePersisted } from "stores/DataStorePersisted";
import { useDataStore } from "stores/DataStore";
import config from "src/api/config";
import APIinterface from "src/api/APIinterface";

export default {
  name: "MerchantCarouselLocation",
  props: [
    "list_type",
    "featured_id",
    "filters",
    "index",
    "title",
    "location_data",
  ],
  components: {
    Swiper,
    SwiperSlide,
  },
  data() {
    return {
      loading: false,
    };
  },
  setup() {
    const DataStorePersisted = useDataStorePersisted();
    const DataStore = useDataStore();
    return { DataStorePersisted, DataStore };
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
    refreshData() {
      this.DataStore.car_data[this.index] = null;
      this.fetchData();
    },
    async fetchData() {
      try {
        this.loading = true;
        const params = {
          transaction_type: "",
          state_id: this.location_data?.state_id || "",
          city_id: this.location_data?.city_id || "",
          area_id: this.location_data?.area_id || "",
          state_id: this.location_data?.state_id || "",
          postal_id: this.location_data?.postal_id || "",
          featured: JSON.stringify([this.featured_id]),
        };
        const response = await APIinterface.fetchGet(
          `${config.api_location}/getfeedv1`,
          params
        );
        this.DataStore.car_data[this.index] = response.details.data;
      } catch (error) {
        this.DataStore.car_data[this.index] = null;
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>
