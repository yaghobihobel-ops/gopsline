<template>
  <q-header class="bg-white" reveal reveal-offset="50">
    <q-toolbar>
      <q-btn
        @click="$router.back()"
        flat
        round
        dense
        icon="arrow_back"
        color="dark"
      />
      <q-toolbar-title class="text-grey-10"></q-toolbar-title>
      <q-btn
        flat
        dense
        :label="$t('Edit')"
        no-caps
        color="myyellow"
        to="/account/edit-profile"
      />
    </q-toolbar>
  </q-header>
  <q-pull-to-refresh @refresh="refresh">
    <q-page class="bg-grey-1">
      <q-space class="q-pa-sm bg-grey-1"></q-space>
      <div class="row bg-white q-gutter-sm">
        <div class="col-3 q-pl-sm q-pr-sm">
          <div class="text-center">
            <q-avatar size="60px">
              <q-img
                :src="data.avatar"
                style="height: 60px; max-width: 60px"
                fit="cover"
                spinner-size="20px"
                spinner-color="primary"
              >
                <template v-slot:error>
                  <div
                    class="absolute-full flex flex-center bg-amber-5 text-white"
                  ></div>
                </template>
              </q-img>
            </q-avatar>
            <div class="text-h7 font16 q-mt-sm">
              {{ data.first_name }} {{ data.last_name }}
            </div>
            <p class="no-margin font11 text-grey ellipsis">
              {{ data.email_address }}
            </p>
          </div>
        </div>
        <div class="col">
          <div class="q-pr-sm">
            <ReviewOverview :overview="true" :refresh="is_refresh" />
          </div>
        </div>
      </div>
      <!-- row -->

      <q-space class="q-pa-sm"></q-space>

      <DeliveriesOverview :refresh="is_refresh"></DeliveriesOverview>

      <q-space class="q-pa-sm"></q-space>

      <div class="font16 text-grey q-pl-md q-pb-xs">
        {{ $t("Information") }}
      </div>
      <q-list dense separator class="bg-white">
        <q-item>
          <q-item-section>{{ $t("Email Address") }}</q-item-section>
          <q-item-section side>
            <q-item-label caption>{{ data.email_address }}</q-item-label>
          </q-item-section>
        </q-item>
        <q-item>
          <q-item-section>{{ $t("Mobile Number") }}</q-item-section>
          <q-item-section side>
            <q-item-label caption
              >+{{ data.phone_prefix }} {{ data.phone }}</q-item-label
            >
          </q-item-section>
        </q-item>
      </q-list>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import auth from "src/api/auth";
import { defineAsyncComponent } from "vue";

export default {
  // name: 'PageName',
  components: {
    ReviewOverview: defineAsyncComponent(() =>
      import("components/ReviewOverview.vue")
    ),
    DeliveriesOverview: defineAsyncComponent(() =>
      import("components/DeliveriesOverview.vue")
    ),
  },
  data() {
    return {
      data: [],
      is_refresh: false,
    };
  },
  created() {
    this.getProfile();
  },
  methods: {
    getProfile() {
      this.data = auth.getUser();
    },
    refresh(done) {
      this.is_refresh = true;
      setTimeout(() => {
        done();
        this.is_refresh = false;
      }, 1000);
    },
  },
};
</script>
