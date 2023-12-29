/// Main features:
/// 1. Add or remove or update columns
/// 2. Add or remove or update rows
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'table/app_colors.dart';
import 'table/table_controller.dart';

class DynamicTable extends StatelessWidget {
  final double columnWidth;
  final double tableHeight;
  final Color tableColor;
  final String tableTitle;
  final Color columnColor;
  final Color cellColor;
  final List<String> columns;
  final List rows;
  final Function? onColumnAdd;
  final Function? onColumnDelete;
  final Function? onColumnEdit;
  final Function? onRowAdd;
  final Function? onRowEdit;
  final Function? onRowDelete;
  final bool tableReadOnly;
  final TextStyle tableTitleStyle;
  const DynamicTable(
      {super.key,
      required this.tableTitle,
      this.tableTitleStyle = const TextStyle(fontWeight: FontWeight.bold),
      this.tableReadOnly = false,
      this.columnWidth = 100,
      this.tableHeight = 500,
      this.tableColor = const Color.fromARGB(255, 141, 255, 144),
      this.columnColor = const Color.fromARGB(255, 255, 255, 255),
      this.cellColor = const Color.fromARGB(255, 255, 255, 255),
      this.columns = const [],
      this.onColumnAdd,
      this.onColumnDelete,
      this.onColumnEdit,
      this.onRowAdd,
      this.onRowEdit,
      this.onRowDelete,
      this.rows = const []});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<TableController>(
        init: TableController(
            columns: columns, tableMatrix: rows, columnWidth: columnWidth),
        builder: (controller) {
          return SizedBox(
            height: tableHeight,
            width: size.width,
            child: SingleChildScrollView(
                child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 40,
                      decoration: BoxDecoration(color: tableColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          "Enterprise Table",
                          style: tableTitleStyle,
                        ),
                      ),
                    ),
                    tableReadOnly
                        ? Container()
                        : Positioned(
                            right: 110,
                            top: 10,
                            child: InkWell(
                                onTap: () {
                                  AddNewColumnDialog(context, onColumnAdd);
                                },
                                child: const Row(
                                  children: [
                                    Icon(Icons.view_column_rounded),
                                    Text("Add Column")
                                  ],
                                )),
                          ),
                    tableReadOnly
                        ? Container()
                        : Positioned(
                            right: 20,
                            top: 10,
                            child: InkWell(
                                onTap: () {
                                  controller.columns.isNotEmpty
                                      ? AddNewRowDialog(context, columnWidth,
                                          onRowAdd ?? () {})
                                      : () {};
                                },
                                child: controller.columns.isNotEmpty
                                    ? const Row(
                                        children: [
                                          Icon(Icons.table_rows),
                                          Text("Add Row")
                                        ],
                                      )
                                    : const Row(
                                        children: [
                                          Icon(
                                            Icons.table_rows,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            "Add Row",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        ],
                                      )),
                          ),
                  ],
                ),
                // columns
                Row(
                  children: [
                    Row(
                      children: List.generate(
                          controller.columns.length,
                          (index) => TableColumn(
                              columnColor: columnColor,
                              title: controller.columns[index],
                              columnWidth: columnWidth)),
                    ),
                    tableReadOnly
                        ? Container()
                        : controller.columns.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  controller.deletedColumns.clear();
                                  AddEditColumnDialog(
                                      context,
                                      onColumnEdit ?? () {},
                                      onColumnDelete ?? () {});
                                },
                                icon: const Icon(Icons.edit))
                            : Container()
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                          controller.tableMatrix.length,
                          (index) => Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                    controller.columns.length, (innerindex) {
                                  // get max height from controller.rowsHeight[index]

                                  double height = 20;
                                  for (var i = 0;
                                      i < controller.rowsHeight[index].length;
                                      i++) {
                                    height = max(height,
                                        controller.rowsHeight[index][i]);
                                  }
                                  return TableCell(
                                      height: height,
                                      cellColor: cellColor,
                                      title: controller.tableMatrix[index]
                                          [innerindex],
                                      columnWidth: columnWidth);
                                }),
                              )),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: List.generate(
                    //       controller.columns.length,
                    //       (index) => ColumnRowWidget(
                    //           columnTitle: controller.columns[index],
                    //           columnIndex: index)),
                    // ),
                    tableReadOnly
                        ? Container()
                        : Column(
                            children: List.generate(
                                controller.tableMatrix.length,
                                (index) => Padding(
                                      padding: const EdgeInsets.only(top: 0),
                                      child: Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                AddEditRowDialog(
                                                    context,
                                                    index,
                                                    columnWidth,
                                                    onRowEdit ?? () {});
                                              },
                                              icon: const Icon(Icons.edit)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                controller.removeRow(index);
                                                onRowDelete ?? () {};
                                              },
                                              icon: const Icon(Icons.delete))
                                        ],
                                      ),
                                    )),
                          ),
                  ],
                )
              ],
            )),
          );
        });
  }
}

