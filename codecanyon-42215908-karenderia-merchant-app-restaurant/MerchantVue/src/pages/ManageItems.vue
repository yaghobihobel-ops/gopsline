<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-header
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
        'beautiful-shadow': isScrolled,
      }"
    >
      <q-toolbar class="q-gutter-x-sm">
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
          {{ isEdit ? $t("Edit Items") : $t("Add Items") }}
        </q-toolbar-title>
        <q-space></q-space>
        <template
          v-if="
            AccessStore.hasAccess('food.item_delete') && isEdit && !loading_get
          "
        >
          <q-btn
            round
            color="red-1"
            text-color="red-9"
            icon="las la-trash"
            unelevated
            dense
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
            v-model="item_name"
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
            type="textarea"
            outlined
            v-model="item_short_description"
            :label="$t('Short Description')"
            stack-label
            color="grey-5"
          />
          <q-input
            type="textarea"
            outlined
            v-model="item_description"
            :label="$t('Long Description')"
            stack-label
            color="grey-5"
          />

          <div>
            <div>{{ $t("Image") }}</div>
            <div class="text-caption text-grey line-normal">
              {{ $t("Recommended size: 800 x 800 px (square, JPG/PNG)") }}<br />
              {{ $t("Minimum size: 400 x 400 px") }}
            </div>
          </div>
          <div
            class="bg-grey-2 q-pa-sm cursor-pointer relative-position"
            @click="takePhoto"
          >
            <q-inner-loading
              :showing="isFileUploading"
              size="sm"
              color="primary"
            />

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
            @start-uploading="StartUploading"
            @finish-uploading="FinishUploading"
          ></UploaderFile>

          <template v-if="!isEdit">
            <q-input
              type="number"
              outlined
              v-model="item_price"
              :label="$t('Price')"
              stack-label
              color="grey-5"
              lazy-rules
            />
            <q-select
              outlined
              v-model="item_unit"
              :label="$t('Unit')"
              color="grey-5"
              :options="selectionData?.unit"
              stack-label
              behavior="menu"
              transition-show="fade"
              transition-hide="fade"
              map-options
              emit-value
            />
          </template>

          <q-select
            outlined
            v-model="category_selected"
            :label="$t('Category')"
            color="grey-5"
            :options="selectionData?.category_list"
            option-value="id"
            option-label="name"
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
            v-model="item_featured"
            :label="$t('Featured')"
            color="grey-5"
            :options="selectionData?.item_featured"
            multiple
            behavior="menu"
            transition-show="fade"
            transition-hide="fade"
            map-options
            emit-value
          />

          <q-list v-if="isEdit" separator>
            <q-item
              clickable
              :to="{
                path: '/item/pricelist',
                query: {
                  item_uuid: id,
                },
              }"
            >
              <q-item-section>{{ $t("Price") }}</q-item-section>
              <q-item-section side>{{ price_range }}</q-item-section>
              <q-item-section avatar>
                <q-avatar rounded text-color="dark" icon="las la-angle-right" />
              </q-item-section>
            </q-item>
            <q-item
              clickable
              :to="{
                path: '/item/addonlist',
                query: {
                  item_uuid: id,
                },
              }"
            >
              <q-item-section>{{ $t("Addon") }}</q-item-section>
              <q-item-section side>{{ total_addon }}</q-item-section>
              <q-item-section avatar>
                <q-avatar rounded text-color="dark" icon="las la-angle-right" />
              </q-item-section>
            </q-item>

            <q-item
              clickable
              :to="{
                path: '/item/attributes',
                query: {
                  item_uuid: id,
                },
              }"
            >
              <q-item-section>{{ $t("Attributes") }}</q-item-section>

              <q-item-section side></q-item-section>
              <q-item-section avatar>
                <q-avatar rounded text-color="dark" icon="las la-angle-right" />
              </q-item-section>
            </q-item>

            <q-item
              clickable
              :to="{
                path: '/item/availability',
                query: {
                  item_uuid: id,
                },
              }"
            >
              <q-item-section>{{ $t("Availability") }}</q-item-section>

              <q-item-section side></q-item-section>
              <q-item-section avatar>
                <q-avatar rounded text-color="dark" icon="las la-angle-right" />
              </q-item-section>
            </q-item>

            <q-item
              clickable
              :to="{
                path: '/item/inventory',
                query: {
                  item_uuid: id,
                },
              }"
            >
              <q-item-section>{{ $t("Item inventory") }}</q-item-section>

              <q-item-section side></q-item-section>
              <q-item-section avatar>
                <q-avatar rounded text-color="dark" icon="las la-angle-right" />
              </q-item-section>
            </q-item>

            <q-item
              clickable
              :to="{
                path: '/item/promotionlist',
                query: {
                  item_uuid: id,
                },
              }"
            >
              <q-item-section>{{ $t("Sales Promotion") }}</q-item-section>

              <q-item-section side></q-item-section>
              <q-item-section avatar>
                <q-avatar rounded text-color="dark" icon="las la-angle-right" />
              </q-item-section>
            </q-item>

            <q-item
              clickable
              :to="{
                path: '/item/gallery',
                query: {
                  item_uuid: id,
                },
              }"
            >
              <q-item-section>{{ $t("Item gallery") }}</q-item-section>

              <q-item-section side></q-item-section>
              <q-item-section avatar>
                <q-avatar rounded text-color="dark" icon="las la-angle-right" />
              </q-item-section>
            </q-item>

            <q-item
              clickable
              :to="{
                path: '/item/seo',
                query: {
                  item_uuid: id,
                },
              }"
            >
              <q-item-section>{{ $t("Item SEO") }}</q-item-section>

              <q-item-section side></q-item-section>
              <q-item-section avatar>
                <q-avatar rounded text-color="dark" icon="las la-angle-right" />
              </q-item-section>
            </q-item>

            <!-- end -->
          </q-list>

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
            map-options
            emit-value
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

        <q-footer class="bg-white q-pa-md box-shadow0">
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
import { useMenuStore } from "stores/MenuStore";
import APIinterface from "src/api/APIinterface";
import AppCamera from "src/api/AppCamera";
import { useAccessStore } from "stores/AccessStore";
import TipsModal from "src/components/TipsModal.vue";

