<template>
  <q-dialog
    v-model="modal"
    position="bottom"
    @show="onShow"
    transition-show="slide-up"
    transition-hide="slide-down"
    @before-hide="onBeforeHide"
    @before-show="onBeforeShow"
  >
    <q-card style="height: calc(95vh)">
      <q-card-section class="q-pa-none q-pt-sm">
        <q-toolbar class="q-gutter-x-sm">
          <q-btn
            @click="modal = false"
            dense
            icon="eva-arrow-back-outline"
            unelevated
            flat
          />

          <q-input
            v-model="q"
            ref="ref_search"
            :placeholder="$t('Search location')"
            dense
            outlined
            color="primary"
            bg-color="grey-1"
            class="input-borderlessx full-width"
            :loading="awaitingSearch"
            rounded
            clearable
            @clear="onShow"
          >
            <template v-slot:prepend>
              <q-icon name="search" />
            </template>
            <template v-slot:append>
              <q-btn
                v-if="!isMaximize"
                no-caps
                dense
                flat
                icon="eva-mic-outline"
                color="primary"
              ></q-btn>
            </template>
          </q-input>
        </q-toolbar>
      </q-card-section>

      <q-card-section style="height: 70vh" class="scroll relative-position">
        <template v-if="isMaximize">
          <q-list separator>
            <template v-for="items in data" :key="items">
              <q-item clickable v-ripple @click="ChooseLocation(items)">
                <q-item-section avatar>
                  <q-avatar
                    color="grey-1"
                    text-color="blue-grey-6"
                    icon="eva-pin-outline"
                  />
                </q-item-section>
                <q-item-section>
                  <q-item-label class="text-subtitle2 text-weight-bold">{{
                    items.description
                  }}</q-item-label>
                  <q-item-label class="text-caption line-normal text-grey">
                    {{ items.addressLine1 }}
                  </q-item-label>
                </q-item-section>
              </q-item>
            </template>
          </q-list>

          <div
            v-if="isNoresults"
            class="text-center q-pa-md absolute-center full-width"
          >
            <div class="text-h6 line-normal text-weight-bold text-dark">
              {{ $t("Sorry, we couldn't find any results") }}
            </div>
            <div class="text-caption text-grey">
              {{ $t("try different search keyword") }}
            </div>
          </div>
        </template>

        <template v-else>
          <q-tabs
            v-model="tab"
            dense
            narrow-indicator
            no-caps
            active-color="'blue-grey-6"
            active-bg-color="orange-1"
            indicator-color="transparent"
            active-class="text-blue-grey-6"
            class="custom-tabs"
          >
            <q-tab
              name="recent_search"
              :label="$t('Recent searches')"
              class="radius28 bg-mygrey1"
            />
            <q-tab
              v-if="is_login"
              name="saved"
              :label="$t('Saved')"
              class="radius28 bg-mygrey1"
            />
          </q-tabs>

          <q-tab-panels
            v-model="tab"
            animated
            transition-prev="slide-down"
            transition-next="slide-up"
          >
            <q-tab-panel name="recent_search">
              <q-list separator>
                <q-item clickable v-ripple:purple @click="getLocation">
                  <q-item-section avatar top>
                    <q-avatar
                      color="grey-1"
                      text-color="blue-grey-6"
                      icon="eva-navigation-2-outline"
                    />
                  </q-item-section>
                  <q-item-section>
                    <q-item-label class="text-subtitle2 text-weight-bold">
                      {{ $t("Current location") }}
                    </q-item-label>
                    <q-item-label caption>{{ $t("Home") }}</q-item-label>
                  </q-item-section>
                </q-item>

                <template v-for="items in recent_addresses" :key="items">
                  <q-item clickable v-ripple:purple @click="setLocation(items)">
                    <q-item-section avatar>
                      <q-avatar
                        color="grey-1"
                        text-color="blue-grey-6"
                        icon="eva-pin-outline"
                      />
                    </q-item-section>
                    <q-item-section>
                      <q-item-label class="text-subtitle2 text-weight-bold">
                        {{ items.place_text }}
                      </q-item-label>
                      <q-item-label caption>
                        {{ items.formatted_address }}
                      </q-item-label>
                    </q-item-section>
                  </q-item>
                </template>
              </q-list>
            </q-tab-panel>

            <q-tab-panel name="saved" v-if="is_login">
              <div v-if="!ClientStore.hasData" style="height: 50vh">
                <NoResults
                  :message="$t('No Saved Addresses')"
                  :description="
                    $t('Add your delivery address to place an order quickly!')
                  "
                ></NoResults>
              </div>

              <q-list separator>
                <template v-for="items in ClientStore.addressList" :key="items">
                  <q-item clickable v-ripple:purple @click="setLocation(items)">
                    <q-item-section avatar top>
                      <q-avatar
                        color="grey-1"
                        text-color="blue-grey-6"
                        icon="eva-pin-outline"
                      />
                    </q-item-section>
                    <q-item-section>
                      <q-item-label class="text-subtitle2 text-weight-bold">
                        {{ items.address_label }}
                      </q-item-label>
                      <q-item-label caption>
                        {{ items.formatted_address }}
                      </q-item-label>
                      <q-item-label class="text-caption">
                        {{ items.street_number }} {{ items.street_name }}
                      </q-item-label>
                      <q-item-label class="text-caption">
                        {{ items.delivery_instructions }}
                      </q-item-label>
                    </q-item-section>
                  </q-item>
                </template>
              </q-list>
            </q-tab-panel>
          </q-tab-panels>
        </template>
      </q-card-section>

      <div
        class="fixed-bottom q-pa-sm border-grey-top shadow-1 row q-gutter-x-md items-center"
      >
        <q-btn
          :label="$t('Choose on map')"
          no-caps
          color="white"
          text-color="blue-grey-6"
          icon="eva-map-outline"
          unelevated
          :to="{
            path: '/location/map',
            query: { is_addnew: this.is_addnew ? 1 : 0 },
          }"
          class="fit"
        ></q-btn>
      </div>
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useLocationStore } from "stores/LocationStore";
import { useClientStore } from "stores/ClientStore";
import { defineAsyncComponent } from "vue";

