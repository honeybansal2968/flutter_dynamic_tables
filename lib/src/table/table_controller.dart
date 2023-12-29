import 'package:flutter_dynamic_table/flutter_dynamic_table.dart';
import 'package:get/get.dart';

class TableController extends GetxController {
  TableController({
    required this.columns,
    required this.tableMatrix,
    required this.columnWidth,
  });
  double columnWidth;
  // columns list
  List<String> columns;

  // edit column
  editColumn(List<String> updatedColumns) {
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

  List tableMatrix; // length will == rows.length

  // when adding the column at the specified index
  addColumnAtIndex(int index, String column) {
    columns.insert(index, column);
    addNewColumntoTableMatrix(index);
    update();
  }

  addNewColumntoTableMatrix(int index) {
    for (int i = 0; i < tableMatrix.length; i++) {
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
    // // manage rowsHeight when column is removed
    // for (int i = 0; i < rowsHeight.length; i++) {
    //   rowsHeight[i] = calculateContainerHeight(100, tableMatrix[i][index]);
    // }
    update();
  }

  // remove row
  removeRow(int index) {
    tableMatrix.removeAt(index);
    rowsHeight.removeAt(index);
    update();
  }

  //when adding new row, a new list of empty entries will be added to tableMatrix
  addNewRowtoTableMatrix(List<String> rowEntries, List<double> rowheights) {
    tableMatrix
        .add(List.generate(columns.length, (index) => rowEntries[index]));
    addRowsHeight(rowheights);
    update();
  }

  //edit row data using index
  editRowData(int index, List<String> rowEntries) {
    tableMatrix[index] =
        List.generate(columns.length, (index) => rowEntries[index]);
    update();
  }

  @override
  void onInit() {
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