export default {
  name: "ManageItems",
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
      id: "",
      item_name: "",
      item_short_description: "",
      item_description: "",
      item_price: "",
      item_unit: "",
      category_selected: [],
      category_value: [],
      status: "publish",
      item_featured: [],
      item_featured_value: [],
      upload_enabled: false,
      featured_filename: "",
      featured_url: "",
      upload_path: "",
      featured_data: "",
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
      price_range: "",
      price_list: [],
      total_addon: "",
      isScrolled: false,
      data: [],
      selectionData: null,
      isSaved: false,
      isFileUploading: false,
    };
  },
  setup() {
    const DataStore = useDataStore();
    const MenuStore = useMenuStore();
    const AccessStore = useAccessStore();
    return { DataStore, MenuStore, AccessStore };
  },
  mounted() {
    this.id = this.$route.query.item_uuid ?? null;
    if (this.id) {
      if (this.DataStore.dataList?.item_data) {
        console.log("save data", this.DataStore.dataList?.item_data);
        const data = this.DataStore.dataList.item_data;
        if (data.item_token === this.id) {
          this.data = data;
          this.setData();
        } else {
          this.getItem();
        }
      } else {
        this.getItem();
      }
    } else {
      this.fetchSelectionData();
    }
  },
  beforeUnmount() {
    console.log("isSaved", this.isSaved);
    if (this.isSaved) {
      this.DataStore.dataList.item_data = null;
      return;
    }
    this.DataStore.dataList.item_data = this.data;
  },
  computed: {
    isEdit() {
      if (!APIinterface.empty(this.id)) {
        return true;
      }
      return false;
    },
    hasPhoto() {
      return APIinterface.empty(this.featured_filename) ? false : true;
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
    StartUploading() {
      this.isFileUploading = true;
    },
    FinishUploading() {
      this.isFileUploading = false;
    },
    clearPhoto() {
      this.featured_url = "";
      this.featured_filename = "";
      this.upload_path = "";
      this.featured_data = "";
    },
    async fetchSelectionData() {
      try {
        const response = await APIinterface.fetchGet("fetchSelectionItem");
        this.selectionData = response.details;
      } catch (error) {
      } finally {
        //
      }
    },
    onScroll(info) {
      if (!info) {
        return;
      }
      this.isScrolled = info.position.top > 20;
    },
    refresh(done) {
      if (!APIinterface.empty(this.id)) {
        this.getItem(done);
      } else {
        done();
      }
    },
    getItem(done) {
      this.loading_get = true;
      APIinterface.fetchDataByTokenPost("getItem", "id=" + this.id)
        .then((data) => {
          this.data = data.details;
          this.setData();
          //
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
    setData() {
      this.item_name = this.data.item_name;
      this.item_short_description = this.data.item_short_description;
      this.item_description = this.data.item_description;
      this.item_price = this.data.item_price;
      this.item_unit = this.data.item_unit;
      this.category_selected = this.data.category_selected;
      this.item_featured = this.data.item_featured;

      this.status = this.data.status;
      this.featured_filename = this.data.photo;
      this.featured_url = this.data.photo_url;
      this.upload_path = this.data.path;
      this.translation = this.data.translation;

      this.price_range = this.data.price_range;
      this.price_list = this.data.price_list;

      this.total_addon = this.data.total_addon;
      this.selectionData = this.data?.selection_data;
    },
    onSubmit() {
      this.loading = true;

      APIinterface.fetchDataByToken("createItem", {
        id: this.id,
        item_name: this.item_name,
        item_short_description: this.item_short_description,
        item_description: this.item_description,
        item_price: this.item_price,
        item_unit: this.item_unit,
        category_selected: this.category_selected,
        item_featured: this.item_featured,
        status: this.status,
        featured_filename: this.featured_filename,
        upload_path: this.upload_path,
        file_data: this.hadFeaturedData() ? this.featured_data.data : "",
        image_type: this.hadFeaturedData() ? this.featured_data.format : "",
        translation_data: this.translation_data,
      })
        .then((data) => {
          APIinterface.ShowSuccessful(data.msg, this.$q);
          this.DataStore.cleanData("food_data");
          this.DataStore.cleanData("menu_data");
          this.isSaved = true;
          this.$router.back();
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading = false;
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
    afterUploadfile(data) {
      this.featured_filename = data.filename;
      this.featured_url = data.url_image;
      this.upload_path = data.upload_path;
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
    confirmDelete() {
      this.$refs.confirm_dialog.confirm();
    },
    afterConfirm() {
      this.$refs.confirm_dialog.dialog = false;
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost("deleteItem", "id=" + this.id)
        .then((data) => {
          //this.$router.push("/menu?refresh=1");
          this.DataStore.cleanData("food_data");
          this.DataStore.cleanData("menu_data");
          this.$router.back();
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
  },
};
</script>
