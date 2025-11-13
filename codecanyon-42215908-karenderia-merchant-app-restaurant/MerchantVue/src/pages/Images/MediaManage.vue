<template>
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
      <div>
        <div>{{ $t("Image") }}</div>
        <div class="text-caption text-grey line-normal">
          {{ $t("Recommended size: 800 x 800 px (square, JPG/PNG)") }}<br />
          {{ $t("Minimum size: 400 x 400 px") }}
        </div>
      </div>
      <div class="bg-grey-2 q-pa-sm cursor-pointer" @click="takePhoto">
        <div
          class="border-dashed-grey radius10 flex flex-center"
          style="height: calc(15vh)"
        >
          <div class="text-center">
            <template v-if="hasFileUploaded">
              <div class="relative-position">
                <q-btn
                  round
                  color="red-2"
                  text-color="red-9"
                  icon="las la-trash"
                  size="sm"
                  class="absolute-top-right z-tap box-shadow0"
                  style="top: -10px; right: -10px"
                  @click.stop="clearPhoto"
                />
                <q-img
                  :src="hasFeaturedData ? this.photo_data?.path : this.avatar"
                  fit="contain"
                  style="height: 70px; width: 100px"
                  class="radius8"
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
              </div>
            </template>
            <template v-else>
              <div><img src="/svg/upload.svg" height="25" /></div>
              <q-btn
                :label="$t('Upload your photo')"
                flat
                color="grey-6 text-weight-medium"
                padding="0"
                no-caps
              ></q-btn>
            </template>
          </div>
        </div>
      </div>

      <UploaderFile
        ref="uploader_file"
        @after-uploadfile="afterUploadfile"
      ></UploaderFile>

      <q-footer class="q-pa-md bg-white myshadow">
        <q-btn
          type="submit"
          color="amber-6"
          text-color="disabled"
          unelevated
          class="full-width radius8"
          size="lg"
          no-caps
          :disabled="!hasFileUploaded"
        >
          <div class="text-weight-bold text-subtitle2">{{ $t("Save") }}</div>
        </q-btn>
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
      loading1: false,
      upload_enabled: false,
      photo_data: "",
      photo: "",
      upload_path: "",
      avatar: "",
      title: "",
      size: "",
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    const DriverStore = useDriverStore();
    return { DataStore, DriverStore };
  },

  mounted() {
    this.DriverStore.VehicleAttributes();
    this.id = this.$route.query.id;

    this.DataStore.page_title = this.id
      ? this.$t("Update Media")
      : this.$t("Add Media");

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
    hasFeaturedData() {
      if (!this.photo_data) {
        return false;
      }

      if (Object.keys(this.photo_data).length > 0) {
        return true;
      }
      return false;
    },
    hasFileUploaded() {
      if (this.photo) {
        return true;
      }
      if (this.photo_data) {
        return true;
      }
      if (this.photo_data.length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    clearPhoto() {
      this.photo = "";
      this.avatar = "";
      this.photo_data = "";
      this.upload_path = "";
    },
    getData() {
      this.loading = true;

      APIinterface.fetchDataByTokenPost("getMedia", "id=" + this.id)
        .then((data) => {
          this.avatar = data.details.avatar;
          this.photo = data.details.photo;
          this.upload_path = data.details.upload_path;
          this.title = data.details.title;
          this.size = data.details.size;
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
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
        photo: this.photo,
        upload_path: this.upload_path,
        title: this.title,
        size: this.size,
        file_data: this.hadData() ? this.photo_data.data : "",
        image_type: this.hadData() ? this.photo_data.format : "",
      };
      this.loading1 = true;
      APIinterface.fetchDataByTokenPost(
        !APIinterface.empty(this.id) ? "UpdateMedia" : "AddMedia",
        params
      )
        .then((data) => {
          APIinterface.ShowSuccessful(data.msg, this.$q);
          this.DataStore.cleanData("media_list");
          this.$router.replace({
            path: "/images/media_library",
          });
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading1 = false;
        });
    },
    afterUploadfile(data) {
      this.photo = data.filename;
      this.avatar = data.url_image;
      this.upload_path = data.upload_path;
      this.title = data.title;
      this.size = data.size;
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
                APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
              });
            //
          })
          .catch((error) => {
            APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
          });
      } else {
        this.$refs.uploader_file.pickFile();
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
