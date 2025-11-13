<template>
  <q-header
    reveal
    :class="{
      'bg-custom-grey': !$q.dark.mode,
      'bg-grey600': $q.dark.mode,
    }"
  >
    <!-- MOBILE VIEW -->
    <template v-if="$q.screen.lt.md">
      <q-toolbar>
        <q-btn
          color="dark"
          :text-color="$q.dark.mode ? 'grey300' : 'custom-grey3'"
          icon-right="eva-volume-mute-outline"
          :label="total > 0 ? total_display : $t('No open orders')"
          no-caps
          unelevated
          flat
          class="q-pa-none"
        />
        <q-space></q-space>
        <div class="q-gutter-x-md">
          <q-btn
            icon="eva-settings-outline"
            flat
            class="q-pa-none"
            to="/settings"
            :color="$q.dark.mode ? 'grey300' : 'dark'"
          />
          <NotificationComponents></NotificationComponents>
        </div>
      </q-toolbar>
    </template>
    <template v-else>
      <!-- DESKTOP VIEW -->
      <div class="flex justify-between q-pa-md items-center">
        <div>
          <template v-if="!KitchenStore.miniState">
            <q-btn
              dense
              round
              unelevated
              color="accent"
              :text-color="$q.dark.mode ? 'grey300' : 'white'"
              icon="chevron_left"
              @click="KitchenStore.miniState = true"
              size="13px"
            />
          </template>

          <q-btn
            :color="$q.dark.mode ? 'grey300' : 'dark'"
            icon-right="eva-volume-mute-outline"
            :label="total > 0 ? total_display : $t('No open orders')"
            no-caps
            unelevated
            flat
          />
        </div>
        <div class="flex q-gutter-x-sm">
          <q-form @submit="onSearchSubmit">
            <q-input
              v-model="q"
              :placeholder="$t('Search reference #')"
              dense
              :bg-color="$q.dark.mode ? 'dark' : 'custom-grey1'"
              autocorrect="off"
              autocapitalize="off"
              autocomplete="off"
              spellcheck="false"
              class="no-border"
              rounded
              outlined
              clearable
              @clear="$emit('clearFilter')"
              :loading="q ? KitchenStore.order_loading : false"
            >
              <template v-slot:prepend>
                <q-icon name="eva-search-outline" />
              </template>
            </q-input>
          </q-form>

          <q-btn
            :color="$q.dark.mode ? 'grey300' : 'dark'"
            icon-right="eva-funnel-outline"
            :label="$t('Filter')"
            no-caps
            unelevated
            flat
          >
            <q-menu ref="ref_filter_menu">
              <div class="card-form q-pa-md q-gutter-y-md">
                <template v-if="SettingStore.screen_options != 'split'">
                  <FilterSelect
                    ref="ref_order_type"
                    :data="KitchenStore.getTransactionList"
                    :label="$t('Order Type')"
                    @after-select="afterSelectOrderType"
                  ></FilterSelect>
                </template>

                <FilterSelect
                  ref="ref_status"
                  :data="KitchenStore.getKitchenStatusList"
                  :label="$t('Status')"
                  @after-select="afterSelectStatus"
                ></FilterSelect>

                <q-btn
                  no-caps
                  unelevated
                  color="primary"
                  class="fit radius-10"
                  :label="$t('Apply Filters')"
                  @click="applyFilters"
                  :size="$q.screen.gt.sm ? '17px' : '15px'"
                  :loading="KitchenStore.order_loading"
                >
                </q-btn>
              </div>
            </q-menu>
          </q-btn>

          <q-btn
            :color="$q.dark.mode ? 'grey300' : 'dark'"
            icon-right="eva-settings-outline"
            no-caps
            unelevated
            flat
            rounded
            to="/settings"
          />

          <NotificationComponents></NotificationComponents>
        </div>
      </div>
    </template>
  </q-header>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useKitchenStore } from "stores/KitchenStore";
import { useIdentityStore } from "stores/IdentityStore";
import { useSettingStore } from "stores/SettingStore";

export default {
  name: "TopOrdernav",
  props: ["total", "total_display"],
  components: {
    FilterSelect: defineAsyncComponent(() =>
      import("components/FilterSelect.vue")
    ),
    NotificationComponents: defineAsyncComponent(() =>
      import("components/NotificationComponents.vue")
    ),
  },
  data() {
    return {
      q: "",
    };
  },
  setup() {
    const KitchenStore = useKitchenStore();
    const IdentityStore = useIdentityStore();
    const SettingStore = useSettingStore();
    return { KitchenStore, IdentityStore, SettingStore };
  },
  methods: {
    afterSelectOrderType(value) {
      this.$emit("afterSeletordertype", value);
    },
    afterSelectStatus(value) {
      this.$emit("afterSelectstatus", value);
    },
    onSearchSubmit() {
      this.$refs.ref_filter_menu.hide();
      this.$emit("afterSearchsubmit", this.q);
    },
    applyFilters() {
      this.$refs.ref_filter_menu.hide();
      this.$emit("applyFilters");
    },
  },
};
</script>
