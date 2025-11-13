<template>
  <div v-if="DataStore.loading_cuisine" class="row q-gutter-sm items-center">
    <div v-for="i in 3" :key="i" class="col">
      <q-skeleton type="QBtn" class="full-width" height="50px" />
    </div>
  </div>
  <template v-else>
    <swiper
      v-if="DataStore.cuisine"
      :slidesPerView="4.3"
      :spaceBetween="10"
      @swiper="onSwiper"
      class="q-mb-md"
    >
      <swiper-slide
        v-for="items in DataStore.cuisine"
        :key="items"
        class="text-center"
      >
        <router-link :to="getCuisineLink(items)">
          <q-responsive style="width: 60px; height: 60px; margin: auto">
            <q-avatar>
              <img
                :src="items.featured_image"
                spinner-color="primary"
                spinner-size="sm"
              />
            </q-avatar>
          </q-responsive>
          <div class="ellipsis text-dark">{{ items.cuisine_name }}</div>
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
  name: "CuisineCarousel",
  props: ["design", "search_mode"],
  components: {
    Swiper,
    SwiperSlide,
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  data() {
    return {
      slide: 0,
      data: [],
      loading: true,
    };
  },
  mounted() {
    if (!this.DataStore.hasDataCuisine()) {
      this.DataStore.CuisineList();
    }
  },
  methods: {
    getCuisineLink(items) {
      if (this.search_mode === "address") {
        return {
          name: "feed",
          query: {
            query: "all",
            cuisine_id: items.cuisine_id,
            cuisine_name: items.cuisine_name,
          },
        };
      } else if (this.search_mode === "location") {
        return {
          path: "feed/location",
          query: {
            cuisine_id: items.cuisine_id,
            cuisine_name: items.cuisine_name,
          },
        };
      }
    },
    CuisineList() {
      this.loading = true;
      APIinterface.CuisineList(4, "")
        .then((data) => {
          this.data = data.details.data;
          this.$emit("afterGetdata", data.details.data_raw);
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
