<template>
  <q-page class="flex items-stretch content-end q-pa-md bg-grey-1">
    <div style="width: 100%; max-width: 400px">
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

      <template v-for="items in getChatmessage" :key="items">
        <template v-if="items.messageType == 'audio'">
          <div class="bg-blue radius10 q-mt-md q-mb-md q-pa-xs">
            <template v-if="isWebM(items.fileUrl)">
              <audio ref="audio" controls class="custom-audio">
                <source :src="items.fileUrl" type="audio/webm" />
              </audio>
            </template>
            <template v-else>
              <AudioPlayback
                :audio_path="items.fileUrl"
                :show_media="true"
                layout="1"
                :uploading_status="upload_audio_loading"
              ></AudioPlayback>
            </template>
          </div>
        </template>
        <template v-else>
          <q-chat-message
            :name="items.senderID == user_uuid ? $t('You') : items.sender"
            :avatar="items.photo"
            :stamp="items.time"
            :text-color="items.senderID == user_uuid ? 'text' : 'white'"
            :bg-color="items.senderID == user_uuid ? 'white' : 'red'"
            :sent="items.senderID == user_uuid ? true : false"
          >
            <template #avatar>
              <q-avatar class="q-ml-sm">
                <q-img
                  :src="items.photo"
                  spinner-size="sm"
                  spinner-color="primary"
                  style="height: 48px; max-width: 48px; min-width: 48px"
                  fit="cover"
                  loading="lazy"
                ></q-img>
              </q-avatar>
            </template>
            <div v-if="items.message">{{ items.message }}</div>
            <template v-if="items.fileUrl">
              <q-img
                :src="items.fileUrl"
                spinner-size="sm"
                spinner-color="primary"
                style="min-height: 150px; min-width: 150px; max-width: 150px"
              >
              </q-img>
            </template>
          </q-chat-message>
        </template>
      </template>

      <template v-for="(items, userUUID) in getUserTyping" :key="items">
        <template v-if="items">
          <template v-if="userUUID != user_uuid">
            <template v-if="to_info">
              <q-chat-message
                :name="`${to_info.first_name} ${this.$t('is typing...')}`"
                :avatar="to_info.photo"
                :text-color="userUUID == user_uuid ? 'text' : 'white'"
                :bg-color="userUUID == user_uuid ? 'white' : 'red'"
                :sent="userUUID == user_uuid ? true : false"
              >
                <q-spinner-dots size="2rem" />
              </q-chat-message>
            </template>
          </template>
        </template>
      </template>
    </div>
    <div ref="scroll_ref" class="text-white q-pa-sm"></div>
  </q-page>
  <q-footer
    v-if="conversation_found"
    class="footer-shadow bg-white q-pl-md q-pr-md q-pb-sm text-text"
  >
    <template v-if="is_recording">
      <div class="q-pa-sm">
        <AudioRecorder
          ref="ref_audio"
          @cancel-recording="cancelRecording"
          @start-upload="startUpload"
        ></AudioRecorder>
      </div>
    </template>
    <template v-else>
      <q-uploader
        :url="upload_api_url"
        multiple
        ref="uploader"
        flat
        accept=".jpg, image/*"
        max-total-size="10485760"
        field-name="file"
        @added="afterAddedFiles"
        @removed="afterRemoveFiles"
        @rejected="onRejectedFiles"
        @uploading="onUploadingFiles"
        @uploaded="afterUploaded"
        @finish="afterFinishUpload"
      >
        <template v-slot:header>
          <q-uploader-add-trigger></q-uploader-add-trigger>
        </template>
        <template v-slot:list="scope">
          <div class="flex justify-start q-col-gutter-x-md">
            <template v-for="file in scope.files" :key="file.__key">
              <div class="relative-position">
                <img
                  :src="file.__img.src"
                  style="max-width: 60px; height: 60px"
                  class="radius10"
                />
                <div
                  class="absolute-right"
                  style="margin-right: -10px; margin-top: -5px"
                >
                  <q-btn
                    unelevated
                    round
                    color="red-8"
                    text-color="red-1"
                    icon="close"
                    size="xs"
                    @click="scope.removeFile(file)"
                  ></q-btn>
                </div>
              </div>
            </template>
          </div>
        </template>
      </q-uploader>

      <div class="row q-gutter-x-sm">
        <q-input
          v-model="message"
          :placeholder="$t('Enter your message here')"
          outlined
          autogrow
          class="col"
        >
          <template v-slot:prepend>
            <q-btn
              unelevated
              round
              flat
              color="text"
              dense
              padding="0"
              @click="pickFiles"
            >
              <q-icon name="add"></q-icon>
            </q-btn>
          </template>
          <template v-slot:append>
            <div class="q-gutter-xs">
              <q-btn unelevated round flat dense padding="0">
                <q-icon name="o_emoji_emotions"></q-icon>
                <q-popup-proxy ref="proxy">
                  <q-card>
                    <EmojiPicker
                      :native="true"
                      @select="onSelectEmoji"
                      :disable-skin-tones="true"
                    />
                  </q-card>
                </q-popup-proxy>
              </q-btn>
            </div>
          </template>
        </q-input>
        <div class="col-2" style="min-width: auto; width: auto">
          <q-btn
            @click="onSubmit"
            round
            size="18px"
            unelevated
            color="red"
            text-color="white"
            class="footer-shadow"
          >
            <template v-if="hasMessage">
              <img src="/svg/mynaui--send.svg" height="25" />
            </template>
            <template v-else>
              <img src="/svg/hugeicons--mic-02.svg" height="25" />
            </template>
          </q-btn>
        </div>
      </div>
    </template>
  </q-footer>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { scroll } from "quasar";
