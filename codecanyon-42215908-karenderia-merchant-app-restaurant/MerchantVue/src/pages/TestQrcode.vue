<template>
  <q-page padding>
    <div class="q-gutter-md">
      <q-btn label="StartSCan" color="primary" @click="StartSCan"></q-btn>
    </div>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import {
  BarcodeScanner,
  BarcodeFormat,
} from "@capacitor-mlkit/barcode-scanning";

export default {
  name: "TestQrcode",

  data() {
    return {
      data: [],
    };
  },
  methods: {
    async StartSCan() {
      try {
        const supported = await BarcodeScanner.isSupported();
        //alert(JSON.stringify(supported));
        if (supported) {
          this.requestPermission();
        } else {
          alert("Not supported");
        }
      } catch (err) {
        alert(JSON.stringify(err));
      }
    },
    async requestPermission() {
      const result = await BarcodeScanner.requestPermissions();
      //alert(JSON.stringify(result));
      alert(result.camera);
      if (result.camera == "granted" || result.camera == "limited") {
        this.isGoogleBarcodeScannerModuleAvailable();
      } else {
        alert("Permission denied");
      }
    },
    async isGoogleBarcodeScannerModuleAvailable() {
      const result =
        await BarcodeScanner.isGoogleBarcodeScannerModuleAvailable();
      alert(JSON.stringify(result));
      if (result.available) {
        alert("Available");
        this.okScan();
      } else {
        alert("Not Available");
        this.installGoogleBarcodeScannerModule();
      }
    },
    async installGoogleBarcodeScannerModule() {
      alert("install");
      const result = await BarcodeScanner.installGoogleBarcodeScannerModule();
      alert(JSON.stringify(result));
    },
    async okScan() {
      try {
        alert("okScan");
        const barcodes = await BarcodeScanner.scan();
        alert(JSON.stringify(barcodes));
      } catch (err) {
        alert(JSON.stringify(err));
      }
    },
  },
};
</script>
