<template>
  <q-dialog
    v-model="modal"
    maximized
    persistent
    transition-show="slide-up"
    transition-hide="slide-down"
    transition-duration="500"
    @before-show="beforeShow"
  >
    <q-card class="no-shadow text-dark">
      <div class="fixed-top bg-white text-dark z-top">
        <q-toolbar class="shadow-1x border-bottom">
          <q-btn icon="close" flat round dense v-close-popup></q-btn>
          <q-toolbar-title class="text-subtitle2 text-weight-bold">
            {{ $t("About") }}
          </q-toolbar-title>
        </q-toolbar>
      </div>
      <q-space style="height: 50px"></q-space>
      <q-card-section>
        <div class="text-h6">{{ data?.merchant?.restaurant_name }}</div>
        <div
          class="text-caption text-dark"
          v-html="data?.merchant?.cuisine2"
        ></div>
        <q-space class="q-pa-sm"></q-space>

        <div class="row items-start q-gutter-x-sm">
          <div class="col-3 text-center">
            <div class="text-h5 text-weight-bold">
              {{ data?.merchant?.ratings }}
            </div>
            <q-rating
              :model-value="data?.merchant?.ratings || 0"
              size="0.9em"
              color="disabled"
              color-selected="amber-5"
              icon="star"
              icon-selected="star"
            />
            <div class="text-caption text-grey">
              {{ data?.merchant?.review_words }}
            </div>
          </div>
          <div class="col">
            <div v-for="n in 5" :key="n">
              <div class="row items-center justify-between">
                <div class="text-caption col-1 text-center text-grey">
                  {{ 6 - n }}
                </div>
                <div class="col">
                  <q-slider
                    dense
                    :model-value="ratings[6 - n]"
                    color="amber"
                    track-color="grey-3"
                    readonly
                    :min="0"
                    :max="100"
                    thumb-size="0"
                  />
                </div>
              </div>
            </div>
          </div>
        </div>

        <q-space class="q-pa-sm"></q-space>

        <div class="q-gutter-y-sm">
          <section>
            <q-chip
              dense
              color="transparent"
              text-color="grey-4"
              class="q-pa-none"
              icon="storefront"
            >
              <span class="text-dark text-subtitle2"
                >{{ $t("Few words about") }}
                {{ data?.merchant?.restaurant_name }}</span
              >
            </q-chip>
            <TextComponents
              :description="data?.merchant?.short_description || null"
              max_lenght="200"
              class_name="text-grey300 text-body2 line-normal"
              :label="{
                read_less: $t('Read less'),
                read_more: $t('Read More'),
              }"
            >
            </TextComponents>
          </section>
          <q-separator></q-separator>
          <section>
            <div class="row">
              <div class="col">
                <q-chip
                  dense
                  color="transparent"
                  text-color="grey-4"
                  class="q-pa-none"
                  icon="storefront"
                >
                  <span class="text-dark text-subtitle2">{{
                    $t("Address")
                  }}</span>
                </q-chip>
                <div class="text-grey300 text-body2 line-normal">
                  {{ data?.merchant?.address }}
                </div>
              </div>
              <div class="col-4">
                <q-responsive style="height: 100px">
                  <q-img
                    :src="data?.merchant?.static_maps || null"
                    lazy
                    fit="cover"
                    class="radius8"
                    spinner-color="amber"
                    spinner-size="sm"
                  />
                </q-responsive>
              </div>
            </div>
          </section>

          <q-separator></q-separator>

          <section>
            <q-chip
              dense
              color="transparent"
              text-color="grey-4"
              class="q-pa-none"
              icon="las la-clock"
            >
              <span class="text-dark text-subtitle2">{{
                $t("Opening hours")
              }}</span>
            </q-chip>

            <q-list>
              <q-expansion-item
                expand-separator
                :label="$t('Today')"
                :caption="data?.open_at ? data?.open_at : $t('Closed')"
              >
                <q-card
                  :class="{
                    'bg-mydark text-white': $q.dark.mode,
                    'bg-white text-black': !$q.dark.mode,
                  }"
                >
                  <q-card-section>
                    <q-list dense class="text-body2 text-grey300">
                      <q-item
                        v-for="items in data?.opening_hours"
                        :key="items"
                        style="padding: 0px !important; min-height: 0"
                      >
                        <q-item-section class="text-capitalize">{{
                          items.value
                        }}</q-item-section>
                        <q-item-section caption
                          >{{ items.start_time }} - {{ items.end_time }}
                        </q-item-section>
                      </q-item>
                    </q-list>
                  </q-card-section>
                </q-card>
              </q-expansion-item>
            </q-list>
          </section>

          <q-separator></q-separator>
          <section>
            <q-chip
              dense
              color="transparent"
              text-color="grey-4"
              class="q-pa-none"
              icon="las la-photo-video"
            >
              <span class="text-dark text-subtitle2">{{ $t("Gallery") }}</span>
            </q-chip>
            <div
              class="container q-mt-md"
              @click="this.$refs.ref_image.modal = !this.$refs.ref_image.modal"
            >
              <template v-for="items in data?.gallery" :key="items">
                <figure>
                  <div class="cell">
                    <q-responsive style="width: 110px; height: 90px">
                      <q-img
                        :src="items.thumbnail"
                        lazy
                        fit="cover"
                        class="radius8"
                        spinner-color="amber"
                        spinner-size="sm"
                      />
                    </q-responsive>
                  </div>
                </figure>
              </template>
            </div>
          </section>
        </div>
        <!-- end gutter -->
      </q-card-section>
    </q-card>
  </q-dialog>

  <ImagePreview ref="ref_image" :gallery="getGallery" :title="$t('Gallery')">
  </ImagePreview>
</template>

<script>
import { defineAsyncComponent } from "vue";

export default {
  name: "MerchantInformation",
  props: ["data"],
  components: {
    TextComponents: defineAsyncComponent(() =>
      import("src/components/TextComponents.vue")
    ),
    ImagePreview: defineAsyncComponent(() =>
      import("src/components/ImagePreview.vue")
    ),
  },
  data() {
    return {
      modal: false,
    };
  },
  computed: {
    ratings() {
      if (!this.data) {
        return;
      }
      return this.data?.review_details ?? null;
    },
    getGallery() {
      const gallery = this.data?.gallery || null;
      if (!gallery) {
        return;
      }
      let list = [];
      if (gallery.length > 0) {
        Object.entries(gallery).forEach(([key, items]) => {
          list.push(items.image_url);
        });
      }
      return list;
    },
  },
};
</script>
