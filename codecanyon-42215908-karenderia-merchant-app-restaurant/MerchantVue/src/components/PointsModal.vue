<template>
  <q-dialog
    v-model="dialog"
    position="bottom"
    class="rounded-borders-top"
    @before-show="beforeShow"
  >
    <q-card>
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <q-toolbar-title
          class="text-darkx text-weight-bold"
          style="overflow: inherit"
          :class="{
            'text-white': $q.dark.mode,
            'text-dark': !$q.dark.mode,
          }"
        >
          {{ $t("Apply Points discount") }}
        </q-toolbar-title>
        <q-space></q-space>
        <q-btn
          @click="dialog = !true"
          color="white"
          square
          unelevated
          text-color="grey"
          icon="las la-times"
          dense
          no-caps
          size="sm"
          class="border-grey radius8"
        />
      </q-toolbar>
      <q-card-section>
        <q-form @submit="onSubmit">
          <template v-if="CartStore.pos_attributes.use_thresholds">
            <template v-if="loading2">
              <q-card-actions class="q-gutter-md flex flex-center">
                <q-skeleton type="QBtn" style="height: 80px" />
                <q-skeleton type="QBtn" style="height: 80px" />
                <q-skeleton type="QBtn" style="height: 80px" />
              </q-card-actions>
              <q-skeleton type="QBtn" class="full-width" style="height: 50px" />
            </template>
            <q-tabs
              v-else
              v-model="points_tab"
              class="text-dark q-mb-lg"
              no-caps
              active-color="white"
              active-bg-color="blue"
              indicator-color="blue"
              @update:model-value="setPoints"
            >
              <template v-for="items in data_points" :key="items">
                <q-tab
                  :name="items"
                  :disable="balance > items.points ? false : true"
                >
                  <div class="text-caption">{{ items.label }}</div>
                  <div class="text-subtitle2 q-mb-sm">{{ items.amount }}</div>
                  <q-linear-progress
                    size="18px"
                    :value="balance / items.points"
                    style="min-width: 80px"
                    class="radius28"
                    :color="balance >= items.points ? 'green' : 'blue'"
                  >
                    <div
                      v-if="balance >= items.points"
                      class="absolute-full flex flex-center"
                    >
                      <span class="text-white font12 text-weight-bold">{{
                        $t("REDEEM")
                      }}</span>
                    </div>
                  </q-linear-progress>
                </q-tab>
              </template>
            </q-tabs>
          </template>

          <template v-else>
            <q-input
              v-model="points"
              outlined
              color="grey-5"
              :rules="[
                (val) =>
                  (val && val.length > 0) || this.$t('Please enter numbers'),
              ]"
              type="number"
              step="any"
            >
            </q-input>
          </template>

          <q-btn
            v-if="!loading2"
            type="submit"
            color="primary"
            text-color="white"
            :label="$t('Apply')"
            unelevated
            class="full-width"
            size="lg"
            no-caps
            :disable="points > 0 ? false : true"
            :loading="loading"
          />
        </q-form>
      </q-card-section>
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import { useCartStore } from "stores/CartStore";

export default {
  name: "PointsModal",
  data() {
    return {
      loading: false,
      loading2: false,
      dialog: false,
      points: 0,
      points_tab: 0,
      data_points: [],
      balance: 0,
      points_id: 0,
    };
  },
  setup() {
    const CartStore = useCartStore();
    const DataStore = useDataStore();
    return { CartStore, DataStore };
  },
  methods: {
    beforeShow() {
      this.points = 0;
      if (this.CartStore.pos_attributes.use_thresholds) {
        this.getPointsthresholds();
      }
    },
    setPoints() {
      console.log(this.points_tab);
      this.points = this.points_tab.points;
      this.points_id = this.points_tab.id;
    },
    onSubmit() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "applyPoints",
        "points=" +
          this.points +
          "&cart_uuid=" +
          this.DataStore.cart_uuid +
          "&customer_id=" +
          this.CartStore.customer_id +
          "&points_id=" +
          this.points_id
      )
        .then((data) => {
          this.dialog = false;
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
          this.$emit("afterApplypoints");
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    getPointsthresholds() {
      this.loading2 = true;
      APIinterface.fetchDataByTokenPost(
        "getPointsthresholds",
        "customer_id=" + this.CartStore.customer_id
      )
        .then((data) => {
          this.data_points = data.details.data;
          this.balance = data.details.balance;
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading2 = false;
        });
    },
  },
};
</script>
