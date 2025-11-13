<template>
  <div v-if="dialog" class="canvas-container hidden">
    <canvas
      class="receiptCanvas"
      ref="receiptCanvas"
      :width="getPaperWidth"
      height="100"
    ></canvas>
  </div>
</template>

<script>
import { useDataStore } from "stores/DataStore";
import PrintTemplate from "src/api/PrintTemplate";
import APIinterface from "src/api/APIinterface";
import CBTPrinter from "src/api/CBTPrinter";

export default {
  name: " PrintPreviewCanvas",
  props: [
    "printer_details",
    "order_info",
    "merchant",
    "order_items",
    "order_summary",
    "order_services",
    "site_data",
  ],
  data() {
    return {
      dialog: false,
      //paper_width: 400,
      data_info: [],
      data_items: [],
      data_summary: [],
      baseImage: "",
      auto_print: false,
    };
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  computed: {
    getPaperWidth() {
      if (this.printer_details.paper_width == "80") {
        return this.DataStore.printer_paper_width_80;
      }
      return this.DataStore.printer_paper_width_56;
    },
  },
  methods: {
    PaperWidth() {
      if (this.printer_details.paper_width == "80") {
        return this.DataStore.printer_paper_width_80;
      }
      return this.DataStore.printer_paper_width_56;
    },
    showDialog(data, auto) {
      if (data) {
        setTimeout(() => {
          this.initData();
        }, 100); // 1 sec delay
      }
      this.auto_print = true;
      this.dialog = data;
    },
    async initData() {
      this.data_info = [];
      this.data_items = [];
      this.data_summary = [];

      let itemHeight = 25;
      let itemCount = 0;
      let canvas = this.$refs.receiptCanvas;
      let context = canvas.getContext("2d");
      context.clearRect(0, 0, canvas.width, canvas.height);

      let maxLineWidth = this.PaperWidth();
      //maxLineWidth = maxLineWidth == 585 ? 398 : 498;
      maxLineWidth = maxLineWidth == 585 ? 395 : 498;
      console.log("maxLineWidth=>" + maxLineWidth);

      let lines = PrintTemplate.countText(
        context,
        this.merchant.restaurant_name,
        maxLineWidth
      );
      itemCount += lines.length;

      lines = PrintTemplate.countText(
        context,
        this.merchant.address,
        maxLineWidth
      );
      itemCount += lines.length;

      // START ORDER INFO
      this.data_info.push({
        label: this.$t("Order ID"),
        value: this.order_info.order_id,
      });
      this.data_info.push({
        label: this.$t("Customer Name"),
        value: this.order_info.customer_name,
      });
      this.data_info.push({
        label: this.$t("Email"),
        value: this.order_info.contact_email,
      });
      this.data_info.push({
        label: this.$t("Phone"),
        value: this.order_info.contact_number,
      });

      if (this.order_info.order_type == "delivery") {
        this.data_info.push({
          label: this.$t("Address"),
          value:
            this.order_info.address1 + " " + this.order_info.delivery_address,
        });
        this.data_info.push({
          label: this.$t("Address label"),
          value: this.order_info.address_label,
        });
        itemCount += 2;
      }

      this.data_info.push({
        label: this.$t("Order Type"),
        value: !APIinterface.empty(this.order_services)
          ? this.order_services.service_name
          : this.order_info.order_type,
      });

      this.data_info.push({
        label: this.$t("Delivery Date/Time"),
        value:
          this.order_info.whento_deliver == "now"
            ? this.order_info.schedule_at
            : this.order_info.delivery_date +
              " " +
              this.order_info.delivery_time,
      });

      if (!APIinterface.empty(this.merchant.merchant_tax_number)) {
        this.data_info.push({
          label: this.$t("Tax number"),
          value: this.merchant.merchant_tax_number,
        });
        itemCount++;
      }

      itemCount += 17;

      lines = PrintTemplate.countText(
        context,
        this.order_info.payment_name,
        maxLineWidth
      );
      itemCount += lines.length;

      if (this.order_info.payment_change > 0) {
        itemCount++;
      }

      // END ORDER INFO

      // ITEMS
      this.data_items = [];

      if (Object.keys(this.order_items).length > 0) {
        Object.entries(this.order_items).forEach(([key, items]) => {
          let size_name =
            items.price.size_name != ""
              ? "(" + items.price.size_name + ")"
              : "";
          this.data_items.push({
            label: items.qty + " x " + items.item_name + size_name,
            value:
              items.price.discount > 0
                ? items.price.pretty_total_after_discount
                : items.price.pretty_total,
          });
          //itemCount++;

          this.data_items.push({
            label: items.category_name,
            value: "",
          });
          //itemCount++;

          if (items.special_instructions != "") {
            this.data_items.push({
              label: items.special_instructions,
              value: "",
            });
            //itemCount++;
          }

          if (items.attributes != "") {
            if (Object.keys(items.attributes).length > 0) {
              Object.entries(items.attributes).forEach(([key1, attributes]) => {
                Object.entries(attributes).forEach(
                  ([key2, attributes_data]) => {
                    this.data_items.push({
                      label: attributes_data,
                      value: "",
                    });
                    //itemCount++;
                  }
                );
              });
            }
          }

          // addons
          if (Object.keys(items.addons).length > 0) {
            Object.entries(items.addons).forEach(([key, addons]) => {
              this.data_items.push({
                label: addons.subcategory_name,
                value: "",
              });
              //itemCount++;
              Object.entries(addons.addon_items).forEach(
                ([key1, addon_items]) => {
                  this.data_items.push({
                    label:
                      addon_items.qty +
                      " x " +
                      addon_items.pretty_price +
                      " " +
                      addon_items.sub_item_name,
                    value: addon_items.pretty_addons_total,
                  });
                }
              );

              //
            });
          }
          // end addons

          //
        });
      }
      //end items

      // SUMMARY
      if (Object.keys(this.order_summary).length > 0) {
        Object.entries(this.order_summary).forEach(([key, summary]) => {
          this.data_summary.push({
            label: summary.name,
            value: summary.value,
          });
          //itemCount++;
        });
      }
      // SUMMARY

      itemCount++;
      lines = PrintTemplate.countText(
        context,
        "Thank you for your order",
        maxLineWidth
      );
      itemCount += lines.length;

      lines = PrintTemplate.countText(
        context,
        "Please visit us again.",
        maxLineWidth
      );
      itemCount += lines.length;

      // COUNT TABLE DATA
      let lineCountY = itemHeight;
      let count_data = 0;

      count_data = await PrintTemplate.TableColumnCount(
        context,
        this.data_items,
        maxLineWidth,
        lineCountY,
        itemHeight
      );
      console.log("items count_data =>" + count_data);
      itemCount += count_data + 2;

      count_data = await PrintTemplate.TableColumnCount(
        context,
        this.data_summary,
        maxLineWidth,
        lineCountY,
        itemHeight
      );
      console.log("data_summary count_data =>" + count_data);
      itemCount += count_data + 11;

      console.log("itemCount=>" + itemCount);
      let canvasHeight = itemHeight * itemCount;
      canvas.height = canvasHeight;

      // START CANVAS
      let data_lenght;

      context.fillStyle = "#ffffff";
      context.fillRect(0, 0, canvas.width, canvas.height);
      context.strokeStyle = "#000000";
      context.lineWidth = 1;
      context.fillStyle = "#000000";
      context.font = "700 32px Arial";

      let lineY = itemHeight;

      PrintTemplate.centerText(
        context,
        this.site_data.title,
        lineY,
        maxLineWidth,
        itemHeight
      );
      lineY += itemHeight + 10;

      PrintTemplate.centerText(
        context,
        "#" + this.order_info.order_id,
        lineY,
        maxLineWidth,
        itemHeight
      );
      lineY += itemHeight;
      lineY += 50;

      context.font = "400 24px Arial";

      PrintTemplate.centerText(
        context,
        this.merchant.restaurant_name,
        lineY,
        maxLineWidth,
        itemHeight
      );
      lineY += itemHeight;

      let merchantAddressLine = PrintTemplate.centerText(
        context,
        this.merchant.address,
        lineY,
        maxLineWidth,
        itemHeight
      );
      for (let i = 0; i < merchantAddressLine.length; i++) {
        lineY += itemHeight;
      }

      if (!APIinterface.empty(this.merchant.merchant_tax_number)) {
        PrintTemplate.centerText(
          context,
          this.merchant.merchant_tax_number,
          lineY,
          maxLineWidth,
          itemHeight
        );
        lineY += itemHeight;
      }

      PrintTemplate.centerText(
        context,
        this.order_info.place_datetime,
        lineY,
        maxLineWidth,
        itemHeight
      );
      lineY += itemHeight;

      PrintTemplate.drawLine(context, maxLineWidth, lineY);
      lineY += itemHeight + 20;

      PrintTemplate.centerText(
        context,
        this.$t("Customer:"),
        lineY,
        maxLineWidth,
        itemHeight
      );
      lineY += itemHeight;

      PrintTemplate.centerText(
        context,
        this.order_info.customer_name,
        lineY,
        maxLineWidth,
        itemHeight
      );
      lineY += itemHeight;

      PrintTemplate.centerText(
        context,
        this.order_info.contact_number,
        lineY,
        maxLineWidth,
        itemHeight
      );
      lineY += itemHeight + 20;

      if (this.order_info.order_type == "delivery") {
        PrintTemplate.centerText(
          context,
          this.$t("Customer address:"),
          lineY,
          maxLineWidth,
          itemHeight
        );
        lineY += itemHeight;

        let results = PrintTemplate.centerText(
          context,
          this.order_info.complete_delivery_address
            ? this.order_info.complete_delivery_address
            : this.order_info.address1 + " " + this.order_info.delivery_address,
          lineY,
          maxLineWidth,
          itemHeight
        );
        for (let i = 0; i < results.length; i++) {
          lineY += itemHeight;
        }
        lineY += itemHeight;
      }

      context.font = "500 25px Arial";

      PrintTemplate.centerText2(
        context,
        this.order_info.payment_status1,
        lineY,
        maxLineWidth,
        itemHeight
      );
      lineY += itemHeight + 20;

      PrintTemplate.centerText2(
        context,
        this.order_info.payment_name,
        lineY,
        maxLineWidth,
        itemHeight
      );
      lineY += itemHeight + 20;

      PrintTemplate.centerText2(
        context,
        this.order_info.order_type1,
        lineY,
        maxLineWidth,
        itemHeight
      );
      lineY += itemHeight + 30;

      context.font = "400 24px Arial";

      PrintTemplate.centerText(
        context,
        this.$t("Delivery of pickup time:"),
        lineY,
        maxLineWidth,
        itemHeight
      );
      lineY += itemHeight;

      let deliveryTime =
        this.order_info.whento_deliver == "now"
          ? this.order_info.schedule_at
          : this.order_info.delivery_time1;
      PrintTemplate.centerText(
        context,
        this.order_info.delivery_date1 + " " + deliveryTime,
        lineY,
        maxLineWidth,
        itemHeight
      );
      lineY += itemHeight;

      PrintTemplate.centerText(
        context,
        this.order_info.total_items1,
        lineY,
        maxLineWidth,
        itemHeight
      );
      lineY += itemHeight;

      context.fillText("\n", 0, lineY);
      PrintTemplate.drawLine(context, maxLineWidth, lineY);
      lineY += 10;

      data_lenght = await PrintTemplate.TableColumn(
        context,
        this.data_items,
        maxLineWidth,
        lineY,
        itemHeight
      );
      console.log("Items data_lenght =>" + data_lenght);
      lineY += itemHeight * data_lenght + 15;

      context.fillText("\n", 0, lineY);
      PrintTemplate.drawLine(context, maxLineWidth, lineY);
      lineY += itemHeight;

      data_lenght = await PrintTemplate.TableColumn(
        context,
        this.data_summary,
        maxLineWidth,
        lineY,
        itemHeight
      );
      lineY += itemHeight * data_lenght + 15;

      context.textAlign = "left";
      context.fillText("\n", 0, lineY);
      PrintTemplate.drawLine(context, maxLineWidth, lineY);
      lineY += itemHeight;

      lineY += itemHeight;
      lineY += itemHeight;

      PrintTemplate.centerText(
        context,
        this.$t("Thank you for your order"),
        lineY,
        maxLineWidth,
        itemHeight
      );
      lineY += itemHeight;

      PrintTemplate.centerText(
        context,
        this.$t("Please visit us again."),
        lineY,
        maxLineWidth,
        itemHeight
      );
      lineY += itemHeight;

      this.baseImage = canvas.toDataURL("image/png");

      if (this.auto_print) {
        this.PrintReceipt();
      }

      // END PRINTING CANVAS
    },
    PrintReceipt() {
      if (!this.$q.capacitor) {
        APIinterface.notify(
          "dark",
          this.$t("Bluetooth printer only works in actual device"),
          "error",
          this.$q
        );
        return false;
      }
      if (APIinterface.empty(this.printer_details.printer_bt_name)) {
        APIinterface.notify(
          "dark",
          this.$t(
            "Printer has no printer name please remove this printer and add again"
          ),
          "error",
          this.$q
        );
        return false;
      }
      console.log(this.printer_details.printer_bt_name);

      APIinterface.showLoadingBox("", this.$q);

      CBTPrinter.ConnectToPrinter(this.printer_details.printer_bt_name)
        .then((data) => {
          CBTPrinter.printPOSCommand("0A");
          CBTPrinter.printPOSCommand("1B6100");
          CBTPrinter.printBase64(this.baseImage, 0)
            .then((data) => {
              if (this.auto_print) {
                this.dialog = false;
              }
            })
            .catch((error) => {
              APIinterface.notify("dark", error, "error", this.$q);
              this.dialog = false;
            })
            .then((data) => {});

          if (this.DataStore.printer_auto_close) {
            this.disConnect();
          }
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
          this.dialog = false;
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    disConnect() {
      CBTPrinter.DisconnectToPrinter(this.printer_details.printer_bt_name)
        .then((data) => {
          //APIinterface.notify("green", "DisConnected", "check", this.$q);
          if (this.auto_print) {
            this.dialog = false;
          }
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {});
    },
  },
};
</script>
