<template>
  <q-page class="bg-white text-dark">
    <q-form @submit="onSubmit">
      <div class="q-pa-md q-gutter-sm">
        <div class="row items-center justify-center q-mb-md">
          <div class="col-3 relative-position text-center">
            <q-avatar size="70px">
              <template v-if="hasData">
                <q-img
                  :src="photo_data.path"
                  spinner-color="primary"
                  spinner-size="sm"
                  fit="cover"
                >
                  <template v-slot:loading>
                    <q-skeleton
                      height="70px"
                      width="70px"
                      square
                      class="bg-grey-2"
                    />
                  </template>
                </q-img>
              </template>
              <template v-else>
                <q-img
                  :src="avatar"
                  spinner-color="primary"
                  spinner-size="sm"
                  fit="cover"
                >
                  <template v-slot:loading>
                    <q-skeleton
                      height="70px"
                      width="70px"
                      square
                      class="bg-grey-2"
                    />
                  </template>
                </q-img>
              </template>
            </q-avatar>
            <q-btn
              round
              color="blue-grey-1"
              text-color="blue-grey-8"
              unelevated
              class="absolute-bottom-right"
              @click="takePhoto"
              dense
            >
              <img src="/svg/f7--camera.svg" width="18" />
            </q-btn>
          </div>
        </div>

        <q-uploader
          :url="upload_api"
          ref="ref_uploader"
          :label="$t('Upload files')"
          :color="$q.dark.mode ? 'grey600' : 'primary'"
          :text-color="$q.dark.mode ? 'grey300' : 'white'"
          no-thumbnails
          class="full-width q-mb-md hidden"
          flat
          accept=".jpg, image/*"
          bordered
          :max-files="1"
          auto-upload
          max-total-size="1048576"
          :headers="[
            { name: 'Authorization', value: `token ${this.getToken()}` },
          ]"
          field-name="file"
          @rejected="onRejectedFiles"
          @uploaded="afterUploaded"
        />

        <q-input
          outlined
          v-model="first_name"
          :label="$t('First name')"
          stack-label
          lazy-rules
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />
        <q-input
          outlined
          v-model="last_name"
          :label="$t('Last name')"
          stack-label
          lazy-rules
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />

        <q-input
          outlined
          v-model="email_address"
          :label="$t('Email address')"
          stack-label
          lazy-rules
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />

        <q-input
          outlined
          v-model="contact_number"
          :label="$t('Contact number')"
          stack-label
          lazy-rules
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />
      </div>

      <q-footer class="bg-white q-pa-md text-dark myshadow">
        <q-btn
          type="submit"
          color="amber-6"
          text-color="disabled"
          unelevated
          class="full-width radius10"
          size="lg"
          no-caps
          :loading="loading"
        >
          <div class="text-weight-bold text-subtitle2">{{ $t("Update") }}</div>
        </q-btn>
      </q-footer>
    </q-form>
  </q-page>
</template>

<script>
import auth from "src/api/auth";
import APIinterface from "src/api/APIinterface";
import config from "src/api/config";
import AppCamera from "src/api/AppCamera";
import { useDataStore } from "stores/DataStore";

export default {
  name: "EditProfile",
  data() {
    return {
      first_name: "",
      last_name: "",
      email_address: "",
      contact_number: "",
      avatar: "",
      loading: false,
      upload_enabled: false,
      upload_api: config.api_base_url + "/interfacemerchant/updateAvatar",
      filename: "",
      upload_path: "",
      photo_data: "",
    };
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  mounted() {
    this.DataStore.page_title = this.$t("Edit Profile");

    const data = auth.getUser();
    if (!data) {
      auth.logout();
      this.$router.push("/login");
      return;
    }
    this.first_name = data.first_name;
    this.last_name = data.last_name;
    this.email_address = data.email_address;
    this.contact_number = data.contact_number;
    this.avatar = data.avatar;
  },
  computed: {
    hasData() {
      if (Object.keys(this.photo_data).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
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
                //APIinterface.notify("dark", error, "error", this.$q);
              });
            //
          })
          .catch((error) => {
            //APIinterface.notify("dark", error, "error", this.$q);
          });
      } else {
        this.$refs.ref_uploader.reset();
        setTimeout;
        setTimeout(() => {
          this.$refs.ref_uploader.pickFiles();
        }, 100);
      }
    },
    getToken() {
      return auth.getToken();
    },
    onRejectedFiles(data) {
      let error = "";
      if (
        data.some((entry) => entry.failedPropValidation === "max-total-size")
      ) {
        error = this.$t("File is too large. Maximum allowed size is 1 MB.");
      } else {
        error = this.$t("Invalid file. Please check size or type.");
      }
      APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
    },
    afterUploaded(files) {
      const response = JSON.parse(files.xhr.responseText);
      if (response.code === 1) {
        this.avatar = response.details.url_image;
        this.filename = response.details.filename;
        this.upload_path = response.details.upload_path;
      } else {
        this.avatar = "";
        this.filename = "";
        this.upload_path = "";
        APIinterface.ShowAlert(response.msg, this.$q.capacitor, this.$q);
      }
    },
    onSubmit() {
      this.loading = true;
      APIinterface.fetchDataByToken("UpdateProfile", {
        first_name: this.first_name,
        last_name: this.last_name,
        email_address: this.email_address,
        contact_number: this.contact_number,
        filename: this.filename,
        upload_path: this.upload_path,
        file_data: this.hadData() ? this.photo_data.data : "",
        image_type: this.hadData() ? this.photo_data.format : "",
      })
        .then((data) => {
          auth.setUser(data.details.user_data);
          APIinterface.ShowSuccessful(data.msg, this.$q);
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
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
