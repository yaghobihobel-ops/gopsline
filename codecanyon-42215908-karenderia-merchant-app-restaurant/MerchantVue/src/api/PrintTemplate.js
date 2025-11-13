import ESC_COMMANDS from "src/api/ESCpos";
import APIinterface from "./APIinterface";

const PrintTemplate = {
  SampleTemplateMin(paper_width) {
    let paperWidth = PrintTemplate.getPaperLenght(paper_width);
    let tpl = "";
    tpl += ESC_COMMANDS.FEED_CONTROL_SEQUENCES.CTL_LF;
    tpl += ESC_COMMANDS.TEXT_FORMAT.TXT_ALIGN_CT;
    tpl += "TEST RECEIPT";
    tpl += ESC_COMMANDS.EOL;
    tpl += PrintTemplate.getLine(paperWidth);
    tpl += ESC_COMMANDS.EOL;
    tpl += ESC_COMMANDS.LF;
    return tpl;
  },
  SampleTemplateUTF(paper_width) {
    let paperWidth = PrintTemplate.getPaperLenght(paper_width);
    let tpl = "";
    //tpl += "\x1b\x1d\x74\x04";
    // tpl += "\x1b\x74\x12";
    // tpl +=
    //   "\x1C\x26\x1B\x4A\x0A\xD9\x85\xD8\xB1\xD8\xAD\xD8\xA8\xD8\xA7\xD9\x8B";
    //tpl += "\x1b\x74\x12";
    //tpl += "\x1b\x1d\x74\x12";

    tpl += "\x1B\x1D\x52";
    tpl += "\x82\xA0\x82\xA2\x82\xA4\x82\xA6";
    tpl += ESC_COMMANDS.EOL;
    tpl += ESC_COMMANDS.EOL;
    tpl += ESC_COMMANDS.LF;
    return tpl;
  },
  SampleTemplate(paper_width) {
    let paperWidth = PrintTemplate.getPaperLenght(paper_width);
    let tpl = "";
    tpl += ESC_COMMANDS.FEED_CONTROL_SEQUENCES.CTL_LF;
    tpl += ESC_COMMANDS.TEXT_FORMAT.TXT_ALIGN_CT;
    tpl += "TEST RECEIPT ";
    tpl += ESC_COMMANDS.EOL;
    tpl += PrintTemplate.getLine(paperWidth);
    tpl += ESC_COMMANDS.EOL;
    tpl += ESC_COMMANDS.FEED_CONTROL_SEQUENCES.CTL_LF;
    tpl += ESC_COMMANDS.TEXT_FORMAT.TXT_ALIGN_LT;

    let LineItems = PrintTemplate.leftRightData(
      "1 x Cheese burger",
      "3.00",
      paperWidth
    );
    tpl += LineItems;

    LineItems = PrintTemplate.leftRightData("2 x Chicken", "23.00", paperWidth);
    tpl += LineItems;

    LineItems = PrintTemplate.leftRightData("5 x Sauce", "100.00", paperWidth);
    tpl += LineItems;

    tpl += PrintTemplate.getLine(paperWidth);
    tpl += ESC_COMMANDS.EOL;

    LineItems = PrintTemplate.leftRightData(
      "TOTAL AMOUNT",
      "126.00",
      paperWidth
    );
    tpl += LineItems;

    LineItems = PrintTemplate.leftRightData("CASH", "200.00", paperWidth);
    tpl += LineItems;

    LineItems = PrintTemplate.leftRightData("CHANGE", "74.00", paperWidth);
    tpl += LineItems;

    tpl += ESC_COMMANDS.LF;
    LineItems = PrintTemplate.leftRightData(
      "BANK CARD",
      "****7212",
      paperWidth
    );
    tpl += LineItems;

    tpl += PrintTemplate.getLine(paperWidth);
    tpl += ESC_COMMANDS.LF;
    tpl += ESC_COMMANDS.EOL;

    LineItems = PrintTemplate.centerData("THANK YOU!", paperWidth);
    tpl += LineItems;
    tpl += ESC_COMMANDS.EOL;

    tpl += ESC_COMMANDS.LF;
    tpl += ESC_COMMANDS.LF;

    return tpl;
  },
  /*
    RECEIPT TEMPLATE
    @parameters order_info , merchant, paper_width
  */
  ReceiptTemplate(
    paper_width,
    order_info,
    merchant,
    order_items,
    order_summary
  ) {
    console.log(order_info);
    let paperWidth = PrintTemplate.getPaperLenght(paper_width);

    let tpl = "";
    let tpl_all = "";
    let tpl_data = [];
    tpl += ESC_COMMANDS.LF;
    tpl += ESC_COMMANDS.TEXT_FORMAT.TXT_ALIGN_CT;
    tpl += merchant.restaurant_name;
    tpl += ESC_COMMANDS.EOL;
    tpl += merchant.address;
    tpl += ESC_COMMANDS.EOL;
    tpl += PrintTemplate.getLine(paperWidth);
    tpl += ESC_COMMANDS.EOL;
    tpl += ESC_COMMANDS.LF;
    tpl += ESC_COMMANDS.TEXT_FORMAT.TXT_ALIGN_LT;

    tpl += PrintTemplate.leftRightData(
      "Order ID",
      String(order_info.order_id),
      paperWidth
    );

    tpl += PrintTemplate.leftRightData(
      "Customer Name",
      order_info.customer_name,
      paperWidth
    );

    tpl += PrintTemplate.leftRightData(
      "Email",
      order_info.contact_email,
      paperWidth
    );

    tpl += PrintTemplate.leftRightData(
      "Phone",
      order_info.contact_number,
      paperWidth
    );

    if (order_info.service_code == "delivery") {
      tpl += PrintTemplate.leftRightData(
        "Address",
        order_info.complete_delivery_address
          ? order_info.complete_delivery_address
          : order_info.delivery_address,
        paperWidth
      );

      tpl += PrintTemplate.leftRightData(
        "Address label",
        order_info.address_label,
        paperWidth
      );
      tpl += ESC_COMMANDS.LF;

      tpl += PrintTemplate.leftRightData(
        "Delivery Instructions",
        order_info.delivery_instructions,
        paperWidth
      );
      tpl += ESC_COMMANDS.LF;
    }

    tpl += PrintTemplate.leftRightData(
      "Order Type",
      order_info.order_type,
      paperWidth
    );

    if (order_info.whento_deliver == "now") {
      tpl += PrintTemplate.leftRightData(
        "Delivery Date/Time",
        order_info.schedule_at,
        paperWidth
      );
    } else {
      tpl += PrintTemplate.leftRightData(
        "Delivery Date/Time",
        order_info.delivery_date + " " + order_info.delivery_time,
        paperWidth
      );
    }

    if (!APIinterface.empty(merchant.merchant_tax_number)) {
      tpl += PrintTemplate.leftRightData(
        "Tax number",
        merchant.merchant_tax_number,
        paperWidth
      );
    }

    let payment_info = order_info.payment_name;
    tpl += payment_info;
    tpl += ESC_COMMANDS.EOL;

    if (order_info.payment_change > 0) {
      tpl += PrintTemplate.leftRightData(
        "Payment change",
        order_info.payment_change_pretty,
        paperWidth
      );
    }

    tpl += PrintTemplate.getLine(paperWidth);
    tpl += ESC_COMMANDS.EOL;
    tpl += ESC_COMMANDS.LF;

    tpl_data.push(tpl);
    tpl_all += tpl;
    tpl = "";

    let item_rows = 0;

    if (Object.keys(order_items).length > 0) {
      Object.entries(order_items).forEach(([key, items]) => {
        if (items.price.discount > 0) {
          tpl += PrintTemplate.leftRightData(
            items.qty + " x" + items.item_name,
            items.price.pretty_total_after_discount,
            paperWidth
          );

          if (!APIinterface.empty(items.price.size_name)) {
            tpl += items.price.size_name;
            tpl += ESC_COMMANDS.EOL;
          }

          tpl +=
            items.price.pretty_price +
            " " +
            items.price.pretty_price_after_discount;
          tpl += ESC_COMMANDS.EOL;
        } else {
          tpl += PrintTemplate.leftRightData(
            items.qty + " x" + items.item_name,
            items.price.pretty_total,
            paperWidth
          );

          if (!APIinterface.empty(items.price.size_name)) {
            tpl += items.price.size_name;
            tpl += ESC_COMMANDS.EOL;
          }

          tpl += items.price.pretty_price;
          tpl += ESC_COMMANDS.EOL;
        }

        // special_instructions
        if (items.special_instructions != "") {
          tpl += items.special_instructions;
          tpl += ESC_COMMANDS.EOL;
        }

        // attributes
        console.log("attributes=>");
        if (items.attributes != "") {
          Object.entries(items.attributes).forEach(([keyatt, itemsatt]) => {
            Object.entries(itemsatt).forEach(([keyatt1, itemsatt1]) => {
              tpl += itemsatt1;
              tpl += ESC_COMMANDS.EOL;
            });
          });
        }

        // addon
        if (Object.keys(items.addons).length > 0) {
          Object.entries(items.addons).forEach(([keyaddon, addons]) => {
            tpl += addons.subcategory_name.trim();
            tpl += ESC_COMMANDS.EOL;
            Object.entries(addons.addon_items).forEach(
              ([keyaddonitems, addon_items]) => {
                tpl += PrintTemplate.leftRightData(
                  addon_items.qty + " x" + addon_items.sub_item_name,
                  addon_items.pretty_addons_total,
                  paperWidth
                );
                tpl += addon_items.pretty_price;
              }
            );
          });
          tpl += ESC_COMMANDS.EOL;
        }

        //tpl += ESC_COMMANDS.EOL;

        //
        item_rows++;
        console.log("items->" + item_rows);
        if (item_rows >= 3) {
          tpl_data.push(tpl);
          tpl_all += tpl;
          tpl = "";
          item_rows = -1;
        }
      });
    }

    tpl_data.push(tpl);
    tpl_all += tpl;
    tpl = "";

    //tpl += ESC_COMMANDS.EOL;
    tpl += PrintTemplate.getLine(paperWidth);
    tpl += ESC_COMMANDS.EOL;
    tpl += ESC_COMMANDS.LF;

    // SUMMARY
    //tpl += ESC_COMMANDS.TEXT_FORMAT.TXT_BOLD_ON;
    if (Object.keys(order_summary).length > 0) {
      Object.entries(order_summary).forEach(([key, items]) => {
        tpl += PrintTemplate.leftRightData(items.name, items.value, paperWidth);
      });
    }
    //tpl += ESC_COMMANDS.TEXT_FORMAT.TXT_BOLD_OFF;

    tpl += ESC_COMMANDS.EOL;
    tpl += PrintTemplate.getLine(paperWidth);
    tpl += ESC_COMMANDS.EOL;
    tpl += ESC_COMMANDS.LF;

    tpl += PrintTemplate.centerData("THANK YOU!", paperWidth);
    tpl += ESC_COMMANDS.EOL;

    tpl += ESC_COMMANDS.LF;
    tpl += ESC_COMMANDS.LF;

    //    tpl += ESC_COMMANDS.PAPER.PAPER_FULL_CUT;

    tpl_data.push(tpl);
    tpl_all += tpl;
    tpl = "";

    return {
      tpl_all: tpl_all,
      tpl_data: tpl_data,
    };
  },
  centerData(string, paperWidth) {
    let totalPad = paperWidth - string.length;
    totalPad = totalPad / 2;
    let RowItems = "";
    RowItems = PrintTemplate.strPad(
      "",
      parseInt(totalPad),
      "*",
      "STR_PAD_LEFT"
    );
    RowItems += string;
    RowItems += PrintTemplate.strPad(
      "",
      parseInt(totalPad),
      "*",
      "STR_PAD_RIGHT"
    );
    return RowItems;
  },

  leftRightData(string1, string2, paperWidth) {
    string1 = APIinterface.empty(string1) ? "" : string1;
    string2 = APIinterface.empty(string2) ? "" : string2;

    const lines = [];
    const maxLeftWidth = paperWidth - string2.length;

    if (string1.length > maxLeftWidth) {
      // Split string1 into lines that fit
      for (let i = 0; i < string1.length; i += maxLeftWidth) {
        let part = string1.substring(i, i + maxLeftWidth);
        lines.push(part);
      }

      // Add string2 on the last line
      for (let i = 0; i < lines.length; i++) {
        if (i === lines.length - 1) {
          // Pad last line to align string2 to the right
          const padLength = paperWidth - (lines[i].length + string2.length);
          let row =
            lines[i] + " ".repeat(padLength > 0 ? padLength : 0) + string2;
          lines[i] = row;
        }
      }
    } else {
      // Normal case: single line with padding
      const padLength = paperWidth - (string1.length + string2.length);
      let row = string1 + " ".repeat(padLength > 0 ? padLength : 0) + string2;
      lines.push(row);
    }

    return lines.join(ESC_COMMANDS.LF) + ESC_COMMANDS.LF;
  },

  strPad(str, pad_length, pad_string, pad_type) {
    var len = pad_length - str.length;
    if (len < 0) return str;
    var pad = new Array(len + 1).join(pad_string);
    if (pad_type == "STR_PAD_LEFT") return pad + str;
    return str + pad;
  },
  getPaperLenght(paperWidth) {
    if (paperWidth == "58") {
      return 31;
    } else return 45;
  },
  getLine(paperWidth) {
    let Line = "-";
    return Line.repeat(paperWidth);
  },
  DailySales(paper_width, restaurant_name, sub_title, data) {
    let paperWidth = PrintTemplate.getPaperLenght(paper_width);

    let tpl = "";
    let tpl_all = "";
    let tpl_data = [];

    tpl += ESC_COMMANDS.LF;
    tpl += ESC_COMMANDS.TEXT_FORMAT.TXT_ALIGN_CT;
    tpl += restaurant_name;
    tpl += ESC_COMMANDS.EOL;
    tpl += sub_title;
    tpl += ESC_COMMANDS.EOL;
    tpl += PrintTemplate.getLine(paperWidth);
    tpl += ESC_COMMANDS.EOL;
    tpl += ESC_COMMANDS.LF;
    tpl += ESC_COMMANDS.TEXT_FORMAT.TXT_ALIGN_LT;

    tpl_data.push(tpl);
    tpl_all += tpl;
    tpl = "";

    let item_rows = 0;

    if (Object.keys(data).length > 0) {
      Object.entries(data).forEach(([key, items]) => {
        tpl += items.payment_name;
        tpl += ESC_COMMANDS.EOL;

        tpl += PrintTemplate.leftRightData(
          "Delivery Fee",
          items.delivery_fee,
          paperWidth
        );
        tpl += PrintTemplate.leftRightData("Tax", items.tax_total, paperWidth);
        tpl += PrintTemplate.leftRightData(
          "Tips",
          items.courier_tip,
          paperWidth
        );
        tpl += PrintTemplate.leftRightData("Total", items.total, paperWidth);

        tpl += ESC_COMMANDS.EOL;
        tpl += ESC_COMMANDS.EOL;
        //

        item_rows++;
        if (item_rows >= 3) {
          tpl_data.push(tpl);
          tpl_all += tpl;
          tpl = "";
          item_rows = -1;
        }
      });
    }

    tpl += ESC_COMMANDS.EOL;
    tpl += PrintTemplate.getLine(paperWidth);

    tpl += ESC_COMMANDS.LF;
    tpl += ESC_COMMANDS.TEXT_FORMAT.TXT_ALIGN_CT;
    tpl += "*** END OF SALES REPORT ***";
    tpl += ESC_COMMANDS.EOL;
    tpl += ESC_COMMANDS.LF;
    tpl += ESC_COMMANDS.TEXT_FORMAT.TXT_ALIGN_LT;

    tpl_data.push(tpl);
    tpl_all += tpl;
    tpl = "";
    return {
      tpl_all: tpl_all,
      tpl_data: tpl_data,
    };
  },
  centerText(context, Text, lineY, maxLineWidth, itemHeight) {
    var lines = [];
    var words = Text.split(" ");
    var currentLine = words[0];

    for (var i = 1; i < words.length; i++) {
      var testLine = currentLine + " " + words[i];
      var testLineWidth = context.measureText(testLine).width;

      if (testLineWidth > maxLineWidth) {
        lines.push(currentLine);
        currentLine = words[i];
      } else {
        currentLine = testLine;
      }
    }
    lines.push(currentLine);

    let textWidth = 0;
    let lineX = 0;
    Object.entries(lines).forEach(([key, items]) => {
      textWidth = context.measureText(items).width;
      lineX = (maxLineWidth - textWidth) / 2;
      context.fillText(items, lineX, lineY);
      lineY += itemHeight;
    });
    return lines;
  },
  longText(context, Text, lineY, maxLineWidth, itemHeight) {
    context.textAlign = "left";
    var lines = [];
    var words = Text.split(" ");
    var currentLine = words[0];

    for (var i = 1; i < words.length; i++) {
      var testLine = currentLine + " " + words[i];
      var testLineWidth = context.measureText(testLine).width;

      if (testLineWidth > maxLineWidth) {
        lines.push(currentLine);
        currentLine = words[i];
      } else {
        currentLine = testLine;
      }
    }
    lines.push(currentLine);

    let lineX = 0;
    Object.entries(lines).forEach(([key, items]) => {
      context.fillText(items, lineX, lineY);
      lineY += itemHeight;
    });
    return lines;
  },
  async TableColumn(context, data, CanvasWidth, InitialY, itemHeight) {
    let promise = new Promise((resolve, reject) => {
      let lineY = InitialY;
      let lineX = 0;
      let Count = 0;
      Object.entries(data).forEach(([key, items]) => {
        lineY += itemHeight;

        context.textAlign = "left";
        let words = items.label.split(" ");
        let line = "";
        for (let n = 0; n < words.length; n++) {
          const testLine = line + words[n] + " ";
          const metrics = context.measureText(testLine);
          const testWidth = metrics.width;
          if (testWidth > CanvasWidth - 150 && n > 0) {
            Count++;
            context.fillText(line, lineX, lineY);
            line = words[n] + " ";
            lineY += itemHeight; // Adjust the line height
          } else {
            line = testLine;
          }
        }
        context.fillText(line, lineX, lineY);
        Count++;

        // VALUE
        context.textAlign = "right";
        //words = items.value.split(" ");
        words = String(items.value || "").split(" ");
        line = "";
        for (let n = 0; n < words.length; n++) {
          const testLine = line + words[n] + " ";
          const metrics = context.measureText(testLine);
          const testWidth = metrics.width;
          if (testWidth > CanvasWidth - 150 && n > 0) {
            Count++;
            context.fillText(line, CanvasWidth, lineY);
            line = words[n] + " ";
            lineY += itemHeight; // Adjust the line height
          } else {
            line = testLine;
          }
        }
        context.fillText(line, CanvasWidth, lineY);
        ///
      });
      context.textAlign = "left";
      resolve(Count);
    });
    return await promise;
  },
  async TableColumnCount(context, data, CanvasWidth, InitialY, itemHeight) {
    let promise = new Promise((resolve, reject) => {
      let lineY = InitialY;
      let lineX = 0;
      let Count = 0;
      Object.entries(data).forEach(([key, items]) => {
        lineY += itemHeight;

        //context.textAlign = "left";
        let words = items.label.split(" ");

        let line = "";
        for (let n = 0; n < words.length; n++) {
          const testLine = line + words[n] + " ";
          const metrics = context.measureText(testLine);
          const testWidth = metrics.width;
          //console.log(testWidth + " => " + testLine);
          if (testWidth > CanvasWidth - 290 && n > 0) {
            Count++;
            //context.fillText(line, lineX, lineY);
            line = words[n] + " ";
            lineY += itemHeight; // Adjust the line height
          } else {
            line = testLine;
          }
        }
        //context.fillText(line, lineX, lineY);
        Count++;

        // VALUE
        //context.textAlign = "right";
        //words = items.value.split(" ");
        words = String(items.value || "").split(" ");
        line = "";
        for (let n = 0; n < words.length; n++) {
          const testLine = line + words[n] + " ";
          const metrics = context.measureText(testLine);
          const testWidth = metrics.width;
          if (testWidth > CanvasWidth - 290 && n > 0) {
            Count++;
            //context.fillText(line, CanvasWidth, lineY);
            line = words[n] + " ";
            lineY += itemHeight; // Adjust the line height
          } else {
            line = testLine;
          }
        }
        //context.fillText(line, CanvasWidth, lineY);
        ///
      });
      //context.textAlign = "left";
      resolve(Count);
    });
    return await promise;
  },
  drawText(context, text, x, y, maxWidth) {
    const words = text.split(" ");
    let line = "";
    for (let n = 0; n < words.length; n++) {
      const testLine = line + words[n] + " ";
      const metrics = context.measureText(testLine);
      const testWidth = metrics.width;
      if (testWidth > maxWidth && n > 0) {
        context.fillText(line, x, y);
        line = words[n] + " ";
        y += 25; // Adjust the line height
      } else {
        line = testLine;
      }
    }
    context.fillText(line, x, y);
  },
  drawLine(context, CanvasWidth, lineY) {
    context.beginPath();
    context.moveTo(0, lineY);
    context.lineTo(CanvasWidth, lineY);
    context.lineWidth = 2;
    context.stroke();
  },
  drawSpace(context, CanvasWidth, lineY) {
    context.fillText("\n", 0, lineY);
  },
  countText(context, Text, maxLineWidth) {
    var lines = [];
    var words = Text.split(" ");
    var currentLine = words[0];

    for (var i = 1; i < words.length; i++) {
      var testLine = currentLine + " " + words[i];
      var testLineWidth = context.measureText(testLine).width;

      if (testLineWidth > maxLineWidth) {
        lines.push(currentLine);
        currentLine = words[i];
      } else {
        currentLine = testLine;
      }
    }
    lines.push(currentLine);
    return lines;
  },

  centerText2(context, Text, lineY, maxLineWidth, itemHeight) {
    const lines = [];
    const words = Text.split(" ");
    let currentLine = words[0];

    for (let i = 1; i < words.length; i++) {
      const testLine = currentLine + " " + words[i];
      const testLineWidth = context.measureText(testLine).width;

      if (testLineWidth > maxLineWidth) {
        lines.push(currentLine);
        currentLine = words[i];
      } else {
        currentLine = testLine;
      }
    }
    lines.push(currentLine);

    // Measure max width of all lines
    let maxTextWidth = 0;
    lines.forEach((line) => {
      const w = context.measureText(line).width;
      if (w > maxTextWidth) maxTextWidth = w;
    });

    // Calculate starting X based on maxTextWidth for centering
    const startX = (maxLineWidth - maxTextWidth) / 2;
    const startY = lineY;

    // Draw each line
    lines.forEach((line, index) => {
      const lineWidth = context.measureText(line).width;
      const lineX = (maxLineWidth - lineWidth) / 2;
      context.fillText(line, lineX, lineY);
      lineY += itemHeight;
    });

    // Draw border around all lines
    const padding = 10;
    const totalHeight = lines.length * itemHeight;
    context.strokeRect(
      startX - padding,
      startY - itemHeight + 5, // slight adjustment to top
      maxTextWidth + padding * 2,
      totalHeight
    );

    return lines;
  },

  //
};
export default PrintTemplate;
