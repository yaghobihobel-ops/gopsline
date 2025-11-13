<template>
  <q-header
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
  >
    <q-toolbar>
      <q-btn
        @click="$router.back()"
        flat
        round
        dense
        icon="las la-angle-left"
        :color="$q.dark.mode ? 'white' : 'dark'"
      />
      <q-toolbar-title class="text-weight-bold">
        {{ $t("License") }}
        <template v-if="hasData">
          -
          {{ data.first_name }} {{ data.last_name }}
        </template>
      </q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
      'flex flex-center': !loading && !hasData,
    }"
    class="q-pa-md"
  >
    <template v-if="loading">
      <q-inner-loading :showing="true" color="primary" size="md" />
    </template>
    <q-form v-else @submit="formSubmit">
      <template v-if="hasData">
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
              {{ $t("License front photo") }}.<br />
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

        <q-space class="q-pa-sm"></q-space>
        <template v-if="upload_enabled">
          <UploaderFile
            ref="uploader_file"
            @after-uploadfile="afterUploadfile"
          ></UploaderFile>
        </template>

        <div class="q-mb-sm">
          <q-separator></q-separator>
        </div>
        <!-- SECOND PHOTO -->
        <div class="row q-gutter-sm">
          <template v-if="hasPhotodata2">
            <q-img
              :src="photo_data2.path"
              spinner-color="primary"
              spinner-size="sm"
              fit="cover"
              style="height: 70px"
              class="col-3 radius8"
            />
          </template>
          <template v-else-if="hasPhoto2">
            <q-img
              :src="this.avatar2"
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
              {{ $t("License back photo") }}.<br />
              {{ $t("Accepted types: PNG. JPG") }}
            </div>
            <q-btn
              :label="
                hasPhoto2
                  ? this.$t('Change Photo')
                  : hasData2
                  ? this.$t('Change Photo')
                  : this.$t('Add Photo')
              "
              flat
              color="primary"
              no-caps
              class="q-pl-none q-pr-none"
              @click="takePhoto2"
            ></q-btn>
          </div>
        </div>

        <q-space class="q-pa-sm"></q-space>
        <template v-if="upload_enabled2">
          <UploaderFile
            ref="uploader_file"
            @after-uploadfile="afterUploadfile2"
          ></UploaderFile>
        </template>
        <!-- SECOND PHOTO -->

        <q-space class="q-pa-sm"></q-space>

        <q-input
          v-model="license_number"
          :label="$t('License number')"
          stack-label
          outlined
          color="grey-5"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />

        <q-input
          v-model="license_expiration"
          :label="$t('License expiration')"
          :hint="$t('(YYYY/mm/dd)')"
          mask="####/##/##"
          stack-label
          outlined
          color="grey-5"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />

        <q-footer>
          <q-btn
            type="submit"
            color="primary"
            text-color="white"
            :label="$t('Save')"
            unelevated
            class="full-width radius8"
            size="lg"
            no-caps
          />
        </q-footer>
      </template>
      <template v-else>
        <div class="text-grey">{{ $t("No available data") }}</div>
      </template>
    </q-form>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import AppCamera from "src/api/AppCamera";
import APIinterface from "src/api/APIinterface";

export default {
  name: "AddLicense",
  data() {
    return {
      loading: false,
      data: [],
      license_number: "",
      license_expiration: "",
      //
      upload_enabled: false,
      photo_data: "",
      photo: "",
      upload_path: "",
      avatar: "",
      //

      upload_enabled2: false,
      photo_data2: "",
      photo2: "",
      upload_path2: "",
      avatar2: "",
    };
  },
  components: {
    UploaderFile: defineAsyncComponent(() =>
      import("components/UploaderFile.vue")
    ),
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
    hasPhotodata2() {
      if (Object.keys(this.photo_data2).length > 0) {
        return true;
      }
      return false;
    },
    hasPhoto2() {
      return APIinterface.empty(this.photo2) ? false : true;
    },
  },
  mounted() {
    this.id = this.$route.query.id;
    if (!APIinterface.empty(this.id)) {
      this.getLicense();
    }
  },
  methods: {
    getLicense() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getDriverInfo", "id=" + this.id)
        .then((data) => {
          this.data = data.details;
          this.license_number = this.data.license_number;
          this.license_expiration = this.data.license_expiration;

          this.avatar = data.details.license_front_photo_url;
          this.photo = data.details.license_front_photo;
          this.upload_path = data.details.path_license;

          this.avatar2 = data.details.license_back_photo_url;
          this.photo2 = data.details.license_back_photo;
          this.upload_path2 = data.details.path_license;
        })
        .catch((error) => {
          //
        })
        .then((data) => {
          this.loading = false;
        });
    },
    formSubmit() {
      APIinterface.showLoadingBox("", this.$q);
      let params = {
        id: this.id,
        license_number: this.license_number,
        license_expiration: this.license_expiration,
        photo: this.photo,
        upload_path: this.upload_path,
        file_data: this.hadData() ? this.photo_data.data : "",
        image_type: this.hadData() ? this.photo_data.format : "",

        upload_path2: this.upload_path2,
        photo2: this.photo2,
        file_data2: this.hadData2() ? this.photo_data2.data : "",
        image_type2: this.hadData2() ? this.photo_data2.format : "",
      };
      APIinterface.fetchDataByTokenPost("AddLicense", params)
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    afterUploadfile(data) {
      this.photo = data.filename;
      this.avatar = data.url_image;
      this.upload_path = data.upload_path;
    },
    afterUploadfile2(data) {
      this.photo2 = data.filename;
      this.avatar2 = data.url_image;
      this.upload_path2 = data.upload_path;
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
    takePhoto2() {
      if (this.$q.capacitor) {
        AppCamera.isCameraEnabled()
          .then((data) => {
            AppCamera.isFileAccessEnabled()
              .then((data) => {
                AppCamera.getPhoto(1)
                  .then((data) => {
                    this.photo_data2 = data;
                  })
                  .catch((error) => {
                    this.photo_data2 = [];
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
        this.upload_enabled2 = !this.upload_enabled2;
      }
    },
    hadData2() {
      if (Object.keys(this.photo_data2).length > 0) {
        return true;
      }
      return false;
    },
    //
  },
};
</script>
