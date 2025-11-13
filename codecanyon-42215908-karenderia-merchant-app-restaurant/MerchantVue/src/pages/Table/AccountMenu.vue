<template>
  <q-header
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
      'beautiful-shadow': isScrolled,
    }"
  >
    <q-toolbar class="q-gutter-x-sm">
      <q-btn
        round
        icon="keyboard_arrow_left"
        color="blue-grey-1"
        text-color="blue-grey-8"
        unelevated
        dense
        to="/dashboard"
      ></q-btn>
      <q-toolbar-title>
        {{ $t("Account") }}
      </q-toolbar-title>

      <q-space></q-space>
    </q-toolbar>
  </q-header>
  <q-page>
    <q-scroll-observer @scroll="onScroll" scroll-target="body" />
    <q-list>
      <q-item>
        <q-item-section avatar top>
          <q-avatar>
            <img src="https://cdn.quasar.dev/img/boy-avatar.png" />
          </q-avatar>
        </q-item-section>
        <q-item-section top>
          <q-item-label> John doe </q-item-label>
          <q-item-label>
            <q-btn flat no-caps padding="0px">
              <div class="text-grey text-weight-medium text-caption">
                Edit Profile
              </div>
              <q-icon name="keyboard_arrow_right" color="grey-4"></q-icon>
            </q-btn>
          </q-item-label>
        </q-item-section>
      </q-item>
    </q-list>
    <q-space class="q-pa-sm"></q-space>

    <q-card
      flat
      class="beautiful-shadow border-greyx q-pl-md q-pr-md no-border-radius"
    >
      <q-tabs
        v-model="shortcut_nav"
        no-caps
        indicator-color="transparent"
        align="justify"
        :breakpoint="0"
        active-bg-color="grey-1"
      >
        <q-tab name="campaigns" class="q-pt-sm q-pb-sm">
          <template v-slot:default>
            <q-btn
              icon="campaign"
              round
              color="blue-grey-1"
              text-color="blue-grey-8"
              unelevated
              dense
            >
              <!-- <img src="/svg/campaign.svg" width="25" height="25" /> -->
            </q-btn>
            <div class="text-caption q-mt-sm">Campaigns</div>
          </template>
        </q-tab>

        <q-tab name="printer">
          <template v-slot:default>
            <q-btn round color="blue-grey-1" text-color="dark" unelevated dense>
              <img src="/svg/printer-solid.svg" width="25" height="25" />
            </q-btn>
            <div class="text-caption q-mt-sm">Printers</div>
          </template>
        </q-tab>

        <q-tab name="chat">
          <template v-slot:default>
            <q-btn round color="blue-grey-1" text-color="dark" unelevated dense>
              <img src="/svg/chat1.svg" width="25" height="25" />
            </q-btn>
            <div class="text-caption q-mt-sm">Chat</div>
          </template>
        </q-tab>

        <q-tab name="orders">
          <template v-slot:default>
            <q-btn round color="blue-grey-1" text-color="dark" unelevated dense>
              <img src="/svg/logout.svg" width="25" height="25" />
            </q-btn>
            <div class="text-caption q-mt-sm">Logout</div>
          </template>
        </q-tab>
      </q-tabs>
    </q-card>

    <q-list>
      <q-item-label header>Account</q-item-label>
      <q-item clickable>
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/profile1.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>Profile</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" name="keyboard_arrow_right" />
        </q-item-section>
      </q-item>

      <q-item clickable>
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/password.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>Change Password</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" name="keyboard_arrow_right" />
        </q-item-section>
      </q-item>

      <q-item clickable>
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/delete-account.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>Delete Account</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" name="keyboard_arrow_right" />
        </q-item-section>
      </q-item>

      <q-item-label header>App Preferences</q-item-label>

      <q-item clickable>
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/globe.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>Language</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" name="keyboard_arrow_right" />
        </q-item-section>
      </q-item>

      <q-item clickable>
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/dark-mode.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>Dark Mode</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" name="keyboard_arrow_right" />
        </q-item-section>
      </q-item>

      <q-item clickable>
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/rtl.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>Direction (RTL)</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" name="keyboard_arrow_right" />
        </q-item-section>
      </q-item>

      <q-item-label header>Orders & Services</q-item-label>

      <q-item clickable>
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/orders.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>Order Type</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" name="keyboard_arrow_right" />
        </q-item-section>
      </q-item>

      <q-item clickable>
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/printer.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>Printers</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" name="keyboard_arrow_right" />
        </q-item-section>
      </q-item>

      <q-item clickable>
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/printer.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>Push Notifications</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" name="keyboard_arrow_right" />
        </q-item-section>
      </q-item>

      <q-item-label header>Promotions</q-item-label>

      <q-item clickable>
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/printer.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>Coupons</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" name="keyboard_arrow_right" />
        </q-item-section>
      </q-item>

      <q-item clickable>
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/printer.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>Offers</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" name="keyboard_arrow_right" />
        </q-item-section>
      </q-item>

      <q-item-label header>Media</q-item-label>
      <q-item clickable>
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/printer.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>Gallery</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" name="keyboard_arrow_right" />
        </q-item-section>
      </q-item>

      <q-item clickable>
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/printer.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>Media</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" name="keyboard_arrow_right" />
        </q-item-section>
      </q-item>

      <q-item-label header>Reports & Invoices</q-item-label>
      <q-item clickable>
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/printer.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>Reports</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" name="keyboard_arrow_right" />
        </q-item-section>
      </q-item>

      <q-item clickable>
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/printer.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>Invoices</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" name="keyboard_arrow_right" />
        </q-item-section>
      </q-item>

      <q-item-label header>Legal & Help</q-item-label>
      <q-item clickable>
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/printer.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>Privacy Policy</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" name="keyboard_arrow_right" />
        </q-item-section>
      </q-item>

      <q-item clickable>
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/printer.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>Terms & Conditions</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" name="keyboard_arrow_right" />
        </q-item-section>
      </q-item>

      <q-item clickable>
        <q-item-section avatar class="itemsection-dense">
          <img src="/svg/printer.svg" width="25" height="25" />
        </q-item-section>
        <q-item-section>
          <q-item-label>About Us</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-icon color="grey-4" size="1.5em" name="keyboard_arrow_right" />
        </q-item-section>
      </q-item>
    </q-list>

    <q-space class="q-pa-md"></q-space>
  </q-page>
</template>

<script>
import { defineComponent, defineAsyncComponent } from "vue";
import { useUserStore } from "stores/UserStore";

export default {
  name: "AccountMenu",
  components: {},
  setup(props) {
    const UserStore = useUserStore();
    return { UserStore };
  },
  data() {
    return {
      shortcut_nav: "orders",
      isScrolled: false,
    };
  },
  methods: {
    onScroll(info) {
      if (!info) {
        return;
      }
      this.isScrolled = info.position.top > 20;
    },
  },
};
</script>
