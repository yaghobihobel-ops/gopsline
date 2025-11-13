<template>
  <div
    class="row q-gutter-x-sm justify-center"
    :class="{
      'absolute-center text-center full-width q-mt-xl': page == 1,
    }"
  >
    <q-circular-progress indeterminate rounded size="sm" color="primary" />
    <div class="text-subtitle1 text-grey">{{ $t("Loading") }}...</div>
  </div>
</template>

<script setup>
defineProps({
  message: {
    type: String,
    default: "No data available",
  },
  page: {
    type: Number,
    default: 1,
  },
});
</script>
