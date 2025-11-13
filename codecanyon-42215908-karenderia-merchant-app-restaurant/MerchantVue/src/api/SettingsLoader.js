import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";
import jwt_decode from "jwt-decode";

export async function loadAppSettings() {
  try {
    const DataStore = useDataStore();
    const results = await APIinterface.fetchDataPost("getAttributes");
    const settings = results.details;

    DataStore.language_data = jwt_decode(settings?.language_data);
    DataStore.money_config = settings?.money_config;
    DataStore.realtime_data = jwt_decode(settings?.realtime);
    DataStore.legal_menu = settings?.legal_menu;
    DataStore.language_list = settings?.language_list;
    DataStore.last_order = settings?.last_order;
    DataStore.rejection_list = settings?.rejection_list;

    DataStore.dish_list = settings.dish_list;
    DataStore.status_list = settings.status_list;
    DataStore.status_list_raw = settings.status_list_raw;
    DataStore.booking_status_list = settings.booking_status_list;
    DataStore.booking_status_list_value = settings.booking_status_list_value;
    DataStore.promo_type = [];
    DataStore.delayed_min_list = [];

    DataStore.bank_status_list = settings.bank_status_list;
    DataStore.multi_option = settings.multi_option;
    DataStore.two_flavor_properties = settings.two_flavor_properties;
    DataStore.promo_type = settings.promo_type;

    DataStore.cuisine = settings.cuisine;
    DataStore.services = settings.services;
    DataStore.tags = settings.tags;
    DataStore.unit = settings.unit;
    DataStore.featured = settings.featured;

    DataStore.two_flavor_options = settings.two_flavor_options;
    DataStore.tips = settings.tips;
    DataStore.tip_type = settings.tip_type;
    DataStore.day_list = settings.day_list;
    DataStore.day_week = settings.day_week;
    DataStore.registration_settings = settings.registration_settings;

    DataStore.phone_default_data = settings.phone_default_data;

    DataStore.printer_list = settings.printer_list;

    DataStore.app_version_android = settings.app_version_android;
    DataStore.app_version_ios = settings.app_version_ios;
    DataStore.android_download_url = settings.android_download_url;
    DataStore.ios_download_url = settings.ios_download_url;

    DataStore.enabled_language = settings.enabled_language;
    DataStore.time_range = settings.time_range;
    DataStore.time_interval = settings.time_interval;
    DataStore.time_interval_list = settings.time_interval_list;
    DataStore.salary_type = settings.salary_type;
    DataStore.employment_type = settings.employment_type;
    DataStore.commission_type = settings.commission_type;
    DataStore.customer_status = settings.customer_status;

    DataStore.maps_config = jwt_decode(settings.maps_config);

    DataStore.phone_prefix_data = [];
    if (Object.keys(settings.phone_prefix_data).length > 0) {
      Object.entries(settings.phone_prefix_data).forEach(([key, items]) => {
        DataStore.phone_prefix_data.push({
          label: "+" + items.phonecode + " " + items.country_name,
          value: "+" + items.phonecode,
          flag: items.flag,
        });
      });
    }

    Object.entries(settings.delayed_min_list).forEach(([key, items]) => {
      DataStore.delayed_min_list.push({
        label: items.value,
        value: items.id,
      });
    });

    DataStore.settings_data = settings?.settings_data ?? null;
  } catch (error) {
    console.log("error", error);
  } finally {
  }
}