double calculateContainerHeight(double containerWidth, String text) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: const TextStyle(fontSize: 14.0), // Adjust the font size as needed
    ),
    textDirection: TextDirection.ltr,
  );

  textPainter.layout(maxWidth: containerWidth);
  return textPainter.height;
}

class TableColumn extends StatelessWidget {
  const TableColumn(
      {super.key,
      required this.title,
      required this.columnWidth,
      required this.columnColor});
  final String title;
  final double columnWidth;
  final Color columnColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
          width: columnWidth,
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: const Color.fromARGB(255, 94, 94, 94)),
              color: columnColor),
          child: Text(title,
              overflow: TextOverflow.clip,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
              ))),
    );
  }
}

class TableCell extends StatelessWidget {
  const TableCell(
      {super.key,
      required this.title,
      required this.height,
      required this.columnWidth,
      required this.cellColor});
  final String title;
  final double height;
  final double columnWidth;
  final Color cellColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: cellColor,
          border: Border.all(
              width: 1, color: const Color.fromARGB(255, 92, 92, 92)),
        ),
        width: columnWidth,
        height: height + 15,
        child: Text(
          title,
          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
      ),
    );
  }
}

// class ColumnRowWidget extends StatelessWidget {
//   const ColumnRowWidget(
//       {super.key, required this.columnTitle, required this.columnIndex});
//   final String columnTitle;
//   final int columnIndex;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         TableColumn(title: columnTitle),
//         GetBuilder<TableController>(builder: (controller) {
//           return Column(
//             children: List.generate(
//                 controller.tableMatrix.length,
//                 (index) => TableCell(
//                     title: controller.tableMatrix[index][columnIndex])),
//           );
//         })
//       ],
//     );
//   }
// }

AddNewColumnDialog(context, onColumnAdd) {
  TextEditingController columnNameController = TextEditingController();
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
              content: GetBuilder<TableController>(builder: (controller) {
            int insertIndex = controller.columns.length;
            return Container(
              height: 210,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                      child: Text("Add New Column",
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold, fontSize: 16))),
                  Column(
                    children: [
                      CustomField(
                        keyboardType: TextInputType.text,
                        controller: columnNameController,
                        FieldName: "Column Name",
                        hintText: "Column Name",
                      ),
                      StatefulBuilder(builder: (context, setstate) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Column Position",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold),
                            ),
                            DropdownButton(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                value: insertIndex,
                                items: List.generate(
                                    controller.columns.length + 1,
                                    (index) => DropdownMenuItem(
                                        value: index,
                                        child: Text("${index + 1}"))),
                                onChanged: (val) {
                                  setstate(() {
                                    insertIndex = (val as int);
                                  });
                                }),
                          ],
                        );
                      }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (columnNameController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text("Enter Column Name")));
                              return;
                            } else {
                              if (controller.columns.isEmpty) {
                                controller.addColumnAtIndex(
                                    0, columnNameController.text);
                              } else {
                                controller.addColumnAtIndex(
                                    insertIndex, columnNameController.text);
                              }
                              onColumnAdd();
                              Get.back();
                              return;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              backgroundColor: AppColors.primaryColor),
                          child: Text(
                            "Add",
                            style: GoogleFonts.roboto(color: Colors.white),
                          )),
                      ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              backgroundColor: AppColors.primaryColor),
                          child: Text("Cancel",
                              style: GoogleFonts.roboto(color: Colors.white)))
                    ],
                  )
                ],
              ),
            );
          })));
}