const { getScrollTarget, setVerticalScrollPosition } = scroll;
import EmojiPicker from "vue3-emoji-picker";
import "vue3-emoji-picker/css";
import insertTextAtCursor from "insert-text-at-cursor";
import { firebaseDb, firebaseCollectionEnum } from "src/boot/Firebase";
import {
  collection,
  query,
  where,
  orderBy,
  limit,
  onSnapshot,
  getDocs,
  setDoc,
  doc,
  getDoc,
  updateDoc,
  Timestamp,
  addDoc,
  serverTimestamp,
} from "firebase/firestore";
import auth from "src/api/auth";
import APIinterface from "src/api/APIinterface";
import { date } from "quasar";
import config from "src/api/config";
import axios from "axios";
import { useChatStore } from "stores/ChatStore";
import { VoiceRecorder } from "capacitor-voice-recorder";
import { useUserStore } from "stores/UserStore";
import { useDataStore } from "src/stores/DataStore";
import { api } from "src/boot/axios";

export default {
  name: "ChatConversation",
  components: {
    EmojiPicker,
    AudioRecorder: defineAsyncComponent(() =>
      import("components/AudioRecorder.vue")
    ),
    AudioPlayback: defineAsyncComponent(() =>
      import("components/AudioPlayback.vue")
    ),
  },
  setup(props) {
    const ChatStore = useChatStore();
    const UserStore = useUserStore();
    const DataStore = useDataStore();
    return { ChatStore, UserStore, DataStore };
  },
  data() {
    return {
      message: "",
      loading: false,
      conversation_id: "",
      data: [],
      user_typing_data: [],
      chating_with_user_uuid: "",
      user_uuid: "",
      user_data: [],
      participants: [],
      main_user_type: "",
      loading_user: true,
      is_typing: false,
      files: {},
      file_url: "",
      file_type: "",
      upload_loading: false,
      chat_api_url: config.api_base_url + "/chatapi",
      upload_api_url: null,
      participant_user_uuid: "",
      order_id: null,
      from_info: null,
      to_info: null,
      client_id: null,
      conversation_found: false,
      SnapMessages: null,
      dataSnapshot: null,
      SnapWhoistyping: "",
      typingTimeout: null,
      is_recording: false,
      audioPath: null,
      audioBase64: null,
      upload_response: null,
      upload_audio_loading: false,
      mimeType: null,
      respPermission: null,
      respRequestPermission: null,
      notification_uuid: null,
      order_uuid: null,
      chat_type: null,
    };
  },
  created() {
    this.chat_api_url = this.chat_api_url.replace("/interfacemerchant/", "/");
    this.upload_api_url = this.chat_api_url + "/uploadimage";
  },
  mounted() {
    //this.DataStore.page_title = this.$t("Chat");
    this.user_data = auth.getUser();
    this.user_uuid = this.user_data.merchant_uuid;

    this.conversation_id = this.$route.query.conversation_id;
    this.notification_uuid = this.$route.query.notification_uuid;

    this.chat_type = this.$route.query.chat_type;
    this.order_uuid = this.$route.query.order_uuid;

    if (this.chat_type == "order") {
      this.createOrderChat();
      return;
    }

    if (this.chat_type == "driver") {
      this.createChatDriver();
      return;
    }

    let added = this.$route.query.added;
    if (!APIinterface.empty(added)) {
      this.ChatStore.data = null;
    }
    this.getMessages();
    this.getParticipant();
    this.getWhoIsTyping();

    if (this.notification_uuid) {
      this.UserStore.setViewNotification(this.notification_uuid);
    }
  },
  beforeUnmount() {
    this.DataStore.page_chat_data = null;
    if (this.SnapMessages) {
      this.SnapMessages();
    }
    if (this.SnapWhoistyping) {
      this.SnapWhoistyping();
    }
  },
  computed: {
    getChatWith() {
      let matchedInfo = null;
      if (this.from_info && this.to_info) {
        if (this.from_info.client_uuid === this.user_uuid) {
          matchedInfo = this.to_info;
        } else if (this.to_info.client_uuid === this.user_uuid) {
          matchedInfo = this.from_info;
        }
      }

      return matchedInfo;
    },
    getChatmessage() {
      return this.data;
    },
    hasMessageOld() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
    hasMessage() {
      if (!APIinterface.empty(this.message)) {
        return true;
      }
      if (Object.keys(this.files).length > 0) {
        return true;
      }

      return false;
    },
    hasChatDocID() {
      if (!empty(this.chating_with_user_uuid)) {
        return true;
      }
      return false;
    },
    hasUserData() {
      if (Object.keys(this.user_data).length > 0) {
        return true;
      }
      return false;
    },
    getUserData() {
      return this.user_data;
    },
    getUserTyping() {
      return this.user_typing_data;
    },
    hasConversation() {
      if (!APIinterface.empty(this.conversation_id)) {
        return true;
      }
      return false;
    },
  },
  watch: {
    is_typing(newval, oldval) {
      if (newval) {
        this.UpdateWhoistyping(true);
      } else {
        this.UpdateWhoistyping(false);
      }
    },
    message(newval, oldval) {
      clearTimeout(this.typingTimeout);
      this.is_typing = true;
      this.typingTimeout = setTimeout(() => {
        this.is_typing = false;
      }, 1000); // 1 second delay after last input
    },
  },
  methods: {
    async createChatDriver() {
      try {
        this.loading = true;

        const client_uuid = this.$route.query?.client_uuid ?? "";
        const from_info = {
          client_uuid: this.user_uuid,
          photo: this.user_data?.avatar,
          first_name: this.user_data?.first_name,
          last_name: this.user_data?.last_name,
          user_type: "merchant",
        };
        const to_info = {
          client_uuid: client_uuid,
          name: this.$route.query?.name,
          first_name: this.$route.query?.first_name,
          last_name: this.$route.query?.last_name,
          avatar: this.$route.query?.avatar,
          photo: this.$route.query?.avatar,
          user_type: "driver",
        };
        const data = {
          lastUpdated: serverTimestamp(),
          dateCreated: serverTimestamp(),
          orderID: this.$route.query.order_id,
          orderUuid: this.order_uuid,
          participants: [this.user_uuid, client_uuid],
          isTyping: {
            [`${this.user_uuid}`]: false,
            [`${client_uuid}`]: false,
          },
          from_info: from_info,
          to_info: to_info,
        };
        console.log("params", data);
        await setDoc(
          doc(firebaseDb, firebaseCollectionEnum.chats, this.order_uuid),
          data
        );
        this.conversation_id = this.order_uuid;
        this.ChatStore.data = null;
        this.getMessages();
        this.getParticipant();
        this.getWhoIsTyping();
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
      }
    },
    async createOrderChat() {
      try {
        this.loading = true;
        const client_uuid = this.$route.query?.client_uuid ?? "";
        const from_info = {
          client_uuid: this.user_uuid,
          photo: this.user_data?.avatar,
          first_name: this.user_data?.first_name,
          last_name: this.user_data?.last_name,
          user_type: "merchant",
        };
        const to_info = {
          client_uuid: client_uuid,
          name: this.$route.query?.name,
          first_name: this.$route.query?.first_name,
          last_name: this.$route.query?.last_name,
          avatar: this.$route.query?.avatar,
          photo: this.$route.query?.avatar,
          user_type: "customer",
        };
        const data = {
          lastUpdated: serverTimestamp(),
          dateCreated: serverTimestamp(),
          orderID: this.$route.query.order_id,
          orderUuid: this.order_uuid,
          participants: [this.user_uuid, client_uuid],
          isTyping: {
            [`${this.user_uuid}`]: false,
            [`${client_uuid}`]: false,
          },
          from_info: from_info,
          to_info: to_info,
        };

        await setDoc(
          doc(firebaseDb, firebaseCollectionEnum.chats, this.order_uuid),
          data
        );
        this.conversation_id = this.order_uuid;
        this.ChatStore.data = null;
        this.getMessages();
        this.getParticipant();
        this.getWhoIsTyping();
      } catch (error) {
        APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
      } finally {
      }
    },
    isWebM(url) {
      return url.toLowerCase().endsWith(".webm");
    },
    scrollTobottom() {
      try {
        setTimeout(() => {
          let el = this.$refs.scroll_ref;
          if (!APIinterface.empty(el)) {
            const target = getScrollTarget(el);
            const offset = el.offsetTop;
            const duration = 1;
            setVerticalScrollPosition(target, offset, duration);
          }
        }, 500);
      } catch (error) {
        console.log(error);
      }
    },
    onSelectEmoji(emoji) {
      insertTextAtCursor(document.querySelector("textarea"), emoji.i);
      this.$refs.proxy.hide();
    },
    getMessages() {
      this.loading = true;
      const chatDocRef = doc(
        firebaseDb,
        firebaseCollectionEnum.chats,
        this.conversation_id
      );
      const messagesQuery = query(
        collection(chatDocRef, "messages"),
        orderBy("timestamp", "asc"),
        limit(firebaseCollectionEnum.limit)
      );

      this.SnapMessages = onSnapshot(
        messagesQuery,
        (querySnapshot) => {
          this.data = [];
          this.loading = false;
          querySnapshot.forEach((doc) => {
            if (doc.exists()) {
              const message = doc.data();
              let timestamp = message.timestamp.toDate().toISOString();
              this.data.push({
                messageType: message.messageType,
                fileType: message.fileType,
                fileUrl: message.fileUrl,
                message: message.message,
                senderID: message.senderID,
                timestamp: timestamp,
                time: date.formatDate(timestamp, "hh:mm a"),
                sender: message.sender,
                photo: message.photo,
              });
            } else {
              console.log("Conversation document does not exist");
            }
          });
          this.scrollTobottom();
        },
        (error) => {
          this.loading = false;
          console.error("Error fetching messages:", error);
        }
      );
    },
    async getParticipant() {
      try {
        const docRef = doc(
          firebaseDb,
          firebaseCollectionEnum.chats,
          this.conversation_id
        );
        const dataSnapshot = await getDoc(docRef);
        if (dataSnapshot.exists()) {
          const data = dataSnapshot.data();
          this.to_info = data.to_info || null;
          this.from_info = data.from_info || null;
          this.participants = data.participants || null;

          let resp_participants = this.participants.filter(
            (i) => !i.includes(this.user_uuid)
          );
          this.participant_user_uuid = resp_participants[0]
            ? resp_participants[0]
            : null;

          this.DataStore.page_title = null;
          if (this.getChatWith) {
            this.DataStore.page_chat_data = {
              name: `${this.getChatWith?.first_name} ${this.getChatWith?.last_name}`,
              avatar: this.getChatWith?.avatar,
            };
          }
          this.conversation_found = true;
        } else {
          console.log("Conversation document does not exist");
          this.conversation_found = false;
        }
      } catch (error) {
        console.error("Error getting participants:", error);
      }
    },
    getUser() {
      this.loading_user = true;
      APIinterface.fetchDataByToken("getUsers", {
        main_user_type: this.main_user_type,
        users: this.participants,
      })
        .then((data) => {
          this.user_data = data.details;
        })
        .catch((error) => {
          this.user_data = [];
        })
        .then((data) => {
          this.loading_user = false;
        });
    },
    getWhoIsTyping() {
      const chatDocRef = doc(
        firebaseDb,
        firebaseCollectionEnum.chats,
        this.conversation_id
      );
      this.SnapWhoistyping = onSnapshot(
        chatDocRef,
        (docSnapshot) => {
          if (docSnapshot.exists()) {
            let results = docSnapshot.data();
            this.user_typing_data = results.isTyping || [];
            Object.entries(this.user_typing_data).forEach(
              ([userIID, isTYping]) => {
                if (isTYping && userIID != this.user_uuid) {
                  this.scrollTobottom();
                }
              }
            );
          } else {
            this.user_typing_data = [];
          }
        },
        (error) => {
          console.error("Error fetching chat document:", error);
        }
      );
    },
    async UpdateWhoistyping(data) {
      try {
        const docRef = doc(
          firebaseDb,
          firebaseCollectionEnum.chats,
          this.conversation_id
        );
        await updateDoc(docRef, {
          [`isTyping.${this.user_uuid}`]: data,
        });
      } catch (error) {
        console.error("Error updating typing status:", error);
      }
    },
    onSubmit() {
      if (!this.hasMessage) {
        this.checkPermissionAndStartAudio();
        return;
      }

      if (Object.keys(this.files).length > 0) {
        this.$refs.uploader.upload();
      } else {
        this.saveChatMessage();
      }
    },
    async checkPermissionAndStartAudio() {
      try {
        const resultAudiopermission =
          await VoiceRecorder.hasAudioRecordingPermission();

        if (resultAudiopermission.value) {
          this.RecordAudio();
          return;
        }

        if (!resultAudiopermission.value) {
          const resultRequestpermission =
            await VoiceRecorder.requestAudioRecordingPermission();

          if (resultRequestpermission.value) {
            this.RecordAudio();
            return;
          }

          if (!resultRequestpermission.value) {
            this.showOpenSettings();
          }
        }
      } catch (error) {
        APIinterface.notify("dark", error, "error", this.$q);
      }
    },
    RecordAudio() {
      this.is_recording = true;
    },
    cancelRecording() {
      this.is_recording = false;
    },
    async saveChatMessage() {
      this.loading = true;
      const messagesRef = collection(
        firebaseDb,
        firebaseCollectionEnum.chats,
        this.conversation_id,
        "messages"
      );
      try {
        let data = {
          messageType: "text",
          message: this.message,
          senderID: this.user_uuid,
          timestamp: Timestamp.now(),
          serverTimestamp: serverTimestamp(),
          fileUrl: this.file_url,
          fileType: this.file_type,
          sender: this.user_data.first_name,
          photo: this.user_data.avatar,
        };
        console.log("data", data);
        console.log("conversation_id", this.conversation_id);
        await addDoc(messagesRef, data);
        this.loading = false;
        this.documentLastUpdate(this.conversation_id);
        this.resetChat();
        this.notifyUser();
      } catch (error) {
        console.error("Error adding message to the conversation:", error);
        APIinterface.notify("dark", error, "error", this.$q);
      }
    },
    async documentLastUpdate(doc_id) {
      try {
        const chatRef = doc(firebaseDb, firebaseCollectionEnum.chats, doc_id);
        await updateDoc(chatRef, {
          lastUpdated: serverTimestamp(),
        });
      } catch (error) {
        APIinterface.notify("dark", error, "error", this.$q);
      }
    },
    resetChat() {
      this.message = "";
      this.file_url = "";
      this.file_type = "";
      this.files = {};
      this.$refs.uploader.reset();
    },
    pickFiles() {
      this.$refs.uploader.pickFiles();
    },
    onRejectedFiles(data) {
      APIinterface.notify(
        "dark",
        this.$t("Invalid file type"),
        "error",
        this.$q
      );
    },
    afterAddedFiles(data) {
      Object.entries(data).forEach(([key, items]) => {
        this.files[items.name] = {
          name: items.name,
        };
      });
    },
    afterRemoveFiles(data) {
      Object.entries(data).forEach(([key, items]) => {
        delete this.files[items.name];
      });
    },
    onUploadingFiles(data) {
      this.upload_loading = true;
    },
    afterUploaded(data) {
      if (data.xhr.status == 200) {
        let result = JSON.parse(data.xhr.response);
        let code = result.code || false;
        let details = result.details || [];
        let message = result.msg || "";
        if (code == 1) {
          this.file_url = details.file_url;
          this.file_type = details.file_type;
          this.saveChatMessage();
        } else {
          APIinterface.notify("dark", message, "error", this.$q);
          this.$refs.uploader.reset();
        }
      } else {
        APIinterface.notify(
          "dark",
          this.$t("IError uploading files"),
          "error",
          this.$q
        );
        this.$refs.uploader.reset();
      }
    },
    afterFinishUpload() {
      this.upload_loading = false;
    },
    notifyUser() {
      console.log("this.from_info", this.from_info);
      console.log("this.to_info", this.to_info);

      let params = "from=" + this.user_uuid;
      params += "&to=" + this.participant_user_uuid;
      params += "&first_name=" + this.from_info.first_name;
      params += "&last_name=" + this.from_info.last_name;
      params += "&conversation_id=" + this.conversation_id;
      axios
        .get(this.chat_api_url + "/notifyChatUser?" + params)
        .then((response) => {
          if (response.data.code == 1) {
          } else {
          }
        })
        .catch((error) => {
          console.error("Error:", error);
        })
        .then((data) => {});
    },
    startUpload(audioPath, audioBase64, mimeType) {
      this.is_recording = false;
      this.audioPath = audioPath;
      this.audioBase64 = audioBase64;
      this.mimeType = mimeType;
      this.data.push({
        messageType: "audio",
        message: "",
        senderID: this.user_uuid,
        timestamp: Timestamp.now(),
        serverTimestamp: serverTimestamp(),
        fileUrl: this.audioPath,
        fileType: this.mimeType,
        sender: this.user_data.first_name,
        photo: this.user_data.photo,
      });
      this.UploadFile();
    },
    async UploadFile() {
      try {
        if (!this.audioBase64) {
          console.error("No audio file to upload");
          return;
        }

        this.upload_audio_loading = true;

        const data = {
          audioBase64: this.audioBase64,
          fileName: `recording_${Date.now()}.m4a`,
        };

        const response = await api.post(
          `${config.api_base_url}/interfacemerchant/uploadaudio`,
          data,
          {
            headers: {
              "Content-Type": "application/json",
            },
          }
        );

        this.upload_audio_loading = false;
        this.upload_response = response.data;
        if (response.data.code == 1) {
          this.saveChatAudio();
        } else {
          APIinterface.notify("dark", response.data.msg, "error", this.$q);
        }
      } catch (error) {
        console.log("error", error);
        this.upload_response = "Failed to upload audio =>" + error.message;
      }
    },
    async saveChatAudio() {
      try {
        this.loading = true;
        const messagesRef = collection(
          firebaseDb,
          firebaseCollectionEnum.chats,
          this.conversation_id,
          "messages"
        );
        let data = {
          messageType: "audio",
          message: this.message,
          senderID: this.user_uuid,
          timestamp: Timestamp.now(),
          serverTimestamp: serverTimestamp(),
          fileUrl: this.upload_response.details.file_url,
          fileType: this.mimeType,
          sender: this.user_data.first_name,
          photo: this.user_data.avatar,
        };
        console.log("data", data);
        console.log("conversation_id", this.conversation_id);
        await addDoc(messagesRef, data);
        this.loading = false;
        this.documentLastUpdate(this.conversation_id);
        this.resetChat();
        this.notifyUser();
      } catch (error) {
        console.error("Error adding message to the conversation:", error);
      }
    },
    //
  },
};
</script>
<style lang="scss">
.q-uploader__list {
  min-height: auto !important;
}
</style>
