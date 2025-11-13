<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
      }"
      class="q-pr-md q-pl-md"
    >
      <OrderWidgets
        ref="order_new"
        :title="$t('New order')"
        border_class="border-left-new"
        filter_by="order_new"
        :message_not_found="$t('No new orders available at the moment.')"
        @after-updatestatus="afterUpdatestatus"
      >
      </OrderWidgets>

      <q-space class="q-pa-md"></q-space>

      <OrderWidgets
        ref="order_processing"
        :title="$t('Accepted orders')"
        :count="2"
        :data="[]"
        border_class="border-left-accepted"
        filter_by="order_processing"
        :message_not_found="$t('No accepted orders found.')"
        @after-updatestatus="afterUpdatestatus"
      >
      </OrderWidgets>

      <q-space class="q-pa-md"></q-space>

      <OrderWidgets
        ref="order_ready"
        :title="$t('Ready for pickup')"
        :count="2"
        :data="[]"
        border_class="border-left-ready"
        filter_by="order_ready"
        :message_not_found="
          $t('Currently, there are no orders ready for pickup.')
        "
        @after-updatestatus="afterUpdatestatus"
      >
      </OrderWidgets>

      <q-space class="q-pa-lg"></q-space>

      <q-page-scroller
        position="bottom-right"
        :scroll-offset="150"
        :offset="[18, 18]"
      >
        <q-btn
          fab
          icon="keyboard_arrow_up"
          :color="$q.dark.mode ? 'grey600' : 'mygrey'"
          :text-color="$q.dark.mode ? 'grey300' : 'dark'"
          dense
          padding="3px"
        />
      </q-page-scroller>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useUserStore } from "stores/UserStore";
import APIinterface from "src/api/APIinterface";

export default {
  name: "DashboardOrders",
  components: {
    OrderWidgets: defineAsyncComponent(() =>
      import("components/OrderWidgets.vue")
    ),
  },
  setup() {
    const UserStore = useUserStore();
    return { UserStore };
  },
  data() {
    return {
      refresh_done: undefined,
    };
  },
  watch: {
    UserStore: {
      immediate: true,
      deep: true,
      handler(newValue, oldValue) {
        if (Object.keys(newValue.data_push_receive).length > 0) {
          console.log("New order watch here");
          console.log(newValue.data_push_receive);
          if (newValue.data_push_receive.notification_type == "order_update") {
            if (!APIinterface.empty(this.$refs.order_new)) {
              this.$refs.order_new.getOrders(null);
            }
          }
        }
      },
    },
  },
  methods: {
    refresh(done) {
      this.$refs.order_new.getOrders(done);
      this.$refs.order_processing.getOrders(null);
      this.$refs.order_ready.getOrders(null);
    },
    afterUpdatestatus(data) {
      console.log("afterUpdatestatus", data);
      if (data == "order_new") {
        this.$refs.order_processing.getOrders(null);
      } else if (data == "order_processing") {
        this.$refs.order_ready.getOrders(null);
      } else if (data == "order_ready") {
      }
    },
  },
};
</script>
