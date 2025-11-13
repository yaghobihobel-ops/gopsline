<template>
  <q-btn
    color="grey"
    text-color="white"
    no-caps
    icon="qr_code_scanner"
    class="radius8"
    dense
    unelevated
    @click="scanQrcode"
  />
</template>

<script>
// import {
//   BarcodeScanner,
//   BarcodeFormat,
// } from "@capacitor-mlkit/barcode-scanning";
import APIinterface from "src/api/APIinterface";

export default {
  name: "QrcodeScanner",
  data() {
    return {
      qrcode_value: "",
    };
  },
  mounted() {},
  methods: {
    async scanQrcode() {
      try {
        const supported = await BarcodeScanner.isSupported();
        if (supported) {
          this.requestPermission();
        } else {
          APIinterface.notify(
            "dark",
            this.$t("Device does not support qrcode scanner"),
            "error",
            this.$q
          );
        }
      } catch (error) {
        APIinterface.notify("dark", error, "error", this.$q);
      }
    },
    async requestPermission() {
      const result = await BarcodeScanner.requestPermissions();
      if (result.camera == "granted" || result.camera == "limited") {
        if (this.$q.platform.is.ios) {
          this.startScan();
        } else {
          this.isGoogleBarcodeScannerModuleAvailable();
        }
      } else {
        APIinterface.notify("dark", JSON.stringify(result), "error", this.$q);
      }
    },
    async isGoogleBarcodeScannerModuleAvailable() {
      const result =
        await BarcodeScanner.isGoogleBarcodeScannerModuleAvailable();
      if (result.available) {
        this.startScan();
      } else {
        this.installGoogleBarcodeScannerModule();
      }
    },
    async installGoogleBarcodeScannerModule() {
      const result = await BarcodeScanner.installGoogleBarcodeScannerModule();
      setTimeout(() => {
        this.isGoogleBarcodeScannerModuleAvailable();
      }, 300); // 1 sec delay
    },
    async startScan() {
      try {
        const results = await BarcodeScanner.scan();
        console.log(results);
        console.log("QRCODE ", results.barcodes[0].displayValue);
        this.qrcode_value = results.barcodes[0].displayValue;
        setTimeout(() => {
          this.$emit("afterScan", this.qrcode_value);
        }, 300);
      } catch (err) {
        console.log("ERROR=>>>>", err);
        if (err != "Error: scan canceled.") {
          APIinterface.notify("dark", err, "error", this.$q);
        }
      }
    },
  },
};
</script>
