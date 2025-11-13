<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page class="q-pa-md bg-grey-1">
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
      <NoData v-else-if="!hasData && !loading" message="No messages yet" />

      <template v-if="hasData && !loading">
        <q-list>
          <q-virtual-scroll
            class="fit"
            :items="getData"
            :virtual-scroll-item-size="48"
            v-slot="{ item: items }"
          >
            <q-item
              clickable
              :to="{
                path: '/chat/conversation',
                query: {
                  conversation_id: items.doc_id,
                },
              }"
            >
              <q-item-section avatar>
                <q-avatar v-if="items?.to_info">
                  <q-img
                    :src="items?.to_info?.photo"
                    loading="lazy"
                    fit="cover"
                  >
                    <template v-slot:loading>
                      <q-skeleton
                        height="50px"
                        width="50px"
                        square
                        class="bg-grey-2"
                      />
                    </template>
                  </q-img>
                </q-avatar>
                <q-avatar v-else color="disabled" text-color="disabled"
                  >U</q-avatar
                >
              </q-item-section>
              <q-item-section>
                <q-item-label class="text-weight-bold text-text">
                  <template v-if="items?.to_info">
                    {{ items?.to_info?.first_name }}
                    {{ items?.to_info?.last_name }}
                  </template>
                </q-item-label>
                <q-item-label caption>
                  <template v-if="items?.orderID">
                    {{ $t("Order#") }} {{ items?.orderID }}
                  </template>
                  <template v-else>
                    <template v-if="items?.to_info">
                      {{ items?.to_info?.user_type }}
                    </template>
                  </template>
                </q-item-label>
                <q-item-label caption lines="2">
                  <template v-if="items?.is_typing">
                    <span class="text-red"> {{ $t("is typing") }} ...</span>
                  </template>
                  <template v-else-if="getLastMessageData[items.doc_id]">
                    {{ getLastMessageData[items.doc_id].message }}
                  </template>
                </q-item-label>
              </q-item-section>
              <q-item-section side top>
                <q-item-label caption>
                  {{ toReadableDate(items.lastUpdated) }}
                </q-item-label>
              </q-item-section>
            </q-item>
          </q-virtual-scroll>
        </q-list>
      </template>

      <q-space class="q-pa-lg"></q-space>

      <q-page-scroller
        position="bottom"
        :scroll-offset="150"
        :offset="[18, 18]"
      >
        <q-btn
          fab
          icon="keyboard_arrow_up"
          color="blue-grey-1"
          text-color="blue-grey-8"
          padding="10px"
        />
      </q-page-scroller>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useChatStore } from "stores/ChatStore";
import auth from "src/api/auth";
import { date } from "quasar";
import { firebaseDb, firebaseCollectionEnum } from "src/boot/Firebase";
import {
  collection,
  query,
  where,
  orderBy,
  limit,
  onSnapshot,
  getDocs,
  addDoc,
  serverTimestamp,
} from "firebase/firestore";
import { useDataStore } from "src/stores/DataStore";
import { defineAsyncComponent } from "vue";

