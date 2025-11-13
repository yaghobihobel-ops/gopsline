<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-header
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
      class="myshadow"
    >
      <q-toolbar>
        <q-btn
          @click="$router.back()"
          flat
          round
          dense
          icon="las la-angle-left"
          :color="$q.dark.mode ? 'white' : 'dark'"
        />
        <q-toolbar-title class="text-weight-bold">{{
          $t("Item Attributes")
        }}</q-toolbar-title>
      </q-toolbar>
      <q-separator></q-separator>
    </q-header>
    <q-page class="q-pa-md">
      <template v-if="loading_get">
        <q-inner-loading :showing="true" color="primary" size="md" />
      </template>

      <q-form v-else @submit="onSubmit">
        <q-space class="q-pa-sm"></q-space>
        <div class="q-pa-mdx q-gutter-md">
          <q-toggle
            v-model="points_enabled"
            :label="$t('Enabled Points')"
            dense
          />
          <q-toggle
            v-model="packaging_incremental"
            :label="$t('Enabled Packaging Incrementals')"
            dense
          />
          <q-toggle
            v-model="cooking_ref_required"
            :label="$t('Cooking Reference Mandatory')"
            dense
          />

          <q-toggle
            v-model="ingredients_preselected"
            :label="$t('Ingredients pre-selected')"
            dense
          />

          <q-input
            outlined
            v-model="points_earned"
            :label="$t('Points earned')"
            stack-label
          />

          <q-input
            outlined
            v-model="packaging_fee"
            :label="$t('Packaging fee')"
            stack-label
          />

          <q-input
            outlined
            v-model="preparation_time"
            type="number"
            step="any"
            :label="$t('Preparation Time (minutes)')"
            stack-label
            :rules="[
              (val) =>
                val === 0 ||
                ((!!val || val === 0) && Number(val) >= 0) ||
                $t('Value must be 0 or greater'),
            ]"
            hide-bottom-space
          />

          <q-input
            outlined
            v-model="extra_preparation_time"
            type="number"
            step="any"
            :label="$t('Extra Time (Minutes)')"
            stack-label
            hide-bottom-space
          />
          <div class="text-caption text-grey">
            {{ $t("example. for each extra Burger, add 2 minutes") }}
          </div>

          <q-select
            outlined
            v-model="allergens_selected"
            :label="$t('Allergens')"
            :options="allergens_list"
            stack-label
            emit-value
            map-options
            multiple
            behavior="menu"
            transition-show="fade"
            transition-hide="fade"
          />

          <q-select
            outlined
            v-model="cooking_selected"
            :label="$t('Cooking Reference')"
            :options="cooking_ref"
            stack-label
            emit-value
            map-options
            multiple
            behavior="menu"
            transition-show="fade"
            transition-hide="fade"
          />

          <q-select
            outlined
            v-model="ingredients_selected"
            :label="$t('Ingredients')"
            :options="ingredients"
            stack-label
            emit-value
            map-options
            multiple
            behavior="menu"
            transition-show="fade"
            transition-hide="fade"
          />

          <q-select
            outlined
            v-model="dish_selected"
            :label="$t('Dish')"
            :options="dish"
            stack-label
            map-options
            emit-value
            multiple
            behavior="menu"
            transition-show="fade"
            transition-hide="fade"
          />

          <q-select
            outlined
            v-model="delivery_options_selected"
            :label="$t('Delivery options')"
            :options="transport"
            stack-label
            map-options
            emit-value
            multiple
            behavior="menu"
            transition-show="fade"
            transition-hide="fade"
          />
        </div>

        <q-space class="q-pa-md"></q-space>

        <q-footer class="q-pa-md bg-white myshadow">
          <q-btn
            type="submit"
            color="amber-6"
            text-color="disabled"
            unelevated
            class="full-width radius8"
            size="lg"
            no-caps
            :loading="loading"
          >
            <div class="text-weight-bold text-subtitle2">
              {{ $t("Save") }}
            </div>
          </q-btn>
        </q-footer>
      </q-form>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "ItemAttributes",
  data() {
    return {
      points_enabled: false,
      packaging_incremental: false,
      cooking_ref_required: false,
      ingredients_preselected: false,
      points_earned: 0,
      packaging_fee: 0,
      cooking_selected: [],
      ingredients_selected: [],
      dish_selected: [],
      delivery_options_selected: [],
      loading_get: false,
      loading: false,
      item_uuid: "",
      cooking_ref: [],
      ingredients: [],
      dish: [],
      transport: [],
      allergens_selected: [],
      allergens_list: [],
      preparation_time: null,
      extra_preparation_time: null,
    };
  },
  computed: {
    isEdit() {
      if (!APIinterface.empty(this.item_uuid)) {
        return true;
      }
      return false;
    },
  },
  mounted() {
    this.item_uuid = this.$route.query.item_uuid;
    this.getItemAttributes();
  },
  methods: {
    refresh(done) {
      if (!APIinterface.empty(this.item_uuid)) {
        this.getItemAttributes(done);
      } else {
        done();
      }
    },
    getItemAttributes(done) {
      this.loading_get = true;
      APIinterface.fetchDataByTokenPost(
        "getItemAttributes",
        "item_uuid=" + this.item_uuid
      )
        .then((data) => {
          this.points_enabled = data.details.data.points_enabled;
          this.packaging_incremental = data.details.data.packaging_incremental;
          this.cooking_ref_required = data.details.data.cooking_ref_required;
          this.ingredients_preselected =
            data.details.data.ingredients_preselected;

          this.points_earned = data.details.data.points_earned;
          this.packaging_fee = data.details.data.packaging_fee;

          this.preparation_time = data.details.data.preparation_time;
          this.extra_preparation_time =
            data.details.data.extra_preparation_time;

          this.cooking_selected = data.details.data.cooking_selected;
          this.ingredients_selected = data.details.data.ingredients_selected;
          this.dish_selected = data.details.data.dish_selected;
          this.delivery_options_selected =
            data.details.data.delivery_options_selected;

          this.allergens_list = data.details.allergens;
          this.allergens_selected = data.details.data.allergen_selected;

          this.cooking_ref = [];
          this.ingredients = [];
          this.dish = [];
          this.transport = [];
          Object.entries(data.details.cooking_ref).forEach(([key, items]) => {
            this.cooking_ref.push({
              label: items,
              value: key,
            });
          });

          Object.entries(data.details.ingredients).forEach(([key, items]) => {
            this.ingredients.push({
              label: items,
              value: key,
            });
          });

          Object.entries(data.details.dish).forEach(([key, items]) => {
            this.dish.push({
              label: items,
              value: key,
            });
          });

          Object.entries(data.details.transport).forEach(([key, items]) => {
            this.transport.push({
              label: items,
              value: key,
            });
          });

          //
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading_get = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    onSubmit() {
      this.loading = true;
      APIinterface.fetchDataByToken("saveItemAttributes", {
        item_uuid: this.item_uuid,
        points_enabled: this.points_enabled,
        packaging_incremental: this.packaging_incremental,
        cooking_ref_required: this.cooking_ref_required,
        ingredients_preselected: this.ingredients_preselected,
        points_earned: this.points_earned,
        packaging_fee: this.packaging_fee,
        cooking_selected: this.cooking_selected,
        ingredients_selected: this.ingredients_selected,
        dish_selected: this.dish_selected,
        delivery_options_selected: this.delivery_options_selected,
        allergens_selected: this.allergens_selected,
        preparation_time: this.preparation_time,
        extra_preparation_time: this.extra_preparation_time,
      })
        .then((data) => {
          APIinterface.ShowSuccessful(data.msg, this.$q);
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
