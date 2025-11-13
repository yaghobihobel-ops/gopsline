<template>
  <q-page padding>
    <div class="q-pa-md">
      <q-btn label="Connect" @click="connect" color="primary"></q-btn>
    </div>
    <div class="q-pa-md">
      <q-btn label="createCanvas" @click="createCanvas" color="primary"></q-btn>
    </div>

    <!-- <canvas
      ref="receiptCanvas"
      :width="canvas_width"
      height="100"
      class="border"
    ></canvas> -->
    <!-- <q-dialog v-model="dialog">
      <div class="canvas-container border">
        <canvas
          class="receiptCanvas"
          ref="receiptCanvas"
          :width="canvas_width"
          height="100"
        ></canvas>
      </div>
    </q-dialog> -->

    <!-- <PrinterList
      ref="printer"
      @after-selectprinter="afterSelectprinter"
    ></PrinterList> -->

    <PrintPreview
      ref="print_preview"
      :printer_details="printer_details"
      :order_info="OrderStore.order_info"
      :merchant="OrderStore.merchant"
      :order_items="OrderStore.order_items"
      :order_summary="OrderStore.order_summary"
    ></PrintPreview>
  </q-page>
</template>

<script>
import CBTPrinter from "src/api/CBTPrinter";
import APIinterface from "src/api/APIinterface";
import PrintTemplate from "src/api/PrintTemplate";
import { defineAsyncComponent } from "vue";
import { useOrderStore } from "stores/OrderStore";
import { useDataStore } from "stores/DataStore";

