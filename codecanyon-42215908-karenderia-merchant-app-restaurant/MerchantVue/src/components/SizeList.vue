<template>
  <q-space class="q-pa-xs"></q-space>

  <q-infinite-scroll ref="nscroll" @load="getSize" :offset="250">
    <template v-if="data.length <= 0 && !loading">
      <ListNoData
        :title="$t('No available data')"
        :subtitle="$t('if there is available data it will show here')"
        set_height="min-height: calc(70vh)"
      ></ListNoData>
    </template>
    <template v-else>
      <q-list separator v-if="AccessStore.hasAccess('attrmerchant.size_list')">
        <template v-for="row in data" :key="row">
          <q-item v-for="items in row" :key="items">
            <q-item-section>
              <q-item-label>
                <div class="text-subtitle2 no-margin line-normal">
                  {{ items.size_name }}
                </div>

                <div
                  class="text-grey ellipsis-2-lines text-caption line-normal"
                >
                  {{ items.date_created }}
                </div>
              </q-item-label>
            </q-item-section>
            <q-item-section side class="row items-stretch">
              <div class="column items-center col-12">
                <div class="col q-mb-sm">
                  <q-btn
                    round
                    :color="$q.dark.mode ? 'grey600' : 'primary'"
                    :text-color="$q.dark.mode ? 'grey300' : 'white'"
                    icon="las la-edit"
                    size="sm"
                    unelevated
                    :to="{
                      path: '/size/edit',
                      query: {
                        size_id: items.size_id,
                      },
                    }"
                  />
                </div>
                <div class="col">
                  <q-btn
                    v-if="AccessStore.hasAccess('attrmerchant.size_delete')"
                    round
                    :color="$q.dark.mode ? 'grey600' : 'mygrey'"
                    :text-color="$q.dark.mode ? 'grey300' : 'dark'"
                    icon="las la-trash"
                    size="sm"
                    unelevated
                    @click="confirmDelete(items.size_id)"
                  />
                </div>
              </div>
            </q-item-section>
          </q-item>
        </template>
      </q-list>
    </template>
    <template v-slot:loading>
      <q-inner-loading
        v-if="page <= 0"
        :showing="true"
        color="primary"
        size="md"
      />
      <div v-else class="row justify-center q-my-md">
        <q-spinner-dots color="primary" size="40px" v-if="data.length > 1" />
      </div>
    </template>
  </q-infinite-scroll>
  <ConfirmDialog
    ref="confirm_dialog"
    :data="DataStore.data_dialog"
    @after-confirm="afterConfirm"
  ></ConfirmDialog>

  <q-page-sticky position="bottom-right" :offset="[18, 18]">
    <q-btn
      round
      icon="las la-plus"
      size="sm"
      unelevated
      :color="$q.dark.mode ? 'grey600' : 'mygrey'"
      :text-color="$q.dark.mode ? 'grey300' : 'dark'"
      to="/size/add"
      padding="sm"
    />
  </q-page-sticky>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import { useAccessStore } from "stores/AccessStore";

export default {
  name: "SizeList",
  props: ["is_refresh"],
  components: {
    ConfirmDialog: defineAsyncComponent(() =>
      import("components/ConfirmDialog.vue")
    ),
    ListNoData: defineAsyncComponent(() => import("components/ListNoData.vue")),
  },
  data() {
    return {
      loading: false,
      data: [],
      page: 0,
      size_id: 0,
    };
  },
  setup() {
    const DataStore = useDataStore();
    const AccessStore = useAccessStore();
    return { DataStore, AccessStore };
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    confirmDelete(sizeId) {
      this.size_id = sizeId;
      this.$refs.confirm_dialog.dialog = true;
    },
    getSize(index, done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getSizeList", "page=" + index)
        .then((data) => {
          if (data.code == 1) {
            this.page = index;
            this.data.push(data.details.data);
          } else if (data.code == 3) {
            this.data_done = true;
            if (!APIinterface.empty(this.$refs.nscroll)) {
              this.$refs.nscroll.stop();
            }
          }
        })
        .catch((error) => {
          this.data_done = true;
          if (!APIinterface.empty(this.$refs.nscroll)) {
            this.$refs.nscroll.stop();
          }
        })
        .then((data) => {
          done();
          this.loading = false;
          if (!APIinterface.empty(this.is_refresh)) {
            this.is_refresh();
          }
        });
    },
    resetPagination() {
      this.page = 0;
      this.data = [];
      this.$refs.nscroll.reset();
      this.$refs.nscroll.resume();
      this.$refs.nscroll.trigger();
    },
    afterConfirm() {
      this.$refs.confirm_dialog.dialog = false;
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost("deleteSize", "size_id=" + this.size_id)
        .then((data) => {
          this.resetPagination();
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
  },
};
</script>
