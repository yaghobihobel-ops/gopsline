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
          {{ $t("Update Booking") }}
        </template>
        <template v-else>
          {{ $t("Add Booking") }}
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
      <q-select
        v-model="client_id"
        :label="$t('Customer')"
        behavior="dialog"
        use-input
        hide-selected
        fill-input
        input-debounce="0"
        outlined
        :options="customer_list"
        @filter="filterFn"
        @update:model-value="setModel"
        color="grey-5"
        stack-label
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
        emit-value
        map-options
      >
        <template v-slot:no-option>
          <q-item>
            <q-item-section class="text-grey">
              {{ $t("No results") }}
            </q-item-section>
          </q-item>
        </template>
      </q-select>

      <!-- <q-space class="q-pa-sm"></q-space> -->

      <q-input
        v-model="reservation_date"
        :rules="['date']"
        outlined
        color="grey-5"
        :label="$t('Reservation date')"
        stack-label
        readonly
      >
        <template v-slot:append>
          <q-icon name="event" class="cursor-pointer" color="blue">
            <q-popup-proxy
              cover
              transition-show="scale"
              transition-hide="scale"
            >
              <q-date v-model="reservation_date" color="blue">
                <div class="row items-center justify-end">
                  <q-btn
                    v-close-popup
                    :label="$t('Close')"
                    color="dark"
                    flat
                    no-caps
                  />
                </div>
              </q-date>
            </q-popup-proxy>
          </q-icon>
        </template>
      </q-input>

      <q-input
        v-model="reservation_time"
        mask="time"
        :rules="['time']"
        outlined
        color="grey-5"
        :label="$t('Reservation time')"
        stack-label
        readonly
      >
        <template v-slot:append>
          <q-icon name="access_time" class="cursor-pointer" color="blue">
            <q-popup-proxy
              cover
              transition-show="scale"
              transition-hide="scale"
            >
              <q-time
                v-model="reservation_time"
                color="blue"
                mask="hh:mm"
                format24h
              >
                <div class="row items-center justify-end">
                  <q-btn
                    v-close-popup
                    :label="$t('Close')"
                    color="dark"
                    flat
                    no-caps
                  />
                </div>
              </q-time>
            </q-popup-proxy>
          </q-icon>
        </template>
      </q-input>

      <q-input
        v-model="guest_number"
        type="number"
        :label="$t('Guest number')"
        stack-label
        outlined
        color="grey-5"
        :rules="[(val) => val > 0 || this.$t('This field is required')]"
      />

      <q-select
        v-model="table_id"
        :options="DataStore.table_list"
        :label="$t('Table name')"
        stack-label
        behavior="dialog"
        outlined
        color="grey-5"
        emit-value
        map-options
        :rules="[(val) => val || this.$t('This field is required')]"
      />

      <q-input
        v-model="special_request"
        :label="$t('Special request')"
        stack-label
        outlined
        color="grey-5"
        autogrow
      />

      <q-space class="q-pa-sm"></q-space>

      <q-select
        v-model="status"
        :options="DataStore.booking_status_list_value"
        :label="$t('Status')"
        stack-label
        behavior="dialog"
        outlined
        color="grey-5"
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
        emit-value
        map-options
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
        />
      </q-footer>
    </q-form>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";

export default {
  name: "TableForms",
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  data() {
    return {
      loading: false,
      data: [],
      client_id: [],
      reservation_date: "",
      reservation_time: "",
      guest_number: 0,
      table_id: "",
      special_request: "",
      status: "pending",
      room_names: [],
      table_names: [
        {
          label: this.$t("Please select"),
          value: 0,
        },
      ],
      status_list: [],
      customer_list: [],
    };
  },
  created() {
    this.DataStore.getTableList();
  },
  mounted() {
    this.id = this.$route.query.id;
    if (!APIinterface.empty(this.id)) {
      this.getBookingDetails();
    }
  },
  computed: {
    isEdit() {
      if (!APIinterface.empty(this.id)) {
        return true;
      }
      return false;
    },
  },
  methods: {
    formSubmit() {
      let params = {
        id: !APIinterface.empty(this.id) ? this.id : "",
        client_id: this.client_id,
        reservation_date: this.reservation_date,
        reservation_time: this.reservation_time,
        guest_number: this.guest_number,
        table_id: this.table_id,
        special_request: this.special_request,
        status: this.status,
      };
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        !APIinterface.empty(this.id) ? "UpdateBooking" : "AddBooking",
        params
      )
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);

          if (!APIinterface.empty(this.id)) {
            this.$router.replace({
              path: "/tables/reservation_overview",
              query: { id: data.details.id },
            });
          } else {
            this.$router.replace({
              path: "/table/menu",
            });
          }
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    filterFn(val, update, abort) {
      if (val.length < 2) {
        abort();
        return;
      }
      APIinterface.fetchDataByTokenPost("SearchCustomer", "q=" + val)
        .then((data) => {
          update(() => {
            this.customer_list = data.details.data;
          });
        })
        .catch((error) => {
          console.debug(error);
        })
        .then((data) => {});
    },
    setModel(val) {
      console.log(val);
      //this.client_id = val;
    },
    getBookingDetails() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "getBookingDetails",
        "id=" + this.id + "&payload=update"
      )
        .then((data) => {
          this.data = data.details.data;
          this.room_names = data.details.room_names;
          this.table_names = data.details.table_names;
          this.status_list = data.details.status_list;

          this.client_id = this.data.client_id;
          this.reservation_date = this.data.reservation_date_raw;
          this.reservation_time = this.data.reservation_time_raw;
          this.guest_number = parseInt(this.data.guest_number_raw);
          this.table_id = parseInt(this.data.table_id);
          this.special_request = this.data.special_request;
          this.status = this.data.status;
          this.customer_list = data.details.customer_list;
        })
        .catch((error) => {})
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
