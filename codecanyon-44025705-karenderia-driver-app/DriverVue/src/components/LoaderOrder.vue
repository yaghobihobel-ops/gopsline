<template>
  <q-card class="shadow-1 q-mb-md">
    <q-card-section>
      <div class="row q-gutter-sm">
        <div class="col-2">
          <q-skeleton type="QAvatar" />
        </div>
        <div class="col">
          <q-skeleton type="text" />
          <q-skeleton type="text" />
        </div>
        <div class="col-1"></div>
        <div class="col-3 text-right">
          <q-skeleton type="text" />
          <q-skeleton type="text" />
        </div>
      </div>
    </q-card-section>
    <q-list>
      <q-item>
        <q-item-section>
          <q-item-label
            ><q-skeleton type="text" style="width: 100px"
          /></q-item-label>
          <q-item-label
            ><q-skeleton type="text" style="width: 100px"
          /></q-item-label>
        </q-item-section>
      </q-item>
      <q-item>
        <q-item-section>
          <q-item-label><q-skeleton type="text" /></q-item-label>
          <q-item-label><q-skeleton type="text" /></q-item-label>
        </q-item-section>
      </q-item>
    </q-list>
  </q-card>
</template>

<script>
export default {
  // name: 'ComponentName',
  setup() {
    return {};
  },
};
</script>
