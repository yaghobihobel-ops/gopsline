<template>
  <q-menu fit ref="ref_menu" v-model="showing">
    <q-card>
      <q-card-section style="width: 200px; max-height: calc(80vh)">
        <q-color v-model="color" no-header flat />
      </q-card-section>
      <q-card-actions class="row q-gutter-x-sm">
        <div class="col">
          <q-btn
            :label="$t('Cancel')"
            no-caps
            unelevated
            color="accent"
            v-close-popup
            class="fit"
          ></q-btn>
        </div>
        <div class="col">
          <q-btn
            :label="$t('Done')"
            @click="Done"
            no-caps
            unelevated
            color="primary"
            class="fit"
          ></q-btn>
        </div>
      </q-card-actions>
    </q-card>
  </q-menu>
</template>

<script>
export default {
  name: "ColorSelection",
  props: ["is_array"],
  emits: ["update:colors"],
  setup() {
    return {};
  },
  data() {
    return {
      showing: false,
      color: "#FF00FF",
      dialog: false,
      object: null,
    };
  },
  methods: {
    Done() {
      this.$emit("update:colors", this.color);
      this.showing = false;
    },
  },
};
</script>
