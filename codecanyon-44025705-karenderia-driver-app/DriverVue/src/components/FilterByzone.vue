<template>
  <q-dialog v-model="dialog" position="bottom">
    <q-card>
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <q-toolbar-title
          class="text-darkx text-weight-bold"
          :class="{
            'text-white': $q.dark.mode,
            'text-dark': !$q.dark.mode,
          }"
        >
          {{ $t("Filter by zone") }}
        </q-toolbar-title>
        <q-space></q-space>
        <q-btn
          @click="dialog = !true"
          color="white"
          square
          unelevated
          text-color="grey"
          icon="las la-times"
          dense
          no-caps
          size="sm"
          class="border-grey radius8"
        />
      </q-toolbar>

      <ListLoading v-if="Activity.zone_loading"></ListLoading>
      <template v-else>
        <q-list dense>
          <!-- <q-item tag="label" v-ripple>
            <q-item-section avatar>
              <q-checkbox v-model="zone_ids" val="all" color="primary" />
            </q-item-section>
            <q-item-section>
              <q-item-label>All</q-item-label>
            </q-item-section>
          </q-item> -->

          <template v-for="items in Activity.zone_data" :key="items">
            <q-item tag="label" v-ripple>
              <q-item-section avatar>
                <q-checkbox
                  v-model="zone_ids"
                  :val="items.value"
                  color="primary"
                />
              </q-item-section>
              <q-item-section>
                <q-item-label>{{ items.label }}</q-item-label>
              </q-item-section>
            </q-item>
          </template>
        </q-list>
        <q-space class="q-pa-xl"></q-space>
        <q-footer
          bordered
          class="q-pa-sm no-border"
          :class="{
            'bg-mydark ': $q.dark.mode,
            'bg-white ': !$q.dark.mode,
          }"
        >
          <q-toolbar class="q-gutter-sm">
            <q-btn
              @click="clear"
              color="dark"
              unelevated
              text-color="white"
              :label="$t('Clear')"
              no-caps
              size="lg"
              class="col"
            />
            <q-btn
              @click="applyFilter"
              color="primary"
              unelevated
              text-color="white"
              :label="$t('Apply')"
              no-caps
              size="lg"
              class="col"
            />
          </q-toolbar>
        </q-footer>
      </template>
    </q-card>
  </q-dialog>
</template>

<script>
import { useActivityStore } from "stores/ActivityStore";
import { defineAsyncComponent } from "vue";

export default {
  name: "FilterByzone",
  data() {
    return {
      dialog: false,
      zone_ids: [],
    };
  },
  components: {
    ListLoading: defineAsyncComponent(() =>
      import("components/ListLoading.vue")
    ),
  },
  setup() {
    const Activity = useActivityStore();
    return { Activity };
  },
  created() {
    this.Activity.getZone();
  },
  methods: {
    showModal(data) {
      this.dialog = data;
    },
    applyFilter() {
      this.showModal(false);
      this.$emit("afterApplyfilter", this.zone_ids);
    },
    clear() {
      this.zone_ids = [];
    },
  },
};
</script>
