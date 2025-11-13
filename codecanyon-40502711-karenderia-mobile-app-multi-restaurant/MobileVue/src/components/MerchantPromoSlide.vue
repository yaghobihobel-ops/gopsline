<template>
  <swiper
    :slides-per-view="2"
    :space-between="10"
    @swiper="onSwiper"
    @slideChange="onSlideChange"
    class="q-mb-md"
  >
    <swiper-slide v-for="(items, index) in data" :key="items">
      <div
        @click="showDetails(index)"
        class="border-grey2 q-pa-sm radius8 cursor-pointer"
      >
        <q-chip
          size="sm"
          :text-color="$q.dark.mode ? 'grey300' : 'secondary'"
          class="no-padding transparent"
          :icon="items.discount_type == 'voucher' ? 'o_discount' : 'o_percent'"
        >
          <div
            class="text-caption ellipsis"
            :class="{
              'text-grey300': $q.dark.mode,
              'text-dark': !$q.dark.mode,
            }"
          >
            <div>{{ items.title }}</div>
            <div class="text-grey">{{ items.valid_to }}</div>
          </div>
        </q-chip>
      </div>
    </swiper-slide>
  </swiper>

  <q-dialog v-model="modal" position="bottom">
    <q-card>
      <q-card-section class="q-pl-md">
        <div
          class="row items-center q-gutter-sm q-mb-sm q-pb-sm border-bottom text-subtitle2"
        >
          <div class="col-1">
            <q-chip
              size="md"
              :text-color="$q.dark.mode ? 'grey300' : 'secondary'"
              :icon="
                data?.[selected_index]?.discount_type == 'voucher'
                  ? 'o_discount'
                  : 'o_percent'
              "
              class="no-padding transparent"
            ></q-chip>
          </div>
          <div class="col">
            {{ data?.[selected_index]?.discount_name }}
          </div>
        </div>
        <div class="text-grey text-caption">
          {{ data?.[selected_index]?.valid_to }}
        </div>
      </q-card-section>
    </q-card>
  </q-dialog>
</template>

<script>
import { Swiper, SwiperSlide } from "swiper/vue";
import "swiper/css";

export default {
  name: "MerchantPromoSlide",
  props: ["data"],
  components: {
    Swiper,
    SwiperSlide,
  },
  data() {
    return {
      modal: false,
      selected_index: 0,
    };
  },
  methods: {
    showDetails(value) {
      this.selected_index = value;
      this.modal = true;
    },
  },
};
</script>
