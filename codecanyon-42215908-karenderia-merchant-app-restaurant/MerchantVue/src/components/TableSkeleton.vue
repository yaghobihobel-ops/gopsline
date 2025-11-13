<template>
  <q-list>
    <q-item v-for="items in rows" :key="items">
      <q-item-section avatar>
        <q-skeleton
          type="QAvatar"
          :class="{
            'bg-grey600': $q.dark.mode,
          }"
        />
      </q-item-section>
      <q-item-section>
        <q-item-label>
          <q-skeleton
            type="text"
            :class="{
              'bg-grey600': $q.dark.mode,
            }"
          />
        </q-item-label>
        <q-item-label caption>
          <q-skeleton
            type="text"
            width="65%"
            :class="{
              'bg-grey600': $q.dark.mode,
            }"
          />
        </q-item-label>
      </q-item-section>
    </q-item>
  </q-list>
</template>

<script>
export default {
  name: "TableSkeleton",
  props: ["rows"],
  setup() {
    return {};
  },
};
</script>
