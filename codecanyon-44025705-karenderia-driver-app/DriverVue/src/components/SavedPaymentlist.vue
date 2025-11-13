<template>
  <template v-if="loading">
    <div
      class="flex flex-center full-width q-pa-xl"
      style="min-height: calc(40vh)"
    >
      <q-spinner color="primary" size="2em" />
    </div>
  </template>
  <template v-else>
    <template v-if="!hasData"> </template>
    <template v-else>
      <q-list>
        <transition
          v-for="items in data"
          :key="items"
          appear
          leave-active-class="animated fadeOut"
          :class="{
            'bg-mydark ': $q.dark.mode,
            'bg-white ': !$q.dark.mode,
          }"
        >
          <q-slide-item
            @action="deletePayment(index, items)"
            :right-color="$q.dark.mode ? 'mydark' : 'white'"
          >
            <template v-slot:right>
              <q-btn
                unelevated
                round
                color="red-5"
                text-color="white"
                icon="eva-trash-outline"
                dense
              />
            </template>
            <q-item
              @click.stop="setDefault(items.payment_uuid)"
              tag="label"
              clickable
              v-ripple
              class="border-grey radius10 q-mb-sm"
              :class="{
                'bg-dark text-white': $q.dark.mode,
                'bg-white text-black': !$q.dark.mode,
              }"
            >
              <q-item-section>
                <q-item-label>{{ items.payment_name }}</q-item-label>
                <q-item-label caption>{{ items.attr2 }}</q-item-label>
              </q-item-section>
              <q-item-section side>
                <q-radio
                  v-model="payment_uuid"
                  :val="items.payment_uuid"
                  color="primary"
                />
              </q-item-section>
            </q-item>
          </q-slide-item>
        </transition>
      </q-list>
    </template>
  </template>
</template>

<script>
import APIinterface from "src/api/APIinterface";
export default {
  name: "SavedPaymentlist",
  data() {
    return {
      payment_uuid: "",
      data: [],
      loading: false,
    };
  },
  created() {
    this.getPaymentSaved();
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  watch: {
    payment_uuid(newval, oldval) {
      this.$emit("setPaymentuuid", newval);
    },
  },
  methods: {
    refreshList(done) {
      this.getPaymentSaved(done);
    },
    getPaymentSaved(done) {
      this.loading = true;
      this.$emit("setLoading", true);
      APIinterface.fetchDataByTokenPost("getPaymentSaved")
        .then((data) => {
          this.data = data.details.data;
          this.payment_uuid = data.details.default_payment_uuid.payment_uuid;
          this.$emit("afterGetpayment", true);
        })
        .catch((error) => {
          this.data = [];
          this.payment_uuid = "";
          this.$emit("afterGetpayment", false);
        })
        .then((data) => {
          this.loading = false;
          this.$emit("setLoading", false);
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    deletePayment(index, data) {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        "deletePayment",
        "payment_uuid=" + data.payment_uuid
      )
        .then((data) => {
          this.getPaymentSaved(null);
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    setDefault(payment_uuid) {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        "setDefaultPayment",
        "payment_uuid=" + payment_uuid
      )
        .then((data) => {
          APIinterface.notify("green-5", data.msg, "check_circle", this.$q);
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    //
  },
};
</script>
