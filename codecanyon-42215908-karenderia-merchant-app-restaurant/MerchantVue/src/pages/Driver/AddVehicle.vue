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
        {{ $t("Vehicle") }}
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
              {{ $t("Vehicle Thumbnail") }}.<br />
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
          <q-space class="q-pa-sm"></q-space>
          <UploaderFile
            ref="uploader_file"
            @after-uploadfile="afterUploadfile"
          ></UploaderFile>
        </template>

        <q-space class="q-pa-sm"></q-space>

        <q-select
          v-model="vehicle_type_id"
          :label="$t('Vehicle type')"
          :options="DriverStore.getVehicleAttributes.vehicle_type"
          stack-label
          behavior="dialog"
          outlined
          color="grey-5"
          emit-value
          map-options
          :rules="[
            (val) => (val && val > 0) || this.$t('This field is required'),
          ]"
        />

        <q-input
          v-model="plate_number"
          :label="$t('Plate number')"
          stack-label
          outlined
          color="grey-5"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />

        <div class="text-subtitle1">{{ $t("Maker") }}</div>

        <div class="q-gutter-y-md">
          <q-select
            v-model="maker"
            :label="$t('Car brand')"
            :options="DriverStore.getVehicleAttributes.vehicle_maker"
            stack-label
            behavior="dialog"
            outlined
            color="grey-5"
            emit-value
            map-options
          />
          <q-input
            v-model="model"
            :label="$t('Model')"
            stack-label
            outlined
            color="grey-5"
          />
          <q-input
            v-model="color"
            :label="$t('Color')"
            stack-label
            outlined
            color="grey-5"
          />
        </div>

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
import { useDriverStore } from "stores/DriverStore";

export default {
  name: "AddLicense",
  data() {
    return {
      loading: false,
      data: [],

      vehicle_type_id: "",
      plate_number: "",
      maker: "",
      model: "",
      color: "",

      upload_enabled: false,
      photo_data: "",
      photo: "",
      upload_path: "",
      avatar: "",

      upload_enabled2: false,
      photo_data2: "",
      photo2: "",
      upload_path2: "",
      avatar2: "",
    };
  },
  setup(props) {
    const DriverStore = useDriverStore();
    return { DriverStore };
  },
  components: {
    UploaderFile: defineAsyncComponent(() =>
      import("components/UploaderFile.vue")
    ),
  },
  created() {
    this.DriverStore.VehicleAttributes();
  },
  mounted() {
    this.id = this.$route.query.id;
    if (!APIinterface.empty(this.id)) {
      this.getVehicle();
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
  methods: {
    getVehicle() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getVehicle", "id=" + this.id)
        .then((data) => {
          this.data = data.details;

          this.vehicle_type_id = parseInt(this.data.vehicle_type_id);
          this.plate_number = this.data.plate_number;
          this.maker = parseInt(this.data.maker);
          this.model = this.data.model;
          this.color = this.data.color;

          if (!APIinterface.empty(data.details.photo_url)) {
            this.avatar = data.details.photo_url;
            this.photo = data.details.photo;
            this.upload_path = data.details.path;
          }

          // this.avatar2 = data.details.document_url;
          // this.photo2 = data.details.document;
          // this.upload_path2 = data.details.document_path;
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
        vehicle_type_id: this.vehicle_type_id,
        plate_number: this.plate_number,
        maker: this.maker,
        model: this.model,
        color: this.color,

        photo: this.photo,
        upload_path: this.upload_path,
        file_data: this.hadData() ? this.photo_data.data : "",
        image_type: this.hadData() ? this.photo_data.format : "",

        // upload_path2: this.upload_path2,
        // photo2: this.photo2,
        // file_data2: this.hadData2() ? this.photo_data2.data : "",
        // image_type2: this.hadData2() ? this.photo_data2.format : "",
      };
      APIinterface.fetchDataByTokenPost("AddVehicle", params)
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
