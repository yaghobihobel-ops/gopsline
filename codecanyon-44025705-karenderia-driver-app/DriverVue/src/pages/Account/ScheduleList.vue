<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page :class="{ 'flex flex-center': !hasData && !loading }">
      <div class="q-pa-md">
        <q-infinite-scroll ref="nscroll" @load="getHistory" :offset="300">
          <template v-slot:default>
            <template v-if="!hasData && !loading">
              <div class="text-center">
                <div class="font16 text-weight-bold">
                  {{ $t("No available data") }}
                </div>
                <p class="font11">{{ $t("Pull down the page to refresh") }}</p>
              </div>
            </template>

            <template v-for="itemdata in data" :key="itemdata">
              <q-card
                v-for="items in itemdata"
                :key="items"
                class="no-shadow q-mb-md"
              >
                <q-list separator>
                  <q-item>
                    <q-item-section>
                      <q-item-label class="text-weight-bold">{{
                        $t("Schedule")
                      }}</q-item-label>
                      <q-item-label lines="2" class="font12" caption>
                        {{ items.time_start }} - {{ items.time_end }}
                      </q-item-label>
                    </q-item-section>
                    <q-item-section side>
                      <q-item-label class="text-weight-boldx">{{
                        $t("Start/Finish at")
                      }}</q-item-label>
                      <q-item-label lines="2" class="font12" caption>
                        <template v-if="items.shift_time_ended">
                          {{ items.shift_time_started }} -
                          {{ items.shift_time_ended }}
                        </template>
                        <template v-else> {{ $t("N/A") }} </template>
                      </q-item-label>
                    </q-item-section>
                  </q-item>
                  <q-item>
                    <q-item-section>
                      <q-item-label caption>{{
                        $t("Vehicle Type")
                      }}</q-item-label>
                      <q-item-label lines="2" class="font12">
                        {{ items.maker }}
                      </q-item-label>
                    </q-item-section>
                    <q-item-section side>
                      <q-item-label class="text-weight-boldx">{{
                        $t("Deliveries")
                      }}</q-item-label>
                      <q-item-label lines="2" class="font12" caption>
                        {{ items.total_delivered }}
                      </q-item-label>
                    </q-item-section>
                  </q-item>
                  <q-item>
                    <q-item-section>
                      <q-item-label caption>{{ $t("Plate #") }}</q-item-label>
                      <q-item-label lines="2" class="font12">{{
                        items.vehicle.plate_number
                      }}</q-item-label>
                    </q-item-section>
                  </q-item>
                  <q-item>
                    <q-item-section>
                      <q-item-label caption>{{ $t("Notes") }}</q-item-label>
                      <q-item-label lines="2" class="font12">{{
                        items.instructions
                      }}</q-item-label>
                    </q-item-section>
                  </q-item>
                </q-list>
              </q-card>
            </template>
          </template>
          <!-- end defualt -->
          <template v-slot:loading>
            <div
              class="flex flex-center full-width q-pa-xl"
              style="min-height: calc(40vh)"
            >
              <q-spinner color="primary" size="2em" />
            </div>
          </template>
        </q-infinite-scroll>
      </div>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { useActivityStore } from "stores/ActivityStore";
import { ShiftHistoryStore } from "stores/MyScheduleStore";
import APIinterface from "src/api/APIinterface";
import { defineAsyncComponent } from "vue";

export default {
  name: "ScheduleList",
  components: {
    // LoaderOrder: defineAsyncComponent(() =>
    //   import("components/LoaderOrder.vue")
    // ),
  },
  setup() {
    const Activity = useActivityStore();
    const history = ShiftHistoryStore();
    return { Activity, history };
  },
  data() {
    return {
      loading: false,
      data: [],
      loading_count: 2,
      page: 0,
    };
  },
  created() {
    this.Activity.setTitle(this.$t("My Schedule"));
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
    page(newval, oldval) {
      if (this.page > 0) {
        this.loading_count = 1;
      } else this.loading_count = 2;
    },
  },
  methods: {
    getHistory(index, done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("shifthistory", "page=" + index)
        .then((data) => {
          this.page = index;
          this.data.push(data.details.data);
        })
        .catch((error) => {
          this.$refs.nscroll.stop();
        })
        .then((data) => {
          done();
          this.loading = false;
        });
    },
    resetPagination() {
      this.data = [];
      this.page = 0;
      this.$refs.nscroll.reset();
      this.$refs.nscroll.resume();
      this.$refs.nscroll.trigger();
    },
    refresh(done) {
      this.resetPagination();
      APIinterface.fetchDataByTokenPost("shifthistory", "page=" + 1)
        .then((data) => {
          this.page = index;
          this.data.push(data.details.data);
        })
        .catch((error) => {
          this.$refs.nscroll.stop();
        })
        .then((data) => {
          done();
        });
    },
  },
};
</script>
