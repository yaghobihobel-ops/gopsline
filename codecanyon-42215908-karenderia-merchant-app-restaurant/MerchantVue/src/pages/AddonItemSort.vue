<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-header
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
      class="myshadow"
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
          {{ $t("Item addon sort") }}
        </q-toolbar-title>
      </q-toolbar>
    </q-header>
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
      class="q-pa-md"
    >
      <template v-if="MenuStore.addonsort_loading">
        <q-inner-loading :showing="true" color="primary" size="md" />
      </template>
      <template v-else>
        <template v-if="MenuStore.hasAddonSort">
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

        <!-- <pre>{{ MenuStore.sort_size_list }}</pre> -->
        <!-- <pre>{{ MenuStore.sort_size }}</pre> -->
        <!-- <pre>{{ MenuStore.sort_addon_category }}</pre> -->

        <template v-for="size in MenuStore.sort_size_list" :key="size">
          <div
            class="list-group-item q-pa-sm cursor-pointer"
            :class="{
              'bg-grey600 ': $q.dark.mode,
              'border-grey': !$q.dark.mode,
            }"
          >
            <template v-if="MenuStore.sort_size[size.size_id]">
              <span
                class="text-weight-bold"
                v-html="MenuStore.sort_size[size.size_id].size_name"
              ></span>
            </template>
            <template v-else>
              <span class="text-weight-bold">{{ $t("No Size") }}</span>
            </template>
          </div>

          <draggable
            v-model="size.addoncategory"
            item-key="value"
            class="list-group"
            ghost-class="ghost"
            :move="checkMove"
            @start="dragging = true"
            @end="dragging = false"
          >
            <template #item="{ element }">
              <div
                class="list-group-item q-pa-sm cursor-pointer"
                :class="{
                  'bg-grey600 ': $q.dark.mode,
                  'border-grey': !$q.dark.mode,
                }"
              >
                <template v-if="MenuStore.sort_addon_category[element]">
                  {{ MenuStore.sort_addon_category[element].name }}
                </template>
                <template v-else>
                  {{ $t("Name not available") }}
                </template>
              </div>
            </template>
          </draggable>
          <q-space class="q-pa-sm"></q-space>
        </template>

        <q-footer
          v-if="MenuStore.hasAddonSort"
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
          />
        </q-footer>
      </template>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { useMenuStore } from "stores/MenuStore";
import draggable from "vuedraggable";
import APIinterface from "src/api/APIinterface";
export default {
  name: "AddonItemSort",
  components: {
    draggable,
  },
  data() {
    return {
      loading: false,
      id: "",
    };
  },
  setup() {
    const MenuStore = useMenuStore();
    return { MenuStore };
  },
  created() {
    this.id = this.$route.query.item_uuid;
    this.MenuStore.getAddonSort(this.id, null);
  },
  methods: {
    refresh(done) {
      this.MenuStore.getAddonSort(this.id, done);
    },
    submit() {
      this.loading = true;
      APIinterface.fetchDataByToken("SortAddonItemsSort", {
        items: this.MenuStore.sort_size_list,
        id: this.id,
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
