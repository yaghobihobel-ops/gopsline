<template>
  <q-header
    reveal
    reveal-offset="10"
    :class="{
      'bg-custom-grey text-dark': !$q.dark.mode,
      'bg-grey600 text-grey300': $q.dark.mode,
    }"
  >
    <q-toolbar style="border-bottom-right-radius: 25px">
      <q-btn
        @click="$router.back()"
        flat
        round
        dense
        icon="eva-arrow-ios-back-outline"
      />
      <q-toolbar-title style="font-size: 14px">{{
        $t("Transition Times")
      }}</q-toolbar-title>
    </q-toolbar>
  </q-header>
  <q-page padding>
    <div class="text-subtitle1 text-weight-medium q-pl-md">
      {{ $t("Scheduled") }}
    </div>

    <q-list separator>
      <q-item
        tag="label"
        v-ripple
        @click="
          chooseTime(
            'scheduled_order_transition_time',
            'scheduled_order_transition_time'
          )
        "
      >
        <q-item-section>
          <q-item-label>
            {{ $t("Transition Times") }}
          </q-item-label>
          <q-item-label caption>
            {{
              $t(
                "Sets the lead time in minutes before a scheduled order to trigger its movement to current orders"
              )
            }}
          </q-item-label>
        </q-item-section>
        <q-item-section side>
          <div class="flex items-center q-gutter-x-sm">
            <div>
              {{ SettingStore.scheduled_order_transition_time }}
            </div>
            <q-icon
              name="eva-arrow-ios-forward-outline"
              color="custom-grey4"
              size="25px"
            />
          </div>
        </q-item-section>
      </q-item>
    </q-list>
    <q-space class="q-pa-sm"></q-space>

    <template
      v-for="items in KitchenStore.getTransactionList"
      v-bind:key="items"
    >
      <div class="text-subtitle1 text-weight-medium q-pl-md">
        {{ items.label }}
      </div>
      <q-list separator class="q-mb-lg">
        <q-item tag="label" v-ripple @click="chooseTime(items, 'caution')">
          <q-item-section>
            <q-item-label>{{ $t("Caution Time") }}</q-item-label>
          </q-item-section>
          <q-item-section side>
            <div class="flex items-center q-gutter-x-sm">
              <div>
                {{ getData(items, "caution") }}
              </div>
              <q-icon
                name="eva-arrow-ios-forward-outline"
                color="custom-grey4"
                size="25px"
              />
            </div>
          </q-item-section>
        </q-item>
        <q-item tag="label" v-ripple @click="chooseTime(items, 'last')">
          <q-item-section>
            <q-item-label>{{ $t("Last Time") }}</q-item-label>
          </q-item-section>
          <q-item-section side>
            <div class="flex items-center q-gutter-x-sm">
              <div>
                {{ getData(items, "last") }}
              </div>
              <q-icon
                name="eva-arrow-ios-forward-outline"
                color="custom-grey4"
                size="25px"
              />
            </div>
          </q-item-section>
        </q-item>
      </q-list>
    </template>

    <TimeSelection ref="ref_time" @after-choose="afterChoose"></TimeSelection>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useKitchenStore } from "stores/KitchenStore";
import { useIdentityStore } from "stores/IdentityStore";
import { useSettingStore } from "stores/SettingStore";

export default {
  name: "DisplayMode",
  components: {
    TimeSelection: defineAsyncComponent(() =>
      import("components/TimeSelection.vue")
    ),
  },
  setup() {
    const KitchenStore = useKitchenStore();
    const IdentityStore = useIdentityStore();
    const SettingStore = useSettingStore();
    return { KitchenStore, IdentityStore, SettingStore };
  },
  methods: {
    getData(value, type) {
      let dataValue = this.SettingStore.transition_times.find(
        (item) => item.value === value.value
      );
      if (dataValue) {
        return dataValue[type];
      }
    },
    chooseTime(data, type) {
      this.$refs.ref_time.data = data.value;
      this.$refs.ref_time.data_type = type;
      this.$refs.ref_time.dialog = true;
    },
    afterChoose(data) {
      if (data.data_type == "scheduled_order_transition_time") {
        this.SettingStore.scheduled_order_transition_time = data.time;
        this.KitchenStore.saveScheduledTransitionTime("time=" + data.time);
      } else {
        if (Object.keys(this.SettingStore.transition_times).length > 0) {
          let found = false;
          this.SettingStore.transition_times.forEach((item) => {
            console.log("item", item);
            if (data.value == item.value) {
              found = true;
              item[data.data_type] = data.time;
            }
          });

          if (!found) {
            const newdata = {
              value: data.value,
              [data.data_type]: data.time,
            };
            this.SettingStore.transition_times.push(newdata);
          }
        } else {
          const newdata = {
            value: data.value,
            [data.data_type]: data.time,
          };
          console.log("newdata", newdata);
          this.SettingStore.transition_times.push(newdata);
        }
      }
    },
  },
};
</script>
