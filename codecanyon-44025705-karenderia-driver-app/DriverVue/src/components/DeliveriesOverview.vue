<template>
  <template v-if="!store.loading">
    <div class="row items-center q-gutter-sm q-pl-md q-pr-md">
      <div class="col">
        <q-card class="no-shadow bg-orange-7 rounded-borders">
          <q-card-section class="q-pa-none">
            <div class="flex flex-center full-width q-gutter-sm">
              <div class="">
                <q-knob
                  :min="0"
                  :max="100"
                  v-model="store.data.total_delivered_percent"
                  show-value
                  size="50px"
                  :thickness="0.22"
                  color="blue"
                  track-color="grey-3"
                  class="q-ma-md"
                >
                  {{ store.data.total_delivered_percent }}%
                </q-knob>
              </div>
              <div class="">
                <div class="font15 text-weight-bold">
                  {{ $t("Total Delivered") }}
                </div>
                <div class="text-h5 text-center">
                  {{ store.data.total_delivered }}
                </div>
              </div>
            </div>
          </q-card-section>
        </q-card>
      </div>
      <div class="col">
        <q-card class="no-shadow bg-green-4 rounded-borders">
          <q-card-section class="q-pa-none">
            <div class="flex flex-center full-width q-gutter-sm">
              <div class="">
                <q-knob
                  :min="0"
                  :max="100"
                  v-model="store.data.total_tip_percent"
                  show-value
                  size="50px"
                  :thickness="0.22"
                  color="yellow"
                  track-color="grey-3"
                  class="q-ma-md"
                >
                  {{ store.data.total_tip_percent }}%
                </q-knob>
              </div>
              <div class="">
                <div class="font15 text-weight-bold">
                  {{ $t("Total Tips") }}
                </div>
                <div class="text-h5 text-center">
                  {{ store.data.total_tip }}
                </div>
              </div>
            </div>
          </q-card-section>
        </q-card>
      </div>
    </div>
    <!-- row -->
  </template>
  <template v-else>
    <div class="row items-center q-gutter-sm q-pl-md q-pr-md">
      <div class="col-4">
        <q-skeleton height="100px" square />
      </div>
      <div class="col">
        <q-skeleton height="100px" square />
      </div>
    </div>
    <!-- row -->
  </template>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { DeliveryOverviewStore } from "stores/DeliveryOverviewStore";

export default {
  name: "DeliveriesOverview",
  props: ["refresh"],
  setup() {
    const store = DeliveryOverviewStore();
    return { store };
  },
  watch: {
    refresh(newval, oldval) {
      if (newval) {
        this.store.deliveriesOverview();
      }
    },
  },
  created() {
    if (Object.keys(this.store.data).length <= 0) {
      this.store.deliveriesOverview();
    }
  },
};
</script>
