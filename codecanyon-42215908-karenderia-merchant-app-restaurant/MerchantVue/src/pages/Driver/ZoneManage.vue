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
      <q-toolbar-title class="text-weight-bold">
        <template v-if="isEdit">
          {{ $t("Update Zone") }}
        </template>
        <template v-else>
          {{ $t("Add Zone") }}
        </template>
      </q-toolbar-title>
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
    <template v-if="loading">
      <q-inner-loading :showing="true" color="primary" size="md" />
    </template>
    <q-form v-else @submit="formSubmit">
      <q-input
        v-model="zone_name"
        :label="$t('Name')"
        stack-label
        outlined
        color="grey-5"
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      />

      <q-input
        v-model="description"
        :label="$t('Description')"
        stack-label
        outlined
        autogrow
        color="grey-5"
      />

      <q-footer>
        <q-btn
          type="submit"
          color="primary"
          text-color="white"
          :label="$t('Save')"
          unelevated
          class="full-width radius8"
          size="lg"
          no-caps
          :disable="CheckData"
        />
      </q-footer>
    </q-form>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "GroupManage",
  components: {},
  data() {
    return {
      id: "",
      data: [],
      loading: false,
      zone_name: "",
      description: "",
    };
  },
  mounted() {
    this.id = this.$route.query.id;
    if (!APIinterface.empty(this.id)) {
      this.getData();
    }
  },
  computed: {
    isEdit() {
      if (!APIinterface.empty(this.id)) {
        return true;
      }
      return false;
    },
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
    CheckData() {
      if (!APIinterface.empty(this.id)) {
        if (Object.keys(this.data).length <= 0) {
          return true;
        }
      }
      return false;
    },
  },
  methods: {
    getData() {
      this.loading = true;

      APIinterface.fetchDataByTokenPost("getZone", "id=" + this.id)
        .then((data) => {
          this.data = data.details;
          this.zone_name = data.details.zone_name;
          this.description = data.details.description;
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    formSubmit() {
      let params = {
        id: this.id,
        zone_name: this.zone_name,
        description: this.description,
      };
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        !APIinterface.empty(this.id) ? "UpdateZone" : "AddZone",
        params
      )
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
          this.$router.replace({
            path: "/delivery-management/zones",
          });
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    //
  },
};
</script>
