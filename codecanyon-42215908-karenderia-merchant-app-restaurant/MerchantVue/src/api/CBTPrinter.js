let countConnect = 0;
const CBTPrinter = {
  async ConnectToPrinter(printerName) {
    try {
      return await new Promise(function (resolve, reject) {
        BTPrinter.connect(
          (result) => {
            countConnect = 0;
            console.log("CONNECTED => " + countConnect);
            resolve(true);
          },
          (error) => {
            console.log("ERROR => ", error);
            reject(error);
          },
          printerName
        );
      });
    } catch (error) {
      if (countConnect <= 0) {
        countConnect++;
        return ConnectToPrinter.ConnectToPrinter(printerName); // Retry once
      } else {
        throw error; // After one retry, throw the error
      }
    }
  },
  async DisconnectToPrinter(printerName) {
    return await new Promise(function (resolve, reject) {
      setTimeout(function () {
        BTPrinter.disconnect(
          (result) => {
            console.log("disconnect");
            resolve(true);
          },
          (error) => {
            reject(error);
          },
          printerName
        );
      }, 1500);
    });
  },
  async printPOSCommand(escPosCommand) {
    return await new Promise(function (resolve, reject) {
      BTPrinter.printPOSCommand(
        (result) => {
          resolve(true);
        },
        (error) => {
          reject(error);
        },
        escPosCommand
      );
    });
  },
  async printText(Text) {
    return await new Promise(function (resolve, reject) {
      BTPrinter.printText(
        (result) => {
          resolve(true);
        },
        (error) => {
          reject(error);
        },
        Text
      );
    });
  },
  async printBase64(base64Image, align) {
    return await new Promise(function (resolve, reject) {
      BTPrinter.printBase64(
        function (data) {
          resolve(true);
        },
        function (error) {
          reject(error);
        },
        base64Image,
        align
      );
    });
  },
  async isConnected() {
    return await new Promise(function (resolve, reject) {
      BTPrinter.connected(
        function (data) {
          if (data) {
            resolve(true);
          } else {
            reject(err);
          }
        },
        function (err) {
          reject(err);
        }
      );
    });
  },
};
export default CBTPrinter;
