<template>
  <template v-if="loading">
    <!-- <div class="row q-gutter-sm q-mb-md">
      <div class="col-3" v-for="items in 3" :key="items">
        <q-skeleton
          height="50px"
          class="radius8"
          :class="{
            'bg-grey600 text-white': $q.dark.mode,
            'bg-white text-dark': !$q.dark.mode,
          }"
        />
      </div>
    </div> -->

    <swiper :slidesPerView="slide" :spaceBetween="10" class="q-mb-md">
      <swiper-slide v-for="items in 4" :key="items">
        <q-skeleton height="50px" class="radius8" animation="pulse" />
      </swiper-slide>
    </swiper>
  </template>

  <swiper
    v-else
    :slidesPerView="slide"
    :spaceBetween="10"
    @swiper="onSwiper"
    class="q-mb-md"
  >
    <swiper-slide v-for="items in data" :key="items">
      <div
        class="q-pa-sm radius8"
        :class="{
          'bg-grey600 text-white': $q.dark.mode,
          'bg-white text-dark': !$q.dark.mode,
        }"
      >
        <div class="text-center">
          <div class="text-weight-bold font16" :class="{ ellipsis: concat }">
            {{ items.value }}
          </div>
          <div
            class="font12 text-blue-grey-2"
            style="line-height: 1"
            :class="{ ellipsis: concat }"
          >
            {{ items.label }}
          </div>
        </div>
      </div>
    </swiper-slide>
  </swiper>
</template>

<script>
import { Swiper, SwiperSlide } from "swiper/vue";
import "swiper/css";

export default {
  name: "TableSummary",
  props: ["loading", "data", "concat", "set_slide"],
  components: {
    Swiper,
    SwiperSlide,
  },
  data() {
    return {
      slide: this.set_slide ? this.set_slide : 3.3,
    };
  },
};
</script>
