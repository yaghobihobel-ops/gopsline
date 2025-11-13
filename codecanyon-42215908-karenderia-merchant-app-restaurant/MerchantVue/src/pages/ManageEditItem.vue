<template>
  <q-header
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
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
        $t("Update Items")
      }}</q-toolbar-title>
      <q-btn
        round
        color="mygrey"
        text-color="dark"
        icon="las la-trash"
        size="sm"
        unelevated
      />
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
  >
    <q-form @submit="onSubmit">
      <div class="row q-gutter-sm q-pl-md q-pr-md q-mt-sm">
        <div
          class="col-3 row items-center justify-center bg-mygrey radius8"
          style="height: 70px"
        >
          <q-icon name="las la-image" class="text-grey" size="xl" />
        </div>
        <div class="col">
          <div class="font12 line-normal">
            {{
              $t(
                "Items with quality photos are often more popular. Maximum 2 MB"
              )
            }}.
            {{ $t("Accepted types: PNG. JPG") }}
          </div>
          <q-btn
            :label="$t('Change Photo')"
            flat
            color="primary"
            no-caps
            class="q-pl-none q-pr-none"
          ></q-btn>
        </div>
      </div>

      <q-space class="q-pa-xs"></q-space>

      <div class="q-gutter-md q-pl-md q-pr-md">
        <q-input
          outlined
          v-model="text"
          :label="$t('Name')"
          stack-label
          color="grey-5"
          lazy-rules
          :rules="[
            (val) => (val && val.length > 0) || 'This field is required',
          ]"
        />
        <q-input
          outlined
          v-model="text"
          :label="$t('Short Description')"
          stack-label
          color="grey-5"
          autogrow
        />
        <q-input
          outlined
          v-model="text"
          :label="$t('Long Description')"
          stack-label
          color="grey-5"
          autogrow
        />

        <q-select
          outlined
          v-model="model"
          :label="$t('Status')"
          color="grey-5"
          :options="options"
          stack-label
          behavior="dialog"
          transition-show="fade"
          transition-hide="fade"
        />
      </div>

      <q-space class="q-pa-sm"></q-space>

      <q-list separator class="q-mb-md">
        <q-item clickable class="border-top-grey" @click="showCategory">
          <q-item-section>{{ $t("Category") }}</q-item-section>
          <q-item-section side>{{ $t("1 category") }}</q-item-section>
          <q-item-section avatar>
            <q-avatar rounded text-color="dark" icon="las la-angle-right" />
          </q-item-section>
        </q-item>

        <q-item clickable to="/item/pricelist">
          <q-item-section>{{ $t("Price") }}</q-item-section>
          <q-item-section side> $14 - $16 </q-item-section>
          <q-item-section avatar>
            <q-avatar rounded text-color="dark" icon="las la-angle-right" />
          </q-item-section>
        </q-item>

        <q-item clickable to="/item/addonlist">
          <q-item-section>{{ $t("Addon") }}</q-item-section>
          <q-item-section side>{{ $t("1 addon") }}</q-item-section>
          <q-item-section avatar>
            <q-avatar rounded text-color="dark" icon="las la-angle-right" />
          </q-item-section>
        </q-item>

        <q-item clickable to="/item/attributes">
          <q-item-section>{{ $t("Attributes") }}</q-item-section>
          <q-item-section avatar>
            <q-avatar rounded text-color="dark" icon="las la-angle-right" />
          </q-item-section>
        </q-item>

        <q-item clickable to="/item/availability">
          <q-item-section>{{ $t("Availability") }}</q-item-section>
          <q-item-section avatar>
            <q-avatar rounded text-color="dark" icon="las la-angle-right" />
          </q-item-section>
        </q-item>

        <q-item clickable to="/item/inventory">
          <q-item-section>{{ $t("Inventory") }}</q-item-section>
          <q-item-section avatar>
            <q-avatar rounded text-color="dark" icon="las la-angle-right" />
          </q-item-section>
        </q-item>

        <q-item clickable to="/item/promotionlist">
          <q-item-section>{{ $t("Sales Promotion") }}</q-item-section>
          <q-item-section avatar>
            <q-avatar rounded text-color="dark" icon="las la-angle-right" />
          </q-item-section>
        </q-item>

        <q-item clickable to="/item/gallery">
          <q-item-section>{{ $t("Gallery") }}</q-item-section>
          <q-item-section avatar>
            <q-avatar rounded text-color="dark" icon="las la-angle-right" />
          </q-item-section>
        </q-item>

        <q-item clickable to="/item/seo">
          <q-item-section>{{ $t("SEO") }}</q-item-section>
          <q-item-section avatar>
            <q-avatar rounded text-color="dark" icon="las la-angle-right" />
          </q-item-section>
        </q-item>
      </q-list>

      <q-footer class="q-pl-md q-pr-md q-pb-xs bg-white">
        <q-btn
          type="submit"
          color="primary"
          text-color="white"
          :label="$t('Save')"
          unelevated
          class="full-width radius8"
          size="lg"
          no-caps
        />
      </q-footer>
    </q-form>

    <CategoryList ref="categoryList"></CategoryList>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
export default {
  name: "ManageEditItem",
  components: {
    CategoryList: defineAsyncComponent(() =>
      import("components/CategoryList.vue")
    ),
  },
  methods: {
    showCategory() {
      this.$refs.categoryList.dialog = true;
    },
  },
};
</script>
