<template>
  <template v-if="!store.summary_loading">
    <div class="row q-gutter-sm">
      <div v-if="overview" class="col-4">
        <q-card class="no-shadow bg-amber-4 rounded-borders fit">
          <q-card-section>
            <div class="font15 text-weight-bold line-normal-1">
              {{ $t("Driver Overview") }}
            </div>
            <div class="text-h5">{{ store.data_summary.total }}</div>
            <div class="text-grey font12 line-normal-1">
              {{ $t("Total reviews") }}
            </div>
          </q-card-section>
        </q-card>
      </div>
      <div class="col">
        <template
          v-for="itemsum in store.data_summary.review_summary"
          :key="itemsum"
        >
          <div class="row font11">
            <div class="col">{{ itemsum.count }} Star</div>
            <div class="col text-right">{{ itemsum.in_percent }}</div>
          </div>
          <q-linear-progress
            size="10px"
            :value="store.setPercent(itemsum.review)"
          />
        </template>
      </div>
    </div>
    <!-- row -->
    <q-space class="q-pa-sm"></q-space>
  </template>
  <template v-else>
    <div class="row q-gutter-sm">
      <div v-if="overview" class="col-4">
        <q-skeleton height="100px" square />
      </div>
      <div class="col">
        <q-skeleton v-for="i in 5" :key="i" type="text" />
      </div>
    </div>
    <!-- row -->
    <q-space class="q-pa-sm"></q-space>
  </template>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { ReviewOverviewStore } from "stores/ReviewOverviewStore";

export default {
  name: "ReviewOverview",
  props: ["overview", "refresh"],
  setup() {
    const store = ReviewOverviewStore();
    return { store };
  },
  watch: {
    refresh(newval, oldval) {
      console.debug(newval);
      if (newval) {
        this.store.getReviewSummary();
      }
    },
  },
  created() {
    if (Object.keys(this.store.data_summary).length <= 0) {
      this.store.getReviewSummary();
    }
  },
};
</script>
