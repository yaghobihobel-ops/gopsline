<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
    >
      <template v-if="loading">
        <div class="absolute-center text-center full-width">
          <div class="flex justify-center q-gutter-x-sm">
            <q-circular-progress
              indeterminate
              rounded
              size="sm"
              color="primary"
            />
            <div class="text-subtitle1 text-grey">{{ $t("Loading") }}...</div>
          </div>
        </div>
      </template>
      <q-form v-else @submit="onSubmit">
        <div class="q-pa-md q-gutter-md">
          <q-input
            outlined
            v-model="restaurant_name"
            :label="$t('Restaurant name')"
            stack-label
            hide-bottom-space
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />
          <q-input
            outlined
            v-model="restaurant_slug"
            :label="$t('Restaurant Slug')"
            hide-bottom-space
            stack-label
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />
          <q-input
            outlined
            v-model="contact_name"
            :label="$t('Contact Name')"
            stack-label
          />
          <q-input
            outlined
            v-model="contact_phone"
            :label="$t('Contact Phone')"
            stack-label
            hide-bottom-space
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />
          <q-input
            outlined
            v-model="contact_email"
            :label="$t('Contact email')"
            stack-label
            lazy-rules
            hide-bottom-space
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <div>
            <div>{{ $t("Restaurant Logo") }}</div>
            <div class="text-caption text-grey line-normal">
              {{
                $t(
                  "Recommended size: 512 x 512 px (square, PNG or SVG, transparent background preferred)"
                )
              }}<br />
              {{ $t("Minimum size: 150 x 150 px") }}
            </div>
          </div>
          <div class="bg-grey-2 q-pa-sm cursor-pointer" @click="takePhoto">
            <div
              class="border-dashed-grey radius10 flex flex-center"
              style="height: calc(15vh)"
            >
              <div class="text-center">
                <template v-if="hasPhoto">
                  <div class="relative-position">
                    <q-btn
                      round
                      color="red-2"
                      text-color="red-9"
                      icon="las la-trash"
                      size="sm"
                      class="absolute-top-right z-tap box-shadow0"
                      style="top: -10px; right: -10px"
                      @click.stop="clearLogo"
                    />
                    <q-img
                      :src="this.logo_url"
                      fit="cover"
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
                <template v-else-if="hasFeaturedData">
                  <q-img
                    :src="featured_data.path"
                    fit="cover"
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
                    </template> </q-img
                ></template>

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

          <!-- HEADER -->
          <div>
            <div>{{ $t("Restaurant Cover") }}</div>
            <div class="text-caption text-grey line-normal">
              {{
                $t("Recommended size: 1600 × 900 px (16:9 ratio, JPG or PNG)")
              }}
              <br />
              {{ $t("Minimum size: 1200 x 628 px") }}
            </div>
          </div>
          <div class="bg-grey-2 q-pa-sm cursor-pointer" @click="takePhoto2">
            <div
              class="border-dashed-grey radius10 flex flex-center"
              style="height: calc(15vh)"
            >
              <div class="text-center">
                <template v-if="hasPhoto2">
                  <div class="relative-position">
                    <q-btn
                      round
                      color="red-2"
                      text-color="red-9"
                      icon="las la-trash"
                      size="sm"
                      class="absolute-top-right z-tap box-shadow0"
                      style="top: -10px; right: -10px"
                      @click.stop="clearHeaderImage"
                    />
                    <q-img
                      :src="this.header_image_url"
                      fit="cover"
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
                <template v-else-if="hasHeader">
                  <q-img
                    :src="featured_data2.path"
                    fit="cover"
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
                    </template> </q-img
                ></template>

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
            ref="uploader_file2"
            @after-uploadfile="afterUploadfile2"
          ></UploaderFile>

          <!-- HEADER -->

          <q-input
            outlined
            v-model="description"
            :label="$t('About')"
            stack-label
            lazy-rules
            type="textarea"
          />
          <q-input
            outlined
            v-model="short_description"
            :label="$t('Short About')"
            stack-label
            lazy-rules
            type="textarea"
          />

          <q-select
            outlined
            v-model="cuisine"
            :label="$t('Cuisine')"
            :options="DataStore.cuisine"
            multiple
            behavior="dialog"
            transition-show="fade"
            transition-hide="fade"
            options-html
            map-options
            emit-value
          />

          <q-select
            outlined
            v-model="services"
            :label="$t('Online Services')"
            :options="DataStore.services"
            multiple
            behavior="menu"
            transition-show="fade"
            transition-hide="fade"
            hide-bottom-space
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
            options-html
            map-options
            emit-value
          />

          <q-select
            outlined
            v-model="pos_services"
            :label="$t('POS Services')"
            :options="DataStore.services"
            multiple
            behavior="menu"
            transition-show="fade"
            transition-hide="fade"
            hide-bottom-space
            options-html
            map-options
            emit-value
          />

          <q-select
            outlined
            v-model="tableside_services"
            :label="$t('Tableside Services')"
            :options="DataStore.services"
            multiple
            behavior="menu"
            transition-show="fade"
            transition-hide="fade"
            hide-bottom-space
            options-html
            map-options
            emit-value
          />

          <q-select
            outlined
            v-model="tags"
            :label="$t('Tags')"
            :options="DataStore.tags"
            multiple
            behavior="dialog"
            transition-show="fade"
            transition-hide="fade"
            options-html
            map-options
            emit-value
          />

          <div class="row items-center">
            <q-input
              type="number"
              outlined
              v-model="delivery_distance_covered"
              :label="$t('Delivery Distance Covered')"
              stack-label
              class="col q-mr-sm"
            />
            <q-select
              outlined
              v-model="distance_unit"
              :options="DataStore.unit"
              :label="$t('Distance Unit')"
              stack-label
              class="col"
              map-options
              emit-value
            />
          </div>

          <q-toggle v-model="is_ready" :label="$t('Published Merchant')" />
        </div>
        <!-- end pad -->

        <q-space class="q-pa-md"></q-space>

        <q-footer
          class="q-pa-md myshadow"
          :class="{
            'bg-mydark ': $q.dark.mode,
            'bg-white ': !$q.dark.mode,
          }"
        >
          <q-btn
            type="submit"
            unelevated
            no-caps
            color="amber-6"
            text-color="disabled"
            class="radius10 fit"
            size="lg"
            :loading="loading2"
          >
            <div class="text-weight-bold text-subtitle2">
              {{ $t("Submit") }}
            </div>
          </q-btn>
        </q-footer>
      </q-form>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import AppCamera from "src/api/AppCamera";

