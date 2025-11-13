<template>
  <q-header reveal reveal-offset="10" class="bg-transparent text-dark">
    <q-toolbar class="bg-custom-grey3" style="border-bottom-right-radius: 25px">
      <q-btn
        @click="$router.back()"
        flat
        round
        dense
        icon="eva-arrow-ios-back-outline"
      />
      <q-toolbar-title style="font-size: 14px">{{
        $t("Settings")
      }}</q-toolbar-title>
    </q-toolbar>
  </q-header>
  <q-page padding>
    <q-list>
      <q-item
        clickable
        active-class="bg-teal-1 text-grey-8 radius-10"
        to="/settings-mobile/display"
      >
        <q-item-section avatar>
          <q-icon name="eva-tv-outline" />
        </q-item-section>
        <q-item-section>
          <q-item-label> {{ $t("Display Mode") }} </q-item-label>
        </q-item-section>
      </q-item>
      <q-item clickable to="/settings-mobile/sounds">
        <q-item-section avatar>
          <q-icon color="custom-grey4" name="eva-volume-up-outline" />
        </q-item-section>
        <q-item-section>
          <q-item-label> {{ $t("Sounds") }} </q-item-label>
        </q-item-section>
      </q-item>
      <q-item clickable to="/settings-mobile/transtition-times">
        <q-item-section avatar>
          <q-icon
            color="custom-grey4"
            name="eva-clock-outline
"
          />
        </q-item-section>
        <q-item-section>
          <q-item-label> {{ $t("Transition Times") }} </q-item-label>
        </q-item-section>
      </q-item>

      <q-item clickable to="/settings-mobile/colors">
        <q-item-section avatar>
          <q-icon color="custom-grey4" name="eva-color-palette-outline" />
        </q-item-section>
        <q-item-section>
          <q-item-label> {{ $t("Colors") }} </q-item-label>
        </q-item-section>
      </q-item>
    </q-list>
  </q-page>
</template>

<script>
export default {
  // name: 'PageName',
};
</script>
