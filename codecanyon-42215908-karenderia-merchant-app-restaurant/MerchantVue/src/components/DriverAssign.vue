<template>
  <q-dialog
    v-model="modal"
    class="rounded-borders-top"
    @before-show="getAvailableDriver"
    @before-hide="beforeHide"
    persistent
    position="bottom"
    transition-show="fade"
  >
    <q-card>
      <q-card-section
        class="row items-center q-pa-xs q-pl-md q-pr-md q-gutter-x-sm"
      >
        <div class="text-weight-bold text-subtitle2">
          {{ $t("Assign Driver") }}
        </div>
        <q-space />
        <q-btn
          unelevated
          round
          dense
          icon="las la-redo-alt"
          color="red-1"
          text-color="red-9"
          @click="refresh"
          v-if="!loading"
          flat
        />
        <q-btn
          icon="las la-times"
          color="grey"
          flat
          round
          dense
          v-close-popup
        />
      </q-card-section>

      <template v-if="!data && !loading">
        <q-card-section style="min-height: 50vh">
          <div class="absolute-center text-center q-gutter-y-md">
            <div clas="text-body1 text-grey">
              {{ $t("No available drivers") }}
            </div>
            <div>
              <q-btn
                unelevated
                round
                dense
                icon="las la-redo-alt"
                color="red-1"
                text-color="red-9"
                @click="refresh"
              />
            </div>
          </div>
        </q-card-section>
      </template>

      <template v-if="loading">
        <q-card-section style="min-height: 50vh">
          <div
            v-if="loading"
            class="row q-gutter-x-sm justify-center q-my-md absolute-center text-center full-width"
          >
            <q-circular-progress
              indeterminate
              rounded
              size="sm"
              color="primary"
            />
            <div class="text-subtitle1 text-grey">{{ $t("Loading") }}...</div>
          </div>
        </q-card-section>
      </template>

      <template v-if="data">
        <q-tabs
          v-model="tab"
          dense
          active-color="primary"
          active-class="active-tabs"
          indicator-color="primary"
          align="justify"
          no-caps
          mobile-arrows
          narrow-indicator
          class="q-pr-md q-pl-md text-disabled"
        >
          <q-tab
            name="driver"
            :label="$t('Driver List')"
            active-class="active-tabs"
            no-caps
          >
          </q-tab>
          <q-tab
            name="mapview"
            :label="$t('Map View')"
            active-class="active-tabs"
            no-caps
          >
          </q-tab>
        </q-tabs>
        <q-separator></q-separator>
        <q-card-section style="min-height: 50vh" class="scroll">
          <template v-if="tab == 'mapview'">
            <div style="height: 55vh">
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
            </div>
          </template>
          <template v-else>
            <q-list>
              <template v-for="items in data" :key="items">
                <q-item
                  clickable
                  v-ripple:purple
                  tag="label"
                  class="radius10"
                  :class="{
                    'border-selected': selected_driver == items.driver_id,
                  }"
                >
                  <q-item-section avatar>
                    <q-avatar>
                      <img :src="items.photo_url" />
                    </q-avatar>
                  </q-item-section>
                  <q-item-section>
                    <q-item-label class="text-capitalize">
                      {{ items.name }}</q-item-label
                    >
                    <q-item-label caption>
                      {{ $t("Active Orders") }} : {{ items.active_task }}
                    </q-item-label>
                  </q-item-section>
                  <q-item-section side class="hidden">
                    <q-radio
                      v-model="selected_driver"
                      :val="items.driver_id"
                      color="teal"
                    />
                  </q-item-section>
                </q-item>
              </template>
            </q-list>
          </template>
        </q-card-section>
        <q-card-actions class="row" v-if="tab == 'driver'">
          <q-btn
            unelevated
            no-caps
            color="disabled"
            text-color="disabled"
            class="radius10 col"
            size="lg"
            @click="modal = false"
          >
            <div class="text-weight-bold text-subtitle2">
              {{ $t("Cancel") }}
            </div>
          </q-btn>
          <q-btn
            unelevated
            no-caps
            color="amber-6"
            text-color="disabled"
            class="radius10 col"
            size="lg"
            :disable="!hasSelected"
            @click="Assign"
            :loading="loading_assign"
          >
            <div class="text-weight-bold text-subtitle2">
              {{ $t("Assigned") }}
            </div>
          </q-btn>
        </q-card-actions>
      </template>
    </q-card>
  </q-dialog>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useDriverStore } from "stores/DriverStore";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";

export default {
  name: "DriverAssign",
  props: ["order_uuid", "merchant_location"],
  components: {
    MapsComponents: defineAsyncComponent(() =>
      import("components/MapsComponents.vue")
    ),
  },
  data() {
    return {
      tab: "driver",
      modal: false,
      loading: false,
      loading_assign: false,
      selected_driver: null,
      zone_id: "",
      group_selected: "",
      q: "",
      data: null,
      center: { lat: 34.04703, lng: -118.24686 },
      marker_position: [],
    };
  },
  setup() {
    const DriverStore = useDriverStore();
    const DataStore = useDataStore();
    return { DriverStore, DataStore };
  },
  computed: {
    hasSelected() {
      return this.selected_driver;
    },
  },
  methods: {
    refresh() {
      this.DriverStore.data = null;
      this.data = null;
      this.getAvailableDriver();
    },
    setSelected(data) {
      this.selected_driver = !data.selected ? data : [];
      data.selected = !data.selected;
    },
    beforeHide() {
      this.tab = "driver";
      this.DriverStore.data = this.data ?? null;
    },
    async getAvailableDriver() {
      if (this.DriverStore.data) {
        this.data = this.DriverStore.data;
        return;
      }

      try {
        this.loading = true;
        const params = new URLSearchParams({
          zone_id: this.zone_id,
          group_selected: this.group_selected,
          q: this.q,
          order_uuid: this.order_uuid,
        }).toString();
        const response = await APIinterface.fetchDataByTokenPost(
          "getAvailableDriver",
          params
        );
        this.data = response.details.data;

        Object.entries(response.details.data).forEach(([key, items]) => {
          this.marker_position.push({
            id: key,
            lat: parseFloat(items.latitude),
            lng: parseFloat(items.longitude),
            icon:
              this.DataStore.getMapsConfig?.map_provider == "mapbox"
                ? "marker_icon_rider"
                : this.DataStore.getMapsConfig?.icon_rider,
            draggable: false,
            title: items.name,
          });
        });

        if (this.merchant_location) {
          this.marker_position.push({
            id: this.marker_position.length + 1,
            lat: parseFloat(this.merchant_location?.lat),
            lng: parseFloat(this.merchant_location?.lng),
            icon:
              this.DataStore.getMapsConfig?.map_provider == "mapbox"
                ? "marker_icon_destination"
                : this.DataStore.getMapsConfig?.icon_destination,
            draggable: false,
            title: this.merchant_location?.restaurant_name,
          });
        }
      } catch (error) {
        console.log("error", error);
        this.data = null;
      } finally {
        this.loading = false;
      }
    },
    async Assign() {
      try {
        this.loading_assign = true;
        const params = new URLSearchParams({
          driver_id: this.selected_driver,
          order_uuid: this.order_uuid,
        }).toString();
        const response = await APIinterface.fetchDataByTokenPost(
          "AssignDriver",
          params
        );
        console.log("response", response);
        this.modal = false;
        this.$emit("afterAssigndriver");
        APIinterface.ShowSuccessful(response.msg, this.$q);
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        this.loading_assign = false;
      }
    },
    //
  },
};
</script>
