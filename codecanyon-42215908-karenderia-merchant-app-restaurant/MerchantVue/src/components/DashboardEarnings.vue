<template>
  <q-card class="q-pa-none no-shadow">
    <q-card-section class="q-pa-sm">
      <template v-if="GlobalStore.sales_summary_loading">
        <q-skeleton type="text" style="width: 50%" />
        <q-skeleton type="text" style="width: 90%" />
        <q-skeleton type="text" style="width: 40%" />
      </template>
      <template v-else>
        <h6 class="no-margin">{{ $t("Earnings") }}</h6>
        <p class="no-margin text-grey">
          {{ $t("Your sales, cash in and referral earnings") }}
        </p>
        <div class="text-h5 text-primary text-weight-bold">
          {{
            GlobalStore.getEarning ? GlobalStore.getEarning.data.balance : ""
          }}
        </div>
      </template>
    </q-card-section>
  </q-card>

  <q-space class="q-pa-sm"></q-space>

  <template v-if="GlobalStore.sales_summary_loading">
    <swiper :slidesPerView="2.3" :spaceBetween="10" class="q-mb-md">
      <swiper-slide v-for="x in 3" :key="x">
        <q-skeleton height="50px" square />
      </swiper-slide>
    </swiper>
  </template>
  <template v-else>
    <swiper
      :slidesPerView="2.3"
      :spaceBetween="10"
      @swiper="onSwiper"
      class="q-mb-md"
    >
      <swiper-slide v-for="items in GlobalStore.getEarningSale" :key="items">
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
import { Swiper, SwiperSlide } from "swiper/vue";
import "swiper/css";
import { useGlobalStore } from "stores/GlobalStore";

export default {
  name: "DashboardEarnings",
  props: ["refresh_done"],
  components: {
    Swiper,
    SwiperSlide,
  },
  setup() {
    const GlobalStore = useGlobalStore();
    return { GlobalStore };
  },
  mounted() {
    if (!this.GlobalStore.sales_summary) {
      this.GlobalStore.getEarningSummary();
    }
  },
  watch: {
    refresh_done(newval, oldva) {
      this.GlobalStore.getEarningSummary(this.refresh_done);
    },
  },
};
</script>
