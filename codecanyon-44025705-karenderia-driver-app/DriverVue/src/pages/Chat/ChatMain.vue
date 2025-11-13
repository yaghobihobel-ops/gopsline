<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-header
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
    >
      <q-toolbar>
        <q-btn
          @click="$router.back()"
          flat
          round
          dense
          icon="las la-angle-left"
          class="q-mr-sm"
          :color="$q.dark.mode ? 'white' : 'dark'"
        />
        <q-toolbar-title>
          {{ $t("Live Chat") }}
        </q-toolbar-title>
      </q-toolbar>
    </q-header>
    <q-page>
      <!-- hasData=>{{ hasData }} -->
      <!-- <pre>{{ this.history.chat_data }}</pre> -->
      <template v-if="!hasData && !loading">
        <div
          class="text-body2 text-weight-medium flex flex-center text-grey"
          style="height: calc(80vh)"
        >
          {{ $t("Chat will show here") }}
        </div>
      </template>

      <template v-if="loading">
        <q-list>
          <q-item v-for="items in 10" :key="items">
            <q-item-section avatar>
              <q-skeleton type="QAvatar" />
            </q-item-section>
            <q-item-section>
              <q-item-label>
                <q-skeleton type="text" />
              </q-item-label>
              <q-item-label caption>
                <q-skeleton type="text" />
              </q-item-label>
            </q-item-section>
          </q-item>
        </q-list>
      </template>

      <template v-if="hasData && !loading">
        <q-list separator>
          <template v-for="items in getData" :key="items">
            <q-item
              clickable
              :to="{
                path: '/chat',
                query: {
                  conversation_id: items.doc_id,
                },
              }"
            >
              <q-item-section avatar>
                <q-avatar v-if="items.to_info">
                  <img :src="items.to_info.photo" />
                </q-avatar>
                <q-avatar v-else color="grey-5" text-color="white"> </q-avatar>
              </q-item-section>
              <q-item-section>
                <q-item-label class="text-weight-bold">
                  <template v-if="items.to_info">
                    {{ items.to_info.first_name }} {{ items.to_info.last_name }}
                  </template>
                </q-item-label>
                <q-item-label caption>
                  <template v-if="items.orderID">
                    {{ $t("Order#") }} {{ items.orderID }}
                  </template>
                  <template v-else>
                    <template v-if="items.to_info">
                      {{ items.to_info.user_type }}
                    </template>
                  </template>
                </q-item-label>
                <q-item-label caption lines="2">
                  <template v-if="items.is_typing">
                    <span class="text-red"> {{ $t("is typing") }} ...</span>
                  </template>
                  <template v-else-if="getLastMessageData[items.doc_id]">
                    {{ getLastMessageData[items.doc_id].message }}
                  </template>
                </q-item-label>
              </q-item-section>
            </q-item>
          </template>
        </q-list>
      </template>

      <q-page-scroller
        v-if="hasData && !loading"
        position="bottom-right"
        :scroll-offset="150"
        :offset="[18, 18]"
      >
        <q-btn fab icon="keyboard_arrow_up" color="primary" padding="sm" />
      </q-page-scroller>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { firebaseDb, firebaseCollectionEnum } from "src/boot/FirebaseChat";
import {
  collection,
  query,
  where,
  orderBy,
  limit,
  onSnapshot,
  getDocs,
} from "firebase/firestore";
import auth from "src/api/auth";
import APIinterface from "src/api/APIinterface";
import { date } from "quasar";
import { ShiftHistoryStore } from "stores/MyScheduleStore";

