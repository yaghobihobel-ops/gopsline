<template>
  <q-item-section side top>
    <div class="relative-position">
      <q-responsive style="width: 110px; height: 90px">
        <q-img
          :src="items.url_logo"
          lazy
          fit="cover"
          class="radius8"
          spinner-color="primary"
          spinner-size="xs"
        />
      </q-responsive>
      <template v-if="!items?.available">
        <div class="absolute-top fit light-dimmed"></div>
      </template>
    </div>
  </q-item-section>
  <q-item-section top>
    <div class="row items-center justify-between">
      <div class="col">
        <template v-if="items?.promos || items?.vouchers">
          <div
            v-if="items?.promos?.length > 0 || items?.vouchers?.length > 0"
            class="text-overline line-normal text-primary text-weight-bold"
          >
            {{ $t("PROMO") }}
          </div>
        </template>

        <div class="text-subtitle2 text-weight-bold no-margin line-normal">
          {{ items.restaurant_name }}
        </div>

        <template v-if="!items?.available">
          <div class="text-weight-bold text-caption text-secondary">
            {{ items?.next_opening || items?.close_reason || "" }}
          </div>
        </template>
      </div>

      <div class="">
        <FavsResto
          ref="favs"
          :data="items"
          :active="items.saved_store == 1 ? true : false"
          :merchant_id="items.merchant_id"
          size="sm"
          @after-savefav="afterSavefav"
        />
      </div>
    </div>
    <!-- row -->

    <div class="row items-top justify-between">
      <div class="col">
        <div
          class="text-grey ellipsis-2-lines text-caption line-normal word-wrap q-mb-sm"
        >
          <template
            v-for="(cuisine_name, index) in items.cuisine"
            :key="cuisine_name"
          >
            {{ cuisine_name
            }}<span v-if="index < items.cuisine.length - 1">, </span>
          </template>
          {{ items?.cuisines ?? "" }}
        </div>

        <PromoListView :data="items?.promo_list || null"></PromoListView>

        <template v-if="items.free_delivery">
          <q-badge color="orange-1" text-color="orange-5" rounded>
            {{ $t("First Delivery Free") }}
          </q-badge>
        </template>
      </div>
    </div>
    <!-- row -->

    <div class="flex items-center justify-between q-mt-sm text-caption">
      <div v-if="enabled_review">
        <q-chip
          size="sm"
          color="secondary"
          :text-color="$q.dark.mode ? 'grey300' : 'primary'"
          icon="star_border"
          class="no-padding transparent"
        >
          <span
            class="text-weight-medium text-caption"
            :class="{
              'text-grey300': $q.dark.mode,
              'text-dark': !$q.dark.mode,
            }"
          >
            {{ items.reviews?.ratings ?? items.ratings ?? "0.0" }}
          </span>
        </q-chip>
      </div>
      <div>
        <template v-if="items.estimation || items.estimation2">
          <q-chip
            size="xs"
            :text-color="$q.dark.mode ? 'grey300' : 'primary'"
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
              {{ items.estimation2 ?? items.estimation }}
            </span>
          </q-chip>
        </template>
      </div>
      <div>
        {{ items?.distance_pretty ?? "" }}
      </div>
    </div>
  </q-item-section>
</template>

<script>
import { defineAsyncComponent } from "vue";
export default {
  name: "MerchantListTpl",
  components: {
    FavsResto: defineAsyncComponent(() => import("components/FavsResto.vue")),
    PromoListView: defineAsyncComponent(() =>
      import("components/PromoListView.vue")
    ),
  },
  props: [
    "items",
    "cuisine",
    "reviews",
    "estimation",
    "services",
    "items_min_max",
    "promos",
    "enabled_review",
    "row",
  ],
  methods: {
    afterSavefav(data, added) {
      data.saved_store = added;
      this.$emit("afterSavefav", this.row);
    },
  },
};
</script>

<style lang="sass" scoped>
.truncate-chip-labels > .q-chip
  max-width: 200px
</style>
