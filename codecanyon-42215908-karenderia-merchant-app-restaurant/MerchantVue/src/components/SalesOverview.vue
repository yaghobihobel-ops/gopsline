<template>
  <template v-if="GlobalStore.sales_loading">
    <q-skeleton height="180px" square />
  </template>
  <template v-else>
    <div v-if="GlobalStore.getSales && !GlobalStore.sales_loading">
      <apexchart
        type="bar"
        :options="GlobalStore.chartOptions"
        :series="GlobalStore.series"
      ></apexchart>
    </div>
    <div v-else>
      <div class="flex flex-center" style="min-height: calc(30vh)">
        <div class="full-width text-center">
          <div class="text-weight-bold">{{ $t("No data") }}</div>
          <div class="text-grey">{{ $t("Sales will show here") }}</div>
        </div>
      </div>
    </div>
  </template>
</template>

<script>
import VueApexCharts from "vue3-apexcharts";
import { useGlobalStore } from "stores/GlobalStore";

export default {
  name: "SalesOverview",
  props: ["refresh_done"],
  components: {
    apexchart: VueApexCharts,
  },
  setup() {
    const GlobalStore = useGlobalStore();
    return { GlobalStore };
  },
  mounted() {
    if (!this.GlobalStore.chat_data) {
      this.GlobalStore.SalesOverview();
    }
  },
  watch: {
    refresh_done(newval, oldva) {
      this.GlobalStore.SalesOverview(this.refresh_done);
    },
  },
};
</script>
