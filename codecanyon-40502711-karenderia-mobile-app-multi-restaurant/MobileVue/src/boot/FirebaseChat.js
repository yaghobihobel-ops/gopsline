import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
import { getMessaging, getToken, onMessage } from "firebase/messaging";

const firebaseConfig = {
  apiKey: "",
  authDomain: "",
  databaseURL: "",
  projectId: "",
  storageBucket: "",
  messagingSenderId: "",
  appId: "",
  measurementId: "",
};

const firebaseCollectionEnum = {
  chats: "chats",
  limit: 50,
  drivers: "drivers",
};

const firebaasApp = initializeApp(firebaseConfig);
const firebaseDb = getFirestore(firebaasApp);

let firebaseMessaging = null;

const is_messaging_supported =
  "Notification" in window &&
  "serviceWorker" in navigator &&
  "PushManager" in window;
if (is_messaging_supported) {
  try {
    firebaseMessaging = getMessaging(firebaasApp);
  } catch (err) {
    console.warn(
      "Firebase Messaging is not supported in this environment:",
      err
    );
  }
}

export {
  firebaseDb,
  firebaseCollectionEnum,
  firebaseMessaging,
  getToken,
  onMessage,
};
