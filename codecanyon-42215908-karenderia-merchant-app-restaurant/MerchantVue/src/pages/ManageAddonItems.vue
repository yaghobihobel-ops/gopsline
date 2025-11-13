<template>
  <q-header
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
    class="myshadow"
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
        <template v-if="isEdit">{{ $t("Edit Addon Item") }}</template>
        <template v-else>{{ $t("Add Addon Items") }}</template>
      </q-toolbar-title>

      <template v-if="AccessStore.hasAccess('food.addonitem_delete')">
        <q-btn
          round
          color="red-1"
          text-color="red-9"
          icon="las la-trash"
          unelevated
          dense
          v-if="isEdit && !loading_get"
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
    <template v-if="loading_get">
      <q-inner-loading :showing="true" color="primary" size="md" />
    </template>
    <q-form v-else @submit="onSubmit">
      <div class="q-gutter-md">
        <q-input
          outlined
          v-model="name"
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
          v-model="description"
          :label="$t('Description')"
          stack-label
          color="grey-5"
          autogrow
          maxlength="255"
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

        <q-input
          outlined
          type="number"
          v-model="price"
          :label="$t('Price')"
          stack-label
          color="grey-5"
          lazy-rules
        />

        <q-select
          outlined
          v-model="category"
          :label="$t('Addon Category')"
          color="grey-5"
          :options="MenuStore.addon_category_list"
          stack-label
          multiple
          behavior="dialog"
          transition-show="fade"
          transition-hide="fade"
          :loading="MenuStore.loading_addoncategory"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
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
          <div class="text-weight-bold text-subtitle2">{{ $t("Submit") }}</div>
        </q-btn>
      </q-footer>
    </q-form>
    <DeleteComponents
      ref="confirm_dialog"
      @after-confirm="afterConfirm"
    ></DeleteComponents>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useDataStore } from "stores/DataStore";
import { useMenuStore } from "stores/MenuStore";
import APIinterface from "src/api/APIinterface";
import AppCamera from "src/api/AppCamera";
import { useAccessStore } from "stores/AccessStore";
import DeleteComponents from "src/components/DeleteComponents.vue";

export default {
  name: "ManageAddonItems",
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
      loading_get: false,
      loading: false,
      id: 0,
      name: "",
      description: "",
      category: [],
      price: 0,
      status: "publish",
      upload_enabled: false,
      featured_filename: "",
      featured_url: "",
      upload_path: "",
      photo_data: "",
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
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    const MenuStore = useMenuStore();
    const AccessStore = useAccessStore();
    return { DataStore, MenuStore, AccessStore };
  },
  computed: {
    isEdit() {
      if (this.id > 0) {
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
    this.MenuStore.getAddonCategoryList();

    this.id = this.$route.query.id;
    if (this.id > 0) {
      this.getAddonItem();
    }
  },
  methods: {
    clearPhoto() {
      this.featured_url = "";
      this.featured_filename = "";
      this.upload_path = "";
      this.featured_data = "";
    },
    getAddonItem() {
      this.loading_get = true;
      APIinterface.fetchDataByTokenPost("getAddonItem", "id=" + this.id)
        .then((data) => {
          this.name = data.details.sub_item_name;
          this.description = data.details.item_description;
          this.price = data.details.price;
          this.status = data.details.status;
          this.featured_filename = data.details.photo;
          this.featured_url = data.details.photo_url;
          this.upload_path = data.details.path;
          this.translation = data.details.translation;

          const dish = data.details.category;

          if (!APIinterface.empty(data.details.category)) {
            if (Object.keys(data.details.category).length > 0) {
              Object.entries(this.MenuStore.addon_category_list).forEach(
                ([key, items]) => {
                  if (dish.includes(items.value)) {
                    this.category.push(items);
                  }
                }
              );
            }
          }
          //
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          //APIinterface.hideLoadingBox(this.$q);
          this.loading_get = false;
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
    afterInput(data) {
      this.translation_data = data;
    },
    onSubmit() {
      this.loading = true;

      const category = [];
      if (Object.keys(this.category).length > 0) {
        Object.entries(this.category).forEach(([key, items]) => {
          category.push(items.value);
        });
      }

      APIinterface.fetchDataByToken("addAddonItem", {
        id: this.id,
        name: this.name,
        description: this.description,
        category: category,
        price: this.price,
        status: this.status.value ? this.status.value : this.status,
        featured_filename: this.featured_filename,
        upload_path: this.upload_path,
        file_data: this.hadData() ? this.photo_data.data : "",
        image_type: this.hadData() ? this.photo_data.format : "",
        translation_data: this.translation_data,
      })
        .then((data) => {
          APIinterface.ShowSuccessful(data.msg, this.$q);
          this.DataStore.cleanData("addonitems");
          if (!this.id) {
            this.$router.replace("/manage/addonitems");
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
      APIinterface.fetchDataByTokenPost("deleteAddonItem", "id=" + this.id)
        .then((data) => {
          this.DataStore.cleanData("addonitems");
          this.$router.replace("/manage/addonitems");
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
  },
};
</script>
