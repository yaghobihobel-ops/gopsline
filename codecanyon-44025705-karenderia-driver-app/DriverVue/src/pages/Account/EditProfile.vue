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
        $t("Edit profile")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
  >
    <q-form @submit="onSubmit">
      <div class="q-pa-md q-gutter-sm">
        <div class="row items-center justify-center q-mb-md">
          <div class="col-3 relative-position text-center">
            <q-avatar size="70px">
              <template v-if="hasPhoto">
                <q-img
                  :src="photo_data.path"
                  spinner-color="primary"
                  spinner-size="sm"
                  fit="cover"
                />
              </template>
              <template v-else-if="hasData">
                <q-img
                  :src="featured_url"
                  spinner-color="primary"
                  spinner-size="sm"
                  fit="cover"
                />
              </template>
            </q-avatar>
            <q-btn
              round
              color="primary"
              text-color="white"
              icon="las la-camera"
              unelevated
              size="sm"
              class="absolute-bottom-right"
              @click="takePhoto"
            />
          </div>
        </div>

        <template v-if="upload_enabled">
          <UploaderFile
            ref="uploader_file"
            path="upload/avatar"
            @after-uploadfile="afterUploadfile"
          ></UploaderFile>
        </template>

        <q-input
          outlined
          v-model="first_name"
          :label="$t('First name')"
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
          v-model="last_name"
          :label="$t('Last name')"
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
          v-model="email_address"
          :label="$t('Email address')"
          stack-label
          color="grey-5"
          lazy-rules
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />

        <q-input
          v-model="phone"
          mask="##############"
          outlined
          color="grey-5"
          lazy-rules
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
          borderless
          class="input-borderless"
        >
          <template v-slot:prepend>
            <q-select
              v-model="phone_prefix"
              :options="options"
              @filter="filterFn"
              behavior="dialog"
              input-debounce="700"
              style="border: none"
              emit-value
              borderless
              class="myq-field"
            >
              <template v-slot:option="{ itemProps, opt }">
                <q-item v-bind="itemProps">
                  <q-item-section avatar>
                    <q-img
                      :src="opt.flag"
                      style="height: 15px; max-width: 20px"
                    />
                  </q-item-section>
                  <q-item-section>
                    <q-item-label v-html="opt.label" />
                  </q-item-section>
                </q-item>
              </template>
              <template v-slot:no-option>
                <q-item>
                  <q-item-section class="text-grey">
                    {{ $t("No results") }}
                  </q-item-section>
                </q-item>
              </template>
            </q-select>
          </template>
        </q-input>
      </div>

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
          :label="$t('Update')"
          unelevated
          class="full-width"
          size="lg"
          no-caps
          :loading="loading"
        />
      </q-footer>
    </q-form>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useActivityStore } from "stores/ActivityStore";
import auth from "src/api/auth";
import AppCamera from "src/api/AppCamera";

export default {
  name: "EditProfile",
  components: {
    UploaderFile: defineAsyncComponent(() =>
      import("components/UploaderFile.vue")
    ),
  },
  data() {
    return {
      data: [],
      first_name: "",
      last_name: "",
      email_address: "",
      phone_prefix: "",
      phone: "",
      avatar: " ",
      options: [],
      loading: false,
      phone_settings: [],
      photo_data: [],
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
    this.getProfile();
  },
  computed: {
    hasData() {
      if (!APIinterface.empty(this.featured_url)) {
        return true;
      }
      return false;
    },
    hasPhoto() {
      if (Object.keys(this.photo_data).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    getProfile() {
      try {
        this.data = auth.getUser();
        this.first_name = this.data.first_name;
        this.last_name = this.data.last_name;
        this.email_address = this.data.email_address;
        this.phone_prefix = this.data.phone_prefix;
        this.phone = this.data.phone;
        this.featured_url = this.data.avatar;

        console.log(this.Activity.phone_settings);
        this.options = this.Activity.phone_settings.prefixes;
      } catch (error) {
        APIinterface.notify("dark", error, "error_outline", this.$q);
      }
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
                if (this.$q.platform.is.ios) {
                  this.upload_enabled = !this.upload_enabled;
                }
              });
            //
          })
          .catch((error) => {
            if (this.$q.platform.is.ios) {
              this.upload_enabled = !this.upload_enabled;
            }
          });
      } else {
        this.upload_enabled = !this.upload_enabled;
      }
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
    onSubmit() {
      APIinterface.showLoadingBox("", this.$q);
      this.loading = true;
      APIinterface.fetchDataByToken("updateprofile", {
        first_name: this.first_name,
        last_name: this.last_name,
        email_address: this.email_address,
        phone_prefix: this.phone_prefix,
        phone: this.phone,
        featured_filename: this.featured_filename,
        upload_path: this.upload_path,
        file_data: this.hadData() ? this.photo_data.data : "",
        image_type: this.hadData() ? this.photo_data.format : "",
        // file_data: this.hadData() ? this.photo_data.data : "",
        // image_type: this.hadData() ? this.photo_data.format : "",
      })
        .then((data) => {
          auth.setUser(data.details.user_data);
          APIinterface.notify("green-5", data.msg, "check_circle", this.$q);
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
          APIinterface.hideLoadingBox(this.$q);
        });
    },
  },
};
</script>