export default {
  name: "AddressRecent",
  props: ["map_provider", "recent_addresses", "is_login", "is_addnew"],
  components: {
    NoResults: defineAsyncComponent(() => import("components/NoResults.vue")),
  },
  data() {
    return {
      modal: false,
      q: "",
      data: [],
      loading: false,
      awaitingSearch: false,
      tab: "recent_search",
    };
  },
  setup() {
    const LocationStore = useLocationStore();
    const ClientStore = useClientStore();
    return { LocationStore, ClientStore };
  },
  computed: {
    isMaximize() {
      if (this.q) {
        return true;
      }
      return false;
    },
    isNoresults() {
      if (this.q && !this.awaitingSearch) {
        if (Object.keys(this.data).length > 0) {
        } else {
          return true;
        }
      }
      return false;
    },
  },
  watch: {
    q(newdata, oldata) {
      if (!this.awaitingSearch) {
        if (
          typeof this.q === "undefined" ||
          this.q === null ||
          this.q === "" ||
          this.q === "null" ||
          this.q === "undefined"
        ) {
          this.data = [];
          return false;
        }

        setTimeout(() => {
          console.log(this.q);
          APIinterface.getlocationAutocomplete(this.q)
            .then((data) => {
              this.data = data.details.data;
            })
            .catch((error) => {})
            .then((data) => {
              this.awaitingSearch = false;
            });
        }, 1000);
      }
      this.awaitingSearch = true;
    },
  },
  methods: {
    onBeforeShow() {
      if (!this.is_login) {
        return;
      }

      if (!this.ClientStore.data) {
        this.ClientStore.getAddress();
      }
    },
    onBeforeHide() {
      this.q = "";
      this.data = [];
    },
    onShow() {
      this.$refs.ref_search.focus();
    },
    ChooseLocation(value) {
      if (this.map_provider == "google.maps") {
        APIinterface.showLoadingBox("", this.$q);
        APIinterface.getLocationDetails(value.id, value.description)
          .then((data) => {
            const place_data = data.details.data;
            const location_coordinates = {
              lat: parseFloat(place_data.latitude),
              lng: parseFloat(place_data.longitude),
            };
            this.$emit(
              "afterChooseaddress",
              {
                place_data: place_data,
                location_coordinates: location_coordinates,
              },
              true
            );
            this.modal = false;
          })
          .catch((error) => {
            APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
          })
          .then((data) => {
            APIinterface.hideLoadingBox(this.$q);
          });
      } else {
        this.reverseGeocoding(value.latitude, value.longitude);
      }
    },
    async getLocation() {
      console.log("getLocation");
      try {
        APIinterface.showLoadingBox("", this.$q);
        let location = null;
        if (this.$q.capacitor) {
          location = await this.LocationStore.fetchLocation(this.$t);
        } else {
          location = await this.LocationStore.fetchWebLocation(this.$t);
        }
        APIinterface.hideLoadingBox(this.$q);
        console.log("location", location);
        this.reverseGeocoding(location.latitude, location.longitude);
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        APIinterface.hideLoadingBox(this.$q);
      }
    },
    async reverseGeocoding(lat, lng) {
      try {
        APIinterface.showLoadingBox("", this.$q);
        const place_data = await this.LocationStore.reverseGeocoding(lat, lng);
        const location_coordinates = {
          lat: parseFloat(lat),
          lng: parseFloat(lng),
        };
        this.$emit(
          "afterChooseaddress",
          {
            place_data: place_data,
            location_coordinates: location_coordinates,
          },
          true
        );

        APIinterface.hideLoadingBox(this.$q);
        this.modal = false;
      } catch (error) {
        APIinterface.hideLoadingBox(this.$q);
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      }
    },
    setLocation(value) {
      const place_data = value;
      const location_coordinates = {
        lat: parseFloat(value.latitude),
        lng: parseFloat(value.longitude),
      };
      this.$emit(
        "afterChooseaddress",
        {
          place_data: place_data,
          location_coordinates: location_coordinates,
        },
        false
      );
      this.modal = false;
    },
  },
};
</script>

<style scoped>
.custom-tabs .q-tab {
  margin-right: 16px; /* Add spacing between tabs */
}

.custom-tabs .q-tab:last-child {
  margin-right: 0; /* Remove margin for the last tab */
}
.q-tabs__content--align-justify .q-tab {
  flex: initial !important;
}
</style>
