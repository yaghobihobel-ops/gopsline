import { BleClient, numberToUUID } from "@capacitor-community/bluetooth-le";

const AppBluetooth = {
  async initConnect($q) {
    let is_android = $q.platform.is.android;
    let connectionPromise = new Promise(async function (resolve, reject) {
      if (is_android) {
        const isLocationEnabled = await BleClient.isLocationEnabled();
        if (!isLocationEnabled) {
          await BleClient.openLocationSettings();
        }
      }
      await BleClient.initialize();
      let is_enabled = await BleClient.isEnabled();
      if (!is_enabled) {
        await BleClient.requestEnable();
      }
      resolve(true);
    });
    return await connectionPromise;
  },
  async Scan() {
    let scanPromise = new Promise(async function (resolve, reject) {
      let device_list = [];
      await BleClient.requestLEScan({}, (result) => {
        console.log("received new scan result", JSON.stringify(result));
        if (result.localName) {
          device_list.push({
            name: result.localName,
            device_id: result.device.deviceId,
            service_id: result.uuids[0] ? result.uuids[0] : "",
          });
        }
      });
      setTimeout(() => {
        BleClient.stopLEScan().then(() => {
          if (Object.keys(device_list).length > 0) {
            resolve(device_list);
          } else {
            reject("No results");
          }
        });
      }, 2000);
    });
    return await scanPromise;
  },
  async StopScan() {
    await BleClient.stopLEScan();
  },
  startsWith0000(str) {
    return str.startsWith("0000");
  },
  async getCharacteristic(device_id) {
    let getDetails = new Promise(async function (resolve, reject) {
      await BleClient.disconnect(device_id);

      BleClient.connect(device_id)
        .then(async () => {
          let characteristic_list = [];
          let default_characteristic = "";
          let services_list = await BleClient.getServices(device_id);
          if (Object.keys(services_list).length > 0) {
            services_list.forEach((service) => {
              service.characteristics.forEach(async (items) => {
                try {
                  if (items.properties.write === true) {
                    console.log(
                      "Characteristic UUID:",
                      JSON.stringify(items.properties)
                    );
                    characteristic_list.push(items.uuid);
                    if (AppBluetooth.startsWith0000(items.uuid)) {
                      default_characteristic = items.uuid;
                    }
                  }
                } catch (error) {
                  AppBluetooth.disConnect(device_id);
                  reject(error.message);
                }
              });
            });
            AppBluetooth.disConnect(device_id);
            resolve({
              default: default_characteristic,
              list: characteristic_list,
            });
          } else {
            AppBluetooth.disConnect(device_id);
            reject("No results");
          }
          //
        })
        .catch((error) => {
          AppBluetooth.disConnect(device_id);
          reject(error.message);
        });
    });
    return await getDetails;
  },
  async disConnect(device_id) {
    try {
      setTimeout(async () => {
        await BleClient.disconnect(device_id);
      }, 100);
    } catch (error) {}
  },
  async Print(data, device_id, service_id, characteristics) {
    let printResults = new Promise(async function (resolve, reject) {
      await BleClient.disconnect(device_id);
      BleClient.connect(device_id)
        .then(async () => {
          await BleClient.write(
            device_id,
            service_id,
            characteristics,
            data,
            5000
          );
          AppBluetooth.disConnect(device_id);
          resolve(true);
        })
        .catch((error) => {
          AppBluetooth.disConnect(device_id);
          reject(error.message);
        });
    });
    return await printResults;
  },
};
export default AppBluetooth;
