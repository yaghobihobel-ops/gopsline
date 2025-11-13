<template>
  <template v-if="loading">
    <q-skeleton type="text" v-for="i in 2" :key="i" />
  </template>
  <q-list v-else>
    <q-expansion-item v-model="expanded" expand-separator :label="changeLabel">
      <q-card>
        <q-card-section>
          <template v-for="items in order_items" :key="items">
            <div class="row item-center font12 q-mb-xs">
              <div class="col-1">{{ items.qty }}</div>
              <div class="col">
                <div>{{ items.item_name }}</div>
                <div v-if="items.special_instructions" class="text-green">
                  {{ items.special_instructions }}
                </div>

                <!-- Attributes -->
                <template v-if="items.attributes != ''">
                  <template
                    v-for="attributes in items.attributes"
                    :key="attributes"
                  >
                    <div>
                      <template
                        v-for="(
                          attributes_data, attributes_index
                        ) in attributes"
                        :key="attributes_data"
                      >
                        {{ attributes_data
                        }}<template
                          v-if="attributes_index < attributes.length - 1"
                          >,
                        </template>
                      </template>
                    </div>
                  </template>
                </template>
                <!-- Attributes -->
              </div>
              <!-- col -->
              <div class="col-2">
                {{ items.price.pretty_total_after_discount }}
              </div>
            </div>

            <template v-for="addons in items.addons" :key="addons">
              <div class="row font12 text-weight-bold">
                <div class="col-1"></div>
                <div class="col">{{ addons.subcategory_name }}</div>
              </div>
              <div
                class="row font12"
                v-for="addon_items in addons.addon_items"
                :key="addon_items"
              >
                <div class="col-1"></div>
                <div class="col">{{ addon_items.sub_item_name }}</div>
                <div class="col-2">
                  {{ addon_items.pretty_addons_total }}
                </div>
              </div>
            </template>
          </template>
        </q-card-section>
      </q-card>
    </q-expansion-item>
  </q-list>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "OrderDetails",
  props: ["order_uuid"],
  data() {
    return {
      expanded: false,
      loading: false,
      order_items: [],
      item_count: 0,
    };
  },
  created() {
    this.getOrderDetails();
  },
  watch: {
    order_uuid(newval, oldval) {
      this.getOrderDetails();
    },
  },
  computed: {
    changeLabel() {
      //const $item_count = Object.keys(this.order_items).length;
      const $item_count = this.item_count;
      const $fastened = $item_count > 1 ? this.$t("Items") : this.$t("Item");

      if (this.expanded) {
        return $item_count + " " + $fastened;
      }
      return this.$t("View order") + " " + $fastened + "(" + $item_count + ")";
    },
    hasData() {
      if (Object.keys(this.order_items).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    getOrderDetails() {
      this.loading = true;
      APIinterface.fetchDataByToken("orderdetails", {
        order_uuid: this.order_uuid,
      })
        .then((result) => {
          this.order_items = result.details.items;
          this.item_count = result.details.item_count;
        })
        .catch((error) => {
          console.debug(error);
          this.order_items = [];
          this.item_count = 0;
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
