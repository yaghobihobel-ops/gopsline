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
      <q-toolbar-title class="text-weight-bold">{{
        $t("Vehicle")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page class="q-pa-md" :class="{ 'flex flex-center': loading }">
    <template v-if="loading">
      <div class="fit text-center">
        <q-spinner color="primary" size="2em" />
      </div>
    </template>

    <template v-else>
      <q-form @submit="onSubmit">
        <div class="row q-col-gutter-sm q-mb-sm">
          <template v-if="has_photo">
            <q-img
              :src="featured_url"
              spinner-color="primary"
              spinner-size="sm"
              fit="cover"
              style="height: 70px"
              class="col-3 radius8"
            />
          </template>
          <template v-else-if="hasPhotoData">
            <q-img
              :src="photo_data.path"
              spinner-color="primary"
              spinner-size="sm"
              fit="cover"
              style="height: 70px"
              class="col-3 radius8"
            />
          </template>
          <div
            v-else
            class="col-3 row items-center justify-center radius8"
            :class="{
              'bg-grey600': $q.dark.mode,
              'bg-mygrey': !$q.dark.mode,
            }"
            style="height: 70px"
          >
            <q-icon name="las la-image" class="text-grey" size="xl" />
          </div>
          <div class="col">
            <div class="font12 line-normal">
              <span class="text-weight-bold">{{ $t("Vehicle Photo") }}</span
              >. {{ $t("Maximum 2MB. Accepted types: PNG. JPG") }}
            </div>
            <q-btn
              :label="
                has_photo
                  ? this.$t('Change Photo')
                  : hasPhotoData
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
        <!-- row -->

        <template v-if="upload_enabled">
          <UploaderFile
            ref="uploader_file"
            path="upload/vehicle"
            @after-uploadfile="afterUploadfile"
          ></UploaderFile>
        </template>

        <q-select
          v-model="vehicle_type_id"
          :options="Activity.vehicle_type"
          :label="$t('Vehicle type')"
          outlined
          color="grey-5"
          :rules="[(val) => val || this.$t('This field is required')]"
          behavior="dialog"
          emit-value
          map-options
          transition-show="fade"
          transition-hide="fade"
        />

        <q-input
          v-model="plate_number"
          :label="$t('Plate number')"
          outlined
          color="grey-5"
          lazy-rules
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        >
        </q-input>

        <q-select
          v-model="maker"
          :label="$t('Maker')"
          :options="Activity.vehicle_maker"
          outlined
          color="grey-5"
          :rules="[(val) => val || this.$t('This field is required')]"
          behavior="dialog"
          emit-value
          map-options
        />

        <q-input
          v-model="model"
          :label="$t('Model')"
          outlined
          color="grey-5"
          lazy-rules
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        >
        </q-input>

        <q-input
          v-model="color"
          :label="$t('Color')"
          outlined
          color="grey-5"
          lazy-rules
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        >
        </q-input>

        <q-footer
          class="q-pa-md"
          :class="{
            'bg-mydark ': $q.dark.mode,
            'bg-white ': !$q.dark.mode,
          }"
        >
          <q-btn
            type="submit"
            color="primary"
            text-color="white"
            :label="$t('Submit')"
            unelevated
            class="full-width"
            size="lg"
            no-caps
            :loading="loading"
          />
        </q-footer>
      </q-form>
    </template>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useActivityStore } from "stores/ActivityStore";
import { defineAsyncComponent } from "vue";
import AppCamera from "src/api/AppCamera";

export default {
  name: "VehiclePage",
  components: {
    UploaderFile: defineAsyncComponent(() =>
      import("components/UploaderFile.vue")
    ),
  },
  data() {
    return {
      loading: true,
      vehicle_uuid: "",
      vehicle_type_id: "",
      plate_number: "",
      maker: "",
      model: "",
      color: "",
      photo_data: "",
      upload_enabled: false,
      featured_filename: "",
      featured_url: "",
      upload_path: "",
      has_photo: false,
    };
  },
  setup() {
    const Activity = useActivityStore();
    return { Activity };
  },
  created() {
    this.getVehicle();
  },
  computed: {
    hasPhoto() {
      return false;
    },
    hasData() {
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
    getVehicle() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getVehicleInfo")
        .then((data) => {
          this.vehicle_uuid = data.details.vehicle_uuid;
          this.vehicle_type_id = data.details.vehicle_type_id;
          this.vehicle_type_selected = data.details.vehicle_type_selected;
          this.plate_number = data.details.plate_number;
          this.maker = data.details.maker;
          this.model = data.details.model;
          this.color = data.details.color;

          this.has_photo = data.details.has_photo;
          this.featured_filename = data.details.photo;
          this.upload_path = data.details.path;
          this.featured_url = data.details.url_photo;
        })
        .catch((error) => {
          this.vehicle_uuid = "";
          this.vehicle_type_id = "";
          this.plate_number = "";
          this.maker = "";
          this.model = "";
          this.color = "";
        })
        .then((data) => {
          this.loading = false;
        });
    },
    onSubmit() {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByToken("saveVehicleInfo", {
        vehicle_uuid: this.vehicle_uuid,
        vehicle_type_id: this.vehicle_type_id,
        plate_number: this.plate_number,
        maker: this.maker,
        model: this.model,
        color: this.color,
        featured_filename: this.featured_filename,
        upload_path: this.upload_path,
        file_data: this.hadData() ? this.photo_data.data : "",
        image_type: this.hadData() ? this.photo_data.format : "",
      })
        .then((data) => {
          APIinterface.notify("green-5", data.msg, "check_circle", this.$q);
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    hadData() {
      if (Object.keys(this.photo_data).length > 0) {
        return true;
      }
      return false;
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
    afterUploadfile(data) {
      this.featured_filename = data.filename;
      this.featured_url = data.url_image;
      this.upload_path = data.upload_path;
      this.has_photo = true;
    },
    //
  },
};
</script>
