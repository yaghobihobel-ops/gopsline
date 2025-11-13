<template>
  <q-uploader
    ref="ref_uploader"
    :url="upload_api"
    :label="$t('Upload files')"
    :color="$q.dark.mode ? 'grey600' : 'mygrey'"
    :text-color="$q.dark.mode ? 'grey300' : 'grey'"
    no-thumbnails
    class="full-width q-mb-md hidden"
    flat
    accept=".jpg, image/*"
    bordered
    :max-files="1"
    auto-upload
    max-total-size="1048576"
    @rejected="onRejectedFiles"
    :headers="[{ name: 'Authorization', value: `token ${this.getToken()}` }]"
    field-name="file"
    @uploaded="afterUploaded"
    :form-fields="[{ name: 'upload_path', value: 'item' }]"
    @start="StartUploading"
    @finish="FinishUploading"
  />
</template>

<script>
import APIinterface from "src/api/APIinterface";
import auth from "src/api/auth";
import config from "src/api/config";

export default {
  name: "UploaderFile",
  data() {
    return {
      upload_api: config.api_base_url + "/interfacemerchant/updateAvatar",
      url_image: "",
      filename: "",
      upload_path: "",
      title: "",
      size: "",
    };
  },
  methods: {
    StartUploading() {
      this.$emit("StartUploading");
    },
    FinishUploading() {
      this.$emit("FinishUploading");
    },
    pickFile() {
      this.$refs.ref_uploader.reset();
      setTimeout;
      setTimeout(() => {
        this.$refs.ref_uploader.pickFiles();
      }, 100);
    },
    getToken() {
      return auth.getToken();
    },
    afterUploaded(files) {
      const response = JSON.parse(files.xhr.responseText);
      if (response.code === 1) {
        this.url_image = response.details.url_image;
        this.filename = response.details.filename;
        this.upload_path = response.details.upload_path;
        this.title = response.details.title;
        this.size = response.details.size;

        this.$emit("afterUploadfile", {
          url_image: this.url_image,
          filename: this.filename,
          upload_path: this.upload_path,
          title: this.title,
          size: this.size,
        });
      } else {
        this.url_image = "";
        this.filename = "";
        this.upload_path = "";
        APIinterface.notify("dark", response.msg, "error", this.$q);
      }
    },
  },
};
</script>
