<template>
  <q-page>
    <div class="q-pa-md">
      <q-input
        outlined
        v-model="search"
        :placeholder="$t('Enter order number')"
        :debounce="500"
        @update:model-value="SearchOrder"
        @clear="this.search = ''"
        :loading="loading"
        clearable
        clear-icon="close"
        dense
      >
        <template v-slot:prepend>
          <img src="/svg/search1.svg" width="20" />
        </template>
      </q-input>
    </div>

    <NoData
      v-if="!hasItems && !loading && search"
      message="We couldn't find any orders matching your search."
    />

    <q-virtual-scroll
      class="fit q-pl-md q-pr-md"
      separator
      :items="data"
      :virtual-scroll-item-size="60"
      v-slot="{ item: order }"
    >
      <q-card class="radius8 q-pl-xs q-pr-xs box-shadow0 q-mb-md" flat>
        <q-list>
          <q-item
            clickable
            v-ripple:purple
            :to="{
              path: '/orderview',
              query: { order_uuid: order?.order_uuid },
            }"
          >
            <q-item-section>
              <q-item-label class="text-weight-bold text-subtitle2">
                <div class="flex items-center q-gutter-x-sm">
                  <div>#{{ order.order_id }}</div>
                  <div v-if="order.is_view == '0'" class="blob green"></div>
                  <div v-if="order.is_critical == true" class="blob red"></div>
                </div>
              </q-item-label>
              <q-item-label>
                <template v-if="order?.is_timepreparation">
                  <PreparationCircularprogress
                    display="text"
                    :order_accepted_at="order.order_accepted_at"
                    :preparation_starts="order.preparation_starts"
                    :timezone="order.timezone"
                    :total_time="order.preparation_time_estimation_raw"
                    :label="{
                      hour: $t('hour'),
                      hours: $t('hours'),
                      min: $t('min'),
                      mins: $t('mins'),
                      order_overdue: $t('Order is Overdue!'),
                    }"
                  />
                </template>
                <template v-else>
                  {{ order.date_created }}
                </template>
              </q-item-label>
            </q-item-section>
            <q-item-section top side>
              <q-badge
                :color="
                  OrderStore.statusColor[order.status_raw]?.bg || 'primary'
                "
                :text-color="
                  OrderStore.statusColor[order.status_raw]?.text || 'white'
                "
                class="text-weight-medium text-body2"
              >
                {{ order.status }}
              </q-badge>
            </q-item-section>
          </q-item>
          <q-item
            clickable
            v-ripple:purple
            :to="{
              path: '/orderview',
              query: { order_uuid: order?.order_uuid },
            }"
          >
            <q-item-section>
              <q-item-label class="text-weight-bold text-subtitle2">{{
                order.customer_name
              }}</q-item-label>
              <q-item-label> {{ order.order_type }}</q-item-label>
            </q-item-section>
            <q-item-section
              top
              side
              class="text-weight-medium text-subtitle2"
              >{{ order.total }}</q-item-section
            >
          </q-item>
        </q-list>
      </q-card>
    </q-virtual-scroll>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "src/stores/DataStore";
import { useOrderStore } from "src/stores/OrderStore";
import { defineAsyncComponent } from "vue";

export default {
  name: "SearchPage",
  components: {
    NoData: defineAsyncComponent(() => import("components/NoData.vue")),
  },
  setup() {
    const DataStore = useDataStore();
    const OrderStore = useOrderStore();
    return { DataStore, OrderStore };
  },
  data() {
    return {
      search: "",
      data: [],
      loading: false,
    };
  },
  mounted() {
    this.DataStore.page_title = this.$t("Search");
  },
  computed: {
    hasItems() {
      if (!this.data) {
        return false;
      }
      return this.data.length > 0;
    },
  },
  methods: {
    async SearchOrder(value) {
      if (!value) {
        this.data = [];
        return;
      }
      try {
        const params = new URLSearchParams({
          q: value,
        }).toString();
        this.loading = true;
        const response = await APIinterface.fetchGet(`orderlistnew?${params}`);
        this.data = response.details.data;
      } catch (error) {
        this.data = [];
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>
