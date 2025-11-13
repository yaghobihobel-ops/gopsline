<template>
  <q-input
    outlined
    v-model="password"
    :label="$t('Password')"
    :bg-color="$q.dark.mode ? 'grey300' : 'secondary'"
    no-error-icon
    lazy-rules
    :rules="[(val) => (val && val.length > 0) || this.$t('This is required')]"
    @update:model-value="updateValue"
    :type="isPwd ? 'password' : 'text'"
    autocorrect="off"
    autocapitalize="off"
    autocomplete="off"
    spellcheck="false"
  >
    <template v-slot:prepend>
      <q-icon name="eva-lock-outline" />
    </template>
    <template v-slot:append>
      <q-icon
        :name="isPwd ? 'eva-eye-off-outline' : 'eva-eye-outline'"
        class="cursor-pointer"
        @click="isPwd = !isPwd"
      />
    </template>
  </q-input>
</template>

<script>
export default {
  name: "PasswordField",
  emits: ["update:password"],
  props: ["defaul_value"],
  data() {
    return {
      isPwd: true,
      password: "",
    };
  },
  mounted() {
    this.password = this.defaul_value;
  },
  methods: {
    updateValue(value) {
      this.$emit("update:password", value);
    },
  },
};
</script>
