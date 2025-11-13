<template>
  <swiper
    :slidesPerView="2.9"
    :spaceBetween="10"
    @swiper="onSwiper"
    class="q-mb-md"
  >
    <swiper-slide v-for="items in data" :key="items" class="row">
      <div
        class="text-white q-pa-sm radius8"
        :style="`background:${items.color}`"
      >
        <div class="font12">{{ $t("Sales this week") }}</div>
        <div class="text-weight-bold">1,200.00$</div>
      </div>
    </swiper-slide>
  </swiper>
</template>

<script>
import { Swiper, SwiperSlide } from "swiper/vue";
import "swiper/css";

export default {
  name: "EarningsComponents",
  components: {
    Swiper,
    SwiperSlide,
  },
  setup() {
    return {};
  },
  data() {
    return {
      data: [
        {
          label: this.$t("Sales this week"),
          value: "1,200.00$",
          color: "#49c3a1",
        },
        {
          label: this.$t("Earning this week"),
          value: "1,100.00$",
          color: "#9689e7",
        },
        {
          label: this.$t("Earning this week"),
          value: "1,100.00$",
          color: "#fab54d",
        },
      ],
    };
  },
};
</script>
