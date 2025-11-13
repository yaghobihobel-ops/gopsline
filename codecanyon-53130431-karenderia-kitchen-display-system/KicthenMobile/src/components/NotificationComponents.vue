<template>
  <template v-if="$q.screen.lt.md">
    <q-btn
      :color="$q.dark.mode ? 'grey300' : 'dark'"
      icon-right="eva-bell-outline"
      no-caps
      unelevated
      flat
      rounded
      to="/notification-list"
    >
      <q-badge
        v-if="KitchenStore.getNotificationCount > 0"
        color="red"
        floating
        rounded
      >
        {{ KitchenStore.getNotificationCount }}
      </q-badge></q-btn
    >
  </template>
  <template v-else>
    <q-btn
      :color="$q.dark.mode ? 'grey300' : 'dark'"
      icon-right="eva-bell-outline"
      no-caps
      unelevated
      flat
      rounded
    >
      <q-badge
        v-if="KitchenStore.getNotificationCount > 0"
        color="red"
        floating
        rounded
      >
        {{ KitchenStore.getNotificationCount }}
      </q-badge>
      <q-menu transition-show="slide-up" class="box-shadow">
        <q-card style="min-width: 380px" class="q-pa-sm relative-position">
          <q-inner-loading
            :showing="KitchenStore.notification_loading"
            color="primary"
          ></q-inner-loading>

          <!-- <pre>{{ KitchenStore.getNotificationList }}</pre> -->

          <template v-if="KitchenStore.getNotificationCount > 0">
            <q-list separator style="max-height: calc(50vh)" class="scroll">
              <q-item-label header class="text-dark">
                <div class="flex justify-between items-center">
                  <div>
                    {{
                      $t("total_messages", {
                        count: KitchenStore.getNotificationCount,
                      })
                    }}
                  </div>
                  <div>
                    <q-btn
                      :label="$t('Clear')"
                      no-caps
                      flat
                      color="blue"
                      @click="KitchenStore.clearNotification()"
                    ></q-btn>
                  </div>
                </div>
              </q-item-label>
              <q-separator />
              <template
                v-for="items in KitchenStore.getNotificationList"
                :key="items"
              >
                <q-item clickable v-close-popup>
                  <q-item-section avatar>
                    <q-icon name="eva-bell-outline"></q-icon>
                  </q-item-section>
                  <q-item-section>
                    <q-item-label>{{ items.message }}</q-item-label>
                    <q-item-label caption class="text-grey-5">{{
                      items.date
                    }}</q-item-label>
                  </q-item-section>
                </q-item>
              </template>
            </q-list>
            <q-separator />
            <q-card-actions>
              <q-btn
                flat
                :label="$t('See all Messages')"
                no-caps
                class="fit text-weight-regular"
                to="/notification-list"
              ></q-btn>
            </q-card-actions>
          </template>
          <template v-else>
            <div
              style="min-height: calc(50vh)"
              class="flex flex-center text-center"
            >
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
        </q-card>
      </q-menu>
    </q-btn>
  </template>
</template>

<script>
import { useKitchenStore } from "stores/KitchenStore";

export default {
  name: "NotificationComponents",
  setup() {
    const KitchenStore = useKitchenStore();
    return { KitchenStore };
  },
  mounted() {
    this.KitchenStore.getNotifications();

    if (this.KitchenStore.realtime_data) {
      this.incomingPush();
    } else {
      this.$watch(
        () => this.KitchenStore.$state.realtime_data,
        (newData, oldData) => {
          this.incomingPush();
        }
      );
    }
  },
  methods: {
    incomingPush() {
      //console.log("incomingPush", this.KitchenStore.realtime_data);
    },
    clearNotification() {},
  },
};
</script>
