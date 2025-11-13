<template>
  <q-page
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-grey-1 text-dark': !$q.dark.mode,
    }"
    class="q-pl-md q-pr-md"
  >
    <div class="q-mt-md q-mb-md">
      <TabsRouterMenu :tab_menu="GlobalStore.merchantMenu"></TabsRouterMenu>
    </div>

    <template v-if="loading">
      <q-inner-loading :showing="true" color="primary" size="md" />
    </template>

    <q-card class="q-pa-none no-shadow" v-else>
      <q-card-section>
        <q-form @submit="onSubmit">
          <div class="q-gutter-md">
            <div class="row q-gutter-sm">
              <template v-if="hasFeaturedData">
                <q-img
                  :src="featured_data.path"
                  spinner-color="primary"
                  spinner-size="sm"
                  fit="cover"
                  style="height: 70px"
                  class="col-3 radius8"
                />
              </template>
              <template v-else-if="hasPhoto">
                <div class="col-3 relative-position">
                  <q-btn
                    round
                    :color="$q.dark.mode ? 'grey600' : 'mygrey'"
                    :text-color="$q.dark.mode ? 'grey300' : 'dark'"
                    icon="las la-trash"
                    unelevated
                    size="sm"
                    class="absolute-top-right z-tap"
                    style="top: -10px; right: -10px"
                    @click="clearLogo"
                  />
                  <q-img
                    :src="this.logo_url"
                    spinner-color="primary"
                    spinner-size="sm"
                    fit="cover"
                    style="height: 70px"
                    class="radius8"
                  />
                </div>
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
                  {{
                    $t(
                      "Items with quality photos are often more popular. Maximum 2 MB"
                    )
                  }}.
                  {{ $t("Accepted types: PNG. JPG") }}
                </div>
                <q-btn
                  :label="
                    hasPhoto
                      ? this.$t('Change Logo')
                      : hasFeaturedData
                      ? this.$t('Change Logo')
                      : this.$t('Add Logo')
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
              <div class="q-pl-sm">
                <UploaderFile
                  ref="uploader_file"
                  @after-uploadfile="afterUploadfile"
                ></UploaderFile>
              </div>
            </template>

            <q-toggle v-model="is_ready" :label="$t('Published Merchant')" />

            <q-input
              outlined
              v-model="restaurant_name"
              :label="$t('Restaurant name')"
              stack-label
              color="grey-5"
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
              stack-label
              color="grey-5"
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
              color="grey-5"
            />
            <q-input
              outlined
              v-model="contact_phone"
              :label="$t('Contact Phone')"
              stack-label
              color="grey-5"
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
              color="grey-5"
              lazy-rules
              :rules="[
                (val) =>
                  (val && val.length > 0) || this.$t('This field is required'),
              ]"
            />

            <q-input
              outlined
              v-model="description"
              :label="$t('About')"
              stack-label
              color="grey-5"
              lazy-rules
              type="textarea"
            />
            <q-input
              outlined
              v-model="short_description"
              :label="$t('Short About')"
              stack-label
              color="grey-5"
              lazy-rules
              type="textarea"
            />

            <q-select
              outlined
              v-model="cuisine"
              :label="$t('Cuisine')"
              color="grey-5"
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
              :label="$t('Services')"
              color="grey-5"
              :options="DataStore.services"
              multiple
              behavior="dialog"
              transition-show="fade"
              transition-hide="fade"
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
              v-model="tags"
              :label="$t('Tags')"
              color="grey-5"
              :options="DataStore.tags"
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
              v-model="featured"
              :label="$t('Featured')"
              color="grey-5"
              :options="DataStore.featured"
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
                color="grey-5"
                class="col q-mr-sm"
              />
              <q-select
                outlined
                v-model="distance_unit"
                :options="DataStore.unit"
                :label="$t('Distance Unit')"
                color="grey-5"
                stack-label
                class="col"
                map-options
                emit-value
              />
            </div>

            <!-- HEADER -->
            <div class="row q-gutter-sm">
              <template v-if="hasHeader">
                <q-img
                  :src="featured_data2.path"
                  spinner-color="primary"
                  spinner-size="sm"
                  fit="cover"
                  style="height: 70px"
                  class="col-3 radius8"
                />
              </template>
              <template v-else-if="hasPhoto2">
                <div class="col-3 relative-position">
                  <q-btn
                    round
                    :color="$q.dark.mode ? 'grey600' : 'mygrey'"
                    :text-color="$q.dark.mode ? 'grey300' : 'dark'"
                    icon="las la-trash"
                    unelevated
                    size="sm"
                    class="z-top absolute-top-right"
                    style="top: -10px; right: -10px"
                    @click="clearHeaderImage"
                  />
                  <q-img
                    :src="this.header_image_url"
                    spinner-color="primary"
                    spinner-size="sm"
                    fit="cover"
                    style="height: 70px"
                    class="radius8"
                  />
                </div>
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
                  {{
                    $t(
                      "Items with quality photos are often more popular. Maximum 2 MB"
                    )
                  }}.
                  {{ $t("Accepted types: PNG. JPG") }}
                </div>
                <q-btn
                  :label="
                    hasPhoto2
                      ? this.$t('Change Header')
                      : hasHeader
                      ? this.$t('Change Header')
                      : this.$t('Add Header')
                  "
                  flat
                  color="primary"
                  no-caps
                  class="q-pl-none q-pr-none"
                  @click="takePhoto2"
                ></q-btn>
              </div>
            </div>

            <template v-if="upload_header_enabled">
              <div class="q-pl-sm">
                <UploaderFile
                  ref="uploader_file2"
                  @after-uploadfile="afterUploadfile2"
                ></UploaderFile>
              </div>
            </template>

            <!-- HEADER -->
          </div>

          <q-space class="q-pa-sm"></q-space>

          <q-btn
            type="submit"
            color="primary"
            text-color="white"
            :label="$t('Save')"
            unelevated
            size="lg"
            no-caps
            :loading="loading2"
            class="fit"
          />
        </q-form>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import AppCamera from "src/api/AppCamera";
import { useGlobalStore } from "stores/GlobalStore";

export default {
  name: "MerchantInfo",
  components: {
    UploaderFile: defineAsyncComponent(() =>
      import("components/UploaderFile.vue")
    ),
    TabsRouterMenu: defineAsyncComponent(() =>
      import("components/TabsRouterMenu.vue")
    ),
  },
  data() {
    return {
      tab: "information",
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
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    const GlobalStore = useGlobalStore();
    return { DataStore, GlobalStore };
  },
  created() {
    this.getInformation();
  },
  computed: {
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
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    onSubmit() {
      APIinterface.showLoadingBox("", this.$q);
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
      })
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
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
                APIinterface.notify("dark", error, "error", this.$q);
              });
            //
          })
          .catch((error) => {
            APIinterface.notify("dark", error, "error", this.$q);
          });
      } else {
        this.upload_header_enabled = !this.upload_header_enabled;
      }
    },
    afterUploadfile(data) {
      this.logo = data.filename;
      this.logo_url = data.url_image;
      this.upload_path = data.upload_path;
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