AddNewRowDialog(context, columnWidth, onAddRow) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
              content: GetBuilder<TableController>(builder: (controller) {
            List<TextEditingController> rowControllers = List.generate(
                controller.columns.length, (index) => TextEditingController());

            return SingleChildScrollView(
              child: Container(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      Center(
                          child: Text("Add New Row",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold, fontSize: 16))),
                      Column(
                        children: List.generate(
                          controller.columns.length,
                          (index) => CustomField(
                            keyboardType: TextInputType.text,
                            controller: rowControllers[index],
                            FieldName: controller.columns[index],
                            hintText: "Row Entry",
                          ),
                        ),
                      ),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              for (var i = 0; i < rowControllers.length; i++) {
                                if (rowControllers[i].text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text("Enter Row Name")));
                                  return;
                                }
                              }
                              List<double> rowheights = [];
                              for (var i = 0; i < rowControllers.length; i++) {
                                rowheights.add(calculateContainerHeight(
                                    columnWidth, rowControllers[i].text));
                              }
                              controller.addNewRowtoTableMatrix(
                                  List.generate(rowControllers.length,
                                      (index) => rowControllers[index].text),
                                  rowheights);
                              onAddRow();
                              Get.back();
                              return;
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                backgroundColor: AppColors.primaryColor),
                            child: Text("Add",
                                style:
                                    GoogleFonts.roboto(color: Colors.white))),
                        ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                backgroundColor: AppColors.primaryColor),
                            child: Text("Cancel",
                                style: GoogleFonts.roboto(color: Colors.white)))
                      ],
                    )
                  ],
                ),
              ),
            );
          })));
}

AddEditRowDialog(context, int index, columnWidth, onRowEdit) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
              content: GetBuilder<TableController>(builder: (controller) {
            List<TextEditingController> rowControllers = List.generate(
                controller.columns.length,
                (colindex) => TextEditingController(
                    text: controller.tableMatrix[index][colindex]));

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Center(
                          child: Text("Update Row",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold, fontSize: 16))),
                      Column(
                        children: List.generate(
                            controller.columns.length,
                            (index) => CustomField(
                                  keyboardType: TextInputType.text,
                                  controller: rowControllers[index],
                                  FieldName: controller.columns[index],
                                  hintText: "Row Entry",
                                )),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            for (var i = 0; i < rowControllers.length; i++) {
                              if (rowControllers[i].text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text("Enter Row Name")));
                                return;
                              }
                            }
                            try {
                              controller.editRowData(
                                  index,
                                  List.generate(rowControllers.length,
                                      (index) => rowControllers[index].text));
                              List<double> rowheights =
                                  controller.rowsHeight[index];
                              for (var i = 0;
                                  i < controller.columns.length;
                                  i++) {
                                rowheights[i] = calculateContainerHeight(
                                    columnWidth, rowControllers[i].text);
                                controller.editRowHeightData(index, rowheights);
                              }
                              onRowEdit();
                            } catch (e) {
                              print("error e: $e");
                            }

                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              backgroundColor: AppColors.primaryColor),
                          child: Text("Update",
                              style: GoogleFonts.roboto(color: Colors.white))),
                      ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              backgroundColor: AppColors.primaryColor),
                          child: Text("Cancel",
                              style: GoogleFonts.roboto(color: Colors.white)))
                    ],
                  )
                ],
              ),
            );
          })));
}

