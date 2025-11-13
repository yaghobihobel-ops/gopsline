<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-header class="myshadow bg-white text-dark">
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
          <template v-if="isEdit">{{ $t("Edit Size") }}</template>
          <template v-else>{{ $t("Add Size") }}</template>
        </q-toolbar-title>
        <q-btn
          v-if="isEdit && !loading_get"
          round
          color="red-1"
          text-color="red-9"
          icon="las la-trash"
          unelevated
          dense
          @click="confirmDelete"
        />
      </q-toolbar>
      <q-separator></q-separator>
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
        <q-space class="q-pa-xs"></q-space>

        <div class="q-gutter-md">
          <q-input
            outlined
            v-model="size_name"
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
            :disable="!edit_found"
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
import DeleteComponents from "src/components/DeleteComponents.vue";

export default {
  name: "ManageAddonCategory",
  components: {
    DeleteComponents: defineAsyncComponent(() =>
      import("components/DeleteComponents.vue")
    ),
    ItemTranslation: defineAsyncComponent(() =>
      import("components/ItemTranslation.vue")
    ),
  },
  data() {
    return {
      loading_get: false,
      loading: false,
      size_id: 0,
      size_name: "",
      status: "publish",
      fields: [
        {
          name: "name",
          title: this.$t("Enter name"),
          type: "text",
        },
      ],
      data_dialog: {
        title: this.$t("Delete Confirmation"),
        subtitle: this.$t(
          "Are you sure you want to permanently delete the selected item?"
        ),
        cancel: this.$t("Cancel"),
        confirm: this.$t("Delete"),
      },
      translation_data: [],
      translation: [],
      edit_found: true,
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    return { DataStore };
  },
  computed: {
    isEdit() {
      if (this.size_id > 0) {
        return true;
      }
      return false;
    },
  },
  created() {
    this.edit_found = true;
    this.size_id = this.$route.query.size_id;
    if (this.size_id > 0) {
      this.getSize();
    }
  },
  methods: {
    refresh(done) {
      this.getSize(done);
    },
    getSize(done) {
      this.loading_get = true;
      APIinterface.fetchDataByTokenPost("getSize", "size_id=" + this.size_id)
        .then((data) => {
          this.size_name = data.details.size_name;
          this.status = data.details.status;
          this.translation = data.details.translation;
        })
        .catch((error) => {
          this.edit_found = false;
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
      APIinterface.fetchDataByToken("addSize", {
        size_id: this.size_id,
        size_name: this.size_name,
        status: this.status.value ? this.status.value : this.status,
        translation_data: this.translation_data,
      })
        .then((data) => {
          this.DataStore.cleanData("sizelist");
          APIinterface.ShowSuccessful(data.msg, this.$q);
          if (!this.size_id) {
            this.$router.replace("/manage/size");
          }
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    confirmDelete() {
      this.$refs.confirm_dialog.confirm();
    },
    afterConfirm() {
      this.$refs.confirm_dialog.dialog = false;
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost("deleteSize", "size_id=" + this.size_id)
        .then((data) => {
          this.DataStore.cleanData("sizelist");
          this.$router.replace("/manage/size");
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
