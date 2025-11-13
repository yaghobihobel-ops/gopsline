<template>
  <q-dialog
    v-model="modal"
    transition-show="slide-up"
    transition-hide="slide-down"
  >
    <q-card style="width: 80vw" class="radius10 q-pa-sm">
      <q-toolbar class="text-primary" dense>
        <q-space></q-space>
        <q-toolbar-title
          class="text-weight-bold text-subtitle1"
          style="overflow: inherit"
          :class="{
            'text-white': $q.dark.mode,
            'text-dark': !$q.dark.mode,
          }"
        >
          {{ $t(title) }}
        </q-toolbar-title>
        <q-space></q-space>
        <div class="q-gutter-x-sm">
          <q-btn
            icon="las la-times"
            color="grey"
            flat
            round
            dense
            v-close-popup
          />
        </div>
      </q-toolbar>
      <q-card-section class="text-center">
        <div class="text-body2 text-grey">
          {{ $t(subtitle) }}
        </div>
      </q-card-section>
      <q-card-actions class="row">
        <q-btn
          unelevated
          no-caps
          color="disabled"
          text-color="disabled"
          class="col"
          rounded
          size="lg"
          v-close-popup
        >
          <div class="text-weight-bold text-subtitle2">
            {{ $t(cancel) }}
          </div>
        </q-btn>
        <q-btn
          type="submit"
          unelevated
          no-caps
          color="amber-6"
          text-color="disabled"
          class="col"
          rounded
          size="lg"
          @click="confirmDelete"
        >
          <div class="text-weight-bold text-subtitle2">
            {{ $t(deleteText) }}
          </div>
        </q-btn>
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script>
export default {
  name: "DeleteComponents",
  props: {
    title: {
      type: String,
      default: "Confirm Delete",
    },
    subtitle: {
      type: String,
      default: "Are you sure to delete this record?",
    },
    cancel: {
      type: String,
      default: "Keep",
    },
    deleteText: {
      type: String,
      default: "Remove",
    },
  },
  data() {
    return {
      modal: false,
    };
  },
  methods: {
    confirm() {
      this.modal = true;
    },
    confirmDelete() {
      this.modal = false;
      this.$emit("afterConfirm");
    },
  },
};
</script>
