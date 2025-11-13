<template>
  <q-dialog
    v-model="dialog"
    position="standard"
    @before-show="beforeShow"
    persistent
    transition-show="fade"
    transition-hide="fade"
  >
    <q-card class="rounded-borders-top radius8">
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <q-toolbar-title
          class="text-weight-bold"
          :class="{
            'text-white': $q.dark.mode,
            'text-dark': !$q.dark.mode,
          }"
        >
          {{ $t("Sign Out") }}
        </q-toolbar-title>
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
      <q-card-section style="width: calc(40vh)" class="q-pt-sm q-pb-sm">
        <p class="text-grey">{{ $t("Do you want to logout") }}?</p>
      </q-card-section>
      <q-card-actions class="row items-center q-pt-sm q-pb-sm">
        <q-btn
          :label="$t('Cancel')"
          flat
          :color="$q.dark.mode ? 'grey600' : 'disabled'"
          :text-color="$q.dark.mode ? 'grey300' : 'disabled'"
          no-caps
          class="radius8 col"
          @click="dialog = false"
        />
        <q-btn
          color="primary"
          text-color="white"
          no-caps
          class="radius8 col"
          unelevated
          @click="logout"
        >
          <div class="text-weight-bold text-subtitle2">
            {{ $t("Log out") }}
          </div>
        </q-btn>
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script>
export default {
  name: "LogOut",
  data() {
    return {
      dialog: false,
    };
  },
  methods: {
    beforeShow() {},
    logout() {
      this.$emit("afterLogout");
    },
  },
};
</script>
