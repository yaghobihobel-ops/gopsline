<template>
  <template v-if="loading">
    <div>
      <q-skeleton type="text" style="width: 30%" />
      <q-skeleton type="text" style="width: 50%" />
    </div>
    <div>
      <q-skeleton height="180px" square />
    </div>
  </template>

  <template v-else>
    <div class="text-h6">{{ $t("Top Customers") }}</div>
    <div class="text-grey">{{ $t("Your top customer consumer") }}</div>

    <template
      v-if="!GlobalStore.getTopcustomer && !GlobalStore.top_customer_loading"
    >
      <q-card class="no-shadow">
        <q-card-section
          class="q-pa-none flex flex-center"
          style="min-height: calc(30vh)"
        >
          <div class="full-width text-center">
            <div class="text-weight-bold">{{ $t("No customer") }}</div>
            <div class="text-grey">{{ $t("You don't have customer yet") }}</div>
          </div>
        </q-card-section>
      </q-card>
    </template>
    <template v-else>
      <q-space class="q-pa-sm"></q-space>
      <q-card class="no-shadow">
        <q-card-section class="q-pa-none">
          <q-list separator>
            <template v-for="items in GlobalStore.getTopcustomer" :key="items">
              <q-item
                clickable
                :to="{
                  path: 'customer/details',
                  query: { client_id: items.client_id },
                }"
              >
                <q-item-section avatar>
                  <q-avatar>
                    <q-img
                      :src="items.image_url"
                      spinner-size="sm"
                      spinner-color="primary"
                    ></q-img>
                  </q-avatar>
                </q-item-section>
                <q-item-section>
                  <q-item-label class="text-weight-medium"
                    >{{ items.first_name }} {{ items.last_name }}</q-item-label
                  >
                  <q-item-label caption>{{ items.total_sold }}</q-item-label>
                  <q-item-label caption class="font11">
                    {{ items.member_since }}
                  </q-item-label>
                </q-item-section>
              </q-item>
            </template>
          </q-list>
        </q-card-section>
      </q-card>
    </template>
  </template>
</template>

<script>
import { useGlobalStore } from "stores/GlobalStore";

export default {
  name: "TopCustomer",
  props: ["refresh_done"],
  data() {
    return {
      loading: false,
      data: [],
    };
  },
  setup() {
    const GlobalStore = useGlobalStore();
    return { GlobalStore };
  },
  mounted() {
    if (!this.GlobalStore.top_customer) {
      this.GlobalStore.getTopCustomer();
    }
  },
  watch: {
    refresh_done(newval, oldva) {
      this.GlobalStore.getTopCustomer(this.refresh_done);
    },
  },
};
</script>
