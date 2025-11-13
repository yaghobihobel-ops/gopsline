<template>
  <q-dialog
    v-model="modal"
    position="bottom"
    @before-show="beforeShow"
    @before-hide="beforeHide"
    :persistent="is_persistent ? is_persistent : false"
  >
    <q-card class="myform">
      <q-card-section>
        <div class="scroll q-mb-lg">
          <q-btn-toggle
            v-model="transaction_type"
            color="mygrey1"
            toggle-color="orange-1"
            text-color="grey"
            toggle-text-color="blue-grey-6"
            no-caps
            unelevated
            class="rounded-group"
            :options="CartStore.getServices ? CartStore.getServices : []"
            @update:model-value="setTransactionType"
          />
        </div>

        <q-list>
          <template
            v-for="items in CartStore.getDeliveryOptionsList"
            :key="items"
          >
            <q-item
              clickable
              v-ripple:purple
              class="text-weight-bold radius8"
              :class="{
                'border-primary': CartStore.geDeliverytype == items.value,
                'border-grey': CartStore.geDeliverytype != items.value,
              }"
              @click="changeDeliveryType(items.value)"
            >
              <q-item-section>
                <div class="flex items-center q-gutter-x-sm">
                  <div>
                    {{ items.name }} <span v-if="items.estimation">&bull;</span>
                  </div>
                  <div v-if="items.estimation" class="text-caption">
                    {{ items.estimation }}
                  </div>
                </div>
              </q-item-section>
            </q-item>
            <q-space class="q-pa-xs"></q-space>
          </template>
        </q-list>
      </q-card-section>
    </q-card>
  </q-dialog>

  <DeliveryTime
    ref="ref_deliverytime"
    :merchant_id="CartStore.getMerchantId"
    :cart_uuid="CartStore.getCartID"
    :save_delivery_date="CartStore.geDeliveryDate"
    :save_delivery_time="CartStore.geDeliveryTime?.start_time || null"
    :is_persistent="is_persistent"
    @after-saveschedule="afterSaveschedule"
  >
  </DeliveryTime>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useCartStore } from "stores/CartStore";
import { defineAsyncComponent } from "vue";

export default {
  name: "DeliverySched",
  props: ["is_persistent", "transactionType", "deliveryType", "merchant_id"],
  components: {
    DeliveryTime: defineAsyncComponent(() =>
      import("components/DeliveryTime.vue")
    ),
  },
  setup() {
    const CartStore = useCartStore();
    return { CartStore };
  },
  data() {
    return {
      modal: false,
      loading: false,
      loading_submit: false,
      transaction_type: "",
      delivery_type: "",
      delivery_date: "",
      delivery_time: "",
      delivery_date_list: [],
      delivery_time_list: [],
      results: null,
    };
  },
  methods: {
    showSched(data) {
      this.modal = data;
    },
    beforeShow() {
      this.transaction_type = this.transactionType;
      this.delivery_type = this.deliveryType;
    },
    async changeDeliveryType(value) {
      console.log("changeDeliveryType", value);
      if (value == "schedule") {
        this.$refs.ref_deliverytime.modal = true;
      } else {
        try {
          APIinterface.showLoadingBox("", this.$q);
          const response = await APIinterface.fetchDataPost(
            "setDeliveryNow",
            "cart_uuid=" + (this.CartStore.getCartID ?? "")
          );
          this.$emit("afterSavetrans", response.details);
        } catch (error) {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        } finally {
          APIinterface.hideLoadingBox(this.$q);
        }
      }
    },
    afterSaveschedule(value) {
      console.log("afterSaveschedule", value);
      this.$emit("afterSavetrans", value);
    },
    async setTransactionType(value) {
      try {
        APIinterface.showLoadingBox("", this.$q);
        console.log("setTransactionType", value);
        const response = await APIinterface.fetchDataPost(
          "setTransactionType",
          "cart_uuid=" +
            (this.CartStore.getCartID ?? "") +
            "&transaction_type=" +
            value
        );
        this.$emit("afterSavetrans", response.details);
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
    //
  },
};
</script>
