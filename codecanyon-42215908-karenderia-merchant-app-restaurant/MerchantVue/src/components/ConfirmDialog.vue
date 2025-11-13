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
          {{ data.title }}
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
        <p class="text-grey">{{ data.subtitle }}</p>
      </q-card-section>
      <q-card-actions class="row items-center q-pt-sm q-pb-sm">
        <q-btn
          :label="data.cancel"
          outline
          :color="$q.dark.mode ? 'grey600' : 'grey'"
          :text-color="$q.dark.mode ? 'grey300' : 'dark'"
          no-caps
          class="radius8 col"
          @click="dialog = false"
        />
        <q-btn
          :label="data.confirm"
          color="primary"
          text-color="white"
          no-caps
          class="radius8 col"
          unelevated
          @click="confirm"
        />
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script>
export default {
  name: "ConfirmDialog",
  props: ["data"],
  data() {
    return {
      dialog: false,
    };
  },
  methods: {
    beforeShow() {},
    confirm() {
      this.$emit("afterConfirm");
    },
  },
};
</script>
