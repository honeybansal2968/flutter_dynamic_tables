import 'package:flutter_dynamic_table/flutter_dynamic_table.dart';
import 'package:get/get.dart';

class TableController extends GetxController {
  TableController({
    required this.columns,
    this.tableMatrix = const [],
    required this.columnWidth,
  });
  double columnWidth;
  // columns list
  List columns = [];

  // edit column
  editColumn(List updatedColumns) {
    columns = updatedColumns;
    update();
  }

  // rows height matrix of each cell
  List<List<double>> rowsHeight = [];

  // add row height
  addRowsHeight(List<double> rowheights) {
    rowsHeight.add(rowheights);
    update();
  }

  //edit row height data using index
  editRowHeightData(int index, List<double> rowEntries) {
    rowsHeight[index] = rowEntries;
    update();
  }

  List<int> deletedColumns = [];
  addToDeletedColumns(int index) {
    deletedColumns.add(index);
    update();
  }

  removeFromDeletedColumns(int index) {
    deletedColumns.remove(index);
    update();
  }

  List tableMatrix = []; // length will == rows.length

  // when adding the column at the specified index
  addColumnAtIndex(int index, dynamic column) {
    if (columns.isEmpty) {
      columns.add(column);
      addNewColumntoTableMatrix(0);
    } else {
      columns.insert(index, column);
      addNewColumntoTableMatrix(index);
    }

    update();
  }

  addNewColumntoTableMatrix(int index) {
    for (int i = 0; i < tableMatrix.length; i++) {
      rowsHeight[i].insert(
          index,
          rowsHeight[i].reduce((currentMax, number) =>
              currentMax > number ? currentMax : number));
      tableMatrix[i].insert(index, "");
    }
    update();
  }

  // remove column
  removeColumn(int index) {
    columns.removeAt(index);
    // remove column from tableMatrix
    for (int i = 0; i < tableMatrix.length; i++) {
      tableMatrix[i].removeAt(index);
      rowsHeight[i].removeAt(index);
      if (tableMatrix[i].isEmpty) {
        tableMatrix.removeAt(i);
      }
    }
    update();
  }

  // remove row
  removeRow(int index) {
    tableMatrix.removeAt(index);
    rowsHeight.removeAt(index);
    update();
  }

  //when adding new row, a new list of empty entries will be added to tableMatrix
  addNewRowtoTableMatrix(List rowEntries, List<double> rowheights) {
    tableMatrix
        .add(List.generate(columns.length, (index) => rowEntries[index]));
    addRowsHeight(rowheights);
    update();
  }

  //edit row data using index
  editRowData(int index, List rowEntries) {
    tableMatrix[index] =
        List.generate(columns.length, (index) => rowEntries[index]);
    update();
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    List<List<double>> rowheightMatrix = [];
    for (var i = 0; i < tableMatrix.length; i++) {
      List<double> rowheights = [];
      for (var j = 0; j < tableMatrix[i].length; j++) {
        rowheights
            .add(calculateContainerHeight(columnWidth, tableMatrix[i][j]));
      }
      rowheightMatrix.add(rowheights);
    }
    rowsHeight = rowheightMatrix;

    update();
  }
}
