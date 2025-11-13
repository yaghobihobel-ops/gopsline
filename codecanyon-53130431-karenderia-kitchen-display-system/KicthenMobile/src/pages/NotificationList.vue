<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-infinite-scroll ref="nscroll" @load="onLoad" :offset="250">
      <TopNav :title="$t('Notifications')"></TopNav>
      <q-page
        padding
        class="flex justify-center"
        :class="{ 'bg-grey600': $q.dark.mode }"
      >
        <q-card flat class="box-shadow card-form-height fit">
          <template v-if="loading">
            <template v-for="items in 10" :key="items">
              <q-item>
                <q-item-section avatar>
                  <q-skeleton type="QAvatar" />
                </q-item-section>

                <q-item-section>
                  <q-item-label>
                    <q-skeleton type="text" />
                  </q-item-label>
                  <q-item-label caption>
                    <q-skeleton type="text" width="65%" />
                  </q-item-label>
                </q-item-section>
              </q-item>
            </template>
          </template>
          <template v-else>
            <template v-if="hasData">
              <q-card-section>
                <q-list separator>
                  <q-item-label header class="text-dark">
                    {{
                      $t("total_messages", {
                        count: KitchenStore.getNotificationCount,
                      })
                    }}
                  </q-item-label>
                  <template v-for="list in data" :key="list">
                    <template v-for="items in list" :key="items">
                      <q-item tag="label">
                        <q-item-section>
                          <q-item-label>
                            {{ items.message }}
                          </q-item-label>
                          <q-item-label caption class="text-grey-5">
                            {{ items.date_created }}
                          </q-item-label>
                        </q-item-section>
                        <!-- <q-item-section> 52 minutes ago </q-item-section> -->
                      </q-item>
                    </template>
                  </template>
                </q-list>
                <div class="flex justify-center q-pa-md">
                  <template v-if="more_loading">
                    <q-spinner-puff color="deep-orange" size="3em" />
                  </template>
                  <template v-if="end_results">
                    <div class="text-grey-5">{{ $t("end of results") }}</div>
                  </template>
                </div>
              </q-card-section>
            </template>
            <template v-else>
              <div class="border flex flex-center card-form-height text-center">
                <div>
                  <div class="text-body1">
                    {{ $t("No notifications yet") }}
                  </div>
                  <div class="text-caption">
                    {{ $t("When you get notifications, they'll show up here") }}
                  </div>
                </div>
              </div>
            </template>
          </template>
        </q-card>
      </q-page>
    </q-infinite-scroll>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useKitchenStore } from "stores/KitchenStore";
import { defineAsyncComponent } from "vue";

export default {
  name: "NotificationList",
  components: {
    TopNav: defineAsyncComponent(() => import("components/TopNav.vue")),
  },
  data() {
    return {
      data: [],
      selected: [],
      loading: false,
      more_loading: false,
      page: 0,
      end_results: true,
      is_done: null,
    };
  },
  setup() {
    const KitchenStore = useKitchenStore();
    return { KitchenStore };
  },
  mounted() {},
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    refresh(done) {
      this.data = [];
      this.$refs.nscroll.reset();
      this.$refs.nscroll.resume();
      this.$refs.nscroll.trigger();
      this.is_done = done;
    },
    onLoad(index, done) {
      this.end_results = false;
      this.loading = index > 1 ? false : true;
      this.more_loading = index > 1 ? true : false;
      APIinterface.fetchDataGet("notificationList", "page=" + index)
        .then((data) => {
          this.data.push(data.data);
        })
        .catch((error) => {
          this.end_results = true;
          this.$refs.nscroll.stop();
        })
        .then((data) => {
          this.loading = false;
          this.more_loading = false;
          done();
          if (this.is_done) {
            this.is_done();
          }
        });
    },
  },
};
</script>
