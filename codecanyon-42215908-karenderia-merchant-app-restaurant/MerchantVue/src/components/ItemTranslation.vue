<template>
  <q-list bordered class="rounded-borders">
    <q-expansion-item expand-separator :label="$t('Item Translation')">
      <q-card>
        <q-card-section>
          <!-- =>{{ update }} -->
          <!-- <pre>{{ data }}</pre> -->
          <!-- <pre>{{ field_data }}</pre> -->
          <!-- <pre>{{ field_data1 }}</pre>  -->
          <template
            v-for="(language, code) in DataStore.language_list"
            :key="language"
          >
            <div>
              {{ language }} <span class="hidden">{{ code }}</span>
            </div>
            <template v-for="items in fields" :key="items">
              <!--:model-value="field_data2[items.name + '|' + code]"-->
              <q-input
                v-if="items.name == 'name'"
                outlined
                :label="items.title"
                :model-value="
                  field_data[items.name] ? field_data[items.name][code] : ''
                "
                stack-label
                color="grey-5"
                class="q-mb-sm"
                @update:model-value="(v) => setValue(v, items.name, code)"
              />

              <q-input
                v-else
                outlined
                :label="items.title"
                :model-value="
                  field_data1[items.name] ? field_data1[items.name][code] : ''
                "
                stack-label
                color="grey-5"
                class="q-mb-sm"
                @update:model-value="(v) => setValue(v, items.name, code)"
                autogrow
              />
            </template>
            <q-space class="q-pa-sm"></q-space>
          </template>
        </q-card-section>
      </q-card>
    </q-expansion-item>
  </q-list>
</template>

<script>
import { useDataStore } from "stores/DataStore";

export default {
  name: "ItemTranslation",
  props: ["fields", "update", "data"],
  setup(props) {
    const DataStore = useDataStore();
    return { DataStore };
  },
  data() {
    return {
      field_data: {},
      field_data1: {},
      field_data2: {},
    };
  },
  created() {
    if (Object.keys(this.DataStore.language_list).length > 0) {
      this.field_data = {
        name: {},
      };
      this.field_data1 = {
        description: {},
      };
      Object.entries(this.DataStore.language_list).forEach(([key, items]) => {
        this.field_data.name[key] = "";
        this.field_data1.description[key] = "";
      });
    }

    this.setData();
  },
  watch: {
    field_data: {
      handler(form, oldForm) {
        this.$emit("afterInput", [this.field_data, this.field_data1]);
      },
      deep: true,
    },
    field_data1: {
      handler(form, oldForm) {
        this.$emit("afterInput", [this.field_data, this.field_data1]);
      },
      deep: true,
    },
    data: {
      handler(form, oldForm) {
        this.setData();
      },
      deep: true,
    },
  },
  methods: {
    setData() {
      if (this.update) {
        if (this.data.name) {
          this.field_data.name = this.data.name;
        }
        if (this.data.description) {
          this.field_data1.description = this.data.description;
        }
      }
    },
    setValue(value, name, code) {
      this.field_data2[name + "|" + code] = value;
      // this.field_data[name] = {
      //   code: code,
      //   value: value,
      // };
      var obj = {};
      var obj2 = {};
      obj2[code] = value;
      obj[name] = obj2;

      if (name == "name") {
        if (this.field_data[name]) {
          this.field_data[name][code] = value;
        } else {
          this.field_data = obj;
        }
      } else {
        if (this.field_data1[name]) {
          this.field_data1[name][code] = value;
        } else {
          this.field_data1 = obj;
        }
      }
    },
  },
};
</script>
