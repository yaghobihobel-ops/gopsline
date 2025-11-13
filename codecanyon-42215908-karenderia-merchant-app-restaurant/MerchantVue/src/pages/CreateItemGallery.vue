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
        $t("Item Gallery")
      }}</q-toolbar-title>
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
    <template v-if="loading_get">
      <q-inner-loading :showing="true" color="primary" size="md" />
    </template>

    <q-form v-else @submit="onSubmit">
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
                  :src="
                    hasFeaturedData ? this.photo_data?.path : this.featured_url
                  "
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
          :loading="loading"
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
import AppCamera from "src/api/AppCamera";
import { defineAsyncComponent } from "vue";

export default {
  name: "CreateItemGallery",
  data() {
    return {
      loading: false,
      loading_get: false,
      upload_enabled: false,
      featured_filename: "",
      featured_url: "",
      upload_path: "",
      photo_data: "",
    };
  },
  components: {
    UploaderFile: defineAsyncComponent(() =>
      import("components/UploaderFile.vue")
    ),
  },
  created() {
    this.item_uuid = this.$route.query.item_uuid;
  },
  computed: {
    hasPhoto() {
      return APIinterface.empty(this.featured_filename) ? false : true;
    },
    hasData() {
      if (Object.keys(this.photo_data).length > 0) {
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
      if (this.featured_filename) {
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
      this.featured_filename = "";
      this.featured_url = "";
      this.upload_path = "";
      this.photo_data = "";
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
        this.$refs.uploader_file.pickFile();
      }
    },
    onSubmit() {
      this.loading = true;
      APIinterface.fetchDataByToken("createGallery", {
        item_uuid: this.item_uuid,
        featured_filename: this.featured_filename,
        upload_path: this.upload_path,
        file_data: this.hadData() ? this.photo_data.data : "",
        image_type: this.hadData() ? this.photo_data.format : "",
      })
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
          this.$router.replace({
            path: "/item/gallery",
            query: { item_uuid: this.item_uuid },
          });
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    afterUploadfile(data) {
      this.featured_filename = data.filename;
      this.featured_url = data.url_image;
      this.upload_path = data.upload_path;
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
