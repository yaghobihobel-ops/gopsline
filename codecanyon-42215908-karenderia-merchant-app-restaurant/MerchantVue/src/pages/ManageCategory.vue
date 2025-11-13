<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-header
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
        'beautiful-shadow': isScrolled,
      }"
    >
      <q-toolbar>
        <q-btn
          round
          icon="keyboard_arrow_left"
          color="blue-grey-1"
          text-color="blue-grey-8"
          unelevated
          dense
          @click="$router.back()"
        ></q-btn>
        <q-toolbar-title>
          <template v-if="isEdit"> {{ $t("Edit Category") }} </template>
          <template v-else> {{ $t("Add Category") }} </template>
        </q-toolbar-title>

        <template v-if="AccessStore.hasAccess('food.category_delete')">
          <q-btn
            v-if="isEdit && !loading_get"
            round
            color="red-1"
            text-color="red-9"
            icon="las la-trash"
            size="sm"
            unelevated
            @click="confirmDelete"
          />
        </template>
      </q-toolbar>
    </q-header>
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
      class="q-pa-md"
    >
      <q-scroll-observer @scroll="onScroll" scroll-target="body" />

      <template v-if="loading_get">
        <div
          class="row q-gutter-x-sm justify-center q-my-md absolute-center text-center full-width"
        >
          <q-circular-progress
            indeterminate
            rounded
            size="sm"
            color="primary"
          />
          <div class="text-subtitle1 text-grey">{{ $t("Loading") }}...</div>
        </div>
      </template>

      <q-form v-else @submit="onSubmit">
        <div class="q-gutter-md">
          <q-input
            outlined
            v-model="category_name"
            :label="$t('Name')"
            stack-label
            color="grey-5"
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
            hide-bottom-space
          />

          <q-input
            outlined
            type="textarea"
            v-model="category_description"
            :label="$t('Description')"
            stack-label
            color="grey-5"
            maxlength="255"
            hide-bottom-space
          />

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
                        hasFeaturedData
                          ? this.photo_data?.path
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

          <q-select
            outlined
            v-model="dish"
            :label="$t('Dish')"
            color="grey-5"
            stack-label
            multiple
            :options="DataStore.dish_list"
            behavior="menu"
            transition-show="fade"
            transition-hide="fade"
            hide-bottom-space
          />

          <q-select
            outlined
            v-model="status"
            :label="$t('Status')"
            color="grey-5"
            :options="DataStore.status_list"
            stack-label
            behavior="menu"
            transition-show="fade"
            transition-hide="fade"
            hide-bottom-space
          />

          <ItemTranslation
            ref="item_translation"
            :fields="fields"
            :update="isEdit"
            :data="translation"
            @after-input="afterInput"
          ></ItemTranslation>
        </div>

        <q-space class="q-pa-lg"></q-space>

        <q-footer class="bg-white q-pa-md myshadow">
          <q-btn
            type="submit"
            color="amber-6"
            text-color="disabled"
            unelevated
            class="full-width radius10"
            size="lg"
            no-caps
            :loading="loading"
          >
            <div class="text-weight-bold text-subtitle2">
              {{ $t("Submit") }}
            </div>
          </q-btn>
        </q-footer>
      </q-form>
      <DeleteComponents
        ref="confirm_dialog"
        @after-confirm="afterConfirm"
      ></DeleteComponents>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";
import AppCamera from "src/api/AppCamera";
import { useAccessStore } from "stores/AccessStore";
import DeleteComponents from "src/components/DeleteComponents.vue";

