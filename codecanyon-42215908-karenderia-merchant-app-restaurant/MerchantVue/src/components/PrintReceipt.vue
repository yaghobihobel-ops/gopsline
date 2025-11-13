<template>
  <div class="hidden">
    <canvas
      class="receiptCanvas border"
      ref="receiptCanvas"
      height="100"
    ></canvas>
  </div>
</template>

<script>
import CBTPrinter from "src/api/CBTPrinter";
import ThermalPrinterFormatter from "src/api/ThermalPrinterFormatter";
import AppBluetooth from "src/api/AppBluetooth";
import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";
import { useDataPersisted } from "src/stores/DataPersisted";

export default {
  name: "PrintReceipt",
  props: ["data", "printer"],
  data() {
    return {
      results: null,
    };
  },
  setup() {
    const DataStore = useDataStore();
    const DataPersisted = useDataPersisted();
    return { DataStore, DataPersisted };
  },
  computed: {
    orderInfo() {
      return this.data?.order?.order_info ?? null;
    },
    getDriver() {
      const data = this.data?.driver_data ?? null;
      if (!data) {
        return null;
      }
      return Object.keys(data).length > 0 ? data : null;
    },
    getItemsCount() {
      return this.data?.items?.length ?? null;
    },
    getItems() {
      return this.data?.items ?? null;
    },
    visibleItems() {
      const items = this.data?.items ?? null;
      if (!items) {
        return null;
      }
      return this.show_all ? items : items.slice(0, 2);
    },
    getSummary() {
      return this.data?.summary ?? null;
    },
    getTimeline() {
      return this.data?.delivery_timeline ?? null;
    },
    getPaymenthistory() {
      return this.data?.payment_history ?? null;
    },
    getMerchant() {
      return this.data?.merchant ?? null;
    },
    getTabledata() {
      return this.data?.order_table_data ?? null;
    },
    getSiteData() {
      return this.data?.site_data ?? null;
    },
  },
  methods: {
    initData() {
      let header = [],
        body = [],
        footer = [];

      // HEADER
      header = [
        {
          position: "left",
          type: "line_break",
          value: "",
        },
        {
          position: "left",
          type: "font",
          font_type: "bold",
        },
        {
          position: "center",
          type: "text",
          value: this.getSiteData?.title,
        },
        {
          position: "center",
          type: "text",
          value: "#" + this.orderInfo?.order_id,
        },
        {
          position: "left",
          type: "line_break",
          value: "",
        },
        {
          position: "left",
          type: "font",
          font_type: "normal",
        },
        {
          position: "center",
          type: "text",
          value: this.getMerchant?.restaurant_name,
        },
        {
          position: "center",
          type: "text",
          value: this.getMerchant?.merchant_address,
        },
      ];
      if (this.getMerchant?.merchant_tax_number) {
        header.push({
          position: "center",
          type: "text",
          value: this.getMerchant?.merchant_tax_number,
        });
      }

      header.push(
        {
          position: "center",
          type: "text",
          value: this.orderInfo?.place_datetime,
        },
        {
          position: "left",
          type: "dotted_line",
          value: "-",
        },
        {
          position: "center",
          type: "text",
          value: this.$t("Customer"),
        },
        {
          position: "center",
          type: "text",
          value: this.orderInfo?.customer_name,
        },
        {
          position: "center",
          type: "text",
          value: this.orderInfo?.contact_number,
        }
      );

      if (this.orderInfo?.order_type == "delivery") {
        header.push(
          {
            position: "center",
            type: "text",
            value: this.orderInfo?.complete_delivery_address,
          },
          {
            position: "center",
            type: "text",
            value:
              this.orderInfo?.address1 + " " + this.orderInfo?.delivery_address,
          }
        );
      }

      header.push(
        {
          position: "left",
          type: "line_break",
          value: "",
        },
        {
          position: "left",
          type: "font",
          font_type: "bold",
        },
        {
          position: "center",
          type: "box_text",
          value: this.orderInfo?.payment_status1,
        },
        {
          position: "left",
          type: "line_break",
          value: "",
        },
        {
          position: "center",
          type: "box_text",
          value:
            this.orderInfo?.payment_code == "none"
              ? this.orderInfo?.payment_by_wallet
              : this.orderInfo?.payment_name1,
        },
        {
          position: "left",
          type: "line_break",
          value: "",
        },
        {
          position: "center",
          type: "box_text",
          value: this.orderInfo?.order_type1,
        },

        {
          position: "left",
          type: "font",
          font_type: "normal",
        },

        {
          position: "left",
          type: "line_break",
          value: "",
        },
        {
          position: "center",
          type: "text",
          value:
            this.orderInfo?.service_code == "delivery"
              ? this.$t("Delivery Date/Time")
              : this.$t("Date/Time"),
        }
      );

      const transaction_type = this.orderInfo?.service_code ?? null;

      let deliveryTime =
        this.orderInfo.whento_deliver == "now"
          ? this.orderInfo.schedule_at
          : this.orderInfo.delivery_time1;

      header.push(
        {
          position: "center",
          type: "text",
          value: this.orderInfo?.delivery_date1 + " " + deliveryTime,
        },
        {
          position: "center",
          type: "text",
          value: this.orderInfo?.total_items1,
        }
      );

      if (transaction_type == "dinein") {
        header.push(
          {
            position: "left",
            type: "line_break",
            value: "",
          },
          {
            position: "center",
            type: "text",
            value:
              this.$t("Guest number") + ` (${this.getTabledata?.guest_number})`,
          },
          {
            position: "center",
            type: "text",
            value: "T-" + this.getTabledata?.table_name,
          }
          // {
          //   position: "center",
          //   type: "text",
          //   value: this.getTabledata?.room_name,
          // }
        );
      }

      header.push({
        position: "left",
        type: "dotted_line",
        value: "-",
      });

      // BODY
      let items = this.getItems;
      Object.entries(items).forEach(([key, items]) => {
        body.push({
          position: "left_right_text",
          type: "text",
          label: `${items.qty} ${items.item_name}`,
          value:
            items?.price?.discount <= 0
              ? items?.price?.pretty_total
              : items?.price?.pretty_total_after_discount,
        });
        body.push({
          position: "left_right_text",
          type: "text",
          label: items?.category_name,
          value: "",
        });

        if (items?.special_instructions) {
          body.push({
            position: "left_right_text",
            type: "text",
            label: items?.special_instructions,
            value: "",
          });
        }

        Object.entries(items?.attributes).forEach(([key, attributes]) => {
          let attr_data = "";
          Object.entries(attributes).forEach(([key, attributes_data]) => {
            attr_data += `${attributes_data},`;
          });
          body.push({
            position: "left_right_text",
            type: "text",
            label: attr_data,
            value: "",
          });
        });

        Object.entries(items?.addons).forEach(([key, addons]) => {
          body.push({
            position: "left_right_text",
            type: "text",
            label: addons?.subcategory_name,
            value: "",
          });
          Object.entries(addons?.addon_items).forEach(([key, addon_items]) => {
            console.log("addon_items", addon_items);
            console.log(addon_items.qty);
            body.push({
              position: "left_right_text",
              type: "text",
              label: `${addon_items.qty} ${addon_items.sub_item_name}`,
              value: addon_items.pretty_addons_total,
            });
          });
        });
        body.push({
          position: "left",
          type: "line_break",
          value: "",
        });
      });
      // END ITEMS

      body.push({
        position: "left",
        type: "dotted_line",
        value: "-",
      });

      Object.entries(this.getSummary).forEach(([key, summary]) => {
        body.push({
          position: "left_right_text",
          type: "text",
          label: summary.name,
          value: summary.value,
        });
      });

      body.push({
        position: "left",
        type: "dotted_line",
        value: "-",
      });

      footer.push(
        {
          position: "left",
          type: "line_break",
          value: "",
        },
        {
          position: "center",
          type: "text",
          value: this.$t("Thank you for your order"),
        },
        {
          position: "center",
          type: "text",
          value: this.$t("Please visit us again."),
        }
      );

      try {
        this.results = ThermalPrinterFormatter.Print(
          this.printer,
          header,
          body,
          footer,
          this.$refs.receiptCanvas
        );
        this.initPrint();
      } catch (error) {
        console.log("error", error);
      } finally {
      }

      //
    },
    async initPrint() {
      console.log("initPrint", JSON.stringify(this.printer));
      console.log("results", this.results);
      console.log("DataStore.osVersion", this.DataStore.osVersion);
      try {
        if (this.DataStore.osVersion >= 12) {
          await AppBluetooth.CheckBTScanPermission();
        } else {
          await AppBluetooth.CheckLocationOnly();
        }
        const results = await AppBluetooth.Enabled();
        console.log("results", results);
        this.Connect();
      } catch (error) {
        console.log("ERROR", error);
        this.$router.push("/settings/location-enabled");
      } finally {
      }
    },
    async Connect() {
      try {
        APIinterface.showLoadingBox("Connecting...", this.$q);

        await AppBluetooth.Connect(
          this.printer?.printer_uuid,
          this.printer?.printer_model
        );

        await CBTPrinter.ConnectToPrinter(this.printer?.printer_name);
        await CBTPrinter.printPOSCommand("0A");
        await CBTPrinter.printPOSCommand("1B6100");
        await CBTPrinter.printBase64(this.results, 0);

        if (this.DataPersisted.printer_auto_close) {
          this.disConnect();
        }
      } catch (error) {
        APIinterface.ShowAlert(
          error ?? this.$t("Undefined error"),
          this.$q.capacitor,
          this.$q
        );
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
    async disConnect() {
      await CBTPrinter.DisconnectToPrinter(this.printer?.printer_name);
    },
  },
};
</script>
