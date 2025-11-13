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
            <q-item>
              <q-item-section>
                <q-item-label>{{ items.printer_name }}</q-item-label>
                <q-item-label caption> {{ items.printer_model }}</q-item-label>
                <q-item-label v-if="items.auto_print == 1">
                  <q-badge color="teal-1" text-color="teal-9" rounded>
                    {{ $t("Default") }}
                  </q-badge>
                </q-item-label>
                <q-item-label v-else>
                  <q-toggle
                    color="primary"
                    v-model="items.default_printer"
                    @update:model-value="MakeDefault(items.printer_id)"
                    val="1"
                    keep-color
                    :label="$t('Default')"
                    left-label
                  />
                </q-item-label>
              </q-item-section>
              <q-item-section side top>
                <div class="flex q-gutter-x-md">
                  <q-btn
                    icon="o_mode_edit"
                    color="indigo-1"
                    text-color="dark"
                    no-caps
                    unelevated
                    round
                    size="sm"
                    :to="{
                      path: '/settings/printer-view',
                      query: { id: items.printer_id },
                    }"
                  ></q-btn>

                  <q-btn
                    icon="o_delete_outline"
                    color="red-1"
                    text-color="red-9"
                    no-caps
                    unelevated
                    round
                    size="sm"
                    @click="confimDelete(items.printer_id)"
                  ></q-btn>
                </div>
              </q-item-section>
            </q-item>
          </q-card>
        </q-virtual-scroll>
      </q-list>

      <q-infinite-scroll
        ref="nscroll"
        @load="getPrinters"
        :offset="250"
        :disable="scroll_disabled"
      >
        <template v-slot:loading>
          <div
            class="row q-gutter-x-sm justify-center q-my-md"
            :class="{
              'absolute-center text-center full-width q-mt-xl': page == 1,
            }"
          >
            <q-circular-progress
              indeterminate
              rounded
              size="sm"
              color="primary"
            />
            <div class="text-subtitle1 text-grey">{{ $t("Loading") }}...</div>
          </div>
        </template>
      </q-infinite-scroll>

      <q-page-sticky position="bottom-right" :offset="[18, 18]">
        <div class="q-gutter-y-sm">
          <div>
            <q-btn
              round
              icon="las la-cog"
              unelevated
              color="orange-2"
              text-color="orange-8"
              padding="sm"
              @click="dialog = !dialog"
            />
          </div>
          <div>
            <q-btn
              round
              icon="las la-plus"
              unelevated
              color="blue-grey-1"
              text-color="blue-grey-8"
              to="/settings/add-printer"
              padding="sm"
            />
          </div>
        </div>
      </q-page-sticky>

      <DeleteComponents ref="ref_delete" @after-confirm="deletePrinter">
      </DeleteComponents>

      <q-dialog v-model="dialog" position="bottom">
        <q-card>
          <q-card-section
            class="row items-center q-pa-xs q-pl-md q-pr-md q-gutter-x-sm"
          >
            <div class="text-weight-bold text-subtitle2">
              {{ $t("Settings") }}
            </div>
            <q-space />
            <q-btn
              icon="las la-times"
              color="grey"
              flat
              round
              dense
              v-close-popup
            />
          </q-card-section>
          <q-card-section>
            <q-form @submit="formSubmit">
              <q-list>
                <q-item tag="label" clickable v-ripple>
                  <q-item-section>
                    <q-item-label>{{
                      $t("Auto close connection")
                    }}</q-item-label>
                    <q-item-label caption>
                      {{ $t("Close bluetooth connection after printing") }}
                    </q-item-label>
                  </q-item-section>
                  <q-item-section avatar>
                    <q-toggle
                      color="primary"
                      v-model="DataPersisted.printer_auto_close"
                      :val="true"
                    />
                  </q-item-section>
                </q-item>

                <q-item tag="label" clickable v-ripple class="hidden">
                  <q-item-section>
                    <q-item-label>{{ $t("Hide currency") }}</q-item-label>
                    <q-item-label caption>
                      {{
                        $t(
                          "do not display currency when printing, this is usefull when printer does not support currency symbol"
                        )
                      }}.
                    </q-item-label>
                  </q-item-section>
                  <q-item-section avatar>
                    <q-toggle
                      color="primary"
                      v-model="DataPersisted.hide_currency"
                      val="hide"
                    />
                  </q-item-section>
                </q-item>
              </q-list>
            </q-form>
          </q-card-section>
          <q-space class="q-pa-lg"></q-space>
        </q-card>
      </q-dialog>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import AppBluetooth from "src/api/AppBluetooth";
