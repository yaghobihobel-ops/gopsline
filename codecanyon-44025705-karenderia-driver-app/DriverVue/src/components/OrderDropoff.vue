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
        <p class="no-margin">{{ $t("Customer Details") }}</p>
        <div class="row items-center">
          <div class="col text-weight-medium">
            {{ data.full_name }}
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
                class="q-mr-xs"
                to="/home/maps"
              />
              <template v-if="order_meta[data.order_id]">
                <q-btn
                  :href="'tel:' + order_meta[data.order_id].contact_number"
                  round
                  color="mygreen"
                  icon="las la-phone-volume"
                  size="sm"
                  unelevated
                  flat
                />
              </template>
            </div>
          </div>
        </div>
        <!-- row -->
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
        <p class="no-margin">{{ $t("Order Details") }}</p>
        <div class="text-weight-bold">Order#{{ data.order_id }}</div>
        <div class="text-weight-medium">
          <template v-if="order_meta[data.order_id]">
            <template v-if="order_meta[data.order_id].address1">{{
              order_meta[data.order_id].address1
            }}</template>
          </template>
          {{ data.address }}
        </div>
        <div class="q-pa-sm"></div>

        <!-- order details -->
        <OrderDetails :order_uuid="order_uuid" />
        <!-- end order details -->
      </q-card-section>
    </q-card>

    <q-card class="no-shadow no-border-radius">
      <q-card-section>
        <p class="no-margin">{{ $t("Payment") }}</p>
        <div class="row items-center">
          <div class="col">{{ paymentLabel }}</div>
          <div v-if="isCash" class="col text-right text-weight-bold">
            {{ data.amount_due_raw > 0 ? data.amount_due : data.total }}
          </div>
        </div>

        <q-space class="q-pa-lg"></q-space>
        <q-space class="q-pa-md"></q-space>
        <q-btn
          :label="$t('Drop-off')"
          @click="confirm_dialog = !confirm_dialog"
          color="primary"
          unelevated
          class="fit text-weight-bold"
          size="lg"
          no-caps
          :style="`background-color:${data.delivery_steps.status_data.bg_color} !important;color:${data.delivery_steps.status_data.font_color} !important;`"
        ></q-btn>
      </q-card-section>
    </q-card>
  </div>
  <!-- white -->

  <q-dialog v-model="confirm_dialog" position="bottom">
    <q-card>
      <q-card-section>
        <div class="text-center">
          <div class="font15 text-weight-bold">
            {{ $t("Do you confirm order#") }}{{ data.order_id }}
            {{ $t("Drop-off") }}?
          </div>
        </div>
      </q-card-section>
      <q-card-actions class="q-gutter-md">
        <q-btn
          color="primary"
          no-caps
          :label="$t('Confirm Drop-off')"
          unelevated
          class="fit text-weight-bold"
          size="lg"
          @click="confirm_dialog_drop = true"
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

  <q-dialog
    v-model="confirm_dialog_drop"
    :maximized="true"
    transition-show="slide-up"
    transition-hide="slide-down"
    @show="hideDialog"
  >
    <q-card>
      <q-bar class="transparent q-pa-sm" style="height: auto">
        <div class="col text-center">
          <div class="text-weight-bold">{{ $t("Confirm Drop-off") }}</div>
          <div class="font11">Order #{{ data.order_id }}</div>
        </div>
        <q-btn dense flat icon="close" v-close-popup>
          <q-tooltip class="bg-white text-primary">{{ $t("Close") }}</q-tooltip>
        </q-btn>
      </q-bar>
      <q-space
        class="q-pa-xs"
        :class="{
          '': $q.dark.mode,
          'bg-grey-1': !$q.dark.mode,
        }"
      ></q-space>
      <q-card-section>
        <template v-if="isCash">
          <div class="row items-center">
            <div class="col font16 text-weight-bold">
              {{ $t("Total Payment") }}
            </div>
            <div class="col text-right"></div>
          </div>
          <div class="text-h7">
            {{ data.amount_due_raw > 0 ? data.amount_due : data.total }}
          </div>
          <p>{{ $t("Collect cash from customer") }}</p>
        </template>

        <div
          class="q-pt-sm"
          :class="{ 'border-top': isCash, 'border-bottom': !isCash }"
        >
          <div
            class="row items-center"
            v-if="Activity.settings_data.add_proof_photo"
          >
            <div class="col">
              <div class="font16 text-weight-bold">
                {{ $t("Proof of Drop-off") }}
              </div>
              <p class="font14 line-normal">
                {{ $t("Add a photo as proof of Drop-off") }}
              </p>
            </div>
            <div class="col text-right">
              <div>
                <template v-if="has_photo">
                  <q-btn
                    flat
                    :label="$t('Delete')"
                    color="primary"
                    no-caps
                    class="q-pr-none font17"
                    @click="clearPhoto"
                  />
                </template>
                <template v-else>
                  <q-btn
                    :label="$t('Add photo')"
                    flat
                    color="primary"
                    no-caps
                    class="q-pl-none q-pr-none"
                    @click="takePhoto"
                  ></q-btn>
                </template>
              </div>

              <template v-if="hasPhoto">
                <q-img
                  :src="featured_url"
                  spinner-color="primary"
                  spinner-size="sm"
                  fit="cover"
                  style="height: 50px; max-width: 50px"
                  class="radius8"
                />
              </template>
              <template v-else-if="hasPhotoData">
                <q-img
                  :src="photo_data.path"
                  spinner-color="primary"
                  spinner-size="sm"
                  fit="cover"
                  style="height: 50px; max-width: 50px"
                  class="radius8"
                />
              </template>
            </div>
          </div>
        </div>
        <!-- border-top -->

        <template v-if="upload_enabled">
          <q-space class="q-pa-xs"></q-space>
          <UploaderFile
            ref="uploader_file"
            path="upload/order_proof"
            @after-uploadfile="afterUploadfile"
          ></UploaderFile>
        </template>

        <div v-if="Activity.settings_data.enabled_delivery_otp" class="q-mt-md">
          <div class="font16 text-weight-bold q-mb-xs">
            {{ $t("Enter order OTP code") }}
          </div>
          <q-input
            v-model="otp_code"
            type="number"
            :label="$t('OTP Code')"
            outlined
            color="grey-5"
            mask="#######"
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          >
          </q-input>
        </div>
        <!-- OPT  -->
      </q-card-section>
      <q-card-actions class="fixed-bottom">
        <q-btn
          :label="$t('Confirm Drop-off')"
          :loading="loading"
          :disabled="!hasAddedProof"
          @click="changeOrderStatus('orderdelivered')"
          color="primary"
          unelevated
          class="fit text-weight-bold"
          size="lg"
          no-caps
          :style="`background-color:${data.delivery_steps.status_data.bg_color} !important;color:${data.delivery_steps.status_data.font_color} !important;`"
        ></q-btn>
      </q-card-actions>
    </q-card>
  </q-dialog>

  <OrderHelp
    ref="order_help"
    list_type="orderhelplist"
    :title="$t('Report an issue')"
    @after-submit="afterSubmit"
  >
  </OrderHelp>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import AppCamera from "src/api/AppCamera";
