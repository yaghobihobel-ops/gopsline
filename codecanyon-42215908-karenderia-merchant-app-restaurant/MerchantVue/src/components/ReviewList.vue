<template>
  <q-infinite-scroll ref="nscroll" @load="getReview" :offset="250">
    <template v-slot:default>
      <template v-if="!hasData && !loading">
        <div class="flex flex-center fit" style="min-height: calc(70vh)">
          <div class="full-width text-center">
            <div class="text-weight-bold">{{ $t("No reviews found") }}</div>
            <div class="text-weight-light text-grey">
              {{ $t("Reviews will show here") }}
            </div>
          </div>
        </div>
      </template>

      <q-space class="q-pa-xs"></q-space>
      <q-list separator v-if="hasData">
        <template v-for="data_item in data" :key="data_item">
          <q-item v-for="items in data_item" :key="items">
            <q-item-section>
              <div class="row items-start q-gutter-sm q-mb-xs">
                <div class="col-2">
                  <q-avatar>
                    <q-img
                      :src="items.url_image"
                      spinner-color="secondary"
                      spinner-size="sm"
                      style="max-width: 80px"
                    />
                  </q-avatar>
                </div>
                <div class="col">
                  <div class="font13 text-weight-bold line-normal ellipsis">
                    <template v-if="items.as_anonymous === 1">
                      {{ items.hidden_fullname }}
                    </template>
                    <template v-else>
                      {{ items.fullname }}
                    </template>
                  </div>
                  <div class="font11 full-width text-grey text-weight-medium">
                    {{ items.date_created }}
                  </div>
                </div>
                <div class="col-3 text-right">
                  <q-rating
                    v-model="items.rating"
                    size="13px"
                    :max="5"
                    color="grey"
                    color-selected="yellow-14"
                    readonly
                    class="q-mb-xs no-shadow"
                  />
                </div>
              </div>

              <div v-if="items.meta.tags_like">
                <template v-for="tags in items.meta.tags_like" :key="tags">
                  <template v-if="tags">
                    <q-badge
                      rounded
                      :color="$q.dark.mode ? 'grey600' : 'mygrey'"
                      text-color="grey"
                      :label="tags"
                      class="q-pl-sm q-pr-sm q-mr-xs"
                    />
                  </template>
                </template>
              </div>

              <div class="ellipsis-2-lines q-mt-xs q-mb-xs">
                <span v-html="items.review"></span>
              </div>

              <div
                v-if="items.meta.upload_images"
                class="q-gutter-sm row items-start"
              >
                <template
                  v-for="(image, index) in items.meta.upload_images"
                  :key="image"
                >
                  <template v-if="index <= 3">
                    <q-img
                      :src="image"
                      spinner-color="secondary"
                      spinner-size="sm"
                      style="height: 50px; max-width: 50px"
                      class="radius8 cursor-pointer"
                      @click="setGallery(items.meta.upload_images)"
                    />
                  </template>
                </template>
              </div>
            </q-item-section>
          </q-item>
        </template>
      </q-list>
    </template>
    <template v-slot:loading>
      <template v-if="page <= 1">
        <q-inner-loading
          :showing="true"
          color="primary"
          size="md"
          label-class="dark"
        />
      </template>
      <template v-else>
        <div class="row justify-center absolute-bottom">
          <q-spinner-dots color="secondary" size="30px" />
        </div>
      </template>
    </template>
  </q-infinite-scroll>
  <ImagePreview ref="imagePreview" :gallery="galleryList" title="">
  </ImagePreview>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";

export default {
  name: "ReviewList",
  props: ["is_refresh"],
  components: {
    ImagePreview: defineAsyncComponent(() =>
      import("components/ImagePreview.vue")
    ),
  },
  data() {
    return {
      loading: true,
      data: [],
      page: 0,
      galleryList: [],
    };
  },
  computed: {
    hasData() {
      if (this.data.length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    getReview(index, done) {
      this.loading = true;
      this.page = index;
      APIinterface.fetchDataByTokenPost("getReview", "page=" + index)
        .then((data) => {
          this.data.push(data.details.data);
        })
        .catch((error) => {
          if (this.$refs.nscroll) {
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
    setGallery(data) {
      this.galleryList = data;
      this.$refs.imagePreview.modal = !this.$refs.imagePreview.modal;
    },
    refresh(done) {
      this.resetPagination();
      done();
    },
    resetPagination() {
      this.page = 0;
      this.data = [];
      this.$refs.nscroll.reset();
      this.$refs.nscroll.resume();
      this.$refs.nscroll.trigger();
    },
  },
};
</script>