import { useUserStore } from "stores/UserStore";
import { Device } from "@capacitor/device";
import { useDataStore } from "stores/DataStore";
import { useDataPersisted } from "stores/DataPersisted";
import { useOrderStore } from "stores/OrderStore";
import { defineAsyncComponent } from "vue";

export default {
  name: "PrinterList",
  components: {
    DeleteComponents: defineAsyncComponent(() =>
      import("components/DeleteComponents.vue")
    ),
  },
  data() {
    return {
      loading: false,
      data: [],
      page: 1,
      osVersion: 0,
      dialog: false,
      scroll_disabled: true,
      hasMore: true,
      id: null,
    };
  },
  setup() {
    const UserStore = useUserStore();
    const DataStore = useDataStore();
    const DataPersisted = useDataPersisted();
    const OrderStore = useOrderStore();
    return { UserStore, DataStore, DataPersisted, OrderStore };
  },
  mounted() {
    this.DataStore.page_title = this.$t("Printers");
    if (this.$q.capacitor) {
      this.getDevice();
    }

    if (this.DataStore.dataList?.printer_list) {
      this.data = this.DataStore.dataList?.printer_list?.data;
      this.page = this.DataStore.dataList?.printer_list?.page;
      this.hasMore = this.DataStore.dataList?.printer_list?.hasMore;
    } else {
      setTimeout(() => {
        this.$refs.nscroll?.trigger();
      }, 200);
    }

    this.scroll_disabled = false;
  },
  beforeUnmount() {
    this.DataStore.dataList.printer_list = {
      data: this.data,
      page: this.page,
      hasMore: this.hasMore,
    };
  },
  computed: {
    hasData() {
      return this.data.length > 0;
    },
  },
  methods: {
    confimDelete(value) {
      this.id = value;
      this.$refs.ref_delete.confirm();
    },
    async deletePrinter() {
      try {
        if (!this.id) {
          APIinterface.ShowAlert(
            this.$t("Invalid Id"),
            this.$q.capacitor,
            this.$q
          );
          return;
        }

        APIinterface.showLoadingBox("", this.$q);
        const params = new URLSearchParams({
          printer_id: this.id,
        }).toString();
        await APIinterface.fetchDataByTokenPost("deletePrinter", params);
        this.data = this.data.filter((item) => item.printer_id !== this.id);
        this.id = null;
        // this.DataStore.clearCache();
        // this.OrderStore.clearCache();
        this.clearCache();
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
    async MakeDefault(value) {
      console.log("MakeDefault", value);
      try {
        APIinterface.showLoadingBox("", this.$q);
        await APIinterface.fetchGet("MakeDefaultPrinter", {
          id: value,
        });
        // this.DataStore.clearCache();
        // this.OrderStore.clearCache();
        this.clearCache();
        this.resetPagination();
      } catch (error) {
        console.log("eror", error);
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
    clearCache() {
      this.OrderStore.clearCache();
      this.DataStore.cleanData("printer_list");
      this.DataStore.cleanData("order_data");
    },
    async getDevice() {
      const info = await Device.getInfo();
      this.osVersion = info.osVersion;
      this.initBT();
    },
    initBT() {
      if (this.osVersion >= 12) {
        if (this.$q.platform.is.ios) {
          this.EnabledBT();
        } else {
          AppBluetooth.CheckBTConnectPermissionOnly()
            .then((data) => {
              this.EnabledBT();
            })
            .catch((error) => {
              this.$router.push("/settings/location-enabled");
            })
            .then((data) => {
              //
            });
        }
      } else {
        AppBluetooth.CheckLocationOnly()
          .then((data) => {
            this.EnabledBT();
          })
          .catch((error) => {
            this.$router.push("/settings/location-enabled");
          })
          .then((data) => {
            //
          });
      }
    },
    EnabledBT() {
      AppBluetooth.Enabled()
        .then((data) => {
          //
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          //
        });
    },
    refresh(done) {
      setTimeout(() => {
        done();
      }, 100);
      this.resetPagination();
    },
    async getPrinters(index, done) {
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
          device_uuid: this.UserStore.device_uuid,
        }).toString();

        const response = await APIinterface.fetchDataByTokenPost(
          "PrintersList",
          params
        );
        this.page++;

        this.data = [...this.data, ...response.details.data];

        if (response.details.is_last_page) {
          this.hasMore = false;
          this.scroll_disabled = true;
          done(true);
          return;
        }
        done();
      } catch (error) {
        console.log("error", error);
        this.hasMore = false;
        this.scroll_disabled = true;
        done(true);
      } finally {
        this.loading = false;
      }
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
  },
};
</script>
