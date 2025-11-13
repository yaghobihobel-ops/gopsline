<template>
  <q-tabs
    v-model="tab"
    dense
    no-caps
    indicator-color="transparent"
    align="justify"
    narrow-indicator
    shrink
    switch-indicator="false"
    class="text-grey q-ml-sm"
    stretch
    mobile-arrows
  >
    <template v-for="items in tab_menu" :key="items">
      <q-route-tab
        :name="items.name"
        :label="items.label"
        :to="items.to"
        exact-active-class="bg-primary text-white radius28"
      />
    </template>
  </q-tabs>
</template>

<script>
export default {
  name: "TabsRouterMenu",
  props: ["tab_menu"],
  data() {
    return {
      tab: "",
    };
  },
};
</script>
