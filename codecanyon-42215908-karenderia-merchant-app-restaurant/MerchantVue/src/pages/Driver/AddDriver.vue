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
          {{ $t("Update Driver") }}
        </template>
        <template v-else>
          {{ $t("Add Driver") }}
        </template>
      </q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
      'flex flex-center': isEdit && !hasData,
    }"
    class="q-pa-md"
  >
    <template v-if="loading">
      <q-inner-loading :showing="true" color="primary" size="md" />
    </template>
    <q-form v-else @submit="formSubmit">
      <div class="row q-gutter-sm">
        <template v-if="hasPhotodata">
          <q-img
            :src="photo_data.path"
            spinner-color="primary"
            spinner-size="sm"
            fit="cover"
            style="height: 70px"
            class="col-3 radius8"
          />
        </template>
        <template v-else-if="hasPhoto">
          <q-img
            :src="this.avatar"
            spinner-color="primary"
            fit="cover"
            style="height: 70px"
            class="col-3 radius8"
          />
        </template>
        <div
          v-else
          class="col-3 row items-center justify-center radius8"
          :class="{
            'bg-grey600 ': $q.dark.mode,
            'bg-mygrey ': !$q.dark.mode,
          }"
          style="height: 70px"
        >
          <q-icon name="las la-image" class="text-grey" size="xl" />
        </div>
        <div class="col">
          <div class="font12 line-normal">
            {{
              $t(
                "Items with quality photos are often more popular. Maximum 2 MB"
              )
            }}.
            {{ $t("Accepted types: PNG. JPG") }}
          </div>
          <q-btn
            :label="
              hasPhoto
                ? this.$t('Change Photo')
                : hasData
                ? this.$t('Change Photo')
                : this.$t('Add Photo')
            "
            flat
            color="primary"
            no-caps
            class="q-pl-none q-pr-none"
            @click="takePhoto"
          ></q-btn>
        </div>
      </div>

      <template v-if="upload_enabled">
        <UploaderFile
          ref="uploader_file"
          @after-uploadfile="afterUploadfile"
        ></UploaderFile>
      </template>
      <q-space class="q-pa-sm"></q-space>

      <q-input
        v-model="first_name"
        :label="$t('First name')"
        stack-label
        outlined
        color="grey-5"
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      />

      <q-input
        v-model="last_name"
        :label="$t('Last name')"
        stack-label
        outlined
        color="grey-5"
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      />

      <q-input
        v-model="email"
        :label="$t('Email address')"
        stack-label
        outlined
        color="grey-5"
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      />

      <MobilePhone
        ref="mobile_phone"
        @after-input="afterInput"
        :prefix="phone_prefix"
        :phone="phone"
      ></MobilePhone>

      <q-input
        v-model="address"
        :label="$t('Complete address')"
        stack-label
        outlined
        color="grey-5"
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      />

      <div class="text-subtitle1">{{ $t("Login") }}</div>

      <q-input
        v-model="new_password"
        type="password"
        :label="$t('Password')"
        stack-label
        outlined
        color="grey-5"
      />
      <q-space class="q-pa-sm"></q-space>
      <q-input
        v-model="confirm_password"
        type="password"
        :label="$t('Confirm password')"
        stack-label
        outlined
        color="grey-5"
      />
      <q-space class="q-pa-sm"></q-space>

      <div class="text-subtitle1">{{ $t("Employment Type") }}</div>
      <q-select
        v-model="employment_type"
        :label="$t('Employment')"
        :options="DataStore.employment_type"
        stack-label
        behavior="dialog"
        outlined
        color="grey-5"
        emit-value
        map-options
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      />

      <div class="text-subtitle1">{{ $t("Payment options") }}</div>

      <div class="q-gutter-y-md">
        <q-select
          v-model="salary_type"
          :label="$t('Salary type')"
          :options="DataStore.salary_type"
          stack-label
          behavior="dialog"
          outlined
          color="grey-5"
          emit-value
          map-options
        />

        <q-input
          v-model="salary"
          type="number"
          step="any"
          :label="$t('Salary amount')"
          stack-label
          outlined
          color="grey-5"
        />

        <q-input
          v-model="fixed_amount"
          type="number"
          step="any"
          :label="$t('Fixed amount')"
          stack-label
          outlined
          color="grey-5"
        />

        <div class="row q-gutter-x-sm">
          <q-input
            v-model="commission"
            type="number"
            step="any"
            :label="$t('Commission amount')"
            stack-label
            outlined
            color="grey-5"
            class="col"
          />
          <q-select
            v-model="commission_type"
            :options="DataStore.commission_type"
            :label="$t('Type')"
            stack-label
            behavior="dialog"
            outlined
            color="grey-5"
            emit-value
            map-options
            class="col-4"
          />
        </div>
      </div>

      <q-space class="q-pa-sm"></q-space>

      <div class="text-subtitle1">{{ $t("Incentives") }}</div>

      <div class="q-gutter-y-md">
        <q-input
          v-model="incentives_amount"
          type="number"
          step="any"
          :label="$t('Incentives amount (per delivery)')"
          stack-label
          outlined
          color="grey-5"
        />
        <q-input
          v-model="allowed_offline_amount"
          type="number"
          step="any"
          :label="$t('Maximum cash amount that can collect')"
          stack-label
          outlined
          color="grey-5"
        />

        <q-select
          v-model="status"
          :options="DataStore.customer_status"
          :label="$t('Status')"
          stack-label
          behavior="dialog"
          outlined
          color="grey-5"
          emit-value
          map-options
        />
      </div>

      <q-space class="q-pa-md"></q-space>

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
        />
      </q-footer>
    </q-form>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import { defineAsyncComponent } from "vue";
