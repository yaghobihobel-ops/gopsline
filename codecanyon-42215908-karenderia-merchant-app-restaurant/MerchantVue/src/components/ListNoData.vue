<template>
  <!-- <div class="flex flex-center" :style="set_height ? set_height : fixedHeight">
    <div class="full-width text-center">
      <div class="text-weight-bold text-subtitle2">{{ title }}</div>
      <p class="text-grey text-body2">{{ subtitle }}</p>
    </div>
  </div> -->

  <div
    class="flex justify-center items-center q-gutter-x-sm"
    :style="set_height ? set_height : fixedHeight"
  >
    <img src="/svg/no-data.svg" />
    <div class="text-body1 text-grey">{{ title }}</div>
  </div>
</template>

<script>
export default {
  name: "ListNoData",
  props: ["title", "subtitle", "set_height"],
  data() {
    return {
      fixedHeight: "min-height: calc(30vh)",
    };
  },
  setup() {
    return {};
  },
};
</script>
