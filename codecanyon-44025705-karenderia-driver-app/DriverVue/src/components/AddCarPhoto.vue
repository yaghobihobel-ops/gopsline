<template>
  <q-dialog
    v-model="dialog"
    :maximized="true"
    transition-show="slide-up"
    transition-hide="slide-down"
  >
    <q-card>
      <q-bar class="transparent q-pa-sm" style="height: auto">
        <div class="col text-center">
          <div class="text-weight-bold">{{ $t("Take photo") }}</div>
        </div>
        <q-btn dense flat icon="close" v-close-popup>
          <q-tooltip class="bg-white text-primary">{{ $t("Close") }}</q-tooltip>
        </q-btn>
      </q-bar>
      <q-space class="q-pa-xs bg-grey-1"></q-space>
      <q-card-section>
        <div class="border-bottom q-pt-sm q-pb-sm">
          <div class="row items-center">
            <div class="col">
              <div class="font16 text-weight-bold">
                {{ $t("Proof of Car") }}
              </div>
              <p class="font14 line-normal">
                {{ $t("Add a photo as proof of your vehicle") }}
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

              <template v-if="has_photo">
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
            <!-- col -->
          </div>
          <!-- row -->
        </div>
        <!-- card-bordered -->

        <template v-if="upload_enabled">
          <q-space class="q-pa-xs"></q-space>
          <UploaderFile
            ref="uploader_file"
            path="upload/order_proof"
            @after-uploadfile="afterUploadfile"
          ></UploaderFile>
        </template>
      </q-card-section>
      <q-card-actions class="fixed-bottom">
        <q-btn
          :loading="loading"
          @click="attachCarPhoto"
          :disabled="!hasData"
          :label="$t('Confirm Photo')"
          color="primary"
          unelevated
          class="fit font17 text-weight-bold"
          no-caps
        ></q-btn>
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import AppCamera from "src/api/AppCamera";

export default {
  name: "AddCarPhoto",
  props: ["schedule_uuid"],
  components: {
    UploaderFile: defineAsyncComponent(() =>
      import("components/UploaderFile.vue")
    ),
  },
  data() {
    return {
      loading: false,
      dialog: false,
      data: [],
      photo_data: [],
      upload_enabled: false,
      has_photo: false,
      upload_path: "",
      featured_filename: "",
      featured_url: "",
    };
  },
  mounted() {
    this.data = [];
    if (this.$q.platform.is.desktop) {
      this.data = {
        data: "dev",
      };
    }
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      if (this.$q.platform.is.desktop) {
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
      this.dialog = false;
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
    attachCarPhoto() {
      APIinterface.showLoadingBox("", this.$q);
      this.loading = true;
      APIinterface.fetchDataByToken("attachCarPhoto", {
        schedule_uuid: this.schedule_uuid,
        featured_filename: this.featured_filename,
        upload_path: this.upload_path,
        file_data: this.hadData() ? this.photo_data.data : "",
        image_type: this.hadData() ? this.photo_data.format : "",
      })
        .then((data) => {
          this.dialog = false;
          this.$emit("afterAttachphoto", this.schedule_uuid);
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
  },
};
</script>