import { defineAsyncComponent } from "vue";
import { useActivityStore } from "stores/ActivityStore";
import { useDriverappStore } from "stores/DriverappStore";

export default {
  name: "OrderDropoff",
  props: ["order_uuid", "merchants", "data", "order_meta", "payment_list"],
  components: {
    OrderDetails: defineAsyncComponent(() =>
      import("components/OrderDetails.vue")
    ),
    OrderHelp: defineAsyncComponent(() => import("components/OrderHelp.vue")),
    UploaderFile: defineAsyncComponent(() =>
      import("components/UploaderFile.vue")
    ),
  },
  setup() {
    const Activity = useActivityStore();
    const DriverappStore = useDriverappStore();
    return { Activity, DriverappStore };
  },
  data() {
    return {
      loading: false,
      confirm_dialog: false,
      confirm_dialog_drop: false,
      photo_data: [],
      upload_enabled: false,
      has_photo: false,
      upload_path: "",
      featured_filename: "",
      featured_url: "",
      otp_code: "",
    };
  },
  mounted() {},
  computed: {
    hasAddedProof() {
      if (this.Activity.settings_data.add_proof_photo) {
        if (this.has_photo) {
          return true;
        }
      } else {
        return true;
      }
      return false;
    },
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
    paymentLabel() {
      const payment_type = this.payment_list[this.data.payment_code]
        ? this.payment_list[this.data.payment_code]
        : 0;
      return payment_type == 1
        ? this.$t("Paid online")
        : this.$t("Collect Cash");
    },
    isCash() {
      const payment_type = this.payment_list[this.data.payment_code]
        ? this.payment_list[this.data.payment_code]
        : 0;
      return payment_type == 1 ? false : true;
    },
    hasPhoto() {
      if (!APIinterface.empty(this.featured_url)) {
        return true;
      }
      return false;
    },
    hasPhotoData() {
      if (Object.keys(this.photo_data).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    hideDialog() {
      this.confirm_dialog = false;
    },
    showHelp() {
      this.$refs.order_help.show();
    },
    changeOrderStatus(methods) {
      this.loading = true;
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByToken(methods, {
        order_uuid: this.order_uuid,
        featured_filename: this.featured_filename,
        upload_path: this.upload_path,
        file_data: this.hadData() ? this.photo_data.data : "",
        image_type: this.hadData() ? this.photo_data.format : "",
        otp_code: this.otp_code,
      })
        .then((result) => {
          this.confirm_dialog_drop = false;
          this.DriverappStore.getTotalTask();
          this.$emit("afterChangestatus", result.details);
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
          this.loading = false;
        });
    },
    takePhoto() {
      if (this.$q.capacitor) {
        AppCamera.isCameraEnabled()
          .then((data) => {
            AppCamera.isFileAccessEnabled()
              .then((data) => {
                AppCamera.getPhoto(1)
                  .then((data) => {
                    this.photo_data = data;
                    this.has_photo = true;
                  })
                  .catch((error) => {
                    this.photo_data = [];
                  });
                //
              })
              .catch((error) => {
                APIinterface.notify("dark", error, "error", this.$q);
              });
            //
          })
          .catch((error) => {
            APIinterface.notify("dark", error, "error", this.$q);
          });
      } else {
        this.upload_enabled = !this.upload_enabled;
      }
    },
    afterSubmit(data) {
      this.loading = true;
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByToken("deliveryfailed", {
        order_uuid: this.order_uuid,
        reason: data,
      })
        .then((result) => {
          this.DriverappStore.getTotalTask();
          this.$refs.order_help.hide();
          this.$emit("afterChangestatus", []);
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
          this.loading = false;
        });
    },
    afterUploadfile(data) {
      this.featured_filename = data.filename;
      this.featured_url = data.url_image;
      this.upload_path = data.upload_path;
      this.has_photo = true;
    },
    clearPhoto() {
      this.upload_enabled = false;
      this.has_photo = false;
      this.featured_filename = "";
      this.featured_url = "";
      this.upload_path = "";
      this.photo_data = [];
    },
    hadData() {
      if (Object.keys(this.photo_data).length > 0) {
        return true;
      }
      return false;
    },
    //
  },
};
</script>
