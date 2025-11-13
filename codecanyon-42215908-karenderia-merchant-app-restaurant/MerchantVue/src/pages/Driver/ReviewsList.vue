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
          {{ $t("Reviews") }}
        </q-toolbar-title>
      </q-toolbar>
      <q-separator></q-separator>
    </q-header>
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
        'flex flex-center': !hasData && !loading,
      }"
    >
      <q-infinite-scroll ref="nscroll" @load="List" :offset="250">
        <template v-slot:default>
          <q-list separator>
            <template v-for="items in data" :key="items">
              <q-slide-item
                @right="onRight"
                v-for="item in items"
                :key="item"
                right-color="grey-2"
              >
                <template v-slot:right>
                  <q-btn
                    @click="close"
                    icon="las la-window-close"
                    color="blue"
                    round
                    flat
                  ></q-btn>
                  <q-btn
                    @click="deleteItems(item.id, items, index)"
                    icon="las la-trash-alt"
                    color="red"
                    round
                    flat
                  ></q-btn>
                </template>
                <q-item clickable @click="showForm(item)">
                  <q-item-section>
                    <q-item-label caption>{{ item.date_created }}</q-item-label>
                    <q-item-label
                      >{{ item.customer_fullname }}
                      <q-badge
                        :color="
                          DataStore.status_color[item.status_raw]
                            ? DataStore.status_color[item.status_raw]
                            : 'amber'
                        "
                        >{{ item.status }}</q-badge
                      >
                    </q-item-label>
                    <q-item-label class="text-grey">{{
                      item.review
                    }}</q-item-label>
                  </q-item-section>
                  <q-item-section side>
                    <q-item-label class="text-right text-green">
                      <q-badge
                        color="amber"
                        text-color="white"
                        :label="item.rating"
                      />
                    </q-item-label>
                  </q-item-section>
                </q-item>
              </q-slide-item>
            </template>
          </q-list>
        </template>
        <template v-slot:loading>
          <TableSkeleton v-if="page <= 0" :rows="10"></TableSkeleton>
          <TableSkeleton v-else-if="data.length > 1" :rows="1"></TableSkeleton>
        </template>
      </q-infinite-scroll>

      <template v-if="!hasData && !loading">
        <div class="full-width text-center flex flex-center">
          <p class="text-grey q-ma-none">{{ $t("No available data") }}</p>
        </div>
      </template>
    </q-page>
  </q-pull-to-refresh>
  <ReviewUpdate ref="review" @after-update="afterUpdate"></ReviewUpdate>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";

export default {
  name: "ReviewsList",
  components: {
    TableSkeleton: defineAsyncComponent(() =>
      import("components/TableSkeleton.vue")
    ),
    ReviewUpdate: defineAsyncComponent(() =>
      import("components/ReviewUpdate.vue")
    ),
  },
  setup(props) {
    const DataStore = useDataStore();
    return { DataStore };
  },
  data() {
    return {
      loading: false,
      id: "",
      data: [],
      page: 0,
      is_refresh: undefined,
      handle: undefined,
    };
  },
  computed: {
    hasBalance() {
      if (Object.keys(this.balance_data).length > 0) {
        return true;
      }
      return false;
    },
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  created() {
    this.id = this.$route.query.id;
  },
  methods: {
    onRight(reset) {
      if (!APIinterface.empty(this.handle)) {
        try {
          this.handle.reset();
        } catch (err) {}
      }
      this.handle = reset;
    },
    close() {
      this.handle.reset();
    },
    afterUpdate() {
      this.resetPagination();
    },
    showForm(data) {
      this.$refs.review.show(data);
    },
    refresh(done) {
      this.is_refresh = done;
      this.resetPagination();
    },
    List(index, done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "driverReviewList",
        "&page=" + index + "&id=" + this.id
      )
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
    deleteItems(id, data, index) {
      APIinterface.dialog(
        this.$t("Delete Confirmation"),
        this.$t(
          "Are you sure you want to permanently delete the selected item?"
        ),
        this.$t("Okay"),
        this.$t("Cancel"),
        this.$q
      )
        .then((result) => {
          this.deleteRecords(id, data, index);
        })
        .catch((error) => {
          this.close();
        });
    },
    deleteRecords(id, data, index) {
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });
      APIinterface.fetchDataByTokenPost("deleteReview", "id=" + id)
        .then((response) => {
          data.splice(index, 1);
        })
        .catch((error) => {})
        .then((data) => {
          this.$q.loading.hide();
        });
    },
  },
};
</script>
