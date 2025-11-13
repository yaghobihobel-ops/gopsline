import { defineStore } from "pinia";
import APIinterface from "src/api/APIinterface";

export const useMenuStore = defineStore("MenuStore", {
  state: () => ({
    loading: false,
    category: [],
    items: [],
    loading_addon: false,
    addon: [],
    addon_items: [],
    addon_category_list: [],
    loading_category: true,
    category_list: [],
    unit: [],
    item_featured: [],
    done_category: false,
    priceatt_loading: false,
    discount_type: [],
    loading_addoncategory: false,
    loading_price: false,
    price_data: [],
    loading_supplier: false,
    supplier_data: [],
    addonsort_loading: false,
    sort_addon_category: [],
    sort_size_list: [],
    sort_size: [],
    page_title: null,
    sideBarmenu: [
      {
        id: "food_items",
        name: "Food Items",
        path: "/manage/items",
        icon: "/svg/food_items.svg",
      },
      {
        id: "food_category",
        name: "Category",
        path: "/manage/category",
        icon: "/svg/food_category.svg",
      },
      {
        id: "food_addoncategory",
        name: "Addon Category",
        path: "/manage/addoncategory",
        icon: "/svg/food_addoncategory.svg",
      },
      {
        id: "food_addonitems",
        name: "Addon Items",
        path: "/manage/addonitems",
        icon: "/svg/food_addonitems.svg",
      },
      {
        id: "food_size",
        name: "Size",
        path: "/manage/size",
        icon: "/svg/food_size.svg",
      },
      {
        id: "food_ingredients",
        name: "Ingredients",
        path: "/manage/ingredients",
        icon: "/svg/food_ingredients.svg",
      },
      {
        id: "food_cooking_ref",
        name: "Cooking Reference",
        path: "/manage/cookingref",
        icon: "/svg/food_cooking_ref.svg",
      },
    ],
  }),
  persist: false,
  getters: {
    hasCategory(state) {
      if (Object.keys(state.category).length > 0) {
        return true;
      }
      return false;
    },
    hasCategories(state) {
      if (Object.keys(state.category_list).length > 0) {
        return true;
      }
      return false;
    },
    hasAddonCategory(state) {
      if (Object.keys(state.addon).length > 0) {
        return true;
      }
      return false;
    },
    hasAddon(state) {
      if (Object.keys(state.addon).length > 0) {
        return true;
      }
      return false;
    },
    hasAddonSort(state) {
      if (Object.keys(state.sort_addon_category).length > 0) {
        return true;
      }
      return false;
    },
    getCategory(state) {
      return state.category;
    },
    getItem(state) {
      return state.items;
    },
  },
  actions: {
    geStoreMenu(done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("geStoreMenu", "")
        .then((data) => {
          this.category = data.details.data.category;
          this.items = data.details.data.items;
        })
        .catch((error) => {
          this.category = [];
          this.items = [];
        })
        .then((data) => {
          this.loading = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    hadCategory() {
      if (Object.keys(this.category).length > 0) {
        return true;
      }
      return false;
    },
    geStoreAddonMenu(done) {
      this.loading_addon = true;
      APIinterface.fetchDataByTokenPost("geStoreAddonMenu", "")
        .then((data) => {
          this.addon = data.details.data;
          this.addon_items = data.details.items;
        })
        .catch((error) => {
          this.addon = [];
          this.addon_items = [];
        })
        .then((data) => {
          this.loading_addon = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    hadAddonCategory() {
      if (Object.keys(this.addon).length > 0) {
        return true;
      }
      return false;
    },
    getAddonCategoryList(done) {
      this.loading_addoncategory = true;
      APIinterface.fetchDataByTokenPost("getAddonCategoryList", "")
        .then((data) => {
          this.addon_category_list = [];
          if (Object.keys(data.details.data).length > 0) {
            Object.entries(data.details.data).forEach(([key, items]) => {
              this.addon_category_list.push({
                label: items.name,
                value: items.id,
              });
            });
          }
        })
        .catch((error) => {
          this.addon_category_list = [];
        })
        .then((data) => {
          this.loading_addoncategory = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    getCategoryList(done) {
      this.loading_category = true;
      this.done_category = false;
      APIinterface.fetchDataByTokenPost("getCategoryList", "")
        .then((data) => {
          this.category_list = [];
          this.unit = [];
          this.item_featured = [];
          if (Object.keys(data.details.data).length > 0) {
            Object.entries(data.details.data).forEach(([key, items]) => {
              this.category_list.push({
                label: items.name,
                value: items.id,
              });
            });
          }

          if (Object.keys(data.details.unit).length > 0) {
            Object.entries(data.details.unit).forEach(([key, items]) => {
              this.unit.push({
                label: items,
                value: key,
              });
            });
          }

          if (Object.keys(data.details.item_featured).length > 0) {
            Object.entries(data.details.item_featured).forEach(
              ([key, items]) => {
                this.item_featured.push({
                  label: items,
                  value: key,
                });
              }
            );
          }

          this.done_category = true;
          //
        })
        .catch((error) => {
          this.category_list = [];
          this.unit = [];
          this.item_featured = [];
        })
        .then((data) => {
          this.loading_category = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    getPriceAttributes() {
      this.priceatt_loading = true;
      APIinterface.fetchDataByTokenPost("getPriceAttributes", "")
        .then((data) => {
          this.unit = [];
          this.discount_type = [];

          if (Object.keys(data.details.unit).length > 0) {
            Object.entries(data.details.unit).forEach(([key, items]) => {
              this.unit.push({
                label: items,
                value: key,
              });
            });
          }

          if (Object.keys(data.details.discount_type).length > 0) {
            Object.entries(data.details.discount_type).forEach(
              ([key, items]) => {
                if (!APIinterface.empty(key)) {
                  this.discount_type.push({
                    label: items,
                    value: key,
                  });
                }
              }
            );
          }
        })
        .catch((error) => {
          this.unit = [];
          this.discount_type = [];
        })
        .then((data) => {
          this.priceatt_loading = false;
        });
    },
    getPriceList(item_uuid) {
      this.loading_price = true;
      APIinterface.fetchDataByTokenPost("getPriceList", "id=" + item_uuid)
        .then((data) => {
          this.price_data = [];
          const price_list = data.details.price_list;
          if (Object.keys(price_list).length > 0) {
            Object.entries(price_list).forEach(([key, items]) => {
              this.price_data.push({
                label: items.price + " " + items.size_name,
                value: items.item_size_id,
              });
            });
          }
        })
        .catch((error) => {
          this.price_data = [];
        })
        .then((data) => {
          this.loading_price = false;
        });
    },
    getSupplier() {
      this.loading_supplier = true;
      APIinterface.fetchDataByTokenPost("getSupplier", "")
        .then((data) => {
          this.supplier_data = [];
          const supplier_data = data.details.data;

          if (Object.keys(supplier_data).length > 0) {
            Object.entries(supplier_data).forEach(([key, items]) => {
              if (!APIinterface.empty(key)) {
                this.supplier_data.push({
                  label: items,
                  value: key,
                });
              }
            });
          }
        })
        .catch((error) => {
          this.supplier_data = [];
        })
        .then((data) => {
          this.loading_supplier = false;
        });
    },
    getAddonSort(id, done) {
      this.addonsort_loading = true;
      APIinterface.fetchDataByTokenPost("getAddonSort", "id=" + id)
        .then((data) => {
          this.sort_addon_category = data.details.addon_category;
          this.sort_size_list = data.details.size_list;
          this.sort_size = data.details.size;
        })
        .catch((error) => {
          this.sort_addon_category = [];
          this.sort_size_list = [];
          this.sort_size = [];
        })
        .then((data) => {
          this.addonsort_loading = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
  },
});
