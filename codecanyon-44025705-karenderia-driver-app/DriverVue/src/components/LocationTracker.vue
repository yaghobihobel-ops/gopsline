<template>
  <div class="hidden">
    threshold_meters=>{{ threshold_meters }}
    <br />
    =>{{ LocationStore.has_watcher }}
    <br />
    location_resp =>{{ location_resp }}
    <br />
    distance_resp=>{{ distance_resp }}
    <pre>{{ LocationStore.watchers }}</pre>
    <pre>{{ LocationStore.coordinates }}</pre>
  </div>
</template>

<script>
import { ref, onMounted, onUnmounted, computed, watch } from "vue";
import { useScheduleStore } from "stores/ScheduleStore";
import { useLocationStore } from "stores/LocationStore";
import { useActivityStore } from "stores/ActivityStore";
import APIinterface from "src/api/APIinterface";
import AppLocation from "src/api/AppLocation";
import { useRouter, useRoute } from "vue-router";
import { Geolocation } from "@capacitor/geolocation";
import { useQuasar } from "quasar";
// import { Http } from "@capacitor-community/http";
import { CapacitorHttp } from "@capacitor/core";
import { registerPlugin } from "@capacitor/core";
import config from "src/api/config";
import auth from "src/api/auth";
const BackgroundGeolocation = registerPlugin("BackgroundGeolocation");
import { firebaseDb, firebaseCollectionEnum } from "src/boot/FirebaseChat";
import {
  doc,
  setDoc,
  addDoc,
  collection,
  onSnapshot,
} from "firebase/firestore";

//https://edupala.com/ionic-capacitor-geolocation-for-getting-location-data/

