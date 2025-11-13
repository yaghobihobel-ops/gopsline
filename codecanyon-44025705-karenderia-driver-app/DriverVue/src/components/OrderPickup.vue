<template>
  <div
    class="bg-whitex q-pb-md"
    :class="{
      'bg-mydark ': $q.dark.mode,
      'bg-white ': !$q.dark.mode,
    }"
  >
    <q-card class="no-shadow">
      <q-card-section>
        <!-- <p class="font11 no-margin">Restaurant Details</p> -->
        <div class="row justify-between">
          <div class="text-weight-bold">{{ $t("Restaurant Details") }}</div>
          <div>#{{ data.order_id }}</div>
        </div>
        <div class="row items-center">
          <div
            v-if="merchants[data.merchant_id]"
            class="col text-weight-medium"
          >
            {{ merchants[data.merchant_id].restaurant_name }}
          </div>
          <div class="col-5 text-right">
            <div class="flex items-center justify-end">
              <q-btn
                round
                color="deep-orange"
                icon="las la-exclamation-triangle"
                size="12px"
                unelevated
                flat
                class="q-mr-xs"
                @click="showHelp"
              />

              <q-btn
                round
                color="primary"
                icon="las la-map"
                size="sm"
                unelevated
                flat
                class="q-mr-sm"
                to="/home/maps"
              />
              <q-btn
                :href="'tel:' + merchants[data.merchant_id].contact_phone"
                round
                color="mygreen"
                icon="las la-phone-volume"
                size="sm"
                unelevated
                flat
              />
            </div>
          </div>
        </div>
        <!-- row -->
      </q-card-section>
    </q-card>

    <q-card
      class="no-shadow no-border-radius"
      :class="{
        '': $q.dark.mode,
        'card-bordered': !$q.dark.mode,
      }"
    >
      <q-card-section>
        <div class="text-weight-bold">
          {{ $t("Restaurant time preparation") }}
        </div>

        <div class="text-center">
          <PreparationCircularprogress
            :order_accepted_at="data.order_accepted_at"
            :preparation_starts="data.preparation_starts"
            :timezone="
              order_meta[data.order_id]
                ? order_meta[data.order_id]['timezone']
                : ''
            "
            :total_time="data.preparation_time_estimation"
            :label="{
              hour: $t('hour'),
              hours: $t('hours'),
              min: $t('min'),
              mins: $t('mins'),
              order_overdue: $t('Order is Overdue!'),
            }"
          >
          </PreparationCircularprogress>
        </div>
      </q-card-section>
    </q-card>

    <q-card
      class="no-shadow card-borderedx no-border-radius"
      :class="{
        '': $q.dark.mode,
        'card-bordered': !$q.dark.mode,
      }"
    >
      <q-card-section>
        <div class="text-weight-bold">{{ $t("Order Details") }}</div>
        <div class="text-weight-medium">
          {{ $t("Order#") }}{{ data.order_id }}
        </div>
        <div class="text-weight-medium">{{ data.full_name }}</div>
        <div class="q-pa-sm"></div>

        <!-- order details -->
        <OrderDetails :order_uuid="order_uuid" />
        <!-- end order details -->
      </q-card-section>

      <q-card-actions>
        <q-btn
          :label="data.delivery_steps.label"
          @click="confirm_dialog = !confirm_dialog"
          :loading="loading"
          color="primary"
          unelevated
          no-caps
          :style="`background-color:${data.delivery_steps.status_data.bg_color} !important;color:${data.delivery_steps.status_data.font_color} !important;`"
          size="lg"
          class="fit text-weight-bold"
        ></q-btn>
      </q-card-actions>
    </q-card>
  </div>
  <!-- white -->

  <q-dialog v-model="confirm_dialog" position="bottom">
    <q-card>
      <q-card-section>
        <div class="text-center">
          <div class="font15 text-weight-bold">
            {{ $t("Do you confirm order#") }}{{ data.order_id }}
            {{ $t("pickup") }}?
          </div>
        </div>
      </q-card-section>
      <q-card-actions class="q-gutter-md">
        <q-btn
          color="primary"
          no-caps
          :label="$t('Confirm Pickup')"
          unelevated
          class="fit text-weight-bold"
          size="lg"
          @click="changeOrderStatus(data.delivery_steps.methods)"
          :style="`background-color:${data.delivery_steps.status_data.bg_color} !important;color:${data.delivery_steps.status_data.font_color} !important;`"
        />
        <q-btn
          color="blue"
          no-caps
          :label="$t('Cancel')"
          unelevated
          flat
          class="fit text-weight-bold"
          size="lg"
          @click="confirm_dialog = !confirm_dialog"
        />
      </q-card-actions>
    </q-card>
  </q-dialog>

  <OrderHelp
    ref="order_help"
    list_type="orderhelppickup"
    :title="$t('Report an issue')"
    @after-submit="afterSubmit"
  >
  </OrderHelp>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { defineAsyncComponent } from "vue";

export default {
  name: "OrderPickup",
  props: ["order_uuid", "merchants", "data", "order_meta"],
  components: {
    OrderDetails: defineAsyncComponent(() =>
      import("components/OrderDetails.vue")
    ),
    OrderHelp: defineAsyncComponent(() => import("components/OrderHelp.vue")),
    PreparationCircularprogress: defineAsyncComponent(() =>
      import("components/PreparationCircularprogress.vue")
    ),
  },
  data() {
    return {
      expanded: false,
      loading: false,
      confirm_dialog: false,
    };
  },
  methods: {
    showHelp() {
      this.$refs.order_help.show();
    },
    changeOrderStatus(methods) {
      this.loading = true;
      APIinterface.showLoadingBox("", this.$q);

      APIinterface.fetchDataByToken(methods, {
        order_uuid: this.order_uuid,
      })
        .then((result) => {
          this.$emit("afterChangestatus", result.details);
        })
        .catch((error) => {
          console.debug(error);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
          this.loading = false;
        });
    },
    afterSubmit() {
      console.debug("afterSubmit");
    },
  },
};
</script>