export default {
  name: "ChatMain",
  data() {
    return {
      user_uuid: "",
      data: [],
      users: [],
      all_users: [],
      loading: false,
      last_message_data: {},
      whoistyping_data: {},
      document_id: "",
      main_user_type: "",
      refresh_page: undefined,
      unsubscribe: null,
    };
  },
  setup() {
    const history = ShiftHistoryStore();
    return { history };
  },
  mounted() {
    let user = auth.getUser();
    this.user_uuid = user.driver_uuid;
    //if (!this.history.chat_data) {
    if (!this.hasData) {
      console.log("getParticipants");
      this.getParticipants();
    }
  },
  unmounted() {
    if (this.unsubscribe) {
      this.unsubscribe();
    }
  },
  computed: {
    getData() {
      return this.history.chat_data;
    },
    getLastMessageData() {
      return this.last_message_data;
    },
    hasData() {
      //if (this.history.chat_data) {
      if (this.history.chat_data) {
        if (Object.keys(this.history.chat_data).length > 0) {
          return true;
        }
      }
      return false;
    },
    hasUserData() {
      if (Object.keys(this.users_data).length > 0) {
        return true;
      }
      return false;
    },
    getShowistyping() {
      return this.whoistyping_data;
    },
  },
  methods: {
    refresh(done) {
      this.refresh_page = done;
      this.getParticipants();
    },
    getParticipants() {
      try {
        this.loading = true;
        this.history.chat_data = [];
        const collectionRef = collection(
          firebaseDb,
          firebaseCollectionEnum.chats
        );

        console.log("this.user_uuid", this.user_uuid);
        const q = query(
          collectionRef,
          where("participants", "array-contains", this.user_uuid),
          orderBy("lastUpdated", "desc"),
          limit(firebaseCollectionEnum.limit)
        );
        this.unsubscribe = onSnapshot(q, (snapshot) => {
          if (!APIinterface.empty(this.refresh_page)) {
            this.refresh_page();
          }

          snapshot.docChanges().forEach((change) => {
            //console.log("change.type", change.type);
            let data = change.doc.data();
            const docId = change.doc.id;

            let isTyping = data.isTyping || null;
            let participants = data.participants || null;

            let resp_participants = participants.filter(
              (i) => !i.includes(this.user_uuid)
            );
            let user_uuid = resp_participants[0] ? resp_participants[0] : null;
            this.users.push(user_uuid);

            let matchedInfo = null;
            let from_info = data.from_info || null;
            let to_info = data.to_info || null;
            if (from_info.client_uuid === this.user_uuid) {
              matchedInfo = to_info;
            } else if (to_info.client_uuid === this.user_uuid) {
              matchedInfo = from_info;
            }

            const docData = {
              doc_id: docId,
              user_uuid: user_uuid,
              is_typing: isTyping[resp_participants[0]]
                ? isTyping[resp_participants[0]]
                : false,
              orderID: data.orderID || null,
              orderUuid: data.orderUuid || null,
              lastUpdated: data.lastUpdated || null,
              to_info: matchedInfo,
            };

            if (change.type === "added") {
              this.history.chat_data.unshift(docData);

              if (Object.keys(participants).length > 0) {
                Object.entries(participants).forEach(([key, items]) => {
                  this.all_users.push(items);
                });
              }
            } else if (change.type === "modified") {
              const index = this.history.chat_data.findIndex(
                (chat) => chat.doc_id === docId
              );
              if (index !== -1) {
                this.history.chat_data[index] = { ...docData, doc_id: docId };
              }
            } else if (change.type === "removed") {
              const index = this.history.chat_data.findIndex(
                (chat) => chat.doc_id === docId
              );
              if (index !== -1) {
                this.history.chat_data.splice(index, 1);
              }
            }
          });

          this.history.chat_data.sort((a, b) => {
            const aTimestamp =
              a.lastUpdated.seconds * 1000 +
              a.lastUpdated.nanoseconds / 1000000;
            const bTimestamp =
              b.lastUpdated.seconds * 1000 +
              b.lastUpdated.nanoseconds / 1000000;
            return bTimestamp - aTimestamp;
          });

          this.loading = false;
          this.getLastMessage();
        });
      } catch (error) {
        APIinterface.notify("dark", error, "error", this.$q);
      }
    },
    async getLastMessage() {
      try {
        if (Object.keys(this.all_users).length > 0) {
          const batch = this.all_users.splice(0, 10);
          const conversationsRef = collection(
            firebaseDb,
            firebaseCollectionEnum.chats
          );
          const querySnapshot = await getDocs(
            query(
              conversationsRef,
              where("participants", "array-contains-any", batch)
            )
          );
          querySnapshot.forEach(async (doc) => {
            const conversationID = doc.id;
            const messagesRef = collection(
              firebaseDb,
              firebaseCollectionEnum.chats,
              conversationID,
              "messages"
            );
            const messagesSnapshot = await getDocs(
              query(
                messagesRef,
                where("senderID", "in", batch),
                orderBy("timestamp", "desc"),
                limit(1)
              )
            );
            messagesSnapshot.forEach((messageDoc) => {
              let results = messageDoc.data();
              let timestamp = results.timestamp.toDate().toISOString();
              this.last_message_data[conversationID] = {
                message: results.message,
                timestamp: timestamp,
                time: date.formatDate(timestamp, "hh:mm a"),
              };
            });
          });
        }
      } catch (error) {
        console.error("Error fetching last message:", error);
      }
    },
    //
  },
};
</script>
