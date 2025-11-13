<template>
  <ListLoading v-if="loading"></ListLoading>
  <ListNoData
    v-else-if="!loading && !hasData"
    :title="$t('No transactions')"
    :subtitle="$t('new transactions will show here')"
  ></ListNoData>
  <q-list v-else separator>
    <q-item v-for="items in data" :key="items">
      <q-item-section>
        <q-item-label class="text-weight-medium">{{
          items.transaction_amount
        }}</q-item-label>
        <q-item-label caption>{{ items.transaction_description }}</q-item-label>
        <q-item-label caption class="font11">{{
          items.transaction_date
        }}</q-item-label>
      </q-item-section>
      <q-item-section side class="text-weight-medium">{{
        items.running_balance
      }}</q-item-section>
    </q-item>
  </q-list>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";

export default {
  name: "TransactionHistory",
  components: {
    ListLoading: defineAsyncComponent(() =>
      import("components/ListLoading.vue")
    ),
    ListNoData: defineAsyncComponent(() => import("components/ListNoData.vue")),
  },
  data() {
    return {
      loading: false,
      data: [],
      page: 0,
    };
  },
  created() {
    this.getData();
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
    getData(done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("transactionHistory", "page=1")
        .then((data) => {
          this.data = data.details.data;
        })
        .catch((error) => {
          this.data = [];
        })
        .then((data) => {
          if (!APIinterface.empty(done)) {
            done();
          }
          this.loading = false;
        });
    },
  },
};
</script>
