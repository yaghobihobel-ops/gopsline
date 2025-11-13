<template>
  <div class="flex flex-center full-width" :style="minHeightStyle">
    <q-spinner-ios size="sm" />
    <div class="text-subtitle1 text-grey">{{ $t("Loading") }}...</div>
  </div>
</template>

<script>
export default {
  name: "ListLoading",
  props: {
    vh: {
      type: Number,
      default: 20,
    },
  },
  computed: {
    minHeightStyle() {
      return {
        minHeight: `calc(${this.vh}vh)`,
      };
    },
  },
};
</script>
