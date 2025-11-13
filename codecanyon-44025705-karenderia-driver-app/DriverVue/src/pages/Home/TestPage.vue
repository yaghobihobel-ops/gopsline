<template>
  <q-page padding>
    <q-btn
      label="camera"
      color="primary"
      @click="testCamera"
      :loading="loading"
    ></q-btn>
    <pre>loading =>{{ loading }}</pre>
    <q-space class="q-pa-md"></q-space>
    <div>image url =>{{ imageUrl }}></div>
    <div>file_type =>{{ file_type }}</div>
    <div>image_string =>{{ image_string }}</div>

    <div class="bg-grey-1">
      image
      <q-img
        :src="imageUrl"
        spinner-color="white"
        style="height: 140px; max-width: 150px"
      />
    </div>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import AppCamera from "src/api/AppCamera";

export default {
  // name: 'PageName',
  data() {
    return {
      imageUrl: "",
      loading: false,
      image_string: "",
      file_type: "",
    };
  },
  methods: {
    testCamera() {
      AppCamera.isCameraEnabled()
        .then((data) => {
          AppCamera.isFileAccessEnabled()
            .then((data) => {
              AppCamera.getPhoto(1)
                .then((data) => {
                  this.image_string = data.data;
                  this.imageUrl = data.path;
                  this.file_type = data.format;
                })
                .catch((error) => {
                  APIinterface.notify("red-5", error, "check_circle", this.$q);
                });
              //
            })
            .catch((error) => {
              APIinterface.notify("red-5", error, "check_circle", this.$q);
            });
          //
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "check_circle", this.$q);
        });
    },
  },
};
</script>
