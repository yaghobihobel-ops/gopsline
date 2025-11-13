<template>
  <q-dialog
    v-model="dialog"
    class="rounded-borders-top"
    @before-show="beforeShow"
    :maximized="true"
    persistent
    transition-show="fade"
  >
    <q-card>
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <q-toolbar-title
          class="text-dark text-weight-bold"
          style="overflow: inherit"
        >
          {{ $t("Delivery address") }}
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
        <!-- <div class="bg-grey-2 radius8" style="height: 110px"></div> -->
        <q-space class="q-pa-sm"></q-space>
        <q-form @submit="onSubmit">
          <q-input
            outlined
            v-model="formatted_address"
            :label="$t('Street name')"
            stack-label
            color="grey-5"
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <q-input
            outlined
            v-model="address1"
            :label="$t('Street number')"
            stack-label
            color="grey-5"
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <q-input
            outlined
            v-model="location_name"
            :label="$t('Aparment, suite or floor')"
            stack-label
            color="grey-5"
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <q-select
            outlined
            v-model="delivery_options"
            :options="options"
            :label="$t('Delivery options')"
          />

          <q-space class="q-pa-sm"></q-space>
          <q-input
            v-model="delivery_instructions"
            outlined
            autogrow
            stack-label
            :label="$t('Add delivery instructions')"
            :hint="
              $t(
                'eg. ring the bell after dropoff, leave next to the porch, call upon arrival, etc'
              )
            "
          />
          <q-space class="q-pa-md"></q-space>
          <div class="text-weight-bold q-mb-sm">{{ $t("Address label") }}</div>

          <!-- <pre>{{ CartStore.getAddresslabel }}</pre> -->
          <div class="border-grey radius8">
            <q-btn-toggle
              v-model="address_label"
              toggle-color="green"
              unelevated
              no-caps
              :options="CartStore.getAddresslabel"
              spread
              padding="10px"
            />
          </div>

          <q-space class="q-pa-lg"> </q-space>

          <q-footer>
            <q-btn
              type="submit"
              color="primary"
              text-color="white"
              :label="$t('Save address')"
              unelevated
              class="full-width"
              size="lg"
              no-caps
              :loading="loading"
            />
          </q-footer>
        </q-form>
      </q-card-section>
    </q-card>
  </q-dialog>
</template>

<script>
import { useCartStore } from "stores/CartStore";
import { useDataStore } from "stores/DataStore";

export default {
  name: "DeliveryInformation",
  data() {
    return {
      dialog: false,
      loading: false,
      formatted_address: "",
      address1: "",
      location_name: "",
      delivery_options: "",
      delivery_instructions: "",
      address_label: "Home",
    };
  },
  setup() {
    const CartStore = useCartStore();
    const DataStore = useDataStore();
    return { CartStore, DataStore };
  },
};
</script>
