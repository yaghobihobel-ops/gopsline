<template>
  <TopNav :title="$t('Settings')"></TopNav>
  <q-page
    padding
    :class="{
      'bg-dark': $q.dark.mode && $q.screen.lt.md,
    }"
  >
    <template v-if="$q.screen.lt.md">
      <q-list separator>
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
          <q-item-section side>
            <q-icon name="eva-chevron-right-outline" color="grey-4"></q-icon>
          </q-item-section>
        </q-item>
        <q-item clickable to="/settings-mobile/sounds">
          <q-item-section avatar>
            <q-icon color="custom-grey4" name="eva-volume-up-outline" />
          </q-item-section>
          <q-item-section>
            <q-item-label> {{ $t("Sounds") }} </q-item-label>
          </q-item-section>
          <q-item-section side>
            <q-icon name="eva-chevron-right-outline" color="grey-4"></q-icon>
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
          <q-item-section side>
            <q-icon name="eva-chevron-right-outline" color="grey-4"></q-icon>
          </q-item-section>
        </q-item>

        <q-item clickable to="/settings-mobile/colors">
          <q-item-section avatar>
            <q-icon color="custom-grey4" name="eva-color-palette-outline" />
          </q-item-section>
          <q-item-section>
            <q-item-label> {{ $t("Colors") }} </q-item-label>
          </q-item-section>
          <q-item-section side>
            <q-icon name="eva-chevron-right-outline" color="grey-4"></q-icon>
          </q-item-section>
        </q-item>

        <q-item clickable to="/settings-mobile/language">
          <q-item-section avatar>
            <q-icon color="custom-grey4" name="eva-flag-outline" />
          </q-item-section>
          <q-item-section>
            <q-item-label> {{ $t("Language") }} </q-item-label>
          </q-item-section>
          <q-item-section side>
            <q-icon name="eva-chevron-right-outline" color="grey-4"></q-icon>
          </q-item-section>
        </q-item>

        <q-item clickable to="/settings-mobile/delete-account">
          <q-item-section avatar>
            <q-icon color="custom-grey4" name="eva-person-delete-outline" />
          </q-item-section>
          <q-item-section>
            <q-item-label> {{ $t("Delete Account") }} </q-item-label>
          </q-item-section>
          <q-item-section side>
            <q-icon name="eva-chevron-right-outline" color="grey-4"></q-icon>
          </q-item-section>
        </q-item>

        <q-item clickable to="/settings-mobile/legal">
          <q-item-section avatar>
            <q-icon color="custom-grey4" name="las la-balance-scale" />
          </q-item-section>
          <q-item-section>
            <q-item-label> {{ $t("Legal") }} </q-item-label>
          </q-item-section>
          <q-item-section side>
            <q-icon name="eva-chevron-right-outline" color="grey-4"></q-icon>
          </q-item-section>
        </q-item>

        <q-item clickable to="/settings-mobile/printers">
          <q-item-section avatar>
            <q-icon color="custom-grey4" name="eva-printer-outline" />
          </q-item-section>
          <q-item-section>
            <q-item-label> {{ $t("Printers") }} </q-item-label>
          </q-item-section>
          <q-item-section side>
            <q-icon name="eva-chevron-right-outline" color="grey-4"></q-icon>
          </q-item-section>
        </q-item>
      </q-list>
    </template>
    <template v-else>
      <q-card flat class="box-shadow card-form-height">
        <q-card-section>
          <q-splitter v-model="splitterModel">
            <template v-slot:before>
              <q-tabs
                v-model="SettingStore.tab"
                vertical
                class="text-custom-grey4 q-mr-sm"
                no-caps
                inline-label
                content-class="custom-tabs"
                :active-bg-color="$q.dark.mode ? 'grey300' : 'teal-1'"
                active-class="radius-10"
                :active-color="$q.dark.mode ? 'grey600' : 'primary'"
                indicator-color="transparent"
              >
                <q-tab
                  name="display"
                  icon="eva-tv-outline"
                  :label="$t('Display Mode')"
                />
                <q-tab
                  name="sounds"
                  icon="eva-volume-up-outline"
                  :label="$t('Sounds')"
                />
                <q-tab
                  name="times"
                  icon="eva-clock-outline"
                  :label="$t('Transition Times')"
                />
                <q-tab
                  name="colors"
                  icon="eva-color-palette-outline"
                  :label="$t('Colors')"
                />
                <q-tab
                  name="language"
                  icon="eva-flag-outline"
                  :label="$t('Language')"
                  v-if="KitchenStore.isLanguageEnabled"
                />

                <q-tab
                  name="account"
                  icon="eva-person-delete-outline"
                  :label="$t('Delete Account')"
                />

                <q-tab
                  name="legal"
                  icon="las la-balance-scale"
                  :label="$t('Legal')"
                />

                <q-tab
                  name="printers"
                  icon="eva-printer-outline"
                  :label="$t('Printers')"
                />
              </q-tabs>
            </template>

            <template v-slot:after>
              <q-tab-panels
                v-model="SettingStore.tab"
                animated
                swipeable
                vertical
                transition-prev="fade"
                transition-next="fade"
              >
                <!-- DISPLAY SETTINGS -->
                <q-tab-panel name="display" class="q-pt-none">
                  <q-list separator>
                    <q-item tag="label" v-ripple>
                      <q-item-section>
                        <q-item-label>{{ $t("Dark Theme") }}</q-item-label>
                      </q-item-section>
                      <q-item-section avatar>
                        <q-toggle
                          v-model="SettingStore.dark_theme"
                          val="1"
                          @update:model-value="setDarkmode"
                        />
                      </q-item-section>
                    </q-item>
                    <q-item>
                      <q-item-section>
                        <q-item-label>{{ $t("Screen Options") }}</q-item-label>
                      </q-item-section>
                    </q-item>

                    <template
                      v-for="items in KitchenStore.screen_list"
                      v-bind:key="items"
                    >
                      <q-item tag="label" v-ripple>
                        <q-item-section avatar>
                          <q-radio
                            v-model="SettingStore.screen_options"
                            :val="items.value"
                          />
                        </q-item-section>
                        <q-item-section>
                          <q-item-label>
                            {{ $t(items.label) }}
                          </q-item-label>
                        </q-item-section>
                      </q-item>
                    </template>
                  </q-list>

                  <!-- <pre>{{ SettingStore.split_order_type }}</pre> -->

                  <template v-if="SettingStore.screen_options == 'split'">
                    <q-separator class="q-mt-md"></q-separator>
                    <q-list separator>
                      <template
                        v-for="items in KitchenStore.getTransactionList"
                        :key="items"
                      >
                        <q-item tag="label">
                          <q-item-section>
                            <q-item-label>
                              {{ items.label }}
                            </q-item-label>
                          </q-item-section>
                          <q-item-section side>
                            <div class="q-gutter-sm">
                              <q-radio
                                v-model="
                                  SettingStore.split_order_type[items.value]
                                "
                                val="top"
                                label="Top"
                              />
                              <q-radio
                                v-model="
                                  SettingStore.split_order_type[items.value]
                                "
                                val="bottom"
                                label="Bottom"
                              />
                            </div>
                          </q-item-section>
                        </q-item>
                      </template>
                    </q-list>
                  </template>
                </q-tab-panel>

                <!-- SOUNDS SETTINGS -->
                <q-tab-panel name="sounds" class="q-pt-none">
                  <q-list separator>
                    <q-item tag="label" v-ripple>
                      <q-item-section>
                        <q-item-label>{{
                          $t("Push Notifications")
                        }}</q-item-label>
                      </q-item-section>
                      <q-item-section avatar>
                        <q-toggle
                          v-model="SettingStore.push_notifications"
                          val="1"
                          @update:model-value="updatePushNotifications"
                        />
                      </q-item-section>
                    </q-item>

                    <q-item tag="label" v-ripple>
                      <q-item-section>
                        <q-item-label>{{
                          $t("Mute Order Sounds")
                        }}</q-item-label>
                      </q-item-section>
                      <q-item-section avatar>
                        <q-toggle v-model="SettingStore.mute_sounds" val="1" />
                      </q-item-section>
                    </q-item>

                    <q-item tag="label" v-ripple>
                      <q-item-section>
                        <q-item-label>{{
                          $t("Repeat Until Order Acknowledge")
                        }}</q-item-label>
                        <q-item-label caption>
                          {{
                            $t(
                              'Repeat sounds until order is marked "in progress"'
                            )
                          }}
                        </q-item-label>
                      </q-item-section>
                      <q-item-section avatar>
                        <q-toggle
                          v-model="SettingStore.repeat_notication"
                          val="1"
                          @update:model-value="setRepeat"
                        />
                      </q-item-section>
                    </q-item>
                  </q-list>
                </q-tab-panel>

                <!-- TRANSITION TIMES -->
                <q-tab-panel name="times" class="q-pt-none">
                  <!-- <pre>{{ SettingStore.transition_times }}</pre> -->

                  <div class="text-h6">{{ $t("Scheduled") }}</div>

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
                    <div class="text-h6">{{ items.label }}</div>
                    <q-list separator class="q-mb-lg">
                      <q-item
                        tag="label"
                        v-ripple
                        @click="chooseTime(items, 'caution')"
                      >
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
                      <q-item
                        tag="label"
                        v-ripple
                        @click="chooseTime(items, 'last')"
                      >
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
                </q-tab-panel>

                <!-- COLORS SETTINGS -->
                <q-tab-panel name="colors" class="q-pt-none">
                  <div class="text-h6">{{ $t("Status Colors") }}</div>
                  <q-list separator>
                    <q-item tag="label" v-ripple>
                      <q-item-section>
                        <q-item-label>{{ $t("On Time") }}</q-item-label>
                      </q-item-section>
                      <q-item-section side>
                        <div class="flex items-center q-gutter-x-sm">
                          <q-avatar
                            :style="`background-color: ${SettingStore.color_ontime}`"
                            text-color="white"
                            size="lg"
                          />
                          <q-icon
                            name="eva-arrow-ios-forward-outline"
                            color="custom-grey4"
                            size="25px"
                          />
                        </div>
                        <ColorSelection
                          is_array="false"
                          v-model:colors="SettingStore.color_ontime"
                        ></ColorSelection>
                      </q-item-section>
                    </q-item>
                    <q-item tag="label" v-ripple>
                      <q-item-section>
                        <q-item-label>{{ $t("Caution") }}</q-item-label>
                      </q-item-section>
                      <q-item-section side>
                        <div class="flex items-center q-gutter-x-sm">
                          <q-avatar
                            :style="`background-color: ${SettingStore.color_caution}`"
                            text-color="white"
                            size="lg"
                          />
                          <q-icon
                            name="eva-arrow-ios-forward-outline"
                            color="custom-grey4"
                            size="25px"
                          />
                          <ColorSelection
                            is_array="false"
                            v-model:colors="SettingStore.color_caution"
                          ></ColorSelection>
                        </div>
                      </q-item-section>
                    </q-item>
                    <q-item tag="label" v-ripple>
                      <q-item-section>
                        <q-item-label>{{ $t("Late") }}</q-item-label>
                      </q-item-section>
                      <q-item-section side>
                        <div class="flex items-center q-gutter-x-sm">
                          <q-avatar
                            :style="`background-color: ${SettingStore.color_late}`"
                            text-color="white"
                            size="lg"
                          />
                          <q-icon
                            name="eva-arrow-ios-forward-outline"
                            color="custom-grey4"
                            size="25px"
                          />
                          <ColorSelection
                            is_array="false"
                            v-model:colors="SettingStore.color_late"
                          ></ColorSelection>
                        </div>
                      </q-item-section>
                    </q-item>
                  </q-list>

                  <q-space class="q-pa-sm"></q-space>

                  <div class="text-h6">{{ $t("Order Type") }}</div>
                  <!-- <pre>{{ SettingStore.color_status }}</pre> -->
                  <q-list separator>
                    <template
                      v-for="items in KitchenStore.getTransactionList"
                      v-bind:key="items"
                    >
                      <q-item tag="label" v-ripple>
                        <q-item-section>
                          <q-item-label>{{ items.label }}</q-item-label>
                        </q-item-section>
                        <q-item-section side>
                          <div class="flex items-center q-gutter-x-sm">
                            <q-avatar
                              :style="`background-color: ${
                                SettingStore.color_status[items.value]
                              }`"
                              text-color="white"
                              size="lg"
                            />
                            <q-icon
                              name="eva-arrow-ios-forward-outline"
                              color="custom-grey4"
                              size="25px"
                            />
                            <ColorSelection
                              is_array="true"
                              v-model:colors="
                                SettingStore.color_status[items.value]
                              "
                            ></ColorSelection>
                          </div>
                        </q-item-section>
                      </q-item>
                    </template>
                  </q-list>
                </q-tab-panel>

                <!-- LANGUAGE -->
                <q-tab-panel
                  name="language"
                  class="q-pt-none"
                  v-if="KitchenStore.isLanguageEnabled"
                >
                  <!-- =>{{ language }} =>{{ SettingStore.app_language }} -->
                  <q-list separator>
                    <q-item
                      v-for="items_language in KitchenStore.languageList"
                      :key="items_language"
                      tag="label"
                    >
                      <q-item-section avatar>
                        <q-avatar square>
                          <q-img
                            :src="items_language.flag_url"
                            style="max-height: 25px"
                            spinner-color="primary"
                            spinner-size="sm"
                          ></q-img>
                        </q-avatar>
                      </q-item-section>
                      <q-item-section>
                        <q-item-label>{{ items_language.title }}</q-item-label>
                        <q-item-label caption>{{
                          items_language.description
                        }}</q-item-label>
                      </q-item-section>
                      <q-item-section side>
                        <q-radio
                          v-model="language"
                          :val="items_language.code"
                          color="yellow-9"
                          checked-icon="check_circle"
                          unchecked-icon="panorama_fish_eye"
                          size="lg"
                          @update:model-value="setLanguage"
                        />
                      </q-item-section>
                    </q-item>
                  </q-list>
                </q-tab-panel>

                <!-- ACCOUNT -->
                <q-tab-panel name="account" class="q-pt-none">
                  <div class="text-h6 q-mb-sm">{{ $t("Delete Account") }}</div>
                  <div class="text-body2 text-weight-bold q-mb-sm">
                    {{
                      $t(
                        "Your are requesting to have your account deleted and personal information removed"
                      )
                    }}.
                  </div>
                  <p class="text-body2">
                    {{
                      $t(
                        "Your account will be deactivated and will permanently deleted after reviewed by admin"
                      )
                    }}.
                  </p>

                  <q-btn
                    no-caps
                    :label="$t('Confirm Deletion')"
                    unelevated
                    color="red-9"
                    text-color="red-2"
                    class="radius-10"
                    @click="RequestCode"
                    :loading="loading_code"
                    :size="$q.screen.gt.sm ? 'lg' : '15px'"
                  ></q-btn>
                </q-tab-panel>

                <!-- LEGAL -->
                <q-tab-panel name="legal" class="q-pt-none">
                  <div class="text-h6 q-mb-sm">{{ $t("Legal") }}</div>
                  <q-list separator>
                    <template
                      v-for="(items, index) in KitchenStore.legalMenu"
                      :key="items"
                    >
                      <q-item
                        clickable
                        :to="{
                          name: 'page',
                          params: {
                            page_id: index,
                          },
                        }"
                      >
                        <q-item-section>
                          <q-item-label>{{ items }}</q-item-label>
                        </q-item-section>
                        <q-item-section side>
                          <q-icon
                            name="eva-chevron-right-outline"
                            color="grey-4"
                          ></q-icon>
                        </q-item-section>
                      </q-item>
                    </template>
                  </q-list>
                </q-tab-panel>

                <!-- PRINTERS -->
                <q-tab-panel name="printers" class="q-pt-none">
                  <PrinterManage :is_ipad="true"></PrinterManage>
                </q-tab-panel>
              </q-tab-panels>
            </template>
          </q-splitter>
        </q-card-section>
      </q-card>
    </template>

    <TimeSelection ref="ref_time" @after-choose="afterChoose"></TimeSelection>

    <TwoStepsVerification
      ref="ref_twosteps"
      :loading="loading_delete"
      :loading_resend="loading_code"
      :message="sentcode_message"
      @after-submitcode="deleteAccount"
      @request-code="RequestCode"
    ></TwoStepsVerification>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useKitchenStore } from "stores/KitchenStore";
import { useIdentityStore } from "stores/IdentityStore";
import { useSettingStore } from "stores/SettingStore";
import { api } from "boot/axios";
import config from "src/api/config";
import { FCM } from "@capacitor-community/fcm";
import APIinterface from "src/api/APIinterface";
import { Loading } from "quasar";
import { jwtDecode } from "jwt-decode";

export default {
  name: "SettingPage",
  components: {
    TimeSelection: defineAsyncComponent(() =>
      import("components/TimeSelection.vue")
    ),
    ColorSelection: defineAsyncComponent(() =>
      import("components/ColorSelection.vue")
    ),
    TopNav: defineAsyncComponent(() => import("components/TopNav.vue")),
    TwoStepsVerification: defineAsyncComponent(() =>
      import("components/TwoStepsVerification.vue")
    ),
    PrinterManage: defineAsyncComponent(() =>
      import("components/PrinterManage.vue")
    ),
  },
  setup() {
    const KitchenStore = useKitchenStore();
    const IdentityStore = useIdentityStore();
    const SettingStore = useSettingStore();
    return { KitchenStore, IdentityStore, SettingStore };
  },
  data() {
    return {
      password: "",
      splitterModel: 20,
      language: "",
      sentcode_message: "",
      loading_code: false,
      loading_delete: false,
      merchant_uuid: "",
    };
  },
  mounted() {
    this.language = this.SettingStore.app_language;
  },
  methods: {
    updatePushNotifications(value) {
      if (this.IdentityStore.authenticated()) {
        try {
          let user_data = jwtDecode(this.IdentityStore.user_data);
          this.merchant_uuid = user_data.merchant_uuid + "-kitchen";
          if (this.$q.capacitor) {
            if (value) {
              FCM.subscribeTo({ topic: this.merchant_uuid })
                .then((r) => {
                  console.log("succesful", r);
                })
                .catch((error) => {
                  console.log("error", error);
                });
            } else {
              FCM.unsubscribeFrom({ topic: this.merchant_uuid })
                .then((r) => {
                  console.log("succesful", r);
                })
                .catch((error) => {
                  console.log("error", error);
                });
            }
          }
        } catch (err) {
          console.log("ERROR", err.message);
          APIinterface.notify(
            this.$q,
            this.$t("Error"),
            err.message,
            "myerror",
            "highlight_off",
            "bottom"
          );
        }
      }
    },
    setDarkmode(value) {
      this.$q.dark.set(value);
    },
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
    setRepeat(value) {
      value = value == true ? 1 : 0;
      console.log("setRepeat", value);
      this.KitchenStore.setRepeatNotification("value=" + value);
    },
    async setLanguage(value) {
      console.log("setLanguage", value);
      this.SettingStore.app_language = value;
      this.$i18n.locale = value;
      api.defaults.params = {};
      api.defaults.params["language"] = this.$i18n.locale;

      this.setRTL();
      await this.KitchenStore.refreshSettings();
    },
    setRTL() {
      if (Object.keys(this.KitchenStore.settings_data).length > 0) {
        Object.entries(
          this.KitchenStore.settings_data.language_list.list
        ).forEach(([key, items]) => {
          if (this.language == items.code) {
            if (items.rtl == 1) {
              this.$q.lang.set({ rtl: true });
              this.SettingStore.rtl = true;
            } else {
              this.$q.lang.set({ rtl: false });
              this.SettingStore.rtl = false;
            }
          }
        });
      }
    },
    async RequestCode() {
      this.loading_code = true;
      let response = await this.KitchenStore.requestCode();
      this.loading_code = false;
      if (response.code == 1) {
        this.sentcode_message = response.msg;
        this.$refs.ref_twosteps.startTimer();
        this.$refs.ref_twosteps.modal = true;
      } else {
        APIinterface.notify(
          this.$q,
          "",
          response.msg,
          "myerror",
          "highlight_off",
          "bottom"
        );
      }
    },
    async deleteAccount(value) {
      this.loading_delete = true;
      let response = await this.KitchenStore.deleteAccount(value);
      this.loading_delete = false;
      if (response.code == 1) {
        this.$refs.ref_twosteps.modal = false;
        this.$router.replace("/delete-account");
      } else {
        APIinterface.notify(
          this.$q,
          "",
          response.msg,
          "myerror",
          "highlight_off",
          "bottom"
        );
      }
    },
    //
  },
};
</script>
