<template>
  <q-list>
    <q-virtual-scroll
      class="fit"
      separator
      :items="data"
      :virtual-scroll-item-size="48"
      v-slot="{ item: items }"
    >
      <BookingItem
        :items="items"
        :statusColor="OrderStore.statusBookingColor"
      ></BookingItem>
    </q-virtual-scroll>
  </q-list>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useAccessStore } from "stores/AccessStore";
import { useOrderStore } from "stores/OrderStore";
import { defineAsyncComponent } from "vue";

export default {
  name: "TableBookingList",
  props: ["data", "status"],
  components: {
    BookingItem: defineAsyncComponent(() =>
      import("components/BookingItem.vue")
    ),
  },
  data() {
    return {
      handle: undefined,
      delete_row: undefined,
      status_color: {
        pending: "blue",
        confirmed: "green",
        cancelled: "deep-orange",
        denied: "amber",
        finished: "green-13",
        no_show: "amber",
        waitlist: "grey-1",
      },
    };
  },
  setup() {
    const AccessStore = useAccessStore();
    const OrderStore = useOrderStore();
    return { AccessStore, OrderStore };
  },
  methods: {
    onRight(reset) {
      if (!APIinterface.empty(this.handle)) {
        try {
          this.handle.reset();
        } catch (err) {}
      }
      this.handle = reset;
    },
    close() {
      this.handle.reset();
    },
    deleteBooking(id, data, index) {
      this.$emit("confirmDelete", id, data, index);
    },
  },
};
</script>
