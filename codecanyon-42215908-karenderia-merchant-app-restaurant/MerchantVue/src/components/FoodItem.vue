<template>
  <div class="row">
    <div v-for="items in row" :key="items" class="col-6 q-pa-sm">
      <q-card class="beautiful-shadow" flat>
        <q-item clickable @click="this.$emit('onShowitem', items)">
          <q-card-section class="q-pa-none relative-position fit">
            <div class="absolute-bottom-right bg-white" style="z-index: 1">
              <img
                :src="
                  items.available
                    ? '/svg/available.svg'
                    : '/svg/not-available.svg'
                "
                width="15"
              />
            </div>
            <!-- <q-img
              :src="items.url_image"
              style="height: 106px"
              fit="cover"
              class="q-mb-sm"
              spinner-color="primary"
              spinner-size="sm"
              loading="lazy"
            ></q-img> -->

            <q-img
              :src="items.url_image"
              style="height: 106px"
              loading="lazy"
              fit="cover"
              class="radius8"
            >
              <template v-slot:loading>
                <q-skeleton
                  height="106px"
                  width="106px"
                  square
                  class="bg-grey-2"
                />
              </template>
            </q-img>

            <div class="text-weight-bold text-body2">
              {{ items.item_name }}
            </div>
            <div
              class="text-caption text-grey ellipsis-2-lines line-normal"
              v-html="items.item_description"
            ></div>
            <div class="text-primary text-weight-bold">
              <template
                v-if="
                  items.lowest_price_discount_raw <= 0 && items.has_discount
                "
              >
                <span class="text-blue-8">
                  {{ $t("Check Offers") }}
                </span>
              </template>
              <template v-else>
                <span
                  v-if="items.lowest_price_discount_raw > 0"
                  class="text-strike text-grey"
                  >{{ items.lowest_price_discount }}</span
                >
                {{ items.lowest_price }}
              </template>
            </div>
          </q-card-section>
        </q-item>
      </q-card>
    </div>
  </div>
</template>

<script>
export default {
  name: "FoodItem",
  props: ["row"],
};
</script>
