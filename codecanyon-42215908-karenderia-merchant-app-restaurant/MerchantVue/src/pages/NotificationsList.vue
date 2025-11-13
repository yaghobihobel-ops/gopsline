<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page class="q-pa-md bg-grey-1">
      <q-list>
        <q-virtual-scroll
          class="fit"
          separator
          :items="data"
          :virtual-scroll-item-size="60"
          v-slot="{ item: items }"
        >
          <q-card flat class="myshadow bg-white q-mb-md">
            <q-item clickable v-ripple:purple @click="ViewNotifications(items)">
              <q-item-section avatar>
                <q-btn
                  round
                  color="lavender"
                  text-color="green"
                  unelevated
                  dense
                >
                  <img
                    v-if="items.notification_type == 'chat'"
                    src="/svg/chat.svg"
                    height="20"
                  />
                  <img v-else src="/svg/orders.svg" height="20" />
                </q-btn>
              </q-item-section>
              <q-item-section>
                <q-item-label class="text-text">
                  {{ items.message }}
                </q-item-label>
                <q-item-label caption> {{ items.date }}</q-item-label>
              </q-item-section>
              <q-item-section top side v-if="!items.viewed">
                <q-icon name="circle" size="0.9em" color="red"></q-icon>
              </q-item-section>
            </q-item>
          </q-card>
        </q-virtual-scroll>
      </q-list>

      <q-infinite-scroll
        ref="nscroll"
        @load="fetchData"
        :offset="250"
        :disable="scroll_disabled"
      >
        <template v-slot:default>
          <NoData
            v-if="!hasItems && !loading"
            message="No notifications yet"
            icon="/svg/no-notication.svg"
          />
        </template>
        <template v-slot:loading>
          <LoadingData :page="page"></LoadingData>
        </template>
      </q-infinite-scroll>

      <q-space class="q-pa-lg"></q-space>

      <DeleteComponents ref="ref_delete" @after-confirm="afterConfirm">
      </DeleteComponents>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "src/stores/DataStore";
import { defineAsyncComponent } from "vue";
import { useAccessStore } from "stores/AccessStore";
import { useOrderStore } from "src/stores/OrderStore";

export default {
  name: "SizeList",
  components: {
    DeleteComponents: defineAsyncComponent(() =>
      import("components/DeleteComponents.vue")
    ),
    NoData: defineAsyncComponent(() => import("components/NoData.vue")),
    LoadingData: defineAsyncComponent(() =>
      import("components/LoadingData.vue")
    ),
  },
  data() {
    return {
      scroll_disabled: true,
      hasMore: true,
      loading: false,
      page: 1,
      data: [],
      id: null,
      selected_items: [],
      total_items: null,
    };
  },
  setup() {
    const DataStore = useDataStore();
    const AccessStore = useAccessStore();
    const OrderStore = useOrderStore();
    return {
      DataStore,
      AccessStore,
      OrderStore,
    };
  },
  mounted() {
    this.DataStore.page_title = this.$t("Notifications");

    if (this.DataStore.dataList?.notificationList) {
      this.data = this.DataStore.dataList?.notificationList?.data;
      this.page = this.DataStore.dataList?.notificationList?.page;
      this.hasMore = this.DataStore.dataList?.notificationList?.hasMore;
      this.DataStore.page_delete = true;
    } else {
      setTimeout(() => {
        this.$refs.nscroll?.trigger();
      }, 200);
    }
    this.scroll_disabled = false;

    this.$watch(
      () => this.DataStore.$state.page_delete_actions,
      (newData, oldData) => {
        this.$refs.ref_delete.confirm();
      }
    );
  },
  beforeUnmount() {
    this.DataStore.page_delete = false;
    this.DataStore.page_delete_actions = false;
    this.DataStore.dataList.notificationList = {
      data: this.data,
      page: this.page,
      hasMore: this.hasMore,
    };
  },
  computed: {
    hasItems() {
      return this.data.length > 0;
    },
  },
  methods: {
    ViewNotifications(data) {
      if (!data?.viewed) {
        const notification_uuid = data?.notification_uuid;
        const params = new URLSearchParams({
          notification_uuid: notification_uuid,
        }).toString();
        APIinterface.fetchDataByTokenPost("setviewnotification", params);
        const item = this.data.find(
          (n) => n.notification_uuid === notification_uuid
        );
        if (item) {
          item.viewed = true;
        }
      }

      const meta_data = data.meta_data ? data.meta_data : null;
      if (meta_data) {
        const PageView = meta_data.page ? meta_data.page : null;
        console.log("PageView", PageView);
        switch (PageView) {
          case "order-view":
            const order_uuid = meta_data.order_uuid
              ? meta_data.order_uuid
              : null;
            this.$router.push({
              path: "/orderview",
              query: { order_uuid: order_uuid },
            });
            break;

          case "booking-view":
            const reservation_uuid = meta_data.reservation_uuid
              ? meta_data.reservation_uuid
              : null;
            this.$router.push({
              path: "/tables/reservation_overview",
              query: { id: reservation_uuid },
            });
            break;

          case "chat-view":
            const conversation_id = meta_data.conversation_id;
            this.$router.push({
              path: "/chat/conversation",
              query: { conversation_id: conversation_id },
            });
            break;

          default:
            break;
        }
      }
    },
    async fetchData(index, done) {
      try {
        if (this.loading) {
          return;
        }

        if (!this.hasMore) {
          this.scroll_disabled = true;
          done(true);
          return;
        }
        this.loading = true;
        const params = new URLSearchParams({
          page: this.page,
        }).toString();

        const response = await APIinterface.fetchGet(
          `getNotification?${params}`
        );
        this.page++;
        this.data = [...this.data, ...response.details.data];
        this.total_items = response.details.total_reviews;
        this.DataStore.page_delete = true;

        if (response.details?.is_last_page) {
          this.hasMore = false;
          this.scroll_disabled = true;
          done(true);
          return;
        }
        done();
      } catch (error) {
        this.data = [];
        done(true);
        this.DataStore.page_delete = false;
      } finally {
        this.loading = false;
      }
    },
    refresh(done) {
      setTimeout(() => {
        done();
      }, 100);
      this.resetPagination();
    },
    resetPagination() {
      this.page = 1;
      this.data = [];
      this.hasMore = true;
      this.scroll_disabled = false;
      this.$nextTick(() => {
        this.$refs.nscroll?.resume?.();
        this.$refs.nscroll?.trigger?.();
      });
    },
    confimDelete() {
      this.$refs.ref_delete.confirm();
    },
    async afterConfirm() {
      try {
        APIinterface.showLoadingBox("", this.$q);
        await APIinterface.fetchGet("deleteNotifications");
        this.data = [];
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
  },
};
</script>
