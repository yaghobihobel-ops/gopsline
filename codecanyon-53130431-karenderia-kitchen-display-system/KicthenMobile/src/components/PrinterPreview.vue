<template>
  <div class="canvas-container hidden">
    <canvas
      class="receiptCanvas border"
      ref="receiptCanvas"
      height="100"
    ></canvas>
  </div>
</template>

<script>
import AppBluetooth from "src/api/AppBluetooth";
import ThermalPrinterFormatter from "src/api/ThermalPrinterFormatter";
import CBTPrinter from "src/api/CBTPrinter";
import APIinterface from "src/api/APIinterface";

export default {
  name: "PrinterPreview",
  setup() {
    return {};
  },
  data() {
    return {
      print_data: [],
      baseImage: null,
      printer_bt_name: null,
      device_id: null,
      service_id: null,
      characteristic: null,
      auto_close: false,
    };
  },
  methods: {
    sleep(ms) {
      return new Promise((resolve) => setTimeout(resolve, ms));
    },
    async print(data) {
      if (this.$q.capacitor) {
        AppBluetooth.initConnect(this.$q)
          .then((response) => {
            console.log("CONNECTED =>", response);
            this.doPrint(data);
          })
          .catch((error) => {
            console.log("error", error);
            APIinterface.notify(
              this.$q,
              this.$t("Error"),
              error,
              "myerror",
              "highlight_off",
              "bottom"
            );
          })
          .then((data) => {});
      } else {
        APIinterface.notify(
          this.$q,
          this.$t("Error"),
          this.$t(
            "Bluetooth printing is not supported in the web version. Please use the mobile device."
          ),
          "myerror",
          "highlight_off",
          "bottom"
        );
      }
    },
    async doPrint(data) {
      APIinterface.showLoadingBox(this.$t("Printing..."), this.$q);
      this.print_data = data;
      let error_message = null;

      this.printer_bt_name = this.print_data.data.settings.printer_bt_name;

      this.device_id = this.print_data.data.settings.device_id;
      this.service_id = this.print_data.data.settings.service_id;
      this.characteristic = this.print_data.data.settings.characteristics;
      this.auto_close = this.print_data.data.settings.auto_close;

      let results = ThermalPrinterFormatter.Print(
        this.print_data.data.settings,
        this.print_data.data.header,
        this.print_data.data.body,
        this.print_data.data.footer,
        this.$refs.receiptCanvas
      );

      if (this.print_data.data.settings.print_type == "image") {
        this.baseImage = results;

        try {
          await CBTPrinter.ConnectToPrinter(this.printer_bt_name);
          this.loading_print = false;
          await CBTPrinter.printPOSCommand("0A");
          await CBTPrinter.printPOSCommand("1B6100");
          const printResults = await CBTPrinter.printBase64(this.baseImage, 0);

          APIinterface.hideLoadingBox(this.$q);
          APIinterface.notify(
            this.$q,
            this.$t("Print"),
            this.$t("Printing Successful"),
            "mysuccess",
            "highlight_off",
            "bottom"
          );
          if (this.auto_close) {
            this.disConnect();
          }
        } catch (err) {
          APIinterface.hideLoadingBox(this.$q);
          APIinterface.notify(
            this.$q,
            this.$t("Error"),
            err.message,
            "myerror",
            "highlight_off",
            "bottom"
          );
        }
      } else {
        if (Object.keys(results).length > 0) {
          for (const [key, items] of Object.entries(results)) {
            console.log("items to print", JSON.stringify(items));
            AppBluetooth.Print(
              items,
              this.device_id,
              this.service_id,
              this.characteristic
            )
              .then((response) => {})
              .catch((error) => {
                error_message += error;
              })
              .then((data) => {});

            await this.sleep(1000);
          }
        }

        APIinterface.hideLoadingBox(this.$q);

        if (error_message) {
          APIinterface.notify(
            this.$q,
            this.$t("Error"),
            error_message,
            "myerror",
            "highlight_off",
            "bottom"
          );
        } else {
          APIinterface.notify(
            this.$q,
            this.$t("Print"),
            this.$t("Printing Successful"),
            "mysuccess",
            "highlight_off",
            "bottom"
          );
        }
      }
    },
    disConnect() {
      CBTPrinter.DisconnectToPrinter(this.device_name)
        .then((data) => {})
        .catch((error) => {
          APIinterface.notify(
            this.$q,
            this.$t("Error"),
            error,
            "myerror",
            "highlight_off",
            "bottom"
          );
        })
        .then((data) => {});
    },
  },
};
</script>
