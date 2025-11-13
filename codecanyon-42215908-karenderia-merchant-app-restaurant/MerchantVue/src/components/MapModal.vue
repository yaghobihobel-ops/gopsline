<template>
  <q-dialog
    v-model="modal"
    class="rounded-borders-top"
    persistent
    position="bottom"
    transition-show="fade"
  >
    <q-card>
      <q-card-section class="row items-center q-pa-xs q-pl-md q-pr-md">
        <q-space />
        <q-btn
          icon="las la-times"
          color="grey"
          flat
          round
          dense
          v-close-popup
        />
      </q-card-section>
      <q-card-section style="height: 70vh" class="q-pt-none radius10">
        <MapsComponents
          ref="mapRef"
          class="maps"
          size="fit"
          :keys="DataStore.getMapsConfig?.key || ''"
          :provider="DataStore.getMapsConfig?.provider || ''"
          :zoom="DataStore.getMapsConfig?.zoom || ''"
          :language="DataStore.getMapsConfig?.language || ''"
          :center="center"
          :markers="marker_position"
          :map_controls="false"
          :controls_center="false"
          :zoom_control="true"
          :adjust_location="false"
        />
      </q-card-section>
    </q-card>
  </q-dialog>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useDataStore } from "stores/DataStore";

export default {
  name: "MapModal",
  components: {
    MapsComponents: defineAsyncComponent(() =>
      import("components/MapsComponents.vue")
    ),
  },
  data() {
    return {
      modal: false,
      center: { lat: 34.04703, lng: -118.24686 },
      marker_position: [],
    };
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  methods: {
    setLocation(center, marker_position) {
      this.center = center;
      this.marker_position = marker_position;
      this.modal = true;
    },
  },
};
</script>
