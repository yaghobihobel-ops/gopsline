<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-header
      :class="{
        'bg-mydark text-white': $q.dark.mode && !isScrolled,
        'bg-grey-1 text-dark': !$q.dark.mode && !isScrolled,
        'beautiful-shadow bg-white text-dark': isScrolled,
      }"
    >
      <q-toolbar>
        <q-btn
          @click="$router.back()"
          flat
          round
          dense
          icon="las la-angle-left"
          :color="$q.dark.mode ? 'white' : 'dark'"
        />
        <q-toolbar-title class="text-weight-bold">
          <template v-if="isScrolled">
            <div class="text-weight-bold text-subtitle2 line-normal">
              {{ orderInfo?.order_id1 }}
            </div>
          </template>
          <template v-else>
            {{ $t("Order Details") }}
          </template>
        </q-toolbar-title>

        <template v-if="!loading && orderInfo">
          <q-btn
            unelevated
            round
            dense
            icon="las la-download"
            color="grey-2"
            text-color="grey-9"
            class="q-mr-sm"
            @click="downloadPDF"
          />

          <q-btn
            unelevated
            round
            dense
            icon="las la-print"
            color="red-1"
            text-color="red-9"
            @click="printReceipt"
          />
        </template>
      </q-toolbar>
    </q-header>
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
      }"
      class="q-pa-md q-gutter-y-sm"
    >
      <q-scroll-observer @scroll="onScroll" scroll-target="body" />

      <PrintReceipt
        ref="ref_printreceipt"
        :data="order_data"
        :printer="printer_details"
      ></PrintReceipt>

      <template v-if="loading">
        <div
          class="row q-gutter-x-sm justify-center q-my-md absolute-center text-center full-width"
        >
          <q-circular-progress
            indeterminate
            rounded
            size="sm"
            color="primary"
          />
          <div class="text-subtitle1 text-grey">{{ $t("Loading") }}...</div>
        </div>
      </template>
      <template v-else>
        <q-card flat class="border-grey radius8">
          <q-item>
            <q-item-section class="text-center">
              <q-item-label caption>{{ $t("Order ID") }}</q-item-label>
              <q-item-label class="text-weight-bold text-subtitle2"
                ># {{ orderInfo?.order_id }}</q-item-label
              >
            </q-item-section>
            <q-item-section class="text-center">
              <q-item-label caption>{{ $t("Order Date") }}</q-item-label>
              <q-item-label class="text-weight-bold text-subtitle2">{{
                orderInfo?.place_on_date
              }}</q-item-label>
            </q-item-section>
          </q-item>
        </q-card>

        <q-card flat class="border-grey radius8">
          <q-item>
            <q-item-section class="text-center">
              <q-item-label caption>{{ $t("Order Type") }}</q-item-label>
              <q-item-label>
                <q-badge
                  rounded
                  :color="
                    OrderStore.ordertypeColor[toSeo(orderInfo?.order_type)]
                      ?.bg || 'primary'
                  "
                  :text-color="
                    OrderStore.ordertypeColor[toSeo(orderInfo?.order_type)]
                      ?.text || 'white'
                  "
                  class="q-pa-sm q-pl-md q-pr-md text-capitalize"
                >
                  {{ orderInfo?.order_type1 }}
                </q-badge>
              </q-item-label>
            </q-item-section>
            <q-item-section class="text-center">
              <q-item-label caption> {{ $t("Order status") }}</q-item-label>
              <q-item-label>
                <q-badge
                  rounded
                  :color="
                    OrderStore.statusColor[toSeo(orderInfo?.status)]?.bg ||
                    'primary'
                  "
                  :text-color="
                    OrderStore.statusColor[toSeo(orderInfo?.status)]?.text ||
                    'white'
                  "
                  class="q-pa-sm q-pl-md q-pr-md text-capitalize"
                >
                  {{ orderInfo?.status1 }}
                </q-badge>
              </q-item-label>
            </q-item-section>
          </q-item>
        </q-card>

        <q-card flat class="border-grey radius8 q-pb-sm">
          <q-item>
            <q-item-section avatar>
              <q-avatar>
                <img :src="order_data?.customer?.avatar" />
              </q-avatar>
            </q-item-section>
            <q-item-section>
              <q-item-label
                class="text-weight-bold text-subtitle2 text-primary"
              >
                {{ orderInfo?.customer_name }}
              </q-item-label>
              <q-item-label caption>{{ $t("Customer") }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <div class="flex q-gutter-x-sm">
                <div>
                  <q-btn
                    round
                    color="red-8"
                    icon="las la-phone"
                    unelevated
                    dense
                    flat
                    :href="`tel:${orderInfo?.contact_number}`"
                  />
                </div>
                <div>
                  <q-btn
                    round
                    color="red-8"
                    icon="las la-comment"
                    unelevated
                    dense
                    flat
                    :to="{
                      path: 'chat/conversation',
                      query: {
                        chat_type: 'order',
                        order_uuid: this.order_uuid,
                        order_id: orderInfo?.order_id,
                        client_uuid: order_data?.customer?.client_uuid,
                        name: order_data?.customer?.first_name,
                        first_name: order_data?.customer?.first_name,
                        last_name: order_data?.customer?.last_name,
                        avatar: order_data?.customer?.avatar,
                      },
                    }"
                  />
                </div>
                <div v-if="orderInfo?.service_code == 'delivery'">
                  <q-btn
                    round
                    color="red-8"
                    icon="las la-map"
                    unelevated
                    dense
                    flat
                    @click="showDeliveryAddress"
                  />
                </div>
              </div>
            </q-item-section>
          </q-item>
          <q-separator></q-separator>
          <q-item>
            <q-item-section>
              <q-item-label caption>{{ $t("Phone") }}</q-item-label>
              <q-item-label>{{ orderInfo?.contact_number }}</q-item-label>
            </q-item-section>
            <q-item-section>
              <q-item-label caption>{{ $t("Email") }}</q-item-label>
              <q-item-label>{{ orderInfo?.contact_email }}</q-item-label>
            </q-item-section>
          </q-item>

          <template v-if="orderInfo?.service_code == 'delivery'">
            <q-item>
              <q-item-section top>
                <q-item-label caption>{{
                  $t("Delivery address")
                }}</q-item-label>
                <q-item-label>
                  <div>
                    {{ orderInfo?.address_label }} &bullet;
                    {{ orderInfo?.complete_delivery_address }}
                  </div>
                  <div class="text-caption">
                    {{ orderInfo?.address1 }} {{ orderInfo?.delivery_address }}
                  </div>
                </q-item-label>
              </q-item-section>
              <q-item-section top>
                <q-item-label caption>{{
                  $t("Aparment, suite or floor")
                }}</q-item-label>
                <q-item-label>{{
                  orderInfo?.location_name || $t("none")
                }}</q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section top>
                <q-item-label caption>{{
                  $t("Delivery options")
                }}</q-item-label>
                <q-item-label>{{
                  orderInfo?.delivery_options || $t("none")
                }}</q-item-label>
              </q-item-section>
              <q-item-section top>
                <q-item-label caption>{{
                  $t("Delivery instructions")
                }}</q-item-label>
                <q-item-label>{{
                  orderInfo?.delivery_instructions || $t("none")
                }}</q-item-label>
              </q-item-section>
            </q-item>
          </template>
        </q-card>

        <q-card flat class="border-grey radius8">
          <q-item>
            <q-item-section avatar>
              <q-avatar
                color="amber-1"
                text-color="amber-8"
                icon="credit_card"
              />
            </q-item-section>
            <q-item-section>
              <q-item-label caption>{{ $t("Payment Method") }}</q-item-label>
              <q-item-label class="text-weight-bold text-subtitle2">
                {{
                  orderInfo?.payment_code == "none"
                    ? orderInfo?.payment_by_wallet
                    : orderInfo?.payment_name1
                }}
              </q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-item-label>
                <q-badge
                  rounded
                  :color="
                    OrderStore.paymentStatusColor[orderInfo?.payment_status]
                      ?.bg || 'primary'
                  "
                  :text-color="
                    OrderStore.paymentStatusColor[orderInfo?.payment_status]
                      ?.text || 'white'
                  "
                  class="q-pa-sm q-pl-md q-pr-md text-capitalize"
                >
                  {{ orderInfo?.payment_status1 }}
                </q-badge>
              </q-item-label>
            </q-item-section>
          </q-item>
        </q-card>

        <!-- Driver -->
        <q-card
          v-if="orderInfo?.service_code == 'delivery'"
          flat
          class="border-grey radius8"
        >
          <template v-if="!getDriver">
            <div class="text-caption text-grey q-pl-md q-pr-md q-pt-sm">
              {{ $t("Driver Information") }}
            </div>
            <div class="q-pa-lg relative-position text-center">
              <template
                v-if="orderInfo?.is_completed || orderInfo?.is_order_failed"
              >
                {{ $t("No assign driver to this order") }}</template
              >
              <div v-else class="absolute-center">
                <template v-if="AccessStore.app_settings?.self_delivery">
                  <q-btn
                    dense
                    no-caps
                    unelevated
                    color="primary"
                    class="radius10 q-pl-md q-pr-md"
                    @click="this.$refs.ref_assign.modal = true"
                    >{{ $t("Assign Driver") }}</q-btn
                  >
                </template>
                <template v-else>
                  {{ $t("No driver has been assigned to this order yet.") }}
                </template>
              </div>
            </div>
          </template>
          <template v-else>
            <q-item>
              <q-item-section avatar>
                <q-avatar>
                  <img :src="getDriver?.photo_url" />
                </q-avatar>
              </q-item-section>
              <q-item-section>
                <q-item-label
                  class="text-weight-bold text-subtitle2 text-primary"
                >
                  {{ getDriver?.driver_name }}
                </q-item-label>
                <q-item-label caption>Delivery Rider</q-item-label>
              </q-item-section>
              <q-item-section side>
                <div class="flex">
                  <div>
                    <q-btn
                      round
                      color="red-8"
                      icon="las la-phone"
                      unelevated
                      dense
                      flat
                      :href="`tel:${getDriver?.phone_number}`"
                    />
                  </div>
                  <div>
                    <q-btn
                      round
                      color="red-8"
                      icon="las la-comment"
                      unelevated
                      dense
                      flat
                      :to="{
                        path: 'chat/conversation',
                        query: {
                          chat_type: 'driver',
                          order_uuid: 'ORD-' + this.order_uuid,
                          order_id: orderInfo?.order_id,
                          client_uuid: getDriver?.uuid,
                          name: getDriver?.driver_name,
                          first_name: getDriver?.driver_name,
                          last_name: '',
                          avatar: getDriver?.photo_url,
                        },
                      }"
                    />
                  </div>
                </div>
              </q-item-section>
            </q-item>
            <q-separator></q-separator>
            <q-item>
              <q-item-section>
                <q-item-label caption>{{ $t("Phone") }}</q-item-label>
                <q-item-label>{{ getDriver?.phone_number }}</q-item-label>
              </q-item-section>
              <q-item-section>
                <q-item-label caption>{{ $t("Email") }}</q-item-label>
                <q-item-label>{{ getDriver?.email_address }}</q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label caption>{{ $t("Delivery Status") }}</q-item-label>
                <q-item-label>
                  <q-badge
                    rounded
                    color="red-2"
                    text-color="red-8"
                    class="q-pa-sm"
                  >
                    {{ orderInfo?.delivery_status }}
                  </q-badge>
                </q-item-label>
              </q-item-section>
              <q-item-section bottom v-if="orderInfo?.can_reassign_driver">
                <q-item-label caption>{{
                  $t("Regassign Driver")
                }}</q-item-label>
                <q-item-label>
                  <q-btn
                    no-caps
                    unelevated
                    color="primary"
                    class="radius10"
                    @click="this.$refs.ref_assign.modal = true"
                    >{{ $t("Assign Driver") }}</q-btn
                  >
                </q-item-label>
              </q-item-section>
            </q-item>
          </template>
        </q-card>

        <q-card
          flat
          class="border-grey radius8"
          v-if="orderInfo?.is_timepreparation"
        >
          <div class="text-caption text-grey q-pl-md q-pr-md q-pt-sm">
            {{ $t("Preparation") }}
          </div>
          <template v-if="orderInfo.order_accepted_at_raw">
            <q-item>
              <q-item-section>
                <q-item-label class="text-weight-bold text-subtitle2">
                  <PreparationCircularprogress
                    display="text"
                    :order_accepted_at="orderInfo.order_accepted_at"
                    :preparation_starts="orderInfo.preparation_starts"
                    :timezone="orderInfo.timezone"
                    :total_time="orderInfo.preparation_time_estimation_raw"
                    :label="{
                      hour: $t('hour'),
                      hours: $t('hours'),
                      min: $t('min'),
                      mins: $t('mins'),
                      order_overdue: $t('Order is Overdue!'),
                    }"
                  />
                </q-item-label>
              </q-item-section>
              <q-item-section side top>
                <q-item-label>
                  <q-btn
                    dense
                    no-caps
                    unelevated
                    color="primary"
                    class="radius10 q-pl-md q-pr-md"
                    icon="las la-edit"
                    :label="$t('Edit')"
                    @click="
                      editPrepationtime(
                        orderInfo.preparation_time_estimation_raw
                      )
                    "
                  >
                  </q-btn
                ></q-item-label>
              </q-item-section>
            </q-item>
          </template>
          <template v-else>
            <q-item>
              <q-item-section>
                <q-item-label>{{ $t("Preparation Estimate") }}</q-item-label>
                <q-item-label class="text-weight-bold text-subtitle2">{{
                  orderInfo.preparation_time_estimation
                }}</q-item-label>
                <q-item-label caption> {{ $t("Suggested") }}</q-item-label>
              </q-item-section>
              <q-item-section side top>
                <q-item-label>
                  <q-btn
                    dense
                    no-caps
                    unelevated
                    color="primary"
                    class="radius10 q-pl-md q-pr-md"
                    icon="las la-edit"
                    :label="$t('Edit')"
                    @click="
                      editPrepationtime(
                        orderInfo.preparation_time_estimation_raw
                      )
                    "
                  >
                  </q-btn
                ></q-item-label>
              </q-item-section>
            </q-item>
          </template>
        </q-card>

        <q-card flat class="border-grey radius8">
          <q-item>
            <q-item-section>
              <q-item-label caption>
                {{
                  orderInfo?.service_code == "delivery"
                    ? $t("Delivery Date/Time")
                    : $t("Date/Time")
                }}
              </q-item-label>
              <q-item-label>
                {{
                  orderInfo?.whento_deliver == "now" ? $t("Now") : $t("Asap")
                }}
              </q-item-label>
            </q-item-section>
            <q-item-section>
              <q-item-label caption>{{ $t("Include utensils") }}</q-item-label>
              <q-item-label>{{
                orderInfo?.include_utensils || $t("No")
              }}</q-item-label>
            </q-item-section>
          </q-item>
        </q-card>

        <q-card
          v-if="orderInfo?.service_code == 'dinein'"
          flat
          class="border-grey radius8"
        >
          <div class="text-caption text-grey q-pl-md q-pr-md q-pt-sm">
            {{ $t("Table information") }}
          </div>
          <q-item>
            <q-item-section>
              <q-item-label caption>{{ $t("Guest") }} </q-item-label>
              <q-item-label>{{ getTabledata?.guest_number }}</q-item-label>
            </q-item-section>
            <q-item-section>
              <q-item-label caption>{{ $t("Room name") }} </q-item-label>
              <q-item-label>{{ getTabledata?.room_name }}</q-item-label>
            </q-item-section>
            <q-item-section>
              <q-item-label caption>{{ $t("Table name") }} </q-item-label>
              <q-item-label>{{ getTabledata?.table_name }}</q-item-label>
            </q-item-section>
          </q-item>
        </q-card>

        <q-card flat class="border-grey radius8 q-pb-sm">
          <div
            class="text-caption text-grey q-pl-md q-pr-md q-pt-sm flex justify-between items-center"
          >
            <div>{{ $t("Order Summary") }}</div>

            <div v-if="order_data?.found_kitchen">
              <q-btn
                dense
                no-caps
                unelevated
                :color="order_data?.found_kitchen ? 'disabled' : 'amber-6'"
                :text-color="order_data?.found_kitchen ? 'disabled' : 'dark'"
                class="radius10 q-pl-md q-pr-md"
                @click="SendToKitchen"
                :loading="loading_kitchen"
                :disabled="order_data?.found_kitchen"
              >
                {{ $t("Send KOT") }}
              </q-btn>
            </div>
          </div>

          <!-- <pre>{{ visibleItems }}</pre> -->

          <template v-for="items in visibleItems" :key="items">
            <q-item>
              <q-item-section avatar top>
                <q-item-label>{{ items.qty }}x</q-item-label>
              </q-item-section>
              <q-item-section>
                <q-item-label>
                  <span v-html="items.item_name"></span>
                  <template v-if="items.price.size_name != ''">
                    ({{ items.price.size_name }})
                  </template>

                  <template v-if="items.item_changes == 'replacement'">
                    <div class="m-0 text-grey">
                      {{ $t("Replace") }} "{{ items.item_name_replace }}"
                    </div>
                    <q-badge
                      color="primary"
                      text-color="white"
                      :label="$t('Replacement')"
                    />
                  </template>
                </q-item-label>

                <q-item-label caption class="text-weight-medium text-caption">
                  <template v-if="items.is_free">
                    <q-badge outline color="green-4" label="Free" />
                  </template>
                  <template v-else>
                    <template v-if="items.price.discount > 0">
                      <p class="no-margin">
                        <del>{{ items.price.pretty_price }}</del>
                        {{ items.price.pretty_price_after_discount }}
                      </p>
                    </template>
                    <template v-else>
                      <p class="no-margin">{{ items.price.pretty_price }}</p>
                    </template>
                  </template>

                  <div
                    class="text-weight-bold text-dark"
                    v-html="items.category_name"
                  ></div>

                  <p class="no-margin" v-if="items.special_instructions != ''">
                    {{ items.special_instructions }}
                  </p>

                  <template v-if="items.attributes != ''">
                    <template
                      v-for="attributes in items.attributes"
                      :key="attributes"
                    >
                      <p class="no-margin">
                        <template
                          v-for="(
                            attributes_data, attributes_index
                          ) in attributes"
                        >
                          {{ attributes_data
                          }}<template
                            v-if="attributes_index < attributes.length - 1"
                            >,
                          </template>
                        </template>
                      </p>
                    </template>
                  </template>
                </q-item-label>
              </q-item-section>
              <q-item-section side top>
                <q-item-label>
                  <template v-if="items.price.discount <= 0">
                    {{ items.price.pretty_total }}
                  </template>
                  <template v-else>
                    {{ items.price.pretty_total_after_discount }}
                  </template>
                </q-item-label>
              </q-item-section>
            </q-item>

            <q-item dense v-if="items.if_sold_out">
              <q-item-section avatar></q-item-section>
              <q-item-section>
                <q-item-label class="text-weight-bold font12">{{
                  $t("If sold out")
                }}</q-item-label>
                <q-item-label caption>{{ items.if_sold_out }}</q-item-label>
              </q-item-section>
            </q-item>

            <template v-for="addons in items.addons" :key="addons">
              <q-item dense>
                <q-item-section avatar></q-item-section>
                <q-item-section>
                  <q-item-label class="text-weight-bold font12">{{
                    addons.subcategory_name
                  }}</q-item-label>
                </q-item-section>
                <q-item-section side top></q-item-section>
              </q-item>

              <q-item
                v-for="addon_items in addons.addon_items"
                :key="addon_items"
                dense
              >
                <q-item-section avatar></q-item-section>
                <q-item-section top>
                  <q-item-label lines="1" class="font12 text-weight-medium"
                    >{{ addon_items.qty }} x {{ addon_items.pretty_price }}
                    {{ addon_items.sub_item_name }}</q-item-label
                  >
                </q-item-section>
                <q-item-section side top>
                  <p class="no-margin font12 text-weight-bold">
                    {{ addon_items.pretty_addons_total }}
                  </p>
                </q-item-section>
              </q-item>
            </template>
            <!-- addons -->
            <q-separator inset />

            <!-- end items -->
          </template>

          <q-item dense v-if="getItemsCount > 2">
            <q-item-section class="text-center">
              <q-btn
                no-caps
                flat
                color="primary"
                @click="show_all = !show_all"
                :label="show_all ? $t('Show Less') : $t('Show More')"
              />
            </q-item-section>
          </q-item>

          <q-separator v-if="getItemsCount > 2" class="q-mb-sm"></q-separator>
          <q-space class="q-pa-xs"></q-space>
          <q-item
            dense
            v-for="summary in getSummary"
            :key="summary"
            style="min-height: 22px"
          >
            <q-item-section avatar>
              <q-item-label
                :class="{
                  'text-weight-bold': summary.type == 'total',
                }"
                >{{ summary.name }}</q-item-label
              >
            </q-item-section>
            <q-item-section></q-item-section>
            <q-item-section side>
              <q-item-label
                :class="{
                  'text-weight-bold': summary.type == 'total',
                }"
              >
                {{ summary.value }}</q-item-label
              >
            </q-item-section>
          </q-item>
        </q-card>

        <q-card flat class="border-grey radius8">
          <div class="q-pl-md q-pr-md q-pt-sm q-pb-sm">
            <div class="text-caption text-grey">{{ $t("Loyalty Points") }}</div>
            <div>{{ orderInfo?.points_label2 }}</div>
          </div>
        </q-card>

        <q-card flat class="border-grey radius8">
          <div class="text-caption text-grey q-pl-md q-pr-md q-pt-sm">
            {{ $t("Time line") }}
          </div>
          <div class="q-pl-md scroll" style="max-height: 220px">
            <q-timeline color="secondary" layout="dense">
              <template v-for="timeline in getTimeline" :key="timeline">
                <q-timeline-entry>
                  <template v-slot:title>
                    <div class="text-grey">
                      {{ timeline.created_at }}
                    </div></template
                  >
                  <template v-slot:subtitle> {{ timeline.status }} </template>

                  <div>{{ timeline.remarks }}</div>
                  <div>{{ timeline.change_by }}</div>
                </q-timeline-entry>
              </template>
            </q-timeline>
          </div>
        </q-card>

        <q-card flat class="border-grey radius8">
          <div class="text-caption text-grey q-pl-md q-pr-md q-pt-sm">
            {{ $t("Payment history") }}
          </div>
          <q-markup-table separator="horizontal">
            <thead>
              <tr>
                <th class="text-left text-grey">{{ $t("Date") }}</th>
                <th class="text-left text-grey">{{ $t("Payment") }}</th>
                <th class="text-left text-grey">{{ $t("Description") }}</th>
                <th class="text-left text-grey">{{ $t("Amount") }}</th>
                <th class="text-left text-grey">{{ $t("Status") }}</th>
              </tr>
            </thead>
            <tbody>
              <template v-for="history in getPaymenthistory" :key="history">
                <tr>
                  <td>{{ history.date_created }}</td>
                  <td class="text-uppercase">{{ history.payment_code }}</td>
                  <td>
                    <div>{{ history.transaction_description }}</div>
                    <div class="text-caption text-grey">
                      {{ $t("Reference#") }} {{ history.payment_reference }}
                    </div>
                  </td>
                  <td>
                    {{
                      history.transaction_type == "debit"
                        ? `(${history.trans_amount})`
                        : history.trans_amount
                    }}
                  </td>
                  <td>
                    <q-badge
                      :color="
                        OrderStore.paymentStatusColor[history?.status_raw]
                          ?.text || 'blue-2'
                      "
                    >
                      {{ history?.status_pretty }}</q-badge
                    >
                  </td>
                </tr>
              </template>
            </tbody>
          </q-markup-table>
        </q-card>

        <q-space class="q-pa-sm"></q-space>

        <q-footer
          v-if="hasButtons"
          class="q-pa-md q-gutter-y-sm beautiful-shadow"
          :class="{
            'bg-mydark text-white': $q.dark.mode,
            'bg-white text-dark': !$q.dark.mode,
          }"
        >
          <div class="row q-gutter-x-md">
            <template v-for="button in getButtons" :key="button">
              <q-btn
                unelevated
                no-caps
                class="radius10 col line-normal"
                size="18px"
                :color="changeColor(button.class_name)"
                :text-color="changeTextColor(button.class_name)"
                @click="doActions(button)"
                :outline="button.do_actions == 'reject_form' ? true : false"
              >
                <div class="text-weight-bold text-subtitle2">
                  {{ button.button_name }}
                </div>
              </q-btn>
            </template>
          </div>

          <div class="row q-gutter-x-md">
            <template v-for="button in getlastButtons" :key="button">
              <q-btn
                unelevated
                no-caps
                class="radius10 col line-normal"
                size="18px"
                :color="changeColor(button.class_name)"
                :text-color="changeTextColor(button.class_name)"
                @click="doActions(button)"
              >
                <div class="text-weight-bold text-subtitle2">
                  {{ button.button_name }}
                </div>
              </q-btn>
            </template>
          </div>
        </q-footer>
      </template>

      <q-page-scroller
        position="bottom-right"
        :scroll-offset="150"
        :offset="[18, 18]"
      >
        <q-btn
          fab
          icon="keyboard_arrow_up"
          color="mygrey"
          text-color="dark"
          padding="8px"
        />
      </q-page-scroller>
    </q-page>

    <RejectionList
      ref="rejection"
      @after-addreason="afterAddreason"
    ></RejectionList>

    <DelayOrder ref="delay_order" @after-select="afterSelect"></DelayOrder>

    <CancelOrder
      ref="cancel_order"
      @after-addreason="afterCancel"
    ></CancelOrder>

    <PreparationTime
      ref="ref_preparation_time"
      :data="orderInfo?.preparation_time_estimation_raw"
      :order_uuid="order_uuid"
      :payload="payload"
      @after-updatetime="afterUpdatetime"
    ></PreparationTime>

    <DriverAssign
      ref="ref_assign"
      :order_uuid="order_uuid"
      :merchant_location="getMerchantLocation"
      @after-assigndriver="afterAssigndriver"
    ></DriverAssign>

    <MapModal ref="ref_mapmodal"> </MapModal>

    <PrinterList
      ref="printer"
      @after-selectprinter="afterSelectprinter"
    ></PrinterList>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import { useOrderStore } from "stores/OrderStore";