AddEditColumnDialog(context, onColumnEdit, onColumnDelete) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
              content: GetBuilder<TableController>(builder: (controller) {
            List<TextEditingController> columnControllers = List.generate(
                controller.columns.length,
                (colindex) =>
                    TextEditingController(text: controller.columns[colindex]));

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Center(
                          child: Text("Update Column",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold, fontSize: 16))),
                      Column(
                          children: List.generate(
                              columnControllers.length,
                              (index) => Row(
                                    children: [
                                      Container(
                                        width: 300,
                                        child: CustomField(
                                          keyboardType: TextInputType.text,
                                          controller: columnControllers[index],
                                          FieldName: controller.columns[index],
                                          readOnly: controller
                                                  .deletedColumns.isNotEmpty
                                              ? controller.deletedColumns
                                                      .contains(index)
                                                  ? true
                                                  : false
                                              : false,
                                          hintText: "Column Name",
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            // if current index is not in controller.deletedColumns, then add it to controller.deletedColumns
                                            if (controller
                                                .deletedColumns.isEmpty) {
                                              controller
                                                  .addToDeletedColumns(index);
                                            } else {
                                              if (!controller.deletedColumns
                                                  .contains(index)) {
                                                controller
                                                    .addToDeletedColumns(index);
                                              }
                                              // if current index is in controller.deletedColumns, then remove it from controller.deletedColumns
                                              else {
                                                controller
                                                    .removeFromDeletedColumns(
                                                        index);
                                              }
                                            }
                                          },
                                          icon: controller
                                                  .deletedColumns.isEmpty
                                              ? const Icon(Icons.delete)
                                              : controller.deletedColumns
                                                      .contains(index)
                                                  ? const Icon(
                                                      Icons.delete_forever)
                                                  : const Icon(Icons.delete))
                                    ],
                                  ))),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            for (var i = 0; i < columnControllers.length; i++) {
                              if (columnControllers[i].text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text("Enter Column Name")));
                                return;
                              }
                            }
                            controller.editColumn(List.generate(
                                columnControllers.length,
                                (index) => columnControllers[index].text));
                            onColumnEdit();
                            // when deletedColumns is not empty
                            if (controller.deletedColumns.isNotEmpty) {
                              for (var i = 0;
                                  i < controller.deletedColumns.length;
                                  i++) {
                                controller
                                    .removeColumn(controller.deletedColumns[i]);
                                onColumnDelete();
                              }
                            }

                            Get.back();
                            return;
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              backgroundColor: AppColors.primaryColor),
                          child: Text("Update",
                              style: GoogleFonts.roboto(color: Colors.white))),
                      ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              backgroundColor: AppColors.primaryColor),
                          child: Text("Cancel",
                              style: GoogleFonts.roboto(color: Colors.white)))
                    ],
                  )
                ],
              ),
            );
          })));
}

class CustomField extends StatelessWidget {
  final double? width;
  final String? FieldName;
  final TextInputType keyboardType;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool readOnly;
  const CustomField({
    Key? key,
    this.validator,
    this.width,
    this.FieldName,
    this.readOnly = false,
    required this.keyboardType,
    required this.controller,
    this.hintText,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      width: width,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          FieldName!,
          softWrap: true,
          style: GoogleFonts.getFont("Nunito",
              fontSize: 15, fontWeight: FontWeight.bold),
        ),
        TextFormField(
            readOnly: readOnly,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            keyboardType: keyboardType,
            cursorColor: Colors.black,
            cursorWidth: 1,
            validator: validator ??
                (val) {
                  return null;
                },
            decoration: InputDecoration(
                helperText: " ",
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xff0033ff),
                    width: 2.0,
                  ),
                ),
                contentPadding: const EdgeInsets.only(bottom: 7, left: 10),
                filled: true,
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 240, 8, 8),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.textFilledColor,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xff0033ff),
                    width: 2.0,
                  ),
                ),
                fillColor: readOnly
                    ? const Color.fromARGB(255, 172, 172, 172)
                    : AppColors.textFilledColor,
                hintText: hintText,
                hintStyle: const TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 195, 195, 195))))
      ]),
    );
  }
}
