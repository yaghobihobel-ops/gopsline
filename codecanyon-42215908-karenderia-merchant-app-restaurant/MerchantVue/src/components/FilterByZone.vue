<template>
  <q-dialog
    v-model="modal"
    position="bottom"
    persistent
    full-width
    @before-show="whenShow"
  >
    <q-card class="rounded-borders-top">
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <q-toolbar-title
          class="text-dark text-weight-bold"
          style="overflow: inherit"
        >
          {{ $t("Filter") }}
        </q-toolbar-title>
        <q-space></q-space>
        <q-btn
          @click="modal = !true"
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

      <q-list separator>
        <q-item-label header>{{ $t("Filter by zone") }}</q-item-label>
        <template v-for="items in DriverStore.getZone" :key="items">
          <q-item clickable tag="label">
            <q-item-section avatar>
              <q-radio v-model="zone_id" :val="items.value" color="orange" />
            </q-item-section>
            <q-item-section>
              <q-item-label>{{ items.label }}</q-item-label>
            </q-item-section>
          </q-item>
        </template>
      </q-list>

      <q-list separator>
        <q-item-label header>{{ $t("Filter by Groups") }}</q-item-label>
        <template v-for="(items, index) in DriverStore.getGroup" :key="items">
          <q-item clickable tag="label">
            <q-item-section avatar>
              <q-radio v-model="group_selected" :val="index" color="orange" />
            </q-item-section>
            <q-item-section>
              <q-item-label>{{ items }}</q-item-label>
            </q-item-section>
          </q-item>
        </template>
      </q-list>

      <q-space class="q-pa-lg"></q-space>

      <q-footer class="bg-white border-grey-top q-pa-sm row">
        <q-btn
          flat
          :label="$t('Apply')"
          color="primary"
          no-caps
          class="col"
          @click="setFilter"
        />

        <q-btn
          flat
          :label="$t('Cancel')"
          color="dark"
          no-caps
          class="col"
          @click="modal = !true"
        />
      </q-footer>
    </q-card>
  </q-dialog>
</template>

<script>
import { useDriverStore } from "stores/DriverStore";

export default {
  name: "FilterByZone",
  data() {
    return {
      modal: false,
      zone_id: [],
      group_selected: [],
    };
  },
  setup(props) {
    const DriverStore = useDriverStore();
    return { DriverStore };
  },
  computed: {
    hasSelected() {
      if (this.zone_id > 0) {
        return true;
      }
      if (this.group_selected > 0) {
        return true;
      }
      return false;
    },
  },
  created() {
    this.DriverStore.getZoneList();
    this.DriverStore.getGroupList();
  },
  methods: {
    setFilter() {
      this.modal = false;
      this.$emit("afterApplyfilter", this.zone_id, this.group_selected);
    },
    whenShow() {
      this.zone_id = 0;
      this.group_selected = 0;
    },
  },
};
</script>
