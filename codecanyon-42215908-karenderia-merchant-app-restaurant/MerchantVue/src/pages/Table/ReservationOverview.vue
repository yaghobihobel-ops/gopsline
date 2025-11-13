<template>
  <q-header
    :class="{
      'beautiful-shadow': isScrolled,
    }"
    class="bg-white text-dark"
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
      <q-toolbar-title class="text-weight-bold">
        {{ $t("Overview") }}
      </q-toolbar-title>
      <q-space></q-space>
      <template
        v-if="AccessStore.hasAccess('booking.reservation_delete') && hasData"
      >
        <q-btn
          round
          color="red-1"
          text-color="red-9"
          icon="las la-trash"
          unelevated
          dense
          @click="this.$refs.ref_delete.confirm()"
        />
      </template>
    </q-toolbar>
  </q-header>
  <q-pull-to-refresh @refresh="refresh">
    <q-page class="bg-white text-dark" padding>
      <q-scroll-observer @scroll="onScroll" scroll-target="body" />

      <template v-if="loading">
        <q-inner-loading
          :showing="true"
          color="primary"
          size="md"
          label-class="dark"
          class="transparent"
        />
      </template>

      <template v-if="hasData">
        <q-list>
          <q-item>
            <q-item-section avatar>
              <q-avatar size="60px">
                <q-img :src="customer_data.avatar">
                  <template v-slot:loading>
                    <q-skeleton
                      height="60px"
                      width="60px"
                      square
                      class="bg-grey-2"
                    />
                  </template>
                </q-img>
              </q-avatar>
            </q-item-section>
            <q-item-section>
              <q-item-label class="text-weight-bold text-capitalize"
                >{{ customer_data.first_name }}
                {{ customer_data.last_name }}</q-item-label
              >
              <q-item-label>
                {{ $t("Phone") }}: {{ customer_data.contact_phone }}
              </q-item-label>
              <q-item-label>
                {{ $t("Email") }}: {{ customer_data.email_address }}
              </q-item-label>
            </q-item-section>
          </q-item>
        </q-list>

        <!-- <pre>{{ data_summary }}</pre> -->
        <q-list class="q-pa-md">
          <q-virtual-scroll
            :items="data_summary"
            virtual-scroll-horizontal
            v-slot="{ item }"
          >
            <q-btn
              color="teal-1"
              text-color="teal-9"
              unelevated
              no-caps
              class="q-mr-sm radius10"
              outlinex
            >
              <span class="text-caption q-mr-xs">({{ item.value }})</span>
              {{ item.label }}
            </q-btn>
          </q-virtual-scroll>
        </q-list>

        <div v-if="hasData">
          <q-tabs
            v-model="tab"
            dense
            active-color="primary"
            active-class="active-tabs"
            indicator-color="primary"
            align="justify"
            narrow-indicator
            no-caps
            @update:model-value="TabChange"
          >
            <q-tab name="details" :label="$t('Details')" />
            <q-tab name="customer" :label="$t('Customer')" />
            <q-tab name="timeline" :label="$t('Timeline')" />
            <q-tab name="reservation" :label="$t('Reservation')" />
          </q-tabs>
        </div>

        <q-tab-panels v-model="tab">
          <q-tab-panel name="details">
            <q-list>
              <q-item class="q-pa-none">
                <q-item-section>
                  <q-item-label lines="1">{{
                    $t("Reservation ID")
                  }}</q-item-label>
                  <q-item-label caption>{{ data.reservation_id }}</q-item-label>
                </q-item-section>
              </q-item>
              <q-item class="q-pa-none">
                <q-item-section>
                  <q-item-label lines="1">{{ $t("Guest") }}</q-item-label>
                  <q-item-label caption>{{ data.guest_number }}</q-item-label>
                </q-item-section>
              </q-item>
              <q-item class="q-pa-none">
                <q-item-section>
                  <q-item-label lines="1">{{ $t("Date/Time") }}</q-item-label>
                  <q-item-label caption
                    >{{ data.reservation_date }}
                    {{ data.reservation_time }}</q-item-label
                  >
                </q-item-section>
              </q-item>
              <q-item class="q-pa-none">
                <q-item-section>
                  <q-item-label lines="1">{{ $t("Table/Room") }}</q-item-label>
                  <q-item-label caption>
                    <template v-if="table_names[data.table_id]">{{
                      table_names[data.table_id]
                    }}</template>
                    /
                    <template v-if="room_names[data.room_id]">
                      {{ room_names[data.room_id] }}
                    </template>
                  </q-item-label>
                </q-item-section>
              </q-item>
              <q-item class="q-pa-none">
                <q-item-section>
                  <q-item-label lines="1">{{ $t("Date booked") }}</q-item-label>
                  <q-item-label caption>
                    {{ data.reservation_datetime }}
                  </q-item-label>
                </q-item-section>
              </q-item>
              <q-item class="q-pl-none q-pr-none">
                <!-- <pre>{{ data }}</pre> -->
                <q-btn
                  :color="OrderStore.statusBookingColor[data.status]?.bg"
                  :text-color="OrderStore.statusBookingColor[data.status]?.text"
                  :label="data.status_pretty1"
                  class="radius10 fit"
                  no-caps
                  unelevated
                  padding="10px"
                >
                  <q-menu
                    fit
                    anchor="bottom left"
                    self="top left"
                    class="footer-shadow"
                  >
                    <q-list>
                      <template
                        v-for="(
                          status, status_raw
                        ) in DataStore.booking_status_list"
                        :key="status"
                      >
                        <q-item
                          v-if="status_raw != data.status"
                          clickable
                          v-close-popup
                          @click="
                            changeStatus(data.reservation_uuid, status_raw)
                          "
                        >
                          <q-item-section>{{ status }}</q-item-section>
                        </q-item>
                        <q-separator />
                      </template>
                    </q-list>
                  </q-menu>
                </q-btn>
              </q-item>
            </q-list>
          </q-tab-panel>

          <q-tab-panel name="customer">
            <q-list>
              <q-item class="q-pa-none">
                <q-item-section>
                  <q-item-label lines="1">{{ $t("Name") }}</q-item-label>
                  <q-item-label caption>{{ data.full_name }}</q-item-label>
                </q-item-section>
              </q-item>
              <q-item class="q-pa-none">
                <q-item-section>
                  <q-item-label lines="1">{{ $t("Email") }}</q-item-label>
                  <q-item-label caption>{{ data.email_address }}</q-item-label>
                </q-item-section>
              </q-item>
              <q-item class="q-pa-none">
                <q-item-section>
                  <q-item-label lines="1">{{ $t("Phone") }}</q-item-label>
                  <q-item-label caption>{{ data.contact_phone }}</q-item-label>
                </q-item-section>
              </q-item>
              <q-item class="q-pa-none">
                <q-item-section>
                  <q-item-label lines="1">{{
                    $t("Special Request")
                  }}</q-item-label>
                  <q-item-label caption>
                    {{ data.special_request }}
                  </q-item-label>
                  <q-item-label caption v-if="data.cancellation_reason">
                    {{ $t("CANCELLATION NOTES") }} =
                    {{ data.cancellation_reason }}
                  </q-item-label>
                </q-item-section>
              </q-item>
            </q-list>
          </q-tab-panel>

          <q-tab-panel name="timeline" class="no-shadow q-pl-none q-pr-none">
            <div class="q-pl-md">
              <q-timeline color="secondary" layout="dense">
                <template v-for="timeline in timeline" :key="timeline">
                  <q-timeline-entry>
                    <template v-slot:title>
                      <div class="text-grey">
                        {{ timeline.timestamp }}
                      </div></template
                    >
                    <template v-slot:subtitle>
                      {{ timeline.content }}
                    </template>

                    <div>{{ timeline.remarks }}</div>
                  </q-timeline-entry>
                </template>
              </q-timeline>
            </div>
          </q-tab-panel>

          <q-tab-panel name="reservation" class="no-shadow q-pl-none q-pr-none">
            <q-list>
              <q-virtual-scroll
                class="fit"
                separator
                :items="booking_data"
                :virtual-scroll-item-size="48"
                v-slot="{ item: items, index }"
              >
                <BookingItem
                  :items="items"
                  :index="index"
                  :statusColor="OrderStore.statusBookingColor"
                  @after-update="afterUpdate"
                ></BookingItem>
              </q-virtual-scroll>
            </q-list>

            <q-infinite-scroll
              ref="nscroll"
              @load="fetchReservation"
              :offset="350"
              :disable="scroll_disabled"
            >
              <template v-slot:default>
                <NoData
                  v-if="!hasItems && !booking_loading"
                  :isCenter="false"
                />
              </template>
              <template v-slot:loading>
                <LoadingData :page="page"></LoadingData>
              </template>
            </q-infinite-scroll>
          </q-tab-panel>
        </q-tab-panels>
      </template>

      <DeleteComponents
        ref="ref_delete"
        @afterConfirm="deleteBooking"
      ></DeleteComponents>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import { useAccessStore } from "stores/AccessStore";
