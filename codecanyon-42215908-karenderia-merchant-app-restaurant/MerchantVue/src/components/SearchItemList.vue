<template>
  <q-list separator>
    <template v-for="items in data" :key="items">
      <q-item clickable @click="onClickResult(items)">
        <q-item-section avatar>
          <q-img
            :src="items.url_image"
            lazy
            fit="cover"
            style="height: 80px; width: 80px"
            class="radius8"
            spinner-color="secondary"
            spinner-size="sm"
            placeholder-src="placeholder.png"
          />
        </q-item-section>
        <q-item-section>
          <q-item-label>
            <div class="font13 text-weight-bold no-margin line-normal">
              {{ items.name }}
            </div>
            <div class="text-grey ellipsis-2-lines font12 line-normal">
              <span v-html="items.description"></span>
            </div>

            <div class="row items-center justify-between">
              <q-chip size="sm" color="mygrey">
                <span class="text-dark">{{ items.food_type }}</span>
              </q-chip>
            </div>
          </q-item-label>
        </q-item-section>
      </q-item>
    </template>
  </q-list>
</template>

<script>
export default {
  name: "SearchItemList",
  props: ["data"],
  setup() {
    return {};
  },
  methods: {
    onClickResult(data) {
      switch (data.food_type) {
        case "category":
          this.$router.push({
            path: "/category/edit",
            query: {
              cat_id: data.cat_id,
            },
          });
          break;
        case "item":
          this.$router.push({
            path: "/item/edit",
            query: {
              item_uuid: data.item_token,
            },
          });
          break;
        case "addon":
          this.$router.push({
            path: "/addcategory/edit",
            query: {
              subcat_id: data.subcat_id,
            },
          });
          break;
        case "addon_item":
          this.$router.push({
            path: "/addonitems/edit",
            query: {
              id: data.sub_item_id,
            },
          });
          break;
      }
    },
  },
};
</script>
