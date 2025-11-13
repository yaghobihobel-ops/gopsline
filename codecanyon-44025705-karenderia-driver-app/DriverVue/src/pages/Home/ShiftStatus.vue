<template>
  <q-pull-to-refresh @refresh="refreshShift">
    <q-page
      :class="{
        'flex flex-center': !Schedule.hasData && !Schedule.loading,
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
      }"
    >
      <template v-if="Schedule.loading">
        <div
          class="flex flex-center full-width q-pa-xl"
          style="min-height: calc(50vh)"
        >
          <q-spinner color="primary" size="2em" />
        </div>
      </template>
      <template v-else>
        <template v-if="Activity.settings_data.on_demand_availability">
          <div class="flex q-gutter-x-sm">
            <div class="">
              <div class="q-gutter-x-sm">
                <q-btn
                  :label="
                    Activity.is_online ? $t('Go offline') : $t('Go online')
                  "
                  :color="Activity.is_online ? 'red-10' : 'indigo-7'"
                  :loading="loading_online"
                  unelevated
                  size="lg"
                  no-caps
                  class="radius28"
                  @click="changeOnlineStatus(Activity.is_online ? false : true)"
                  style="min-width: 150px"
                />
                <q-btn
                  unelevated
                  color="white"
                  text-color="dark"
                  size="lg"
                  no-caps
                  class="radius28"
                  icon="tune"
                  to="/selectzone"
                />
              </div>
              <div class="q-mt-md">
                <!-- LOCATION CHECK -->
                <template v-if="location_enabled === false">
                  <q-space class="q-pa-xs"></q-space>
                  <p class="q-mb-none">
                    {{ $t("Your location is disabled") }}.
                  </p>
                  <q-btn
                    to="/location/permission"
                    :label="$t('Enabled Location')"
                    unelevated
                    color="blue"
                    class="text-weight-bold fit font16"
                    no-caps
                    size="lg"
                  />
                </template>
                <!--
                    END LOCATION CHECK
                  -->
              </div>

              <!-- WALLET BALANCE -->
              <template v-if="DriverappStore.hasBalance">
                <q-card class="no-shadow q-mt-md">
                  <q-card-section>
                    <div class="font14 text-weight-bold">
                      {{ $t("Balance") }} :
                      <span class="text-blue">{{
                        DriverappStore.wallet_balance.balance
                      }}</span>
                    </div>
                    <div class="text-grey font12">
                      {{
                        $t(
                          "Your remaining balance that you can accept cash order"
                        )
                      }}
                    </div>
                  </q-card-section>
                </q-card>
              </template>
              <!-- WALLET BALANCE -->
            </div>
          </div>
        </template>
        <template v-else>
          <template v-if="Schedule.hasData">
            <!-- WORKING STATUS -->

            <div class="row items-center q-pl-md q-pr-md q-pt-sm">
              <div class="col">
                <q-badge
                  v-if="Schedule.isWorking"
                  text-color="white"
                  style="background: #49c3a1"
                  label="Working"
                  class="q-pa-sm q-pl-md q-pr-md text-weight-bold font15"
                />
                <q-badge
                  v-else
                  text-color="white"
                  style="background: #9689e7"
                  label="Not Working"
                  class="q-pa-sm q-pl-md q-pr-md text-weight-bold font15"
                />
              </div>
              <div v-if="Schedule.hasBreak" class="col text-right">
                <q-btn
                  unelevated
                  flat
                  no-caps
                  color="blue"
                  dense
                  @click="endBreak"
                  >End Break</q-btn
                >
              </div>
            </div>
            <!-- WORKING STATUS -->

            <div class="q-pa-md text-left">
              <div class="text-h7 q-mb-sm font16">
                {{ $t("Today Schedule") }}
              </div>
              <template v-for="items in Schedule.data" :key="items">
                <q-card class="no-shadow q-mb-md">
                  <q-card-section class="q-pa-sm">
                    <div class="row items-start q-gutter-sm">
                      <div class="col-3">
                        <div class="bg-grey-2 flex flex-center rounded-borders">
                          <div class="text-center">
                            <div class="text-orange text-weight-bold font17">
                              {{ items.date_start_split.month }}
                            </div>
                            <div class="text-dark text-weight-bold font19">
                              {{ items.date_start_split.day }}
                            </div>
                            <div class="text-dark text-weight-medium font15">
                              <span
                                class="ellipsis block"
                                style="width: 80px"
                                >{{ items.date_start_split.date_string }}</span
                              >
                            </div>
                          </div>
                        </div>
                      </div>
                      <div class="col">
                        <div class="font14 text-weight-bold">
                          {{ items.time_start }} - {{ items.time_end }}
                        </div>
                        <div class="flex">
                          <q-badge color="myyellow1">
                            <q-icon name="las la-car-side" size="1.3em" />
                          </q-badge>
                          <div class="q-ml-sm font15 text-weight-medium">
                            <template
                              v-if="Schedule.vehicle_data[items.vehicle_id]"
                            >
                              {{
                                Schedule.vehicle_maker[
                                  Schedule.vehicle_data[items.vehicle_id].maker
                                ]
                              }}
                              -
                              {{
                                Schedule.vehicle_data[items.vehicle_id]
                                  .plate_number
                              }}
                            </template>
                          </div>
                        </div>
                        <!-- flex -->

                        <div class="font14 text-weight-bold ellipsis-2-lines">
                          {{ items.zone_name }}
                        </div>

                        <div class="font12 text-weight-light ellipsis-2-lines">
                          {{ items.instructions }}
                        </div>

                        <q-btn
                          v-if="Schedule.vehicle_documents[items.vehicle_id]"
                          :label="$t('View Car Documents')"
                          unelevated
                          no-caps
                          flat
                          class="q-pa-none"
                          size="lg"
                          color="amber-5"
                          @click="
                            viewDocs(
                              Schedule.vehicle_documents[items.vehicle_id]
                            )
                          "
                        ></q-btn>

                        <template v-if="items.starting_in">
                          <div class="font13 text-weight-medium text-green-5">
                            {{ $t("Starting in") }} {{ items.starting_in }}
                          </div>
                        </template>

                        <template v-if="items.shift_status == 'started'">
                          <div class="flex items-center">
                            <q-icon
                              name="las la-check-circle"
                              size="sm"
                              class="text-mygreen"
                            />
                            <div class="q-ml-sm font14 text-weight-medium">
                              {{ $t("Ongoing") }}
                            </div>
                          </div>
                        </template>
                        <!-- ongoing -->
                      </div>
                      <!-- col -->
                    </div>
                    <!-- row -->

                    <!-- <pre>=>{{ items.shift_status }}</pre> -->
                    <template
                      v-if="
                        items.shift_status == 'ready' ||
                        items.shift_status == 'late'
                      "
                    >
                      <p>{{ $t("Are you ready") }}?</p>
                      <q-btn
                        :label="$t('Start Working Now')"
                        unelevated
                        color="primary"
                        class="text-weight-bold fit font17"
                        no-caps
                        @click="startWorking(items.schedule_uuid)"
                        size="lg"
                      />
                    </template>
                    <template v-else-if="items.shift_status == 'started'">
                      <template v-if="Schedule.hasBreak">
                        <div class="text-center q-pt-md">
                          <template
                            v-if="Schedule.break_status == 'break_ended'"
                          >
                            <span class="text-red text-weight-medium">{{
                              $t("Your break is already ended")
                            }}</span>
                          </template>
                          <template v-else>
                            {{ $t("You are on break until") }}
                            <span class="text-weight-bold">{{
                              Schedule.data_break.break_until_hours
                            }}</span>
                          </template>
                        </div>
                      </template>

                      <template v-else>
                        <q-btn
                          v-if="Schedule.can_request_break"
                          :label="$t('Request Break')"
                          unelevated
                          color="primary"
                          class="text-weight-bold fit font17 q-mt-md"
                          no-caps
                          size="lg"
                          :to="{
                            name: 'request_break',
                            query: { schedule_uuid: items.schedule_uuid },
                          }"
                        />
                      </template>
                    </template>
                    <template v-else-if="items.shift_status == 'shift_ended'">
                      <p>{{ $t("Shift schedule already passed") }}</p>
                      <q-btn
                        :label="$t('Search Shifts')"
                        unelevated
                        color="primary"
                        class="text-weight-bold fit font17"
                        no-caps
                        to="/shift/find"
                        size="lg"
                      />
                    </template>
                    <template v-else-if="items.shift_status == 'ended'">
                      <p>
                        {{
                          $t(
                            "Your shift is already done please click end shift"
                          )
                        }}!
                      </p>
                      <q-btn
                        :label="$t('End shift')"
                        unelevated
                        color="red"
                        class="text-weight-bold fit"
                        no-caps
                        @click="endShift(items.schedule_uuid)"
                        size="lg"
                      />
                    </template>
                    <!-- END SHIFT STATUS -->

                    <!-- END SHIFT BUTTON -->
                    <template v-if="Activity.settings_data.enabled_end_shift">
                      <template
                        v-if="
                          items.shift_status == 'started' ||
                          items.shift_status == 'shift_ended'
                        "
                      >
                        <q-space class="q-pa-xs"></q-space>
                        <q-btn
                          :label="$t('End shift')"
                          unelevated
                          color="red"
                          class="text-weight-bold fit"
                          no-caps
                          @click="endShift(items.schedule_uuid)"
                          size="lg"
                        />
                      </template>
                    </template>
                    <!-- END SHIFT BUTTON -->

                    <!-- LOCATION CHECK -->
                    <template v-if="location_enabled === false">
                      <q-space class="q-pa-xs"></q-space>
                      <p class="q-mb-none">
                        {{ $t("Your location is disabled") }}.
                      </p>
                      <q-btn
                        to="/location/permission"
                        :label="$t('Enabled Location')"
                        unelevated
                        color="blue"
                        class="text-weight-bold fit font16"
                        no-caps
                        size="lg"
                      />
                    </template>
                    <!--
                    END LOCATION CHECK
                  -->
                  </q-card-section>
                </q-card>
              </template>

              <!-- WALLET BALANCE -->
              <template v-if="DriverappStore.hasBalance">
                <q-card class="no-shadow">
                  <q-card-section>
                    <div class="font14 text-weight-bold">
                      {{ $t("Balance") }} :
                      <span class="text-blue">{{
                        DriverappStore.wallet_balance.balance
                      }}</span>
                    </div>
                    <div class="text-grey font12">
                      {{
                        $t(
                          "Your remaining balance that you can accept cash order"
                        )
                      }}
                    </div>
                  </q-card-section>
                </q-card>
              </template>
              <!-- WALLET BALANCE -->
            </div>
          </template>
          <template v-else>
            <div class="text-center">
              <div class="font16 text-weight-bold">
                <template v-if="employment_type == 'contractor'">
                  {{ $t("You don't have any shifts starting soon") }}.
                </template>
                <template v-else>
                  You have no work schedule for today
                </template>
              </div>
              <p class="font11">
                <template v-if="employment_type == 'contractor'">
                  {{ $t("Search for more available shifts") }}
                </template>
                <template v-else>
                  {{ $t("Pull down the page to refresh") }}
                </template>
              </p>
              <q-btn
                v-if="employment_type == 'contractor'"
                :label="$t('Search Shifts')"
                unelevated
                color="primary"
                class="text-weight-bold fit font17"
                no-caps
                to="/shift/find"
                size="lg"
              />
            </div>
          </template>
        </template>
      </template>
      <!-- </div> -->

      <q-page-sticky position="bottom-right" :offset="[18, 18]">
        <q-btn
          fab
          icon="eva-message-circle-outline"
          color="green"
          to="/account/chat"
        />
      </q-page-sticky>
    </q-page>
  </q-pull-to-refresh>
  <AddCarPhoto
    ref="car_photo"
    :schedule_uuid="schedule_uuid"
    @after-attachphoto="afterAttachphoto"
  />
  <PhotoCarousel ref="photo_carousel" title="Car Documents" :data="docs_data">
  </PhotoCarousel>