import AppCamera from "src/api/AppCamera";

export default {
  name: "AddDriver",
  components: {
    MobilePhone: defineAsyncComponent(() =>
      import("components/MobilePhone.vue")
    ),
    UploaderFile: defineAsyncComponent(() =>
      import("components/UploaderFile.vue")
    ),
  },
  data() {
    return {
      id: "",
      data: [],
      loading: false,
      first_name: "",
      last_name: "",
      email: "",
      phone: "",
      address: "",
      new_password: "",
      confirm_password: "",
      employment_type: "employee",
      salary_type: "salary",
      salary: 0,
      fixed_amount: 0,
      commission: 0,
      commission_type: "fixed",
      incentives_amount: 0,
      allowed_offline_amount: 0,
      status: "active",
      upload_enabled: false,
      photo_data: "",
      photo: "",
      upload_path: "",
      avatar: "",
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    return { DataStore };
  },
  mounted() {
    this.id = this.$route.query.id;
    if (!APIinterface.empty(this.id)) {
      this.getDriverInfo();
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
    hasPhotodata() {
      if (Object.keys(this.photo_data).length > 0) {
        return true;
      }
      return false;
    },
    hasPhoto() {
      return APIinterface.empty(this.photo) ? false : true;
    },
  },
  methods: {
    getDriverInfo() {
      this.loading = true;

      APIinterface.fetchDataByTokenPost("getDriverInfo", "id=" + this.id)
        .then((data) => {
          this.data = data.details;
          this.first_name = this.data.first_name;
          this.last_name = this.data.last_name;
          this.email = this.data.email;

          this.phone_prefix = this.data.phone_prefix;
          this.phone = this.data.phone;

          this.address = this.data.address;
          this.employment_type = this.data.employment_type;
          this.salary_type = this.data.salary_type;
          this.salary = this.data.salary;
          this.fixed_amount = this.data.fixed_amount;
          this.commission = this.data.commission;
          this.commission_type = this.data.commission_type;
          this.incentives_amount = this.data.incentives_amount;
          this.allowed_offline_amount = this.data.allowed_offline_amount;
          this.status = this.data.status;

          this.avatar = data.details.avatar;
          this.photo = data.details.photo;
          this.upload_path = data.details.path;
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    afterInput(data) {
      this.phone = data;
    },
    formSubmit() {
      let params = {
        id: this.id,
        first_name: this.first_name,
        last_name: this.last_name,
        email: this.email,
        phone: this.phone,
        address: this.address,
        new_password: this.new_password,
        confirm_password: this.confirm_password,
        employment_type: this.employment_type,
        salary_type: this.salary_type,
        salary: this.salary,
        fixed_amount: this.fixed_amount,
        commission: this.commission,
        commission_type: this.commission_type,
        incentives_amount: this.incentives_amount,
        allowed_offline_amount: this.allowed_offline_amount,
        status: this.status,
        photo: this.photo,
        upload_path: this.upload_path,
        file_data: this.hadData() ? this.photo_data.data : "",
        image_type: this.hadData() ? this.photo_data.format : "",
      };
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        !APIinterface.empty(this.id) ? "UpdateDriver" : "AddDriver",
        params
      )
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
          this.$router.replace({
            path: "/delivery-management/driver",
          });
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    afterUploadfile(data) {
      this.photo = data.filename;
      this.avatar = data.url_image;
      this.upload_path = data.upload_path;
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
                APIinterface.notify("dark", error, "error", this.$q);
              });
            //
          })
          .catch((error) => {
            APIinterface.notify("dark", error, "error", this.$q);
          });
      } else {
        this.upload_enabled = !this.upload_enabled;
      }
    },
    hadData() {
      if (Object.keys(this.photo_data).length > 0) {
        return true;
      }
      return false;
    },
    //
  },
};
</script>
