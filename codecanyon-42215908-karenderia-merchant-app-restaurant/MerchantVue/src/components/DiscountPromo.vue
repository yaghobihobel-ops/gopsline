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
          {{ $t("Discount") }}
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
          <q-input
            v-model="discount"
            outlined
            color="grey-5"
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('Please enter numbers'),
            ]"
            type="number"
          >
            <template v-slot:append>
              <q-icon
                name="las la-percent"
                color="grey"
                class="cursor-pointer"
              />
            </template>
          </q-input>
          <q-btn
            type="submit"
            color="primary"
            text-color="white"
            :label="$t('Apply')"
            unelevated
            class="full-width"
            size="lg"
            no-caps
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

export default {
  name: "DiscountPromo",
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  data() {
    return {
      loading: false,
      dialog: false,
      discount: 0,
    };
  },
  methods: {
    beforeShow() {
      this.discount = 0;
    },
    onSubmit() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "applyDiscount",
        "discount=" + this.discount + "&cart_uuid=" + this.DataStore.cart_uuid
      )
        .then((data) => {
          this.dialog = false;
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
          this.$emit("afterApplydiscount");
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