</template>

<script>
import { useActivityStore } from "stores/ActivityStore";
import { useScheduleStore } from "stores/ScheduleStore";
import { useDriverappStore } from "stores/DriverappStore";
import APIinterface from "src/api/APIinterface";
import { defineAsyncComponent } from "vue";
import AppLocation from "src/api/AppLocation";
import auth from "src/api/auth";
import { Geolocation } from "@capacitor/geolocation";

export default {
  name: "ShiftStatus",
  components: {
    AddCarPhoto: defineAsyncComponent(() =>
      import("components/AddCarPhoto.vue")
    ),
    PhotoCarousel: defineAsyncComponent(() =>
      import("components/PhotoCarousel.vue")
    ),
  },
  setup() {
    const Activity = useActivityStore();
    const Schedule = useScheduleStore();
    const DriverappStore = useDriverappStore();
    return { Activity, Schedule, DriverappStore };
  },
  data() {
    return {
      loading: false,
      schedule_uuid: "",
      location_enabled: false,
      docs_data: [],
      employment_type: "",
      loading_online: false,
    };
  },
  created() {
    if (this.Activity.settings_data.on_demand_availability) {
      if (!this.Activity.is_online) {
        this.Activity.getOnlineStatus(null);
      }
    } else {
      this.Schedule.$q = this.$q;
      this.Activity.setTitle(this.$t("Status"));
      if (!this.Schedule.hadData()) {
        this.Schedule.gettShift();
      } else {
        this.Schedule.runRemainingTime();
        this.Schedule.startTimer();
      }
    }

    let $user_data = [];
    if (($user_data = auth.getUser())) {
      this.employment_type = $user_data.employment_type;
    }

    if (this.$q.capacitor) {
      this.locationEnabled();
    } else {
      this.locationWebEnabled();
    }
    if (!this.DriverappStore.wallet_balance) {
      this.DriverappStore.getRemainingCashBalance();
    }
  },
  unmounted() {
    this.Schedule.stopTimer();
  },
  mounted() {
    if (!this.DriverappStore.total_task) {
      this.DriverappStore.getTotalTask();
    }
  },
  methods: {
    async locationWebEnabled() {
      const permission = await Geolocation.checkPermissions();
      if (permission.location == "granted") {
        this.location_enabled = true;
      } else {
        this.location_enabled = false;
      }
    },
    refreshShift(done) {
      if (this.Activity.settings_data.on_demand_availability) {
        this.Activity.getOnlineStatus(done);
      } else {
        this.Schedule.refreshShift(done);
      }
      this.DriverappStore.getRemainingCashBalance();
      this.DriverappStore.getTotalTask();
    },
    startWorking(schedule_uuid) {
      this.schedule_uuid = schedule_uuid;
      let $task_take_pic = !APIinterface.empty(this.Activity.settings_data)
        ? this.Activity.settings_data.task_take_pic
        : false;
      console.log("=>" + $task_take_pic);
      if ($task_take_pic) {
        this.setPhoto();
      } else {
        this.startShift(schedule_uuid);
      }
    },
    setPhoto(schedule_uuid) {
      this.$refs.car_photo.dialog = true;
    },
    afterAttachphoto(data) {
      this.startShift(data);
    },
    startShift(schedule_uuid) {
      APIinterface.showLoadingBox("Starting", this.$q);
      APIinterface.startShift({
        schedule_uuid: schedule_uuid,
      })
        .then((data) => {
          this.Schedule.gettShift();
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    endShift(schedule_uuid) {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.endShift({
        schedule_uuid: schedule_uuid,
      })
        .then((data) => {
          this.Schedule.gettShift();
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    locationEnabled() {
      console.log("locationEnabled");
      AppLocation.islocationEnabled()
        .then((data) => {
          this.location_enabled = true;
        })
        .catch((error) => {
          this.location_enabled = false;
        });
    },
    viewDocs(data) {
      this.docs_data = data;
      this.$refs.photo_carousel.dialog = true;
    },
    endBreak(schedule_uuid) {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        "endBreak",
        "id=" + this.Schedule.data_break.id
      )
        .then((data) => {
          this.Schedule.gettShift();
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    changeOnlineStatus(data) {
      let new_data = data == true ? 1 : 0;
      this.loading_online = true;

      APIinterface.fetchDataByTokenPost(
        "changeOnlineStatus",
        "is_online=" + new_data
      )
        .then((data) => {
          this.Activity.is_online = data.details.is_online;
          if (this.Activity.is_online) {
            this.$router.push("/selectzone");
          }
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          // this.$q.loading.hide();
          this.loading_online = false;
        });
    },
  },
};
</script>
