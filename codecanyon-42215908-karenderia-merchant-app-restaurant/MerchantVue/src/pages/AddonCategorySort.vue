<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-header
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
    >
      <q-toolbar>
        <q-btn
          @click="$router.back()"
          flat
          round
          dense
          icon="las la-angle-left"
          :color="$q.dark.mode ? 'white' : 'dark'"
        />
        <q-toolbar-title class="text-weight-bold">
          {{ $t("Sort Adddon Category") }}
        </q-toolbar-title>
      </q-toolbar>
      <q-separator></q-separator>
    </q-header>
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
      class="q-pa-md"
    >
      <template v-if="MenuStore.loading_addon">
        <q-inner-loading :showing="true" color="primary" size="md" />
      </template>
      <template v-else>
        <template v-if="MenuStore.hasAddon">
          <p
            :class="{
              'text-grey300': $q.dark.mode,
              'text-dark': !$q.dark.mode,
            }"
          >
            {{ $t("Drag the list to sort") }}
          </p>
        </template>
        <template v-else>
          <div>{{ $t("No available data") }}</div>
        </template>

        <draggable
          v-model="MenuStore.addon"
          item-key="value"
          class="list-group"
          ghost-class="ghost"
          :move="checkMove"
          @start="dragging = true"
          @end="dragging = false"
        >
          <template #item="{ element }">
            <div
              class="list-group-item q-pa-sm cursor-pointer q-mb-sm"
              :class="{
                'bg-grey600 ': $q.dark.mode,
                'border-grey': !$q.dark.mode,
              }"
            >
              <span v-html="element.subcategory_name"></span>
            </div>
          </template>
        </draggable>
      </template>

      <q-footer
        v-if="MenuStore.hasAddon"
        class="q-pl-md q-pr-md q-pb-xs"
        :class="{
          'bg-mydark ': $q.dark.mode,
          'bg-white ': !$q.dark.mode,
        }"
      >
        <q-btn
          @click="submit"
          color="primary"
          text-color="white"
          :label="$t('Save')"
          unelevated
          class="full-width radius8"
          size="lg"
          no-caps
          :loading="loading"
          :disable="!MenuStore.hasAddonCategory"
        />
      </q-footer>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { useMenuStore } from "stores/MenuStore";
import draggable from "vuedraggable";
import APIinterface from "src/api/APIinterface";

export default {
  name: "AddonCategorySort",
  components: {
    draggable,
  },
  setup() {
    const MenuStore = useMenuStore();
    return { MenuStore };
  },
  data() {
    return {
      data: [],
      loading: false,
      enabled: true,
      category: [],
    };
  },
  created() {
    this.MenuStore.geStoreAddonMenu();
  },
  methods: {
    refresh(done) {
      this.MenuStore.geStoreAddonMenu(done);
    },
    submit() {
      this.loading = true;
      let data = [];
      if (Object.keys(this.MenuStore.addon).length > 0) {
        Object.entries(this.MenuStore.addon).forEach(([key, items]) => {
          data.push(items.subcat_id);
        });
      }
      APIinterface.fetchDataByToken("SortAddonCategory", {
        addoncategory: data,
      })
        .then((data) => {
          APIinterface.notify(
            this.$q.dark.mode ? "grey600" : "light-green",
            data.msg,
            "check_circle",
            this.$q
          );
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
