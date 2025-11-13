<template>
  <q-card flat class="radius8 box-shadow0 q-pa-sm q-mb-md">
    <div class="hidden">
      <pre>{{ items }}</pre>
    </div>

    <q-item
      class="q-pl-none q-pr-none text-dark"
      clickable
      v-ripple:purple
      :to="{
        path: '/tables/reservation_overview',
        query: { id: items.reservation_uuid },
      }"
    >
      <q-item-section avatar class="itemsection-dense" top>
        <q-btn color="oranges" text-color="dark" unelevated dense>
          <img src="/svg/orders.svg" width="20" />
        </q-btn>
      </q-item-section>
      <q-item-section>
        <q-item-label class="text-caption">{{ $t("Booking ID") }}</q-item-label>
        <q-item-label class="text-caption text-weight-bold">{{
          items.reservation_id
        }}</q-item-label>
      </q-item-section>
      <q-item-section side top>
        <q-item-label caption> {{ items.reservation_date }}</q-item-label>
        <q-item-label>
          <q-badge
            class="text-weight-medium text-body2 radius10"
            :color="statusColor[items.status_raw]?.bg"
            :text-color="statusColor[items.status_raw]?.text"
          >
            {{ items.status }}
          </q-badge>
        </q-item-label>
      </q-item-section>
    </q-item>

    <q-separator></q-separator>

    <q-item
      class="q-pl-none q-pr-none text-dark"
      style="min-height: auto"
      clickable
      v-ripple:purple
      :to="{
        path: '/tables/reservation_overview',
        query: { id: items.reservation_uuid },
      }"
    >
      <div class="row fit">
        <div class="col borderx">
          <div class="flex items-center no-wrap q-gutter-x-sm">
            <img src="/svg/person.svg" width="20" />
            <div class="text-weight-medium">
              {{ items.full_name }}
            </div>
          </div>
        </div>
        <div class="col borderx">
          <div class="flex items-center no-wrap q-gutter-x-sm">
            <img src="/svg/phone.svg" width="20" />
            <div class="text-weight-medium ellipsis">
              {{ items.contact_phone }}
            </div>
          </div>
        </div>
      </div>
    </q-item>

    <q-item
      class="q-pl-none q-pr-none text-dark"
      style="min-height: auto"
      clickable
      :to="{
        path: '/tables/reservation_overview',
        query: { id: items.reservation_uuid },
      }"
    >
      <div class="row fit">
        <div class="col borderx">
          <div class="flex items-center no-wrap q-gutter-x-sm">
            <img src="/svg/tables.svg" width="20" />
            <div class="text-weight-medium">
              {{ items.table_id }}
            </div>
          </div>
        </div>
        <div class="col borderx">
          <div class="flex items-center no-wrap q-gutter-x-sm">
            <img src="/svg/guest.svg" width="20" />
            <div class="text-weight-medium">
              {{ items.guest_number }}
            </div>
          </div>
        </div>
      </div>
    </q-item>
    <q-separator></q-separator>
    <q-item>
      <q-btn
        :color="statusColor[items.status_raw]?.bg"
        :text-color="statusColor[items.status_raw]?.text"
        :label="items.status"
        class="radius10 fit"
        no-caps
        unelevated
      >
        <q-menu fit anchor="bottom left" self="top left" class="footer-shadow">
          <q-list>
            <template
              v-for="(status, status_raw) in DataStore.booking_status_list"
              :key="status"
            >
              <q-item
                v-if="status_raw != items.status_raw"
                clickable
                v-close-popup
                @click="changeStatus(items.reservation_uuid, status_raw)"
              >
                <q-item-section>{{ status }}</q-item-section>
              </q-item>
              <q-separator />
            </template>
          </q-list>
        </q-menu>
      </q-btn>
    </q-item>
  </q-card>
</template>

<script>
// import { useOrderStore } from "src/stores/OrderStore";
import { useDataStore } from "src/stores/DataStore";
import APIinterface from "src/api/APIinterface";

export default {
  name: "BookingItem",
  props: ["items", "statusColor", "index"],
  setup() {
    //const OrderStore = useOrderStore();
    const DataStore = useDataStore();
    return { DataStore };
  },
  methods: {
    async changeStatus(reservation_uuid, status) {
      try {
        APIinterface.showLoadingBox("", this.$q);
        const params = new URLSearchParams({
          id: reservation_uuid,
          status: status,
          index: this.index,
        }).toString();
        const response = await APIinterface.fetchDataByTokenPost(
          "UpdateBookingStatus",
          params
        );
        this.$emit("afterUpdate", this.index, response.details.data);
      } catch (error) {
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
  },
};
</script>
