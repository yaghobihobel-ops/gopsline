import APIinterface from "./APIinterface";
import { Network } from "@capacitor/network";

const AppBluetooth = {
  async Enabled() {
    let accuracyPromise = new Promise(function (resolve, reject) {
      bluetoothle.isInitialized(function (data) {
        //alert(JSON.stringify(data));
        if (data.isInitialized == true) {
          bluetoothle.isEnabled(function (data) {
            console.log(JSON.stringify(data));
            if (data.isEnabled == true) {
              resolve(true);
            } else {
              bluetoothle.enable(
                function (data) {
                  console.log(JSON.stringify(data));
                  resolve(true);
                },
                function (error) {
                  reject(error);
                }
              );
            }
          });
        } else {
          bluetoothle.initialize(
            function (data) {
              if (data.status == "enabled") {
                resolve(true);
              } else {
                bluetoothle.enable(
                  function (data) {
                    console.log(JSON.stringify(data));
                    resolve(true);
                  },
                  function (error) {
                    reject(error);
                  }
                );
              }
            },
            {
              request: true,
              statusReceiver: false,
              restoreKey: "bluetoothleplugin",
            }
          );
        }
      });

      Network.addListener("networkStatusChange", (status) => {
        if (status.connected == true) {
          resolve(true);
        }
      });
    });
    return await accuracyPromise;
  },
  async CheckLocation() {
    let locationResult = new Promise(function (resolve, reject) {
      bluetoothle.hasPermission(function (result) {
        console.log(JSON.stringify(result));
        if (result.hasPermission == true) {
          resolve(true);
        } else {
          bluetoothle.requestPermission(
            function (result) {
              console.log(JSON.stringify(result));
              if (result.requestPermission == true) {
                console.log("successful");
                resolve(true);
              } else {
                reject("Failed to enabled location");
              }
            },
            function (eror) {
              console.log(JSON.stringify(eror));
              reject(error);
            }
          );
        }
      });
    });
    return await locationResult;
  },
  async CheckLocationOnly() {
    let locationResult = new Promise(function (resolve, reject) {
      bluetoothle.hasPermission(function (result) {
        console.log(JSON.stringify(result));
        if (result.hasPermission == true) {
          resolve(true);
        } else {
          reject(false);
        }
      });
    });
    return await locationResult;
  },
  async checkLocationEnabled() {
    let locationResult = new Promise(function (resolve, reject) {
      bluetoothle.isLocationEnabled(function (result) {
        console.log(JSON.stringify(result));
        if (result.isLocationEnabled == true) {
          resolve(true);
        } else {
          bluetoothle.requestLocation(
            function (result) {
              if (result.requestLocation == true) {
                resolve(true);
              } else {
                reject(false);
              }
            },
            function (error) {
              console.log(JSON.stringify(eror));
              reject(error);
            }
          );
        }
      });
    });
    return await locationResult;
  },
  async CheckBTScanPermission() {
    let locationResult = new Promise(function (resolve, reject) {
      bluetoothle.hasPermissionBtScan(function (result) {
        console.log(JSON.stringify(result));
        if (result.hasPermission == true) {
          resolve(true);
        } else {
          bluetoothle.requestPermissionBtScan(
            function (result) {
              console.log(JSON.stringify(result));
              if (result.requestPermission == true) {
                console.log("successful");
                resolve(true);
              } else {
                reject("Failed location");
              }
            },
            function (eror) {
              console.log(JSON.stringify(eror));
              reject(error);
            }
          );
        }
      });
    });
    return await locationResult;
  },
  async CheckPeripheral() {
    let locationResult = new Promise(function (resolve, reject) {
      bluetoothle.initializePeripheral(
        function (result) {
          console.log(JSON.stringify(result));
          if (result.status == "enabled") {
            resolve(true);
          }
        },
        function (error) {
          console.log(JSON.stringify(error));
          reject(error);
        },
        {
          request: true,
          restoreKey: "bluetoothleplugin",
        }
      );
    });
    return await locationResult;
  },
  async CheckBTConnectPermission() {
    let locationResult = new Promise(function (resolve, reject) {
      bluetoothle.hasPermissionBtConnect(function (result) {
        console.log(JSON.stringify(result));
        if (result.hasPermission == true) {
          resolve(true);
        } else {
          bluetoothle.requestPermissionBtConnect(
            function (result) {
              console.log(JSON.stringify(result));
              if (result.requestPermission == true) {
                console.log("successful");
                resolve(true);
              } else {
                reject("Failed location");
              }
            },
            function (eror) {
              console.log(JSON.stringify(eror));
              reject(error);
            }
          );
        }
      });
    });
    return await locationResult;
  },
  async CheckBTConnectPermissionOnly() {
    let locationResult = new Promise(function (resolve, reject) {
      bluetoothle.hasPermissionBtConnect(function (result) {
        console.log(JSON.stringify(result));
        if (result.hasPermission == true) {
          resolve(true);
        } else {
          reject(false);
        }
      });
    });
    return await locationResult;
  },
  async Scan() {
    let $data = [];
    let scanResult = new Promise(function (resolve, reject) {
      console.log("STAR SCAN");
      let $scanOptions = {
        services: [],
        allowDuplicates: false,
        scanMode: bluetoothle.SCAN_MODE_LOW_LATENCY,
        matchMode: bluetoothle.MATCH_MODE_AGGRESSIVE,
        matchNum: bluetoothle.MATCH_NUM_MAX_ADVERTISEMENT,
        callbackType: bluetoothle.CALLBACK_TYPE_ALL_MATCHES,
      };
      bluetoothle.startScan(
        function (result) {
          //console.log(JSON.stringify(result));
          if (result.status === "scanStarted") {
          } else if (result.status === "scanResult") {
            //console.log(JSON.stringify(result));
            if (typeof result.name !== "undefined" && result.name !== null) {
              // if (result.rssi <= -30) {
              //   $data.push(result);
              // }
              if (
                !$data.some(function (device) {
                  return device.address === result.address;
                })
              ) {
                $data.push(result);
              }
            }
          }
        },
        function (eror) {
          console.log(JSON.stringify(eror));
        },
        $scanOptions
      );

      //
      setTimeout(() => {
        bluetoothle.stopScan(
          function (result) {
            if (result.status == "scanStopped") {
              resolve($data);
            }
          },
          function (error) {
            resolve(true);
          }
        );
      }, 10000); //30000
    });
    return await scanResult;
  },
  async StopScan() {
    let scanResult = new Promise(function (resolve, reject) {
      bluetoothle.stopScan(
        function (result) {
          if (result.status == "scanStopped") {
            resolve(result);
          }
        },
        function (error) {
          reject(error);
        }
      );
    });
    return await scanResult;
  },
  async retrieveDevice() {
    let scanResult = new Promise(function (resolve, reject) {
      bluetoothle.retrieveConnected(
        function (result) {
          resolve(result);
        },
        function (error) {
          reject(error);
        }
      );
    });
    return await scanResult;
  },
  async Bond(deviceAddress) {
    let scanResult = new Promise(function (resolve, reject) {
      bluetoothle.bond(
        function (result) {
          resolve(result);
        },
        function (error) {
          console.log("BOND ERROR==>");
          console.log(JSON.stringify(error));
          if (error.message == "Device already bonded") {
            resolve(true);
          } else {
            reject(error.message);
          }
        },
        {
          address: deviceAddress,
        }
      );
    });
    return await scanResult;
  },
  async Connect(deviceAddress, printerModel) {
    let scanResult = new Promise(function (resolve, reject) {
      console.log("CONNECTING..==>");
      if (printerModel == "sunmi") {
        ble.isConnected(
          deviceAddress,
          (result) => {
            console.log("CONNECTED SUCCESFUL ==>");
            console.log(JSON.stringify(result));
            ble.disconnect(
              deviceAddress,
              (result) => {
                console.log("DISCONNECT SUCCESFUL ==>");
                console.log(JSON.stringify(result));

                setTimeout(() => {
                  ble.connect(
                    deviceAddress,
                    function (result) {
                      console.log("CONNECT SUCCESS==>");
                      console.log(JSON.stringify(result));
                      resolve(true);
                    },
                    function (error) {
                      console.log("CONNECT 1 ERROR==>");
                      console.log(JSON.stringify(error));
                      resolve(true);
                    }
                  );
                }, 1);
              },
              (error) => {
                console.log("DISCONNECT 2 ERROR ==>");
                console.log(JSON.stringify(error));
                reject(error.errorMessage);
              }
            );
          },
          (error) => {
            console.log("CONNECTED ERROR ==>");
            console.log(JSON.stringify(error));
            ble.connect(
              deviceAddress,
              function (result) {
                console.log("CONNECT SUCCESS==>");
                console.log(JSON.stringify(result));
                resolve(true);
              },
              function (error) {
                console.log("CONNECT 3 ERROR==>");
                console.log(JSON.stringify(error));
                //reject(error.errorMessage);
                resolve(true);
              }
            );
          }
        );
        /// bluetooth ble
      } else {
        ble.isConnected(
          deviceAddress,
          function (result) {
            console.log("isConnected SUCCESS==>");
            console.log(JSON.stringify(result));
            resolve(true);
          },
          function (error) {
            console.log("isConnected ERROR==>");
            ble.connect(
              deviceAddress,
              function (result) {
                console.log("CONNECT SUCCESS==>");
                console.log(JSON.stringify(result));
                resolve(true);
              },
              function (error) {
                console.log("CONNECT 1 ERROR==>");
                console.log(JSON.stringify(error));
                reject(error.errorMessage);
              }
            );
          }
        );
      }
    });
    return await scanResult;
  },

  async Print(
    deviceAddress,
    printData,
    printerModel,
    printerServiceID,
    printerCharacteristic
  ) {
    let service_uuid = "";
    let characteristic_uuid = "";
    if (!APIinterface.empty(printerServiceID)) {
      service_uuid = printerServiceID;
      characteristic_uuid = printerCharacteristic;
    } else {
      service_uuid = printerModel == "bluetooth" ? "18f0" : "1101";
      characteristic_uuid = printerModel == "bluetooth" ? "2af1" : "1101";
    }

    const encodedString = bluetoothle.encodeUnicode(printData);
    const chunkSize = 20; // BLE limit
    const delay = 100; // milliseconds

    const totalChunks = Math.ceil(encodedString.length / chunkSize);
    console.log(`Total chunks to send: ${totalChunks}`);

    function sendChunk(index) {
      return new Promise((resolve, reject) => {
        if (index >= totalChunks) {
          return resolve(true); // All chunks sent
        }

        const chunk = encodedString.slice(
          index * chunkSize,
          (index + 1) * chunkSize
        );

        ble.write(
          deviceAddress,
          service_uuid,
          characteristic_uuid,
          chunk,
          () => {
            setTimeout(() => {
              sendChunk(index + 1)
                .then(resolve)
                .catch(reject);
            }, delay);
          },
          (error) => {
            console.log("PRINT ERROR==>");
            console.log(JSON.stringify(error));
            if (printerModel == "bluetooth") {
              reject(error.errorMessage);
            } else {
              // For Sunmi, resolve to avoid breaking
              resolve(true);
            }
          }
        );
      });
    }

    try {
      console.log("INIT PRINTING..==>");
      await sendChunk(0);
      console.log("PRINT SUCCESS==>");
      return true;
    } catch (err) {
      console.error("PRINT FAILED:", err);
      throw err;
    }
  },

  async GetServices(deviceAddress) {
    let locationResult = new Promise(function (resolve, reject) {
      ble.isConnected(
        deviceAddress,
        function (result) {
          console.log("IS CONNECTED==>");
          console.log(JSON.stringify(result));
          ble.disconnect(
            deviceAddress,
            (result) => {
              console.log("DISCONNECT SUCCESFUL==>");
              console.log(JSON.stringify(result));
              //
              setTimeout(() => {
                ble.connect(
                  deviceAddress,
                  function (result) {
                    console.log("CONNECT 1 SUCCESS==>");
                    console.log(JSON.stringify(result));
                    resolve(result);
                  },
                  function (error) {
                    console.log("CONNECT 1  ERROR==>");
                    console.log(JSON.stringify(error));
                    reject(error);
                  }
                );
              }, 1);
              //
            },
            (error) => {
              reject(error);
            }
          );
        },
        function (error) {
          console.log("GET SERVICES ERROR==>");
          console.log(JSON.stringify(error));
          //
          setTimeout(() => {
            ble.connect(
              deviceAddress,
              function (result) {
                console.log("CONNECT SUCCESS==>");
                console.log(JSON.stringify(result));
                resolve(result);
              },
              function (error) {
                console.log("CONNECT  ERROR==>");
                console.log(JSON.stringify(error));
                reject(error.errorMessage);
              }
            );
          }, 1);
          //
        }
      );
    });
    return await locationResult;
  },
  async Disconnect(deviceAddress) {
    let locationResult = new Promise(function (resolve, reject) {
      ble.disconnect(
        deviceAddress,
        (result) => {
          console.log("DISCONNECT SUCCESSFUL==>");
        },
        (error) => {
          console.log("DISCONNECT failed==>");
        }
      );
    });
    return await locationResult;
  },
  //
};
export default AppBluetooth;
