<template>
  <template v-if="GlobalStore.review_loading">
    <div>
      <q-skeleton type="text" style="width: 30%" />
      <q-skeleton type="text" style="width: 50%" />
    </div>
    <div>
      <q-skeleton height="180px" square />
    </div>
  </template>

  <template v-else>
    <div class="text-h6">{{ $t("Overview of Review") }}</div>

    <div class="text-grey">
      {{ GlobalStore.getReviewData.this_month_words }}
    </div>

    <q-space class="q-pa-sm"></q-space>
    <q-card class="no-shadow">
      <q-card-section>
        <div
          v-for="items in GlobalStore.getReviewData.review_summary"
          :key="items"
          class="q-mb-xs"
        >
          <div class="row justify-between font12">
            <div>{{ items.count }} Star</div>
            <div>{{ items.in_percent }}</div>
          </div>
          <q-linear-progress
            size="10px"
            :value="items.review / 100"
            color="light-blue"
          />
        </div>
      </q-card-section>
    </q-card>
    <q-btn
      no-caps
      unelevated
      class="full-width radius8"
      color="primary"
      size="lg"
      to="/customer/review-list"
    >
      <div class="text-weight-bold text-subtitle2">
        {{ $t("View All") }}
      </div>
    </q-btn>
  </template>
</template>

<script>
import { useGlobalStore } from "stores/GlobalStore";
export default {
  name: "ReviewOverview",
  props: ["refresh_done"],
  setup() {
    const GlobalStore = useGlobalStore();
    return { GlobalStore };
  },
  mounted() {
    if (!this.GlobalStore.review_data) {
      this.GlobalStore.getReviewSummary();
    }
  },
  watch: {
    refresh_done(newval, oldva) {
      this.GlobalStore.getReviewSummary(this.refresh_done);
    },
  },
};
</script>
