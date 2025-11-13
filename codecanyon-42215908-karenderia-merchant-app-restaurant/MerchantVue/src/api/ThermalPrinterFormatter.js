import ThermalPrinterEncoder from "thermal-printer-encoder";

const ThermalPrinterFormatter = {
  //
  Print(printerSettings, Headers, Items, Footer, canvas) {
    const print_type = printerSettings.print_type;
    return ThermalPrinterFormatter.PrintImage(
      printerSettings,
      Headers,
      Items,
      Footer,
      canvas
    );
  },

  /*
  functions for print esc/pos command
  */
  PrintRaw(printerSettings, Headers, Items, Footer) {
    const page_width = printerSettings.page_width;
    let tableLeftWidth, tableRightWidth;
    let paperWidth = null;
    if (page_width == 58) {
      paperWidth = 32;
      tableLeftWidth = 19;
      tableRightWidth = 13;
    } else {
      paperWidth = 42;
      tableLeftWidth = 28;
      tableRightWidth = 14;
    }

    let encoder = new ThermalPrinterEncoder({
      language: "esc-pos",
      width: paperWidth,
    });

    let rows = 4;
    let chunked_data = [];
    const chunked = [];

    // HEADERS
    if (Object.keys(Headers).length > 0) {
      for (let i = 0; i < Headers.length; i += rows) {
        chunked_data = Headers.slice(i, i + rows);
        let data = encoder.initialize();
        data = ThermalPrinterFormatter.prepareRawPrint(
          chunked_data,
          data,
          paperWidth,
          tableLeftWidth,
          tableRightWidth
        );
        data = data.encode();
        chunked.push(data);
      }
    }

    // ITEMS
    if (Object.keys(Items).length > 0) {
      for (let i = 0; i < Items.length; i += rows) {
        chunked_data = Items.slice(i, i + rows);
        let data = encoder.initialize();
        data = ThermalPrinterFormatter.prepareRawPrint(
          chunked_data,
          data,
          paperWidth,
          tableLeftWidth,
          tableRightWidth
        );
        data = data.encode();
        chunked.push(data);
      }
    }

    // FOOTER
    if (Object.keys(Footer).length > 0) {
      for (let i = 0; i < Footer.length; i += rows) {
        chunked_data = Footer.slice(i, i + rows);
        let data = encoder.initialize();
        data = ThermalPrinterFormatter.prepareRawPrint(
          chunked_data,
          data,
          paperWidth,
          tableLeftWidth,
          tableRightWidth
        );
        data = data.encode();
        chunked.push(data);
      }
    }

    return chunked;
  },

  prepareRawPrint(
    data,
    encodedData,
    paperWidth,
    tableLeftWidth,
    tableRightWidth
  ) {
    if (Object.keys(data).length > 0) {
      Object.entries(data).forEach(([key, items]) => {
        let commandType = items.type;
        let position = items.position;

        if (position == "center") {
          encodedData = encodedData.align("center");
        } else if (position == "left") {
          encodedData = encodedData.align("left");
        } else if (position == "left_right_text") {
          encodedData = encodedData.align("left");
        }

        switch (commandType) {
          case "font":
            let is_bold = items.font_type == "bold" ? true : false;
            encodedData = encodedData.bold(is_bold);
            break;

          case "text":
            let value = items.value;
            if (position == "left_right_text") {
              let label = items.label;
              let value_length = value.length;
              let label_length = label.length;

              if (value_length > tableRightWidth) {
                encodedData = encodedData.line(label);
                encodedData = encodedData.line(value);
              } else {
                encodedData = encodedData.table(
                  [
                    { width: tableLeftWidth, align: "left" },
                    { width: tableRightWidth, align: "right" },
                  ],
                  [[label, value]]
                );
              }
            } else {
              encodedData = encodedData.line(value);
            }
            break;

          case "line_break":
            encodedData = encodedData.newline();
            break;

          case "line_break_big":
            encodedData = encodedData.newline().newline();
            break;

          case "qrcode":
            let qrcode_value = items.value;
            encodedData = encodedData.qrcode(qrcode_value);
            break;

          case "dotted_line":
            let dotte_char = items.value;
            encodedData = encodedData.line(dotte_char.repeat(paperWidth));
            break;
        }
        //
      });
    }
    return encodedData;
  },
  ///

  PrintImage(printerSettings, Headers, Items, Footer, canvas) {
    const page_width = printerSettings.paper_width;
    let paperWidth = null;
    let printerPaperWidth = null;
    if (page_width == 58) {
      printerPaperWidth = 32;
      paperWidth = 585;
    } else {
      printerPaperWidth = 42;
      paperWidth = 685;
    }

    let maxLineWidth = paperWidth;
    maxLineWidth = maxLineWidth == 585 ? 395 : 498;

    let itemHeight = 25;

    let context = canvas.getContext("2d");
    context.clearRect(0, 0, canvas.width, canvas.height);

    let canvasHeight =
      Headers.length * itemHeight +
      Items.length * itemHeight +
      Footer.length * itemHeight;
    canvas.height = canvasHeight + itemHeight * 3;
    canvas.width = paperWidth;

    context.fillStyle = "#ffffff";
    context.fillRect(0, 0, canvas.width, canvas.height);
    context.strokeStyle = "#000000";
    context.lineWidth = 1;
    context.fillStyle = "#000000";
    //context.font = "700 32px Arial";
    context.font = "400 24px Arial";

    let lineY = itemHeight;

    // HEADERS
    lineY = ThermalPrinterFormatter.prepareCanvas(
      Headers,
      context,
      lineY,
      maxLineWidth,
      itemHeight,
      paperWidth
    );

    lineY = ThermalPrinterFormatter.prepareCanvas(
      Items,
      context,
      lineY,
      maxLineWidth,
      itemHeight,
      paperWidth
    );

    lineY = ThermalPrinterFormatter.prepareCanvas(
      Footer,
      context,
      lineY,
      maxLineWidth,
      itemHeight,
      paperWidth
    );

    let image = canvas.toDataURL("image/png");
    return image;
  },

  prepareCanvas(data, context, lineY, maxLineWidth, itemHeight, paperWidth) {
    if (Object.keys(data).length > 0) {
      Object.entries(data).forEach(async ([key, items]) => {
        let commandType = items.type;
        let position = items.position;
        let textLenght = null;
        let dataLenght = null;

        switch (commandType) {
          case "font":
            let is_bold = items.font_type == "bold" ? true : false;
            if (is_bold) {
              context.font = "700 32px Arial";
            } else {
              context.font = "400 24px Arial";
              //context.font = "400 27px Arial";
            }
            break;
          case "text":
            let value = items.value;
            if (position == "center") {
              textLenght = ThermalPrinterFormatter.centerText(
                context,
                value,
                lineY,
                maxLineWidth,
                itemHeight
              );
              for (let i = 0; i < textLenght.length; i++) {
                lineY += itemHeight;
              }
            } else if (position == "left_right_text") {
              let data_items = [
                {
                  label: items.label,
                  value: value,
                },
              ];

              dataLenght = ThermalPrinterFormatter.TableColumn(
                context,
                data_items,
                maxLineWidth,
                lineY,
                itemHeight
              );
              lineY += itemHeight * dataLenght;
            } else {
              textLenght = ThermalPrinterFormatter.Text(
                context,
                value,
                lineY,
                maxLineWidth,
                itemHeight
              );
              for (let i = 0; i < textLenght.length; i++) {
                lineY += itemHeight;
              }
              //lineY += itemHeight;
            }
            break;
          case "line_break_big":
            lineY += itemHeight;
            lineY += itemHeight;
            break;
          case "line_break":
            lineY += itemHeight;
            break;
          case "dotted_line":
            let dotte_char = items.value;
            textLenght = ThermalPrinterFormatter.Text(
              context,
              dotte_char.repeat(paperWidth),
              lineY,
              maxLineWidth,
              itemHeight
            );
            for (let i = 0; i < textLenght.length; i++) {
              lineY += itemHeight;
            }
            break;

          case "box_text":
            let box_text = items.value;
            textLenght = ThermalPrinterFormatter.centerText2(
              context,
              box_text,
              lineY,
              maxLineWidth,
              itemHeight
            );
            for (let i = 0; i < textLenght.length; i++) {
              lineY += itemHeight;
            }
            break;

          case "logo":
            const logoHeight = await ThermalPrinterFormatter.drawLogo(
              context,
              items.src,
              lineY,
              paperWidth,
              itemHeight,
              {
                width: items.width,
                height: items.height,
                spacing: 20, // extra space below logo
              }
            );
            lineY += logoHeight;
            break;
        }
      });
    }
    return lineY;
  },

  Text(context, Text, lineY, maxLineWidth, itemHeight) {
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
  drawSpace(context, CanvasWidth, lineY) {
    context.fillText("\n", 0, lineY);
  },
  drawLine(context, CanvasWidth, lineY) {
    context.beginPath();
    context.moveTo(0, lineY);
    context.lineTo(CanvasWidth, lineY);
    context.lineWidth = 2;
    context.stroke();
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

  // centerText2(context, Text, lineY, maxLineWidth, itemHeight) {
  //   var lines = [];
  //   var words = Text.split(" ");
  //   var currentLine = words[0];

  //   for (var i = 1; i < words.length; i++) {
  //     var testLine = currentLine + " " + words[i];
  //     var testLineWidth = context.measureText(testLine).width;

  //     if (testLineWidth > maxLineWidth) {
  //       lines.push(currentLine);
  //       currentLine = words[i];
  //     } else {
  //       currentLine = testLine;
  //     }
  //   }
  //   lines.push(currentLine);

  //   let textWidth = 0;
  //   let lineX = 0;
  //   Object.entries(lines).forEach(([key, items]) => {
  //     textWidth = context.measureText(items).width;
  //     lineX = (maxLineWidth - textWidth) / 2;
  //     context.fillText(items, lineX, lineY);
  //     lineY += itemHeight;
  //   });
  //   context.strokeRect(lineX - 10, lineY - 50, textWidth + 5 * 5, 35);
  //   return lines;
  // },

  TableColumn(context, data, CanvasWidth, InitialY, itemHeight) {
    //let promise = new Promise((resolve, reject) => {
    let lineY = InitialY;
    let lineX = 0;
    let Count = 0;
    Object.entries(data).forEach(([key, items]) => {
      //lineY += itemHeight;

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
      words = items.value.split(" ");
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
    //resolve(Count);
    return Count;
    //});
    //return await promise;
  },

  async drawLogo(context, src, lineY, paperWidth, itemHeight, options = {}) {
    return new Promise((resolve, reject) => {
      const img = new Image();
      img.onload = () => {
        let newWidth, newHeight;

        if (options.width && options.height) {
          // Use custom size
          newWidth = options.width;
          newHeight = options.height;
        } else {
          // Auto scale
          const maxWidth = paperWidth - 40;
          const scale = Math.min(maxWidth / img.width, 1);
          newWidth = img.width * scale;
          newHeight = img.height * scale;
        }

        // ✅ Center image horizontally
        const x = (paperWidth - newWidth) / 2;

        context.drawImage(img, x, lineY, newWidth, newHeight);

        // Add bottom margin (1 line spacing by default)
        const extraSpacing = options.spacing || itemHeight;

        resolve(newHeight + extraSpacing);
      };
      img.onerror = reject;
      img.src = src;
    });
  },

  //
};
export default ThermalPrinterFormatter;
