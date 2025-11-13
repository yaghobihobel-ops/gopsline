<template>
  <q-dialog
    v-model="dialog"
    :maximized="true"
    transition-show="slide-up"
    transition-hide="slide-down"
  >
    <q-card class="bg-dark">
      <q-bar class="transparent q-pa-sm" style="height: auto">
        <div class="col text-center">
          <div class="text-weight-bold text-white">{{ title }}</div>
        </div>
        <q-btn dense flat icon="close" color="white" v-close-popup>
          <q-tooltip class="bg-white text-primary">Close</q-tooltip>
        </q-btn>
      </q-bar>

      <q-card-section class="fit">
        <q-carousel
          animated
          v-model="slide"
          arrows
          navigation
          infinite
          swipeable
        >
          <template v-for="(item, index) in data" :key="item">
            <q-carousel-slide :name="index" :img-src="item.document" />
          </template>
        </q-carousel>
      </q-card-section>
    </q-card>
  </q-dialog>
</template>

<script>
export default {
  name: "PhotoCarousel",
  props: ["data", "title"],
  data() {
    return {
      dialog: false,
      slide: 0,
    };
  },
};
</script>
