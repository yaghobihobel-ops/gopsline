<template>
  <q-dialog v-model="dialog" position="bottom" @before-show="beforeShow">
    <q-card class="rounded-borders-top">
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <q-toolbar-title
          class="text-weight-bold"
          :class="{
            'text-white': $q.dark.mode,
            'text-dark': !$q.dark.mode,
          }"
        >
          {{ $t("Choose Category") }}
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
      <q-list separator dense>
        <q-item v-for="x in 10" :key="x" tag="label" clickable>
          <q-item-section avatar>
            <q-checkbox v-model="category" :val="x" />
          </q-item-section>
          <q-item-section> Burger </q-item-section>
        </q-item>
      </q-list>

      <q-space class="q-pa-xl"></q-space>

      <div
        class="fixed-bottom-left bg-white full-width q-pa-sm row items-center q-gutter-sm"
      >
        <q-btn
          :label="$t('Cancel')"
          unelevated
          no-caps
          color="mygrey"
          text-color="dark"
          class="col radius8"
          size="lg"
        ></q-btn>
        <q-btn
          :label="$t('Next')"
          unelevated
          no-caps
          color="primary"
          text-color="white"
          class="col radius8"
          size="lg"
        ></q-btn>
      </div>
    </q-card>
  </q-dialog>
</template>

<script>
export default {
  name: "CategoryList",
  data() {
    return {
      dialog: false,
      category: [],
    };
  },
  setup() {
    return {};
  },
  methods: {
    beforeShow() {
      this.category = [];
    },
  },
};
</script>
