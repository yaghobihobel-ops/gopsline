<template>
  <span>{{ total }}</span>
</template>

<script>
import { NumberFormat } from "@coders-tm/vue-number-format";
import { useActivityStore } from "stores/ActivityStore";

export default {
  name: "NumberFormat",
  props: ["amount"],
  data() {
    return {
      total: 0,
      number: undefined,
    };
  },
  created() {
    this.number = new NumberFormat(this.Activity.money_config);
    this.total = this.number.format(this.amount);
  },
  watch: {
    amount(newval, oldval) {
      this.total = this.number.format(newval);
    },
  },
  setup() {
    const Activity = useActivityStore();
    return {
      Activity,
    };
  },
};
</script>
