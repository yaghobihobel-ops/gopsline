<template>
  <q-dialog
    v-model="dialog"
    :maximized="true"
    transition-show="slide-up"
    transition-hide="slide-down"
    @before-show="beforeShow"
    @before-hide="beforeHide"
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
      <template v-if="enabled_camera == true">
        <q-card-section>
          <div id="cameraPreview" class="cameraPreview"></div>
        </q-card-section>
        <q-card-actions class="fixed-bottom q-pb-lg border-top">
          <div class="text-center full-width q-pa-sm">
            <div class="text-h7 font15">{{ steps_data[steps] }}</div>
          </div>
          <div class="row q-gutter-md items-center content-center full-width">
            <div class="col text-center">
              <q-btn
                @click="TurnOffCamera"
                round
                color="red"
                unelevated
                icon="las la-times"
                size="md"
              />
            </div>
            <div class="col text-center">
              <q-btn
                @click="TakePhoto"
                round
                color="primary"
                unelevated
                icon="las la-camera"
                size="md"
              />
            </div>
            <div class="col text-center">
              <q-btn
                @click="FlipCamera"
                round
                color="blue"
                unelevated
                icon="flip_camera_ios"
                size="md"
              />
            </div>
          </div>
        </q-card-actions>
      </template>

      <template v-else>
        <q-card-section>
          <div class="border-bottom q-pt-sm q-pb-sm">
            <div class="row items-start">
              <div class="col">
                <div class="font16 text-weight-bold q-mt-sm">
                  {{ $t("Proof of Car") }}
                </div>
                <p class="font14 line-normal">
                  {{ $t("Add a photo as proof of your assigned vehicle") }}
                </p>
              </div>
              <div class="col text-right">
                <div>
                  <template v-if="hasData">
                    <q-btn
                      @click="resetData"
                      flat
                      :label="$t('Delete All')"
                      color="primary"
                      no-caps
                      class="q-pr-none font17"
                    />
                  </template>
                  <template v-else>
                    <q-btn
                      @click="enabled_camera = true"
                      flat
                      :label="$t('Add photo')"
                      color="primary"
                      no-caps
                      class="q-pr-none font17"
                    />
                  </template>
                </div>
              </div>
            </div>
          </div>
          <!-- card-bordered -->

          <q-list separator>
            <q-item v-for="(items, index) in data" :key="items">
              <q-item-section>
                <q-item-label
                  v-if="steps_data[index + 1]"
                  class="font16 text-weight-bold"
                >
                  {{ steps_data[index + 1] }}
                </q-item-label>
              </q-item-section>
              <q-item-section side>
                <q-img
                  :src="'data:image/jpeg;base64,' + items"
                  spinner-color="primary"
                  spinner-size="sm"
                  style="height: 50px; width: 50px"
                  class="radius8"
                />
              </q-item-section>
            </q-item>
          </q-list>
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
      </template>
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import AppCamera from "src/api/AppCamera";
import { CameraPreview } from "@capacitor-community/camera-preview";

export default {
  name: "AddCarPhoto",
  props: ["schedule_uuid"],
  data() {
    return {
      loading: false,
      dialog: false,
      enabled_camera: false,
      data: [],
      steps: 1,
      steps_data: {
        1: "Front Right",
        2: "Front Left",
        3: "Back Right",
        4: "Back Left",
      },
    };
  },
  mounted() {
    this.data = [];
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 3) {
        return true;
      }
      return false;
    },
  },
  watch: {
    enabled_camera(newval, oldval) {
      console.debug(newval);
      if (newval) {
        this.TurnCamera();
      } else {
        this.TurnOffCamera();
      }
    },
    data: {
      handler(newval, oldval) {
        console.debug(newval);
        console.debug(Object.keys(newval).length);
      },
      deep: true,
    },
  },
  methods: {
    hideDialog() {
      this.dialog = false;
    },
    beforeShow() {
      this.steps = 1;
      this.enabled_camera = false;
    },
    beforeHide() {
      this.enabled_camera = false;
    },
    resetData() {
      this.data = [];
      this.steps = 1;
    },
    async TurnCamera() {
      try {
        APIinterface.showLoadingBox("", this.$q);
        const cameraPreviewOptions = {
          position: "rear",
          toBack: true,
          enableZoom: true,
          parent: "cameraPreview",
          className: "cameraPreview",
        };
        CameraPreview.start(cameraPreviewOptions);
        setTimeout(() => {
          APIinterface.hideLoadingBox(this.$q);
        }, 1000);
      } catch (error) {
        APIinterface.hideLoadingBox(this.$q);
        APIinterface.notify("red-5", error, "error_outline", this.$q);
      }
    },
    async TurnOffCamera() {
      await CameraPreview.stop();
      this.enabled_camera = false;
    },
    async FlipCamera() {
      try {
        const result = await CameraPreview.flip();
        console.debug(result);
      } catch (error) {
        APIinterface.notify("red-5", error, "error_outline", this.$q);
      }
    },
    async TakePhoto() {
      const CameraPreviewPictureOptions = {
        quality: 50,
        width: 300,
        height: 300,
      };

      try {
        const result = await CameraPreview.capture(CameraPreviewPictureOptions);
        // if (this.steps == 1) {
        //   this.data.push({
        //     front_right: result.value,
        //   });
        // } else if (this.steps == 2) {
        //   this.data.push({
        //     front_left: result.value,
        //   });
        // } else if (this.steps == 3) {
        //   this.data.push({
        //     back_right: result.value,
        //   });
        // } else if (this.steps == 4) {
        //   this.data.push({
        //     back_left: result.value,
        //   });
        //   this.enabled_camera = false;
        // }
        //this.data.push("data:image/jpeg;base64," + result.value);
        this.data.push(result.value);
        if (this.steps == 4) {
          this.enabled_camera = false;
        }
        this.steps++;
      } catch (error) {
        console.debug(error);
      }
    },
    attachCarPhoto() {
      APIinterface.showLoadingBox("", this.$q);
      this.loading = true;
      APIinterface.fetchDataByToken("attachCarMultiplePhoto", {
        schedule_uuid: this.schedule_uuid,
        data: this.data,
      })
        .then((data) => {
          this.dialog = false;
          this.enabled_camera = false;
          this.resetData();
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
  },
};
</script>