const printerName = "MTP-2";
export default {
  // name: 'PageName',
  components: {
    // PrinterList: defineAsyncComponent(() =>
    //   import("components/PrinterList.vue")
    // ),
    PrintPreview: defineAsyncComponent(() =>
      import("components/PrintPreview.vue")
    ),
  },
  setup() {
    const OrderStore = useOrderStore();
    const DataStore = useDataStore();
    return { OrderStore, DataStore };
  },
  data() {
    return {
      canvas_width: 585,
      maxLineWidth: 398,
      connect_status: "",
      printer_name: "MTP-2",
      dialog: true,
      printer_details: [],
    };
  },
  mounted() {
    // setTimeout(() => {
    //   this.createCanvas();
    // }, 100); // 1 sec delay

    setTimeout(() => {
      this.getOrder();
    }, 100); // 1 sec delay
  },
  methods: {
    afterSelectprinter(data) {
      this.getOrder();
    },
    async getOrder() {
      APIinterface.showLoadingBox(this.$t("Getting order..."), this.$q);
      try {
        let result = await this.OrderStore.orderDetails(
          "3db76bc6-664d-11ee-bfee-64e44bc80bde"
        );
        //this.$refs.printer.dialog = false;
        APIinterface.hideLoadingBox(this.$q);
        this.$refs.print_preview.showDialog(true, false);
      } catch (err) {
        APIinterface.notify("dark", err, "error", this.$q);
        //APIinterface.hideLoadingBox(this.$q);
      }
    },
    async createCanvas() {
      console.log("createCanvas");
      var canvas = this.$refs.receiptCanvas;
      var context = canvas.getContext("2d");
      context.clearRect(0, 0, canvas.width, canvas.height);

      var itemHeight = 27;
      var itemCount = 32;
      var canvasHeight = itemHeight * itemCount;
      canvas.height = canvasHeight;

      // Set up the receipt layout
      context.fillStyle = "#ffffff";
      context.fillRect(0, 0, canvas.width, canvas.height);

      // Draw horizontal lines for the receipt
      context.strokeStyle = "#000000";
      context.lineWidth = 1;

      context.fillStyle = "#000000";
      context.font = "300 24px Arial";

      // Header
      //var maxLineWidth = this.canvas_width;
      var maxLineWidth = this.maxLineWidth;

      let lineY = itemHeight;

      PrintTemplate.centerText(
        context,
        "Mcdonalds",
        lineY,
        maxLineWidth,
        itemHeight
      );
      lineY += itemHeight;

      PrintTemplate.centerText(
        context,
        "Lot 1187-D Old National Highway, Brgy, Balibago, Santa Rosa, Laguna",
        lineY,
        maxLineWidth,
        itemHeight
      );
      lineY += itemHeight;
      lineY += itemHeight;

      PrintTemplate.drawLine(context, maxLineWidth, lineY);

      //PrintTemplate.drawSpace(context, maxLineWidth, lineY);
      lineY += 15;

      let data2 = [
        { label: "Order ID", value: "10384" },
        {
          label: "Customer Name",
          value: "John Doe",
        },
        { label: "Phone", value: "+1422323232" },
        {
          label: "Address",
          value: "Guadalupe Nuevo, Makati, Metro Manila, Philippines",
        },
        { label: "Address label", value: "Home" },
        {
          label: "Delivery options",
          value: "Leave at the door",
        },
        { label: "Order Type", value: "Delivery" },
        { label: "Delivery Date/Time", value: "Asap" },
        { label: "Paid by Stripe", value: "" },
      ];
      let data_lenght = await PrintTemplate.TableColumn(
        context,
        data2,
        maxLineWidth,
        lineY,
        itemHeight
      );
      console.log("data_lenght=>" + data_lenght);
      lineY += itemHeight * data_lenght + 15;

      PrintTemplate.drawLine(context, maxLineWidth, lineY);

      lineY += 10;

      let data = [
        { label: "3 x Cheese burger", value: "$10.00" },
        { label: "1 x 2-pc. Mushroom Pepper Steak Meal", value: "$5.00" },
        { label: "1 x Sausage McMuffin w/ Egg Meal ", value: "$19.00" },
        { label: "2 x Sausage McMuffin w/ Egg Meal ", value: "$20.00" },
      ];
      data_lenght = await PrintTemplate.TableColumn(
        context,
        data,
        maxLineWidth,
        lineY,
        itemHeight
      );
      console.log("data_lenght=>" + data_lenght);
      lineY += itemHeight * data_lenght + 15;

      PrintTemplate.drawLine(context, maxLineWidth, lineY);

      data = [
        { label: "Sub total", value: "$10.00" },
        { label: "Service Fee", value: "$5.00" },
        { label: "Delivery Fee", value: "$19.00" },
      ];

      lineY += 10;
      data_lenght = await PrintTemplate.TableColumn(
        context,
        data,
        maxLineWidth,
        lineY,
        itemHeight
      );
      lineY += itemHeight * data_lenght + 15;

      context.fillText("\n", 0, lineY);
      lineY += itemHeight + 30;

      PrintTemplate.centerText(
        context,
        "************ THANK YOU ************ ",
        lineY,
        maxLineWidth,
        itemHeight
      );

      this.baseImage = canvas.toDataURL("image/png");
    },
    connect() {
      CBTPrinter.ConnectToPrinter(this.printer_name)
        .then((data) => {
          this.connect_status = data;
          CBTPrinter.printPOSCommand("0A");
          CBTPrinter.printPOSCommand("1B6100");
          // CBTPrinter.printText("Hello word");
          // CBTPrinter.printPOSCommand("0A");
          // CBTPrinter.printPOSCommand("1B6100");
          CBTPrinter.printBase64(this.baseImage, 0)
            .then((data) => {
              APIinterface.notify("green", "DisConnected", "check", this.$q);
            })
            .catch((error) => {
              APIinterface.notify("dark", error, "error", this.$q);
            })
            .then((data) => {});

          this.disConnect();
        })
        .catch((error) => {
          this.connect_status = error;
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {});
    },
    disConnect() {
      CBTPrinter.DisconnectToPrinter(this.printer_name)
        .then((data) => {
          this.connect_status = data;
          APIinterface.notify("green", "DisConnected", "check", this.$q);
        })
        .catch((error) => {
          this.connect_status = error;
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {});
    },
  },
};
</script>
