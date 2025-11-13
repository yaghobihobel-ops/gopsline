<template>
  <swiper :slidesPerView="7" :spaceBetween="10" @swiper="onSwiper" class="q-mb-md">
    <swiper-slide v-for="items in Activity.calendar_data" :key="items">
      <div
        class="text-center cursor-pointer"
        @click="setDate(items.value)"
        :class="{
          'text-white': $q.dark.mode,
          'text-dark': !$q.dark.mode,
        }"
      >
        <div class="font12">{{ items.label }}</div>
        <div class="text-weight-bold" :class="{ 'text-blue': items.value == today_date }">
          {{ items.caption }}
        </div>
      </div>
    </swiper-slide>
  </swiper>
</template>

<script>
import { useActivityStore } from "stores/ActivityStore";
import { Swiper, SwiperSlide } from "swiper/vue";
import "swiper/css";

export default {
  name: "CalendarHalf",
  props: ["today_date"],
  components: {
    Swiper,
    SwiperSlide,
  },
  setup() {
    const Activity = useActivityStore();
    return { Activity };
  },
  methods: {
    setDate(data) {
      this.$emit("afterSelectdate", data);
    },
  },
};
</script>
