<template>
  <div class="text-h5 text-weight-bold q-mb-sm">
    {{ title }} <span class="text-red">{{ total_records }}</span>
  </div>
  <q-card flat class="relative-position">
    <!-- style="max-height: calc(50vh)" -->

    <q-card-section class="q-pa-sm">
      <template v-if="loading">
        <div v-for="items in 1" :key="items" class="q-mb-sm">
          <q-skeleton height="50px" square />
          <q-skeleton type="text" />
        </div>
      </template>
      <template v-else>
        <template v-if="hasData">
          <template v-for="items in data" :key="items">
            <q-card class="beautiful-shadow q-pa-sm q-mb-md">
              <q-item
                clickable
                class="q-mb-xs"
                :class="border_class"
                @click="showPreview(items)"
              >
                <q-item-section>
                  <q-item-label class="text-weight-bold">
                    #{{ items.order_id_raw }}
                  </q-item-label>
                  <q-item-label class="flex q-gutter-x-md" caption>
                    <div>{{ items.date_created2 }}</div>
                    <div>{{ items.total_items1 }}</div>
                  </q-item-label>
                </q-item-section>
              </q-item>
              <q-item
                clickable
                class="border-top-grey"
                @click="showPreview(items)"
              >
                <q-item-section avatar>
                  <q-icon name="eva-person-outline"></q-icon>
                </q-item-section>
                <q-item-section class="text-weight-bold text-capitalize">
                  <div class="flex q-gutter-x-sm items-center">
                    <div>{{ items.customer_name }}</div>
                    <div v-if="items.payment_status == 'paid'">
                      <q-badge
                        rounded
                        color="green-1"
                        text-color="green-9"
                        :label="$t('Paid')"
                        class="text-weight-bold"
                      />
                    </div>
                  </div>
                </q-item-section>
                <q-item-section side>
                  <!-- {{ items.tracking_start }}
                  {{ items.tracking_end }} -->
                  <OrderCountdown
                    :start="items.tracking_start"
                    :end="items.tracking_end"
                    :timezone="items.timezone"
                  ></OrderCountdown>
                </q-item-section>
              </q-item>
            </q-card>
          </template>
        </template>
        <template v-else>
          <div class="text-body2 q-pa-md text-weight-bold text-grey">
            {{ message_not_found }}
          </div>
        </template>
      </template>
    </q-card-section>

    <OrderPreview
      ref="order_preview"
      :data="order_items"
      :items_details="item_details"
      :settings_tabs="settings_tabs"
      :order_group_buttons="order_group_buttons"
      :order_buttons="order_buttons"
      @after-updatestatus="afterUpdatestatus"
    ></OrderPreview>
  </q-card>
</template>

<script>
import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";
import { useUserStore } from "stores/UserStore";
import { useOrderStore } from "stores/OrderStore";
import { defineAsyncComponent } from "vue";

export default {
  name: "OrderWidgets",
  props: ["title", "border_class", "filter_by", "message_not_found"],
  components: {
    OrderPreview: defineAsyncComponent(() =>
      import("components/OrderPreview.vue")
    ),
    OrderCountdown: defineAsyncComponent(() =>
      import("components/OrderCountdown.vue")
    ),
  },
  setup() {
    return {};
  },
  data() {
    return {
      loading: false,
      refresh_loading: false,
      data: [],
      limit: 20,
      total_records: 0,
      order_items: [],
      settings_tabs: [],
      order_group_buttons: [],
      order_buttons: [],
      services_list: [],
      item_details: [],
    };
  },
  mounted() {
    this.getOrders(null);
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    showPreview(data) {
      console.log(data);
      this.order_items = data;
      this.$refs.order_preview.dialog = true;
    },
    getOrders(done) {
      this.loading = true;

      APIinterface.fetchDataByTokenPost(
        "OrderList",
        "queryby=" + this.filter_by + "&limit=" + this.limit + "&page=0"
      )
        .then((data) => {
          this.data = data.details.data;
          this.total_records = data.details.total_records;
          this.item_details = data.details.item_details;
          this.settings_tabs = data.details.settings_tabs;
          this.order_group_buttons = data.details.order_group_buttons;
          this.order_buttons = data.details.order_buttons;
          this.services_list = data.details.services_list;
        })
        .catch((error) => {
          this.data = [];
          this.total_records = 0;
          this.item_details = [];
          this.settings_tabs = [];
          this.order_group_buttons = [];
          this.order_buttons = [];
          this.services_list = [];
        })
        .then((data) => {
          this.loading = false;
          this.refresh_loading = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    afterUpdatestatus() {
      this.$refs.order_preview.dialog = false;
      this.getOrders(null);
      this.$emit("afterUpdatestatus", this.filter_by);
    },
  },
};
</script>