import { useOrderStore } from "stores/OrderStore";

export default {
  name: "ReservationOverview",
  components: {
    BookingItem: defineAsyncComponent(() =>
      import("components/BookingItem.vue")
    ),
    DeleteComponents: defineAsyncComponent(() =>
      import("components/DeleteComponents.vue")
    ),
    LoadingData: defineAsyncComponent(() =>
      import("components/LoadingData.vue")
    ),
    NoData: defineAsyncComponent(() => import("components/NoData.vue")),
  },
  setup() {
    const DataStore = useDataStore();
    const AccessStore = useAccessStore();
    const OrderStore = useOrderStore();
    return { DataStore, AccessStore, OrderStore };
  },
  data() {
    return {
      data: [],
      id: "",
      loading: false,
      loading_update: false,
      room_names: [],
      table_names: [],
      tab: "details",
      step: 0,
      loading_summary: true,
      data_summary: [],
      timeline: [],
      booking_loading: false,
      booking_data: [],
      page: 1,
      is_refresh: undefined,
      data_done: false,
      status: [],
      customer_data: [],
      isScrolled: false,
      scroll_disabled: true,
      hasMore: true,
    };
  },
  mounted() {
    this.id = this.$route.query.id;
    this.getBookingDetails();
  },
  watch: {
    "$route.query.id"(newId, oldId) {
      if (newId !== oldId) {
        this.id = newId;
        this.tab = "details";
        this.getBookingDetails();
      }
    },
  },
  computed: {
    getData() {
      return this.data;
    },
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
    hasItems() {
      return this.booking_data.length > 0;
    },
  },
  methods: {
    async changeStatus(reservation_uuid, status) {
      try {
        APIinterface.showLoadingBox("", this.$q);
        const params = new URLSearchParams({
          id: reservation_uuid,
          status: status,
        }).toString();
        await APIinterface.fetchDataByTokenPost("UpdateBookingStatus", params);
        this.DataStore.cleanData("booking_data");
        this.getBookingDetails();
      } catch (error) {
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
    onScroll(info) {
      if (!info) {
        return;
      }
      this.isScrolled = info.position.top > 20;
    },
    refresh(done) {
      setTimeout(() => {
        done();
      }, 100);
      this.refreshAll();
    },
    refreshAll() {
      this.getBookingDetails();
      setTimeout(() => {
        this.resetPagination();
      }, 100);
    },
    resetPagination() {
      this.page = 1;
      this.booking_data = [];
      this.hasMore = true;
      this.scroll_disabled = false;
      this.$nextTick(() => {
        this.$refs.nscroll?.resume?.();
        this.$refs.nscroll?.trigger?.();
      });
    },
    TabChange(data) {
      console.log("TabChange", data);
      if (data == "reservation") {
        this.scroll_disabled = false;
      } else {
        this.scroll_disabled = true;
      }
    },
    getBookingDetails() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getBookingDetails", "id=" + this.id)
        .then((data) => {
          this.data = data.details.data;
          this.room_names = data.details.room_names;
          this.table_names = data.details.table_names;
          this.timeline = data.details.timeline;
          this.customer_data = data.details.customer_data;
          this.data_summary = data.details.summary;
          this.step = 3;
        })
        .catch((error) => {})
        .then((data) => {
          this.loading = false;
        });
    },
    async fetchReservation(index, done) {
      try {
        if (this.booking_loading) {
          return;
        }

        if (!this.hasMore) {
          this.scroll_disabled = true;
          done(true);
          return;
        }
        this.booking_loading = true;

        const params = new URLSearchParams({
          page: this.page,
        }).toString();

        const response = await APIinterface.fetchGet(
          `reservationList?${params}`
        );
        console.log("response", response);
        this.page++;
        this.booking_data = [...this.booking_data, ...response.details.data];

        if (response.details?.is_last_page) {
          this.hasMore = false;
          this.scroll_disabled = true;
          done(true);
          return;
        }
        done();
      } catch (error) {
        done(true);
      } finally {
        this.booking_loading = false;
      }
    },
    afterUpdate(index, value) {
      this.booking_data[index] = value;
      setTimeout(() => {
        this.fetchSummary();
      }, 500);

      setTimeout(() => {
        this.OrderStore.fetchReservationcount();
      }, 1000);
    },
    confirmDelete() {
      this.$refs.ref_delete.confirm();
    },
    deleteBooking() {
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });
      APIinterface.fetchDataByTokenPost("deleteBooking", "id=" + this.id)
        .then((data) => {
          APIinterface.ShowSuccessful(data.msg, this.$q);
          this.DataStore.cleanData("booking_data");
          this.$router.replace({
            path: "/table",
          });
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.$q.loading.hide();
        });
    },
    //
  },
};
</script>
