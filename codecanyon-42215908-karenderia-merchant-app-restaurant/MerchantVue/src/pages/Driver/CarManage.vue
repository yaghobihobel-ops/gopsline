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
        <template v-if="isEdit">
          {{ $t("Update Car") }}
        </template>
        <template v-else>
          {{ $t("Add Car") }}
        </template>
      </q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
    class="q-pa-md"
  >
    <template v-if="loading">
      <q-inner-loading :showing="true" color="primary" size="md" />
    </template>
    <q-form v-else @submit="formSubmit">
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
            {{ $t("Vehicle Thumbnail. Maximum 2 MB") }}.
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
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      />

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

        <q-toggle v-model="active" color="primary" :label="$t('Active')" />
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
    </q-form>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import { defineAsyncComponent } from "vue";
import AppCamera from "src/api/AppCamera";
import { useDriverStore } from "stores/DriverStore";

export default {
  name: "CarManage",
  components: {
    UploaderFile: defineAsyncComponent(() =>
      import("components/UploaderFile.vue")
    ),
  },
  data() {
    return {
      id: "",
      data: [],
      loading: false,
      vehicle_type_id: "",
      plate_number: "",
      maker: "",
      model: "",
      color: "",
      active: true,
      upload_enabled: false,
      photo_data: "",
      photo: "",
      upload_path: "",
      avatar: "",
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    const DriverStore = useDriverStore();
    return { DataStore, DriverStore };
  },
  created() {
    this.DriverStore.VehicleAttributes();
  },
  mounted() {
    this.id = this.$route.query.id;
    if (!APIinterface.empty(this.id)) {
      this.getData();
    }
  },
  computed: {
    isEdit() {
      if (!APIinterface.empty(this.id)) {
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
    getData() {
      this.loading = true;

      APIinterface.fetchDataByTokenPost("getCarInfo", "id=" + this.id)
        .then((data) => {
          this.avatar = data.details.avatar;
          this.photo = data.details.photo;
          this.upload_path = data.details.path;
          this.vehicle_type_id = data.details.vehicle_type_id;
          this.plate_number = data.details.plate_number;
          this.maker = data.details.maker;
          this.model = data.details.model;
          this.color = data.details.color;
          this.active = data.details.active;
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    afterInput(data) {
      this.phone = data;
    },
    formSubmit() {
      let params = {
        id: this.id,
        vehicle_type_id: this.vehicle_type_id,
        plate_number: this.plate_number,
        maker: this.maker,
        model: this.model,
        color: this.color,
        active: this.active,
        photo: this.photo,
        upload_path: this.upload_path,
        file_data: this.hadData() ? this.photo_data.data : "",
        image_type: this.hadData() ? this.photo_data.format : "",
      };
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        !APIinterface.empty(this.id) ? "UpdateCar" : "AddCar",
        params
      )
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
          this.$router.replace({
            path: "/delivery-management/car",
          });
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
    //
  },
};
</script>
