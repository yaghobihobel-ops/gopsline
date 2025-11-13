<template>
  <template v-if="DataStore.total_order_loading">
    <swiper :slidesPerView="2.9" :spaceBetween="10" class="q-mb-md">
      <swiper-slide v-for="x in 3" :key="x">
        <q-skeleton height="50px" square />
      </swiper-slide>
    </swiper>
  </template>

  <template v-else>
    <swiper
      :slidesPerView="2.9"
      :spaceBetween="10"
      @swiper="onSwiper"
      class="q-mb-md"
    >
      <swiper-slide
        v-for="items in DataStore.total_order_summary"
        :key="items"
        class="row"
      >
        <div
          class="text-white q-pa-sm radius8"
          :style="`background:${items.color}`"
        >
          <div class="font12">{{ items.label }}</div>
          <div class="text-weight-bold">{{ items.value }}</div>
        </div>
      </swiper-slide>
    </swiper>
  </template>
</template>

<script>
import { useDataStore } from "stores/DataStore";
import { Swiper, SwiperSlide } from "swiper/vue";
import "swiper/css";

export default {
  name: "TotalOrderCarousel",
  props: ["refresh_done"],
  components: {
    Swiper,
    SwiperSlide,
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  data() {
    return {};
  },
  watch: {
    refresh_done(newval, oldval) {
      this.DataStore.getTotalOrders(this.refresh_done);
    },
  },
  created() {
    if (Object.keys(this.DataStore.total_order_summary).length <= 0) {
      this.DataStore.getTotalOrders();
    }
  },
};
</script>
