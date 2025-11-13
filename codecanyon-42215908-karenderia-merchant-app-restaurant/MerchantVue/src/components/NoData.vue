<template>
  <div
    class="column items-center justify-center text-center full-width q-pa-md"
    :class="{ 'absolute-center': isCenter, 'q-pt-xl': !isCenter }"
  >
    <img :src="icon" class="q-mb-sm" />
    <div class="text-body1 text-grey">
      {{ $t(message) }}
    </div>
  </div>
</template>

<script setup>
defineProps({
  isCenter: {
    type: Boolean,
    default: true,
  },
  message: {
    type: String,
    default: "No data available",
  },
  icon: {
    type: String,
    default: "/svg/no-notication.svg",
  },
});
</script>
