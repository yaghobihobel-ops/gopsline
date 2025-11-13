<template>
  <q-page padding class="q-pt-lg">
    <div>
      <q-inner-loading
        :showing="visible"
        label="Please wait..."
        label-class="text-teal"
        label-style="font-size: 1.1em"
      />
      <q-btn
        color="primary"
        label="Search printer"
        @click="searchPrinter"
        size="lg"
        class="q-mb-md"
        :loading="loading"
        no-caps
      ></q-btn>
      <br />
      <q-btn
        color="warning"
        label="Test Print"
        @click="testPrint"
        size="lg"
        class="q-mb-md"
        :loading="loading_print"
        no-caps
      ></q-btn>
      <!-- :disable="!hasPrinter" -->

      <!-- <div>loading : {{ loading }}</div> -->
      <div class="q-pa-md"></div>
      <q-list separator>
        <template v-for="items in list" :key="items">
          <q-item clickable v-ripple @click="getCharacteristic(items)">
            <q-item-section>
              <q-item-label>{{ items.name }}</q-item-label>
              <q-item-label>{{ items.device_id }}</q-item-label>
              <q-item-label>{{ items.service_id }}</q-item-label>
            </q-item-section>
          </q-item>
        </template>
      </q-list>
      <div class="q-pa-md"></div>

      <div class="canvas-container">
        <canvas
          class="receiptCanvas border"
          ref="receiptCanvas"
          height="100"
        ></canvas>
      </div>

      <div>device_name : {{ device_name }}</div>
      <div>device_id : {{ device_id }}</div>
      <div>service_id : {{ service_id }}</div>
      <div>characteristic : {{ characteristic }}</div>
      <!-- <pre>{{ characteristic_list }}</pre> -->
      <!-- <pre>{{ sample_data }}</pre> -->
      <!-- <pre>{{ test_data }}</pre> -->
      <pre>{{ baseImage }}</pre>
    </div>
  </q-page>
</template>

<script>
import AppBluetooth from "src/api/AppBluetooth";
import ThermalPrinterFormatter from "src/api/ThermalPrinterFormatter";
import CBTPrinter from "src/api/CBTPrinter";
import APIinterface from "src/api/APIinterface";

