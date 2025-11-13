<template>
  <q-dialog
    v-model="dialog"
    :maximized="this.$q.screen.lt.sm ? true : false"
    :position="this.$q.screen.lt.sm ? 'bottom' : 'standard'"
  >
    <q-card>
      <q-card-section class="row items-center q-pb-none">
        <q-space />
        <q-btn icon="close" flat round dense v-close-popup />
      </q-card-section>
      <q-card-section
        style="max-height: calc(80vh)"
        class="scroll"
        :class="{
          'width-200': !this.$q.screen.lt.md,
        }"
      >
        <q-list separator>
          <template v-for="items in KitchenStore.timeList" v-bind:key="items">
            <q-item clickable @click="setValue(items)">
              <q-item-section>
                <q-item-label>{{ items }}</q-item-label>
              </q-item-section>
            </q-item>
          </template>
        </q-list>
      </q-card-section>
    </q-card>
  </q-dialog>
</template>

<script>
import { useKitchenStore } from "stores/KitchenStore";

export default {
  name: "TimeSelection",
  data() {
    return {
      dialog: false,
      minutes: [],
      timeList: [],
      data: "",
      data_type: "",
    };
  },
  setup() {
    const KitchenStore = useKitchenStore();
    return { KitchenStore };
  },
  created() {
    //this.generateMinutes();
    this.KitchenStore.generateMinutes();
  },
  methods: {
    // generateMinutes() {
    //   const totalMinutes = 120;
    //   for (let minutes = 1; minutes <= totalMinutes; minutes++) {
    //     const hours = Math.floor(minutes / 60);
    //     const remainderMinutes = minutes % 60;
    //     const formattedTime = this.formatTime(hours, remainderMinutes, 0);
    //     this.timeList.push(formattedTime);
    //   }
    // },
    // formatTime(hours, minutes, seconds) {
    //   const formattedHours = hours.toString().padStart(2, "0");
    //   const formattedMinutes = minutes.toString().padStart(2, "0");
    //   const formattedSeconds = seconds.toString().padStart(2, "0");
    //   return `${formattedHours}:${formattedMinutes}:${formattedSeconds}`;
    // },
    setValue(value) {
      this.dialog = false;
      this.$emit("afterChoose", {
        value: this.data,
        data_type: this.data_type,
        time: value,
      });
    },
  },
};
</script>
