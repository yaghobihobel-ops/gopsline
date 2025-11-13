<template>
  <q-dialog
    v-model="dialog"
    class="rounded-borders-top"
    @before-show="beforeShow"
    persistent
    position="bottom"
    transition-show="fade"
  >
    <q-card>
      <template v-if="loading">
        <div style="min-height: 50vh">
          <q-inner-loading :showing="true" size="md" color="primary">
          </q-inner-loading>
        </div>
      </template>

      <template v-else>
        <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
          <q-toolbar-title
            class="text-dark text-weight-bold"
            style="overflow: inherit"
          >
            {{ $t("Update review") }}
          </q-toolbar-title>
          <q-space></q-space>
          <q-btn
            @click="dialog = !true"
            color="white"
            square
            unelevated
            text-color="grey"
            icon="las la-times"
            dense
            no-caps
            size="sm"
            class="border-grey radius8"
          />
        </q-toolbar>
        <q-form @submit="formSubmit">
          <q-card-section class="q-pt-none">
            <q-input
              v-model="review"
              :label="$t('Reviews')"
              stack-label
              outlined
              color="grey-5"
              :rules="[
                (val) =>
                  (val && val.length > 0) || this.$t('This field is required'),
              ]"
            />

            <q-input
              v-model="rating"
              type="number"
              :label="$t('Ratings')"
              stack-label
              outlined
              color="grey-5"
              :rules="[
                (val) => (val && val > 0) || this.$t('This field is required'),
              ]"
            />

            <q-select
              v-model="status"
              :options="DataStore.status_list"
              :label="$t('Status')"
              stack-label
              behavior="dialog"
              outlined
              color="grey-5"
              emit-value
              map-options
            />
          </q-card-section>

          <q-space class="q-pa-sm"></q-space>
          <q-separator></q-separator>
          <q-card-actions class="q-pt-md q-pb-md">
            <q-btn
              rounded
              color="green"
              no-caps
              unelevated
              class="fit"
              size="lg"
              type="submit"
              >{{ $t("Save") }}</q-btn
            >
          </q-card-actions>
        </q-form>
      </template>
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";

export default {
  name: "ReviewUpdate",
  components: {},
  data() {
    return {
      dialog: false,
      loading: false,
      review: "",
      rating: 0,
      status: "publish",
      id: "",
    };
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    show(data) {
      console.log(data);
      this.id = data.id;
      this.review = data.review;
      this.rating = data.rating;
      this.status = data.status_raw;
      this.dialog = true;
    },
    formSubmit(data) {
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });
      APIinterface.fetchDataByTokenPost("UpdateReviews", {
        id: this.id,
        review: this.review,
        rating: this.rating,
        status: this.status,
      })
        .then((data) => {
          this.dialog = false;
          this.$emit("afterUpdate");
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.$q.loading.hide();
        });
    },
  },
};
</script>
