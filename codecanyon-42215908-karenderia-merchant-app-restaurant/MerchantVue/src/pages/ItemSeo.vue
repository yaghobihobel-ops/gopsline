<template>
  <q-pull-to-refresh @refresh="refresh">
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
          $t("Item SEO")
        }}</q-toolbar-title>
      </q-toolbar>
      <q-separator></q-separator>
    </q-header>
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
        'flex flex-center': !hasData && !loading_get,
      }"
    >
      <template v-if="loading_get">
        <q-inner-loading :showing="true" color="primary" size="md" />
      </template>

      <q-form v-else @submit="onSubmit">
        <template v-if="hasData">
          <div class="q-pa-md q-gutter-md">
            <q-input
              outlined
              v-model="meta_title"
              :label="$t('Meta Title')"
              stack-label
              color="grey-5"
              lazy-rules
            />
            <q-input
              outlined
              v-model="meta_description"
              :label="$t('Meta Description')"
              stack-label
              color="grey-5"
              lazy-rules
              autogrow
            />
            <q-input
              outlined
              v-model="meta_keywords"
              :label="$t('Keywords')"
              stack-label
              color="grey-5"
              lazy-rules
              autogrow
            />

            <div>
              <div>{{ $t("Image") }}</div>
              <div class="text-caption text-grey line-normal">
                {{ $t("Recommended size: 800 x 800 px (square, JPG/PNG)")
                }}<br />
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
                          hasFeaturedData
                            ? this.featured_data?.path
                            : this.featured_url
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
          </div>
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
            >
              <div class="text-weight-bold text-subtitle2">
                {{ $t("Submit") }}
              </div>
            </q-btn>
          </q-footer>
        </template>
        <template v-else>
          <div class="full-width text-center">
            <div class="text-weight-bold">{{ $t("Record not found") }}</div>
            <div>
              {{ $t("Oops sorry we cannot find what your looking for") }}
            </div>
          </div>
        </template>
      </q-form>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import AppCamera from "src/api/AppCamera";
import { defineAsyncComponent } from "vue";

export default {
  name: "ItemSeo",
  data() {
    return {
      upload_enabled: false,
      featured_filename: "",
      featured_url: "",
      upload_path: "",
      featured_data: "",
      loading: false,
      meta_title: "",
      meta_description: "",
      meta_keywords: "",
      loading_get: false,
      data: [],
    };
  },
  components: {
    UploaderFile: defineAsyncComponent(() =>
      import("components/UploaderFile.vue")
    ),
  },
  created() {
    this.item_uuid = this.$route.query.item_uuid;
    if (!APIinterface.empty(this.item_uuid)) {
      this.getItem();
    }
  },
  computed: {
    hasPhoto() {
      return APIinterface.empty(this.featured_filename) ? false : true;
    },
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
    hasFeaturedData() {
      if (!this.featured_data) {
        return false;
      }

      if (Object.keys(this.featured_data).length > 0) {
        return true;
      }
      return false;
    },
    hasFileUploaded() {
      if (this.featured_filename) {
        return true;
      }
      if (this.featured_data) {
        return true;
      }
      if (this.featured_data.length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    clearPhoto() {
      this.featured_url = "";
      this.featured_filename = "";
      this.upload_path = "";
      this.featured_data = "";
    },
    refresh(done) {
      if (!APIinterface.empty(this.item_uuid)) {
        this.getItem(done);
      } else {
        done();
      }
    },
    getItem(done) {
      this.loading_get = true;
      APIinterface.fetchDataByTokenPost(
        "getItemSeo",
        "item_uuid=" + this.item_uuid
      )
        .then((data) => {
          this.data = data.details;
          this.meta_title = data.details.meta_title;
          this.meta_description = data.details.meta_description;
          this.meta_keywords = data.details.meta_keywords;
          this.featured_filename = data.details.meta_image;
          this.featured_url = data.details.url_image;
          this.upload_path = data.details.meta_image_path;
        })
        .catch((error) => {
          //
        })
        .then((data) => {
          this.loading_get = false;
          if (!APIinterface.empty(done)) {
            done();
          }
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
                    this.featured_data = data;
                  })
                  .catch((error) => {
                    this.featured_data = [];
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
    onSubmit() {
      this.loading = true;
      APIinterface.fetchDataByToken("updateItemSeo", {
        item_uuid: this.item_uuid,
        featured_filename: this.featured_filename,
        upload_path: this.upload_path,
        file_data: this.hadFeaturedData() ? this.featured_data.data : "",
        image_type: this.hadFeaturedData() ? this.featured_data.format : "",
        meta_title: this.meta_title,
        meta_description: this.meta_description,
        meta_keywords: this.meta_keywords,
      })
        .then((data) => {
          APIinterface.ShowSuccessful(data.msg, this.$q);
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
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
    hadFeaturedData() {
      if (Object.keys(this.featured_data).length > 0) {
        return true;
      }
      return false;
    },
  },
};
</script>