import { useDataPersisted } from "stores/DataPersisted";
import { useDriverStore } from "stores/DriverStore";
import { Browser } from "@capacitor/browser";
import { useAccessStore } from "src/stores/AccessStore";

export default {
  name: "OrderDetails",
  components: {
    RejectionList: defineAsyncComponent(() =>
      import("components/RejectionList.vue")
    ),
    DelayOrder: defineAsyncComponent(() => import("components/DelayOrder.vue")),

    CancelOrder: defineAsyncComponent(() =>
      import("components/RejectionList.vue")
    ),
    PreparationCircularprogress: defineAsyncComponent(() =>
      import("components/PreparationCircularprogress.vue")
    ),
    PreparationTime: defineAsyncComponent(() =>
      import("components/PreparationTime.vue")
    ),
    DriverAssign: defineAsyncComponent(() =>
      import("components/DriverAssign.vue")
    ),
    PrintReceipt: defineAsyncComponent(() =>
      import("components/PrintReceipt.vue")
    ),
    MapModal: defineAsyncComponent(() => import("components/MapModal.vue")),

    PrinterList: defineAsyncComponent(() =>
      import("components/PrinterList.vue")
    ),
  },
  data() {
    return {
      order_uuid: "",
      order_data: [],
      loading: false,
      order_items: [],
      order_summary: [],
      order_info: [],
      site_data: [],
      order_label: [],
      refund_transaction: [],
      order_status: [],
      order_services: [],
      merchant: [],
      progress: 0,
      data_progress: [],
      progress_order_status: "",
      progress_order_status_details: "",
      allowed_to_cancel: false,
      pdf_link: "",
      delivery_timeline: [],
      order_delivery_status: [],
      allowed_to_review: false,
      payload: [
        "merchant_info",
        "items",
        "summary",
        "order_info",
        "progress",
        "refund_transaction",
        "status_allowed_cancelled",
        "pdf_link",
        "delivery_timeline",
        "order_delivery_status",
        "allowed_to_review",
        "credit_card",
        "driver",
      ],
      buttons: [],
      button_uuid: "",
      group_name: "",
      map_direction: "",
      credit_card_details: "",
      printer_details: null,
      customer: [],
      is_refresh: false,
      order_table_data: [],
      isScrolled: false,
      show_all: false,
      loading_kitchen: false,
    };
  },
  mounted() {
    this.order_uuid = this.$route.query.order_uuid;

    const saved = this.DataStore.dataList?.order_data;
    if (saved && saved.order_uuid === this.order_uuid) {
      this.order_data = saved.data;
    } else {
      this.orderDetails();
    }
  },
  beforeUnmount() {
    this.DataStore.dataList.order_data = {
      order_uuid: this.order_uuid,
      data: this.order_data,
    };
    this.DriverStore.data = null;
  },
  setup() {
    const DataStore = useDataStore();
    const OrderStore = useOrderStore();
    const DataPersisted = useDataPersisted();
    const DriverStore = useDriverStore();
    const AccessStore = useAccessStore();
    return { DataStore, OrderStore, DataPersisted, DriverStore, AccessStore };
  },
  computed: {
    orderInfo() {
      return this.order_data?.order?.order_info ?? null;
    },
    getDriver() {
      const data = this.order_data?.driver_data ?? null;
      if (!data) {
        return null;
      }
      return Object.keys(data).length > 0 ? data : null;
    },
    getItemsCount() {
      return this.order_data?.items?.length ?? null;
    },
    getItems() {
      return this.order_data?.items ?? null;
    },
    visibleItems() {
      const items = this.order_data?.items ?? null;
      if (!items) {
        return null;
      }
      return this.show_all ? items : items.slice(0, 2);
    },
    getSummary() {
      return this.order_data?.summary ?? null;
    },
    getTimeline() {
      return this.order_data?.delivery_timeline ?? null;
    },
    getPaymenthistory() {
      return this.order_data?.payment_history ?? null;
    },
    getMerchant() {
      return this.order_data?.merchant ?? null;
    },
    getTabledata() {
      return this.order_data?.order_table_data ?? null;
    },
    hasButtons() {
      const data = this.order_data?.buttons ?? null;
      if (!data) {
        return false;
      }
      return Object.keys(data).length > 0;
    },
    getButtons() {
      const data = this.order_data?.buttons ?? null;
      if (!data) {
        return null;
      }
      if (data?.length > 2) {
        return data?.slice(0, 2);
      }
      return data;
    },
    getlastButtons() {
      const data = this.order_data?.buttons ?? null;
      if (!data) {
        return null;
      }
      if (data?.length > 2) {
        return data?.slice(2);
      }
      return null;
    },

    getMerchantLocation() {
      const data = this.order_data?.order?.order_info ?? null;
      if (!data) {
        return null;
      }
      return {
        lat: data?.latitude,
        lng: data?.longitude,
        restaurant_name: this.getMerchant?.restaurant_name,
      };
    },
  },
  methods: {
    showDeliveryAddress() {
      const center = {
        lat: this.DataStore.getMapsConfig?.default_lat,
        lng: this.DataStore.getMapsConfig?.default_lng,
      };
      const marker_position = [
        {
          id: 0,
          lat: parseFloat(this.orderInfo?.latitude),
          lng: parseFloat(this.orderInfo?.longitude),
          icon:
            this.DataStore.getMapsConfig?.map_provider == "mapbox"
              ? "marker_icon_destination"
              : this.DataStore.getMapsConfig?.icon_destination,
          draggable: false,
        },
      ];
      this.$refs.ref_mapmodal.setLocation(center, marker_position);
    },
    printReceipt() {
      const printer = this.order_data?.printer_details ?? null;
      console.log("printer", printer);
      if (printer) {
        printer.print_type = this.DataPersisted.printer_set;
        this.printer_details = printer;
        if (this.printer_details == "feieyun") {
          this.FPprint();
          return;
        }

        if (!this.$q.capacitor) {
          APIinterface.ShowAlert(
            this.$t(
              "To use Bluetooth printers, please connect from a real device."
            ),
            this.$q.capacitor,
            this.$q
          );
          return;
        }

        setTimeout(() => {
          this.$refs.ref_printreceipt.initData();
        }, 500);
        return;
      }

      this.$refs.printer.dialog = true;
    },
    afterSelectprinter(data) {
      data.print_type = this.DataPersisted.printer_set;
      this.printer_details = data;
      console.log("this.printer_details", this.printer_details);
      this.$refs.printer.dialog = false;

      if (this.printer_details == "feieyun") {
        this.FPprint();
        return;
      }

      if (!this.$q.capacitor) {
        APIinterface.ShowAlert(
          this.$t(
            "To use Bluetooth printers, please connect from a real device."
          ),
          this.$q.capacitor,
          this.$q
        );
        return;
      }

      setTimeout(() => {
        this.$refs.ref_printreceipt.initData();
      }, 500);
    },
    async FPprint() {
      try {
        APIinterface.showLoadingBox(this.$t("Printing..."), this.$q);
        const response = await APIinterface.fetchDataByTokenPost(
          "FPprint",
          new URLSearchParams({
            printer_id: this.printer_details?.printer_id,
            order_uuid: this.order_uuid,
          }).toString()
        );
        APIinterface.ShowSuccessful(response.msg, this.$q);
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
    async downloadPDF() {
      console.log(this.order_data?.pdf_link);
      await Browser.open({ url: this.order_data?.pdf_link });
    },
    toSeo(value) {
      if (!value) {
        return;
      }
      let text = value;
      let result = text.toLowerCase().replace(/\s+/g, "_");
      return result;
    },
    async SendToKitchen() {
      try {
        this.loading_kitchen = true;
        const params = {
          order_uuid: this.order_uuid,
          order_info: {
            customer_name: this.orderInfo.customer_name,
            order_id: this.orderInfo.order_id,
            merchant_id: this.getMerchant.merchant_id,
            merchant_uuid: this.getMerchant.merchant_uuid,
            order_type: this.orderInfo.order_type,
            transaction_type: this.orderInfo.transaction_type,
            delivery_date: this.orderInfo.delivery_date,
            whento_deliver: this.orderInfo.whento_deliver,
            delivery_time: this.orderInfo.delivery_time,
            timezone: this.orderInfo.timezone,
          },
          order_table_data: this.getTabledata,
          items: this.getItems,
        };
        const response = await APIinterface.fetchDataByTokenPost(
          "SendToKitchen",
          params
        );
        APIinterface.ShowSuccessful(response.msg, this.$q);
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
        this.loading_kitchen = false;
      }
    },
    onScroll(info) {
      if (!info) {
        return;
      }
      this.isScrolled = info.position.top > 20;
    },
    changeColor(data) {
      let $color = "mygrey";
      switch (data) {
        case "btn-green":
          $color = "primary";
          break;
        case "btn-yellow":
          $color = "yellow-9";
          break;
        case "btn-black":
          $color = "mygrey";
          break;
      }
      return $color;
    },
    changeTextColor(data) {
      let $color = "dark";
      switch (data) {
        case "btn-green":
          $color = "white";
          break;
        case "btn-yellow":
          $color = "white";
          break;
        case "btn-black":
          $color = "dark";
          break;
      }
      return $color;
    },
    refresh(done) {
      setTimeout(() => {
        done();
      }, 100);
      this.orderDetails();
    },
    afterAssigndriver() {
      this.orderDetails();
    },
    async orderDetails() {
      try {
        this.loading = true;
        const response = await APIinterface.fetchDataByToken("orderDetails", {
          order_uuid: this.order_uuid,
          hide_currency: this.DataPersisted.hide_currency ? 1 : 0,
          payload: this.payload,
        });
        console.log("response", response);
        this.order_data = response.details?.data;
      } catch (error) {
        this.order_data = [];
      } finally {
        this.loading = false;
      }
    },
    doActions(data) {
      this.button_uuid = data.uuid;
      if (data.do_actions == "reject_form") {
        this.$refs.rejection.dialog = true;
      } else {
        this.updateOrderStatus("", "updateOrderStatus");
      }
    },
    afterAddreason(data) {
      this.dialog = false;
      this.updateOrderStatus(data, "updateOrderStatus");
    },
    updateOrderStatus(reason, actions) {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByToken(actions, {
        order_uuid: this.order_uuid,
        reason: reason,
        uuid: this.button_uuid,
      })
        .then((data) => {
          this.OrderStore.clearSavedOrderList();
          this.orderDetails();

          console.log("data", data);
          this.OrderStore.order_count = data.details.tabs_total_order;
          this.OrderStore.orderListFeed = null;
          this.OrderStore.updateOrderCount(
            this.OrderStore.order_count?.new_order
          );
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    afterSelect(data) {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByToken("setDelayToOrder", {
        order_uuid: this.order_info.order_uuid,
        time_delay: data,
      })
        .then((data) => {
          APIinterface.notify("positive", data.msg, "check", this.$q);
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    afterCancel(data) {
      console.log(data);
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        "cancelOrder",
        "order_uuid=" + this.order_uuid + "&reason=" + data
      )
        .then((data) => {
          this.orderDetails();
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    editPrepationtime(data) {
      console.log("editPrepationtime", data);
      this.$refs.ref_preparation_time.modal = true;
    },
    afterUpdatetime(data) {
      console.log("afterUpdatetime", data);
      this.OrderStore.clearSavedOrderList();
      this.order_data = data.details?.data;
    },
  },
};
</script>
