<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page class="q-pa-md">
      <template v-if="loading">
        <q-inner-loading :showing="true" color="primary" size="md" />
      </template>
      <template v-else>
        <div class="text-subtitle1 q-mb-sm">
          {{ $t("Upload Proof of Payment") }}
        </div>
        <div class="text-caption">
          {{
            $t("Please enter the details of your bank deposit payment below")
          }}
        </div>
        <div class="text-caption">
          {{
            $t(
              "Failure to provide accurate information may cause delays in processing or invalidation of your payment"
            )
          }}.
        </div>

        <div class="q-pt-sm q-pb-sm">
          <div class="text-subtitle2">
            {{ $t("Invoice No#") }}: {{ data.invoice_number }}
          </div>
          <div class="text-subtitle2">{{ $t("Amount") }}: {{ data.total }}</div>
        </div>

        <q-form @submit="formSubmit">
          <div class="row q-gutter-sm">
            <template v-if="hasPhotodata">
              <q-img
                :src="photo_data.path"
                spinner-color="primary"
                spinner-size="sm"
                fit="cover"
                style="height: 70px"
                class="col-3 radius8"
              />
            </template>
            <template v-else-if="hasPhoto">
              <q-img
                :src="this.avatar"
                spinner-color="primary"
                fit="cover"
                style="height: 70px"
                class="col-3 radius8"
              />
            </template>
            <div
              v-else
              class="col-3 row items-center justify-center radius8"
              :class="{
                'bg-grey600 ': $q.dark.mode,
                'bg-mygrey ': !$q.dark.mode,
              }"
              style="height: 70px"
            >
              <q-icon name="las la-image" class="text-grey" size="xl" />
            </div>
            <div class="col">
              <div class="font12 line-normal">
                {{ $t("Proof of payment") }}.<br />
                {{ $t("Maximum 2 MB") }}<br />
                {{ $t("Accepted types: PNG. JPG") }}
              </div>
              <q-btn
                :label="
                  hasPhoto
                    ? this.$t('Change Photo')
                    : hasData
                    ? this.$t('Change Photo')
                    : this.$t('Add Photo')
                "
                flat
                color="primary"
                no-caps
                class="q-pl-none q-pr-none"
                @click="takePhoto"
              ></q-btn>
            </div>
          </div>

          <template v-if="upload_enabled">
            <UploaderFile
              ref="uploader_file"
              @after-uploadfile="afterUploadfile"
            ></UploaderFile>
          </template>
          <q-space class="q-pa-sm"></q-space>

          <q-input
            v-model="account_name"
            :label="$t('Account name')"
            stack-label
            outlined
            color="grey-5"
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />
          <q-input
            v-model="amount"
            type="number"
            step="any"
            :label="$t('Amount')"
            stack-label
            outlined
            color="grey-5"
            :rules="[
              (val) => (val && val > 0) || this.$t('This field is required'),
            ]"
          />
          <q-input
            v-model="reference_number"
            :label="$t('Reference Number')"
            stack-label
            outlined
            color="grey-5"
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <q-footer class="q-pa-md bg-white myshadow">
            <q-btn
              type="submit"
              color="amber-6"
              text-color="disabled"
              unelevated
              class="full-width radius8"
              size="lg"
              no-caps
            >
              <div class="text-weight-bold text-subtitle2">
                {{ $t("Submit") }}
              </div>
            </q-btn>
          </q-footer>
        </q-form>
      </template>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import AppCamera from "src/api/AppCamera";
import { useDataStore } from "stores/DataStore";

export default {
  name: "InvoiceActivity",
  components: {
    UploaderFile: defineAsyncComponent(() =>
      import("components/UploaderFile.vue")
    ),
  },
  data() {
    return {
      id: null,
      loading: false,
      data: [],
      account_name: "",
      amount: 0,
      reference_number: "",
      is_refresh: undefined,
      upload_enabled: false,
      photo_data: "",
      photo: "",
      upload_path: "",
      avatar: "",
    };
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  mounted() {
    this.DataStore.page_title = this.$t("Upload deposit");
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
    hasPhotodata() {
      if (Object.keys(this.photo_data).length > 0) {
        return true;
      }
      return false;
    },
    hasPhoto() {
      return APIinterface.empty(this.photo) ? false : true;
    },
  },
  methods: {
    formSubmit() {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost("invoiceProofpayment", {
        id: this.id,
        account_name: this.account_name,
        amount: this.amount,
        reference_number: this.reference_number,
        photo: this.photo,
        upload_path: this.upload_path,
        file_data: this.hadData() ? this.photo_data.data : "",
        image_type: this.hadData() ? this.photo_data.format : "",
      })
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
          this.$router.replace({
            path: "/invoice/list",
          });
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    refresh(done) {
      this.is_refresh = done;
      this.getData();
    },
    getData() {
      if (APIinterface.empty(this.is_refresh)) {
        this.loading = true;
      }
      APIinterface.fetchDataByTokenPost("getInvoice", "id=" + this.id)
        .then((data) => {
          this.data = data.details;
          this.account_name = data.details.account_name;
          this.amount = data.details.amount;
          this.reference_number = data.details.reference_number;

          this.photo = data.details.photo;
          this.upload_path = data.details.upload_path;
          this.avatar = data.details.avatar;
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
    afterUploadfile(data) {
      this.photo = data.filename;
      this.avatar = data.url_image;
      this.upload_path = data.upload_path;
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
    hadData() {
      if (Object.keys(this.photo_data).length > 0) {
        return true;
      }
      return false;
    },
  },
};
</script>