export default {
  name: "ChatMain",
  components: {
    NoData: defineAsyncComponent(() => import("components/NoData.vue")),
  },
  data() {
    return {
      search: "",
      is_search: false,
      awaitingSearch: false,
      search_data: null,
      user_uuid: null,
      unsubscribe: null,
      all_users: [],
      whoistyping_data: {},
      refresh_page: undefined,
      loading: false,
      user_data: null,
      create_loading: false,
    };
  },
  setup(props) {
    const ChatStore = useChatStore();
    const DataStore = useDataStore();
    return { ChatStore, DataStore };
  },
  mounted() {
    this.DataStore.page_title = this.$t("Chat");
    let user = auth.getUser();
    this.user_data = user;
    this.user_uuid = user.merchant_uuid;
    if (!this.ChatStore.data) {
      this.getParticipants();
    }
  },
  unmounted() {
    this.DataStore.page_title = null;
    if (this.unsubscribe) {
      this.unsubscribe();
    }
  },
  computed: {
    hasSearch() {
      if (!APIinterface.empty(this.search)) {
        return true;
      }
      return false;
    },
    getSearchdata() {
      return this.search_data;
    },
    getData() {
      return this.ChatStore.data;
    },
    getLastMessageData() {
      return this.ChatStore.last_message_data;
    },
    hasData() {
      if (!this.ChatStore.data) {
        return false;
      }
      return this.ChatStore.data.length > 0;
    },
  },
  watch: {
    search(newsearch, oldsearch) {
      if (!this.awaitingSearch) {
        if (APIinterface.empty(newsearch)) {
          return false;
        }
        setTimeout(() => {
          APIinterface.fetchDataByTokenPost(
            "SearchCustomer",
            "q=" + this.search + "&results_return=profile"
          )
            .then((data) => {
              if (data.code == 1) {
                if (Object.keys(data.details.data).length > 0) {
                  this.search_data = data.details.data;
                } else this.search_data = null;
              } else {
                this.search_data = null;
              }
            })
            .catch((error) => {})
            .then((data) => {
              this.awaitingSearch = false;
            });
        }, 1000); // 1 sec delay
        this.awaitingSearch = true;
      }
    },
  },
  methods: {
    toReadableDate(ts) {
      if (!ts) return "";

      const millis = ts.seconds * 1000 + ts.nanoseconds / 1e6;
      const date = new Date(millis);
      const now = new Date();

      // Difference in milliseconds
      const diff = now - date;

      // If less than 1 minute → show "Just now"
      if (diff < 60 * 1000) {
        return "Just now";
      }

      // Otherwise → show like "18 Dec"
      return new Intl.DateTimeFormat("en", {
        day: "2-digit",
        month: "short",
      }).format(date);
    },
    refresh(done) {
      this.refresh_page = done;
      this.getParticipants();
    },
    clearSearch() {
      this.search = "";
      this.search_data = null;
    },
    closeSearch() {
      this.is_search = false;
      this.search = "";
      this.search_data = null;
    },
    getParticipants() {
      try {
        this.loading = true;
        this.ChatStore.data = [];
        this.ChatStore.last_message_data = {};
        const collectionRef = collection(
          firebaseDb,
          firebaseCollectionEnum.chats
        );

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
            console.log("change.type", change.type);
            let data = change.doc.data();
            const docId = change.doc.id;

            let isTyping = data.isTyping || null;
            let participants = data.participants || null;

            if (Object.keys(participants).length > 0) {
              Object.entries(participants).forEach(([key, items]) => {
                this.all_users.push(items);
              });
            }

            let resp_participants = participants.filter(
              (i) => !i.includes(this.user_uuid)
            );
            let user_uuid = resp_participants[0] ? resp_participants[0] : null;

            let matchedInfo = null;
            let from_info = data.from_info || null;
            let to_info = data.to_info || null;
            if (from_info?.client_uuid === this.user_uuid) {
              matchedInfo = to_info;
            } else if (to_info?.client_uuid === this.user_uuid) {
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
              this.ChatStore.data.unshift(docData);
            } else if (change.type === "modified") {
              const index = this.ChatStore.data.findIndex(
                (chat) => chat.doc_id === docId
              );
              if (index !== -1) {
                this.ChatStore.data[index] = { ...docData, doc_id: docId };
              }
            } else if (change.type === "removed") {
              const index = this.ChatStore.data.findIndex(
                (chat) => chat.doc_id === docId
              );
              if (index !== -1) {
                this.ChatStore.data.splice(index, 1);
              }
            }
          });

          if (this.ChatStore.data) {
            // this.ChatStore.data.sort((a, b) => {
            //   const aTimestamp =
            //     a.lastUpdated.seconds * 1000 +
            //     a.lastUpdated.nanoseconds / 1000000;
            //   const bTimestamp =
            //     b.lastUpdated.seconds * 1000 +
            //     b.lastUpdated.nanoseconds / 1000000;
            //   return bTimestamp - aTimestamp;
            // });
            this.ChatStore.data.sort((a, b) => {
              const aTimestamp =
                (a.lastUpdated?.seconds || 0) * 1000 +
                (a.lastUpdated?.nanoseconds || 0) / 1000000;
              const bTimestamp =
                (b.lastUpdated?.seconds || 0) * 1000 +
                (b.lastUpdated?.nanoseconds || 0) / 1000000;
              return bTimestamp - aTimestamp;
            });

            this.getLastMessage();
          }

          this.loading = false;
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
              this.ChatStore.last_message_data[conversationID] = {
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
    async onChatuser(data) {
      console.log("data", data);
      try {
        const collectionRef = collection(
          firebaseDb,
          firebaseCollectionEnum.chats
        );
        const q = query(
          collectionRef,
          where("participants", "array-contains", data.client_uuid),
          orderBy("lastUpdated", "desc"),
          limit(1)
        );

        let current_doc_id = "";
        const querySnapshot = await getDocs(q);
        querySnapshot.forEach((doc) => {
          let data = doc.data();
          let participants = data.participants || null;
          if (participants.includes(this.user_uuid) === true) {
            current_doc_id = doc.id;
          }
        });

        if (!APIinterface.empty(current_doc_id)) {
          this.loadConversation(current_doc_id);
        } else {
          this.createConversation(data);
        }
      } catch (error) {
        APIinterface.notify("dark", error, "error", this.$q);
      }
    },
    async createConversation(to_info) {
      try {
        this.create_loading = true;

        let user_uuid = to_info.client_uuid;
        let from_info = {
          client_uuid: this.user_data.merchant_uuid,
          photo: this.user_data.avatar,
          first_name: this.user_data.first_name,
          last_name: this.user_data.last_name,
          user_type: "merchant",
        };
        let data = {
          lastUpdated: serverTimestamp(),
          dateCreated: serverTimestamp(),
          participants: [user_uuid, this.user_uuid],
          isTyping: {
            [`${user_uuid}`]: false,
            [`${this.user_uuid}`]: false,
          },
          from_info: from_info,
          to_info: to_info,
        };

        const newConversationRef = await addDoc(
          collection(firebaseDb, firebaseCollectionEnum.chats),
          data
        );

        const chatId = newConversationRef.id;
        console.log("chatId", chatId);

        this.create_loading = false;
        this.loadConversation(chatId);
      } catch (error) {
        this.create_loading = false;
        APIinterface.notify("dark", error, "error", this.$q);
      }
    },
    loadConversation(docId) {
      console.log("loadConversation", docId);
      this.$router.push({
        path: "/chat/conversation",
        query: { conversation_id: docId, added: true },
      });
    },
    //
  },
};
</script>
