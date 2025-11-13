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
          $t("Gallery")
        }}</q-toolbar-title>
      </q-toolbar>
      <q-separator></q-separator>
    </q-header>
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
        'flex flex-center': !loading && !hasData,
      }"
      class="q-pa-md"
    >
      <template v-if="loading">
        <q-inner-loading :showing="true" color="primary" size="md" />
      </template>

      <template v-else>
        <template v-if="hasData">
          <div class="row items-center justify-between">
            <div class="text-weight-bold">{{ $t("Gallery") }}</div>
            <q-btn
              v-if="hasData2"
              :label="edit ? this.$t('Done') : this.$t('Edit')"
              flat
              no-caps
              color="primary"
              @click="edit = !edit"
            />
          </div>
          <q-separator class="q-mb-lg"></q-separator>

          <div class="row items-stretch items-center q-gutter-md">
            <div
              class="col-3 relative-position"
              v-for="(items, index) in data"
              :key="items"
            >
              <q-btn
                v-if="edit"
                round
                color="primary"
                icon="las la-trash"
                dense
                unelevated
                size="sm"
                class="absolute-top-left z-max"
                style="top: -10px"
                @click="confirmDelete(items, index)"
              />
              <q-img
                :src="items.image_url"
                style="max-width: 100px; height: 70px"
                fit="cover"
                class="radius8 col-3"
                spinner-color="primary"
                spinner-size="sm"
              >
              </q-img>
            </div>
            <div class="col-3">
              <q-btn
                color="primary"
                text-color="white"
                class="line-normal radius8 font13"
                unelevated
                style="min-height: 70px"
                no-caps
                :to="{
                  path: '/item/create-gallery',
                  query: {
                    item_uuid: id,
                  },
                }"
              >
                + {{ $t("Add") }}
              </q-btn>
            </div>
          </div>
        </template>
        <template v-else>
          <div class="full-width text-center">
            <div class="text-weight-bold">{{ $t("ID is missing") }}</div>
            <div>
              {{ $t("Oops sorry we cannot find what your looking for") }}
            </div>
          </div>
        </template>
      </template>
    </q-page>
  </q-pull-to-refresh>
  <ConfirmDialog
    ref="confirm_dialog"
    :data="DataStore.data_dialog"
    @after-confirm="afterConfirm"
  ></ConfirmDialog>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";

export default {
  name: "ItemAddPrice",
  components: {
    ConfirmDialog: defineAsyncComponent(() =>
      import("components/ConfirmDialog.vue")
    ),
  },
  data() {
    return {
      dialog_price: false,
      id: "",
      loading: true,
      data: [],
      edit: false,
      data_to_delete: [],
      title: "",
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    return { DataStore };
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      if (!APIinterface.empty(this.id)) {
        return true;
      }
      return false;
    },
    hasData2() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  created() {
    this.id = this.$route.query.item_uuid;
    if (!APIinterface.empty(this.id)) {
      this.getItemGallery();
    } else {
      this.loading = false;
    }
  },
  methods: {
    refresh(done) {
      this.getItemGallery(done);
    },
    getItemGallery(done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getItemGallery", "id=" + this.id)
        .then((data) => {
          this.data = data.details;
        })
        .catch((error) => {
          this.data = [];
        })
        .then((data) => {
          this.loading = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    confirmDelete(data, index) {
      this.data_to_delete = data;
      this.data_to_delete.index = index;
      this.$refs.confirm_dialog.dialog = true;
    },
    afterConfirm() {
      this.$refs.confirm_dialog.dialog = false;
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        "deleteItemGallery",
        "item_uuid=" + this.id + "&id=" + this.data_to_delete.id
      )
        .then((data) => {
          this.data.splice(this.data_to_delete.index, 1);
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
