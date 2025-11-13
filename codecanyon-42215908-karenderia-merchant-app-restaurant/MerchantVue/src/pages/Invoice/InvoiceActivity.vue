<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page class="q-pa-md row items-stretch">
      <template v-if="loading">
        <q-inner-loading :showing="true" color="primary" size="md" />
      </template>
      <template v-else>
        <q-card class="no-shadow full-width">
          <q-card-section>
            <template v-if="hasData">
              <div class="text-subtitle1">{{ $t("Invoice activity") }}</div>

              <q-space class="q-pa-sm"></q-space>

              <!-- <q-list separator>
                <q-item v-for="items in data" :key="items">
                  <q-item-section>
                    <q-item-label caption>{{ items.meta_value2 }}</q-item-label>
                    <q-item-label>{{ items.meta_value1 }}</q-item-label>
                  </q-item-section>
                </q-item>
              </q-list> -->

              <q-stepper
                v-model="step"
                vertical
                animated
                active-icon="done"
                flat
              >
                <template v-for="(items, index) in data" :key="items">
                  <q-step
                    :name="1"
                    :title="items.meta_value1"
                    icon="done"
                    :done="step <= index"
                    color="grey"
                  >
                    <div class="text-caption line-normal">
                      {{ items.meta_value2 }}
                    </div>
                  </q-step>
                </template>
              </q-stepper>
            </template>
            <template v-else>
              <div class="full-width text-center">
                <p class="text-grey q-ma-none">{{ $t("No available data") }}</p>
              </div>
            </template>
          </q-card-section>
        </q-card>
      </template>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "InvoiceActivity",
  data() {
    return {
      id: null,
      loading: false,
      data: [],
      is_refresh: undefined,
      step: 1,
    };
  },
  mounted() {
    this.id = this.$route.query.id;
    if (!APIinterface.empty(this.id)) {
      this.getData();
    }
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
    refresh(done) {
      this.is_refresh = done;
      this.getData();
    },
    getData() {
      if (APIinterface.empty(this.is_refresh)) {
        this.loading = true;
      }
      APIinterface.fetchDataByTokenPost("invoiceActivity", "id=" + this.id)
        .then((data) => {
          this.data = data.details;
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
          if (!APIinterface.empty(this.is_refresh)) {
            this.is_refresh();
          }
        });
    },
  },
};
</script>
