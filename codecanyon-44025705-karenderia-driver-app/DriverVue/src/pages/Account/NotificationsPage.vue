<template>
  <q-header
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
    reveal
    reveal-offset="50"
  >
    <q-toolbar>
      <q-btn
        v-if="hold"
        @click="resetHold"
        round
        dense
        flat
        icon="close"
        color="red-5"
      />
      <q-btn
        v-else
        @click="$router.back()"
        flat
        round
        dense
        icon="las la-angle-left"
        :color="$q.dark.mode ? 'white' : 'dark'"
      />
      <q-toolbar-title class="text-grey-10">
        <template v-if="hold">
          {{ itemToDelete }} {{ $t("selected") }}
        </template>
        <template v-else> {{ $t("Notifications") }} </template>
      </q-toolbar-title>
      <q-btn
        v-if="hold"
        @click="deleteNotification"
        flat
        round
        dense
        icon="las la-trash-alt"
        color="red-5"
      />
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-pull-to-refresh @refresh="refresh">
    <q-page
      padding
      :class="{
        'flex flex-center': !hasData && !loading,
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
    >
      <q-infinite-scroll ref="nscroll" @load="getNotifications" :offset="250">
        <template v-slot:default>
          <template v-if="!hasData && !loading">
            <div class="text-center">
              <div class="font16 text-weight-bold">
                {{ $t("No available data") }}
              </div>
              <p class="font11">{{ $t("Pull down the page to refresh") }}</p>
            </div>
          </template>
          <q-list
            separator
            :class="{
              'bg-mydark ': $q.dark.mode,
              'bg-white ': !$q.dark.mode,
            }"
          >
            <template v-for="itemdata in data" :key="itemdata">
              <q-item
                clickable
                v-for="items in itemdata"
                :key="items"
                v-touch-hold.mouse="handleHold"
                tag="label"
              >
                <q-item-section avatar>
                  <template v-if="hold">
                    <q-checkbox
                      v-model="notification_uuids"
                      :val="items.notification_uuid"
                    />
                  </template>
                  <template v-else>
                    <template v-if="items.image_type === 'image'">
                      <q-avatar>
                        <q-img
                          :src="items.image"
                          style="height: 80px; width: 80px"
                          lazy
                          fit="cover"
                        />
                      </q-avatar>
                    </template>
                    <template v-else>
                      <q-avatar
                        size="md"
                        color="myyellow"
                        text-color="white"
                        icon="las la-bell"
                      />
                    </template>
                  </template>
                </q-item-section>
                <q-item-section>
                  <q-item-label class="text-weight-medium" lines="1">
                    {{ items.date }}
                  </q-item-label>
                  <q-item-label caption lines="2" class="font11">
                    {{ items.message }}
                  </q-item-label>
                </q-item-section>
              </q-item>
            </template>
          </q-list>
        </template>

        <template v-slot:loading>
          <div
            class="flex flex-center full-width q-pa-xl"
            style="min-height: calc(50vh)"
          >
            <q-spinner color="primary" size="2em" />
          </div>
        </template>
      </q-infinite-scroll>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "NotificationsPage",
  data() {
    return {
      loading: true,
      data: [],
      page: 0,
      data_done: false,
      hold: false,
      notification_uuids: [],
    };
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
    itemToDelete() {
      return Object.keys(this.notification_uuids).length;
    },
  },
  methods: {
    getNotifications(index, done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getNotification", "page=" + index)
        .then((data) => {
          this.page = index;
          this.data.push(data.details.data);
        })
        .catch((error) => {
          this.data_done = true;
          this.$refs.nscroll.stop();
        })
        .then((data) => {
          done();
          this.loading = false;
        });
    },
    // deleteNotification(index, data) {
    //   this.data.splice(index, 1);
    // },
    deleteNotification() {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByToken("deleteNotifications", {
        data: this.notification_uuids,
      })
        .then((data) => {
          this.resetHold();
          this.resetPagination();
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    handleHold(event) {
      this.hold = true;
    },
    resetHold() {
      this.hold = false;
      this.notification_uuids = [];
    },
    resetPagination() {
      this.page = 0;
      this.data = [];
      this.$refs.nscroll.reset();
      this.$refs.nscroll.resume();
      this.$refs.nscroll.trigger();
    },
    refresh(done) {
      this.resetPagination();
      this.page = 0;
      done();
    },
    //
  },
};
</script>