export default {
  name: "LocationTracker",
  setup() {
    const router = useRouter();
    const route = useRoute();
    const $q = useQuasar();

    const Schedule = useScheduleStore();
    const LocationStore = useLocationStore();
    const Activity = useActivityStore();
    const watchId = ref(null);
    const driverInfo = ref(undefined);

    const lastUpdate = ref(0);
    const updateInterval = ref(10000);
    const lastSentPosition = ref(null);
    const newPosition = ref(null);
    const threshold_meters = ref(50);

    const location_resp = ref(null);
    const distance_resp = ref(null);

    const myData = computed(() => Activity.settings_data);

    watch(myData, (newValue, oldValue) => {
      if (newValue.threshold_meters > 0) {
        threshold_meters.value = newValue.threshold_meters;
      }
      if ($q.capacitor) {
        checkLocationPermission();
      } else {
        checkLocationPermissionWeb();
      }
    });

    onMounted(() => {
      driverInfo.value = auth.getUser();
    });

    onUnmounted(() => {
      if (!$q.capacitor) {
        stopWatching();
      }
    });

    async function checkLocationPermissionWeb() {
      const permission = await Geolocation.checkPermissions();
      if (permission.location == "granted") {
        //console.log("watchId", watchId.value);
        if (!watchId.value) {
          startWatching();
        }
      } else {
        const $skip = APIinterface.getSession("skip_location");
        if ($skip != 1) {
          router.push({
            path: "/location/permission",
            query: { page: "/home" },
          });
        }
      }
    }

    function startWatching() {
      //console.log("startWatching");
      watchId.value = Geolocation.watchPosition(
        {
          enableHighAccuracy: true,
          timeout: 10000,
          maximumAge: 0,
        },
        (position, err) => {
          const now = Date.now();
          if (position && now - lastUpdate.value > updateInterval.value) {
            lastUpdate.value = now;
            //console.log("lastUpdate", lastUpdate.value);
            //console.log("startWatching", position);
            const currentTimestamp = Date.now();
            LocationStore.coordinates = {
              lat: position.coords.latitude,
              lng: position.coords.longitude,
              accuracy: position.coords.accuracy,
              altitude: position.coords.altitude,
              altitudeAccuracy: position.coords.altitudeAccuracy,
              speed: position.coords.speed,
              bearing: position.coords.heading,
              time: position.timestamp,
              simulated: false,
              created_at: APIinterface.getDateTimeNow(),
              driver_id: driverInfo.value.driver_id,
            };

            const { latitude, longitude } = position.coords;

            newPosition.value = { latitude, longitude };
            if (
              !lastSentPosition.value ||
              isSignificantChange(
                newPosition.value,
                lastSentPosition.value,
                threshold_meters.value
              )
            ) {
              //console.log("update location");
              location_resp.value = "update location";
              lastSentPosition.value = { latitude, longitude };
              httpLocation();
              setFirebaseLocation();
            } else {
              //console.log("same location");
              location_resp.value = "same location";
            }
          } else if (err) {
            console.log("startWatching error", err);
          }
        }
      );
    }

    function isSignificantChange(newStart, oldStart, threshold = 50) {
      const distance = getDistance(
        newStart.latitude,
        newStart.longitude,
        oldStart.latitude,
        oldStart.longitude
      );
      //console.log("distance", distance);
      distance_resp.value = distance;
      return distance > threshold; // If the distance is greater than the threshold (e.g., 50 meters)
    }

    function getDistance(lat1, lng1, lat2, lng2) {
      const R = 6371e3; // Radius of the Earth in meters
      const φ1 = (lat1 * Math.PI) / 180; // φ, λ in radians
      const φ2 = (lat2 * Math.PI) / 180;
      const Δφ = ((lat2 - lat1) * Math.PI) / 180;
      const Δλ = ((lng2 - lng1) * Math.PI) / 180;

      const a =
        Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
        Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ / 2) * Math.sin(Δλ / 2);
      const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

      const d = R * c; // in meters
      return d;
    }

    function stopWatching() {
      if (watchId.value !== null) {
        Geolocation.clearWatch({ id: watchId.value });
        watchId.value = null;
      }
    }

    function checkLocationPermission() {
      AppLocation.islocationEnabled()
        .then((data) => {
          if ($q.capacitor) {
            if (!LocationStore.has_watcher) {
              initBackground();
            }
            //watchLocation();
          }
        })
        .catch((error) => {
          const $skip = APIinterface.getSession("skip_location");
          if ($skip != 1) {
            router.push({
              path: "/location/permission",
              query: { page: "/home" },
            });
          }
        });
    }

    const initBackground = () => {
      let distance_filter = parseInt(threshold_meters.value);
      BackgroundGeolocation.addWatcher(
        {
          backgroundMessage: "Location tracking updates.",
          backgroundTitle: "Tracking...",
          requestPermissions: true,
          stale: false,
          distanceFilter: distance_filter,
        },
        (location, error) => {
          if (error) {
            APIinterface.notify("red-5", error, "error_outline", $q);
          }

          console.log("LOCATION", location);
          LocationStore.coordinates = {
            lat: location.latitude,
            lng: location.longitude,
            accuracy: location.accuracy,
            altitude: location.altitude,
            altitudeAccuracy: location.altitudeAccuracy,
            speed: location.speed,
            bearing: location.bearing,
            time: location.time,
            simulated: location.simulated,
            created_at: APIinterface.getDateTimeNow(),
            driver_id: driverInfo.value.driver_id,
          };

          newPosition.value = {
            latitude: location.latitude,
            longitude: location.longitude,
          };

          if (
            !lastSentPosition.value ||
            isSignificantChange(
              newPosition.value,
              lastSentPosition.value,
              threshold_meters.value
            )
          ) {
            console.log("UPDATE LOCATION");
            location_resp.value = "update location";
            lastSentPosition.value = {
              latitude: location.latitude,
              longitude: location.longitude,
            };
            httpLocation();
            setFirebaseLocation();
          } else {
            console.log("SAME LOCATION");
            location_resp.value = "same location";
          }
        }
      ).then((watcher_id) => {
        LocationStore.has_watcher = true;
        LocationStore.watchers.push(watcher_id);
      });
    };

    async function watchLocation() {
      //console.log("watchLocation");
      let position = await Geolocation.getCurrentPosition({
        enableHighAccuracy: true,
      });
      if (position) {
        //console.log("watchLocation", position);
        LocationStore.coordinates = {
          lat: position.coords.latitude,
          lng: position.coords.longitude,
          accuracy: position.coords.accuracy,
          altitude: position.coords.altitude,
          altitudeAccuracy: position.coords.altitudeAccuracy,
          speed: position.coords.speed,
          bearing: "",
          time: position.timestamp,
          simulated: false,
          created_at: APIinterface.getDateTimeNow(),
          driver_id: driverInfo.value.driver_id,
        };
        httpLocation();
        setFirebaseLocation();
      }
    }

    const clearWatch = () => {
      Geolocation.clearWatch({ id: watchId.value })
        .then((result) => {
          console.log("result of clear is", result);
        })
        .catch((error) => {
          console.log("clearWatch error", error);
        });
    };

    const stopWacthers = () => {
      if (Object.keys(LocationStore.watchers).length > 0) {
        Object.entries(LocationStore.watchers).forEach(([key, items]) => {
          BackgroundGeolocation.removeWatcher({
            id: items,
          });
          LocationStore.watchers = [];
          LocationStore.has_watcher = false;
        });
      }
    };

    const httpLocation = async () => {
      try {
        //console.log("httpLocation");
        const options = {
          url: config.api_base_url + "/updateLocation",
          headers: { Authorization: "token " + auth.getToken() },
          params: {
            latitude: String(LocationStore.coordinates.lat),
            longitude: String(LocationStore.coordinates.lng),
            accuracy: String(LocationStore.coordinates.accuracy),
            altitude: String(LocationStore.coordinates.altitude),
            altitudeAccuracy: String(
              LocationStore.coordinates.altitudeAccuracy
            ),
            speed: String(LocationStore.coordinates.speed),
            bearing: String(LocationStore.coordinates.bearing),
            time: String(LocationStore.coordinates.time),
            simulated: String(LocationStore.coordinates.simulated),
          },
        };
        let HttpResponse = await CapacitorHttp.get(options);
      } catch (err) {
        console.log(err);
      }
    };

    const setFirebaseLocation = async () => {
      console.debug("setFirebaseLocation", driverInfo.value);
      const docRef = doc(
        firebaseDb,
        firebaseCollectionEnum.driver,
        driverInfo.value.driver_uuid
      );
      await setDoc(docRef, LocationStore.coordinates);
    };

    const createFirebaseLocationLogs = async () => {
      console.debug("createFirebaseLocationLogs");
      let $date_now = APIinterface.getDateNow();
      const docRef = await addDoc(
        collection(
          firebaseDb,
          firebaseCollectionEnum.driver_logs,
          driverInfo.value.driver_uuid,
          $date_now
        ),
        LocationStore.coordinates
      );
    };

    const getRealtimeLocation = async () => {
      console.log("getRealtimeLocation");
    };

    return {
      clearWatch,
      stopWacthers,
      LocationStore,
      location_resp,
      distance_resp,
      threshold_meters,
    };
  },
};
</script>