export default {
  name: "ManageCategory",
  components: {
    DeleteComponents: defineAsyncComponent(() =>
      import("components/DeleteComponents.vue")
    ),
    UploaderFile: defineAsyncComponent(() =>
      import("components/UploaderFile.vue")
    ),
    ItemTranslation: defineAsyncComponent(() =>
      import("components/ItemTranslation.vue")
    ),
  },
  data() {
    return {
      cat_id: 0,
      category_name: "",
      category_description: "",
      status: "publish",
      dish: [],
      status_list: [],
      loading: false,
      loading_get: false,
      data_dialog: {
        title: this.$t("Delete Confirmation"),
        subtitle: this.$t(
          "Are you sure you want to permanently delete the selected item?"
        ),
        cancel: this.$t("Cancel"),
        confirm: this.$t("Delete"),
      },
      upload_enabled: false,
      featured_filename: "",
      featured_url: "",
      upload_path: "",
      fields: [
        {
          name: "name",
          title: this.$t("Enter name"),
          type: "text",
        },
        {
          name: "description",
          title: this.$t("Enter description"),
          type: "textarea",
        },
      ],
      translation_data: [],
      translation: [],
      photo_data: "",
      isScrolled: false,
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    const AccessStore = useAccessStore();
    return { DataStore, AccessStore };
  },
  computed: {
    isEdit() {
      if (this.cat_id > 0) {
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
  created() {
    this.cat_id = this.$route.query.cat_id;
    if (this.cat_id > 0) {
      this.getCategory();
    }
  },
  methods: {
    clearPhoto() {
      this.featured_url = "";
      this.featured_filename = "";
      this.upload_path = "";
      this.photo_data = "";
    },
    onScroll(info) {
      if (!info) {
        return;
      }
      this.isScrolled = info.position.top > 20;
    },
    refresh(done) {
      if (this.cat_id > 0) {
        this.getCategory(done);
      } else {
        done();
      }
    },
    getCategory(done) {
      this.loading_get = true;
      APIinterface.fetchDataByTokenPost("getCategory", "cat_id=" + this.cat_id)
        .then((data) => {
          this.category_name = data.details.category_name;
          this.category_description = data.details.category_description;
          this.status = data.details.status;
          this.featured_filename = data.details.photo;
          this.featured_url = data.details.photo_url;
          this.upload_path = data.details.path;
          this.translation = data.details.translation;

          const dish = data.details.dish_selected;
          if (Object.keys(data.details.dish_selected).length > 0) {
            Object.entries(this.DataStore.dish_list).forEach(([key, items]) => {
              if (dish.includes(items.value)) {
                this.dish.push(items);
              }
            });
          }
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading_get = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    afterInput(data) {
      this.translation_data = data;
    },
    onSubmit() {
      this.loading = true;

      const dish = [];
      if (Object.keys(this.dish).length > 0) {
        Object.entries(this.dish).forEach(([key, items]) => {
          dish.push(items.value);
        });
      }

      APIinterface.fetchDataByToken("addCategory", {
        cat_id: this.cat_id,
        category_name: this.category_name,
        category_description: this.category_description,
        status: this.status.value ? this.status.value : this.status,
        dish: dish,
        featured_filename: this.featured_filename,
        upload_path: this.upload_path,
        file_data: this.hadData() ? this.photo_data.data : "",
        image_type: this.hadData() ? this.photo_data.format : "",
        translation_data: this.translation_data,
      })
        .then((data) => {
          APIinterface.ShowSuccessful(data.msg, this.$q);
          this.DataStore.cleanData("category_data");
          if (!this.cat_id) {
            this.$router.replace("/manage/category");
          }
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    hadData() {
      if (Object.keys(this.photo_data).length > 0) {
        return true;
      }
      return false;
    },
    confirmDelete() {
      this.$refs.confirm_dialog.confirm();
    },
    afterConfirm() {
      this.$refs.confirm_dialog.dialog = false;
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        "deleteCategory",
        "cat_id=" + this.cat_id
      )
        .then((data) => {
          this.DataStore.cleanData("category_data");
          this.$router.replace("/manage/category");
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
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
    afterUploadfile(data) {
      this.featured_filename = data.filename;
      this.featured_url = data.url_image;
      this.upload_path = data.upload_path;
    },
  },
};
</script>