export default {
  name: "MerchantInformation",
  components: {
    UploaderFile: defineAsyncComponent(() =>
      import("components/UploaderFile.vue")
    ),
  },
  data() {
    return {
      loading: false,
      loading2: false,
      is_ready: false,
      upload_enabled: false,
      logo: "",
      logo_url: "",
      upload_path: "",
      featured_data: "",
      cuisine: [],
      services: [],
      featured: [],
      distance_unit: "",
      tags: [],
      restaurant_name: "",
      restaurant_slug: "",
      contact_name: "",
      contact_phone: "",
      contact_email: "",
      description: "",
      short_description: "",
      delivery_distance_covered: "",
      header_image: "",
      upload_header_enabled: false,
      path2: "",
      header_image_url: "",
      featured_data2: [],
      isScrolled: false,
      uploaded_logo: null,
      pos_services: [],
      tableside_services: [],
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    return { DataStore };
  },
  mounted() {
    this.DataStore.page_title = this.$t("Information");
    this.getInformation();
  },
  computed: {
    hasUploadedLogo() {
      return APIinterface.empty(this.uploaded_logo) ? false : true;
    },
    hasPhoto() {
      return APIinterface.empty(this.logo) ? false : true;
    },
    hasPhoto2() {
      return APIinterface.empty(this.header_image) ? false : true;
    },
    hasFeaturedData() {
      if (Object.keys(this.featured_data).length > 0) {
        return true;
      }
      return false;
    },
    hasHeader() {
      if (Object.keys(this.featured_data2).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    onScroll(info) {
      if (!info) {
        return;
      }
      this.isScrolled = info.position.top > 20;
    },
    clearLogo() {
      this.logo = "";
      this.logo_url = "";
      this.upload_path = "";
      this.upload_enabled = false;
    },
    clearHeaderImage() {
      this.header_image = "";
      this.path2 = "";
      this.header_image_url = "";
      this.upload_header_enabled = false;
    },
    refresh(done) {
      this.getInformation(done);
    },
    getInformation(done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getInformation")
        .then((data) => {
          this.is_ready = data.details.is_ready;
          this.restaurant_name = data.details.restaurant_name;
          this.restaurant_slug = data.details.restaurant_slug;
          this.contact_name = data.details.contact_name;
          this.contact_phone = data.details.contact_phone;
          this.contact_email = data.details.contact_email;
          this.description = data.details.description;
          this.short_description = data.details.short_description;
          this.delivery_distance_covered =
            data.details.delivery_distance_covered;
          this.distance_unit = data.details.distance_unit;
          this.cuisine = data.details.cuisine;
          this.services = data.details.services;
          this.tags = data.details.tags;
          this.featured = data.details.featured;

          this.logo = data.details.logo;
          this.logo_url = data.details.logo_url;
          this.upload_path = data.details.path;

          this.header_image = data.details.header_image;
          this.header_image_url = data.details.header_image_url;
          this.path2 = data.details.path2;

          this.pos_services = data.details.pos_services;
          this.tableside_services = data.details.tableside_services;
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    onSubmit() {
      this.loading2 = true;
      APIinterface.fetchDataByToken("updateInformation", {
        is_ready: this.is_ready == true ? 2 : 1,
        restaurant_name: this.restaurant_name,
        restaurant_slug: this.restaurant_slug,
        contact_name: this.contact_name,
        contact_email: this.contact_email,
        description: this.description,
        short_description: this.short_description,
        cuisine: this.cuisine,
        services: this.services,
        tags: this.tags,
        featured: this.featured,
        delivery_distance_covered: this.delivery_distance_covered,
        distance_unit: this.distance_unit,
        logo: this.logo,
        upload_path: this.upload_path,
        featured_data: this.hadFeaturedData() ? this.featured_data.data : "",
        image_type: this.hadFeaturedData() ? this.featured_data.format : "",

        header_image_data: this.hadHeader() ? this.featured_data2.data : "",
        header_image_type: this.hadHeader() ? this.featured_data2.format : "",

        header_image: this.header_image,
        path2: this.path2,
        pos_services: this.pos_services,
        tableside_services: this.tableside_services,
      })
        .then((data) => {
          this.DataStore.cleanData("menu_data");
          APIinterface.ShowSuccessful(data.msg, this.$q);
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading2 = false;
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
    takePhoto2() {
      if (this.$q.capacitor) {
        AppCamera.isCameraEnabled()
          .then((data) => {
            AppCamera.isFileAccessEnabled()
              .then((data) => {
                AppCamera.getPhoto(1)
                  .then((data) => {
                    this.featured_data2 = data;
                  })
                  .catch((error) => {
                    this.featured_data2 = [];
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
        this.$refs.uploader_file2.pickFile();
      }
    },
    afterUploadfile(data) {
      this.logo = data.filename;
      this.logo_url = data.url_image;
      this.upload_path = data.upload_path;

      this.uploaded_logo = data.url_image;
    },
    afterUploadfile2(data) {
      this.header_image = data.filename;
      this.header_image_url = data.url_image;
      this.path2 = data.upload_path;
    },
    afterInput(data) {
      this.translation_data = data;
    },
    hadFeaturedData() {
      if (Object.keys(this.featured_data).length > 0) {
        return true;
      }
      return false;
    },
    hadHeader() {
      if (Object.keys(this.featured_data2).length > 0) {
        return true;
      }
      return false;
    },
  },
};
</script>