const chunkCMD = [];
export default {
  name: "TestPrinter",
  data() {
    return {
      loading: false,
      list: [],
      visible: false,
      characteristic_list: [],
      device_name: null,
      device_id: null,
      service_id: null,
      characteristic: null,
      loading_print: false,
      test_data: [],
      // sample_data:
      //   '{"data":{"settings":{"print_type":"raw","page_width":58,"device_id":"1232323211","service_id":"18f0","characteristics":"18f0"},"header":[{"position":"left","type":"font","font_type":"bold"},{"position":"center","type":"text","value":"McDonalds"},{"position":"left","type":"font","font_type":"normal"},{"position":"center","type":"text","value":"Adddress: 2810 South Figueroa Street, Los Angeles, CA, USA"},{"position":"center","type":"text","value":"Tel: +12243333333"},{"position":"center","type":"text","value":"14.06.2024 10:52"},{"position":"left","type":"line_break","value":""}],"body":[{"position":"left","type":"dotted_line","value":"-"},{"position":"left_right_text","type":"text","label":"Order ID:","value":"371"},{"position":"left_right_text","type":"text","label":"Customer:","value":"basti bach"},{"position":"left_right_text","type":"text","label":"Phone:","value":"+632311321111"},{"position":"left_right_text","type":"text","label":"Order Type:","value":"Pickup"},{"position":"left_right_text","type":"text","label":"Pickup Date/Time:","value":"Asap"},{"position":"left","type":"text","value":"Paid by Pay on delivery"},{"position":"left","type":"dotted_line","value":"-"},{"position":"left_right_text","type":"text","label":"2 x  6-pc. Chicken McShare Box ","value":"666.00$"},{"position":"left","type":"text","value":"Medium rare,Cheese,Grain,Milk"},{"position":"left","type":"text","value":"Choose 2 Rice Bowls"},{"position":"left_right_text","type":"text","label":"2 x Sausage w/ Egg","value":"2.00$"},{"position":"left","type":"line_break","value":""},{"position":"left_right_text","type":"text","label":"2 x test & item (Medium)","value":"10.00$"},{"position":"left","type":"text","value":"Broiling,Cheese,Milk"},{"position":"left","type":"text","value":"Choose  Drinks"},{"position":"left_right_text","type":"text","label":"2 x addon price zero","value":"0.00$"},{"position":"left","type":"line_break","value":""},{"position":"left_right_text","type":"text","label":"1 x Cheesy Eggdesal Meal (Large)","value":"110.00$"},{"position":"left","type":"text","value":"Medium rare,Cheese,eggs,Grain,Milk"},{"position":"left","type":"text","value":"Include Add-ons"},{"position":"left_right_text","type":"text","label":"1 x Apple Pie","value":"37.00$"},{"position":"left","type":"line_break","value":""},{"position":"left_right_text","type":"text","label":"1 x Total items","value":"111.00$"},{"position":"left","type":"line_break","value":""},{"position":"left","type":"dotted_line","value":"-"},{"position":"left_right_text","type":"text","label":"Sub total (6 items)","value":"936.00$"},{"position":"left_right_text","type":"text","label":"Packaging fee","value":"1.00$"},{"position":"left_right_text","type":"text","label":"TAX 5%","value":"46.80$"},{"position":"left_right_text","type":"text","label":"Courier tip","value":"165.00$"},{"position":"left","type":"font","font_type":"bold"},{"position":"left_right_text","type":"text","label":"Total","value":"1148.80$"},{"position":"left","type":"font","font_type":"normal"},{"position":"left","type":"dotted_line","value":"-"},{"position":"left","type":"text","value":"Place on 14 Jun 2024 10:52 AM"},{"position":"left","type":"dotted_line","value":"-"}],"footer":[{"position":"left","type":"line_break_big","value":""},{"position":"center","type":"text","value":"Thank you for your order"},{"position":"center","type":"text","value":"Please visit us again."}]}}',
      sample_data:
        '{"data":{"settings":{"print_type":"raw","page_width":58,"device_id":"1232323211","service_id":"18f0","characteristics":"18f0"},"header":[{"position":"left","type":"font","font_type":"bold"},{"position":"center","type":"text","value":"McDonalds"},{"position":"left","type":"font","font_type":"normal"},{"position":"center","type":"text","value":"Adddress: 2810 South Figueroa Street, Los Angeles, CA, USA"},{"position":"center","type":"text","value":"Tel: +12243333333"},{"position":"center","type":"text","value":"14.06.2024 10:52"},{"position":"left","type":"line_break","value":""}],"body":[{"position":"left","type":"dotted_line","value":"-"},{"position":"left_right_text","type":"text","label":"Order ID:","value":"371"},{"position":"left_right_text","type":"text","label":"Customer:","value":"basti bach"},{"position":"left_right_text","type":"text","label":"Phone:","value":"+632311321111"},{"position":"left_right_text","type":"text","label":"Order Type:","value":"Pickup"},{"position":"left_right_text","type":"text","label":"Pickup Date/Time:","value":"Asap"},{"position":"left","type":"text","value":"Paid by Pay on delivery"},{"position":"left","type":"dotted_line","value":"-"},{"position":"left_right_text","type":"text","label":"2 x  6-pc. Chicken McShare Box ","value":"666.00$"},{"position":"left","type":"text","value":"Medium rare,Cheese,Grain,Milk"},{"position":"left","type":"text","value":"Choose 2 Rice Bowls"},{"position":"left_right_text","type":"text","label":"2 x Sausage w/ Egg","value":"2.00$"},{"position":"left","type":"line_break","value":""},{"position":"left_right_text","type":"text","label":"2 x test & item (Medium)","value":"10.00$"},{"position":"left","type":"text","value":"Broiling,Cheese,Milk"},{"position":"left","type":"text","value":"Choose  Drinks"},{"position":"left_right_text","type":"text","label":"2 x addon price zero","value":"0.00$"},{"position":"left","type":"line_break","value":""},{"position":"left_right_text","type":"text","label":"1 x Cheesy Eggdesal Meal (Large)","value":"110.00$"},{"position":"left","type":"text","value":"Medium rare,Cheese,eggs,Grain,Milk"},{"position":"left","type":"text","value":"Include Add-ons"},{"position":"left_right_text","type":"text","label":"1 x Apple Pie","value":"37.00$"},{"position":"left","type":"line_break","value":""},{"position":"left_right_text","type":"text","label":"1 x Total items","value":"111.00$"},{"position":"left","type":"line_break","value":""},{"position":"left","type":"dotted_line","value":"-"},{"position":"left_right_text","type":"text","label":"Sub total (6 items)","value":"936.00$"},{"position":"left_right_text","type":"text","label":"Packaging fee","value":"1.00$"},{"position":"left_right_text","type":"text","label":"TAX 5%","value":"46.80$"},{"position":"left_right_text","type":"text","label":"Courier tip","value":"165.00$"},{"position":"left","type":"font","font_type":"bold"},{"position":"left_right_text","type":"text","label":"Total","value":"1148.80$"},{"position":"left","type":"font","font_type":"normal"},{"position":"left","type":"dotted_line","value":"-"},{"position":"left","type":"text","value":"Place on 14 Jun 2024 10:52 AM"},{"position":"left","type":"dotted_line","value":"-"}],"footer":[{"position":"left","type":"line_break_big","value":""},{"position":"center","type":"text","value":"Thank you for your order"},{"position":"center","type":"text","value":"Please visit us again."}]}}',
      paper_width: 585,
      baseImage: null,
    };
  },
  computed: {
    hasPrinter() {
      if (this.device_id && this.service_id && this.characteristic) {
        return true;
      }
      return false;
    },
  },
  mounted() {
    this.sample_data = JSON.parse(this.sample_data);
  },
  methods: {
    searchPrinter() {
      this.device_id = null;
      this.service_id = null;
      this.characteristic = null;
      this.list = [];
      this.characteristic_list = [];
      AppBluetooth.initConnect(this.$q).then((data) => {
        this.loading = true;
        AppBluetooth.Scan()
          .then((data) => {
            //alert(JSON.stringify(data));
            this.list = data;
          })
          .catch((error) => {
            alert(error);
          })
          .then((data) => {
            this.loading = false;
          });
      });
    },
    getCharacteristic(data) {
      this.device_name = data.name;
      this.device_id = data.device_id;
      this.service_id = data.service_id;
      this.visible = true;
      this.characteristic_list = [];
      AppBluetooth.getCharacteristic(data.device_id)
        .then((data) => {
          this.characteristic = data.default;
          this.characteristic_list = data;
        })
        .catch((error) => {
          alert(error.message);
        })
        .then((data) => {
          this.visible = false;
        });
    },
    sleep(ms) {
      return new Promise((resolve) => setTimeout(resolve, ms));
    },
    async testPrint() {
      let newdata = [];
      let data = ThermalPrinterFormatter.Print(
        this.sample_data.data.settings,
        this.sample_data.data.header,
        this.sample_data.data.body,
        this.sample_data.data.footer,
        this.$refs.receiptCanvas
      );

      console.log("data", data);
      this.baseImage = data;

      let error_message = null;

      if (this.sample_data.data.settings.print_type == "image") {
        try {
          this.loading_print = true;

          await CBTPrinter.ConnectToPrinter(this.device_name);
          this.loading_print = false;
          await CBTPrinter.printPOSCommand("0A");
          await CBTPrinter.printPOSCommand("1B6100");

          const printResults = await CBTPrinter.printBase64(this.baseImage, 0);

          APIinterface.notify(
            this.$q,
            this.$t("Successful"),
            printResults,
            "mysuccess",
            "highlight_off",
            "bottom"
          );

          this.disConnect();
        } catch (error) {
          this.loading_print = false;
          this.loading = false;
          APIinterface.notify(
            this.$q,
            this.$t("ERROR"),
            error,
            "myerror",
            "highlight_off",
            "bottom"
          );
        }
      } else {
        if (Object.keys(data).length > 0) {
          for (const [key, items] of Object.entries(data)) {
            console.log("items to print", items);

            AppBluetooth.Print(
              items,
              this.device_id,
              this.service_id,
              this.characteristic
            )
              .then((data) => {
                //alert("Success");
              })
              .catch((error) => {
                error_message += error;
              })
              .then((data) => {});

            await this.sleep(1000);
          }
        }

        if (error_message) {
          alert(error_message);
        } else {
          alert("Finish");
        }
      }
    },
    chunkStr(str, size) {
      if (str == null) {
        return [];
      }
      str = String(str);
      size = ~~size;
      return size > 0
        ? str.match(new RegExp(".{1," + size + "}", "g")) || []
        : [str];
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
    //
  },
};
</script>
