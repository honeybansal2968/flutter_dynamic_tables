
# Flutter Dynamic Tables

Flutter Dynamic Tables package lets you add a beautiful and dynamic tables to your Flutter app.

## Installation 

1. Add the latest version of package to your pubspec.yaml (and run`dart pub get`):
```yaml
dependencies:
  flutter_dynamic_tables: ^0.0.1
```
2. Import the package and use it in your Flutter App.
```dart
import 'package:flutter_dynamic_tables/flutter_dynamic_tables.dart';
```

## Example
There are a number of properties that you can modify:

  - columnWidth;
  - tableHeight;
  - tableColor;
  - columnColor;
  - cellColor;

<hr>

<table>
<tr>
<td>

```dart
class TableWidget extends StatelessWidget {  
  const TableWidget({Key? key}) : super(key: key);  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(
      body: Center(  
        child: const DynamicTable(  
          columnWidth = 100,
          tableHeight = 500,
          tableColor = const Color.fromARGB(255, 141, 255, 144),
          columnColor = const Color.fromARGB(255, 255, 255, 255),
          cellColor = const Color.fromARGB(255, 255, 255, 255)
        ),  
      ),  
    );  
  }  
}
```

</td>
<td>
<img  src="https://raw.githubusercontent.com/honeybansal2968/portfolio/main/dynamic_table_example.png"  alt="">
</td>
</tr>
</table>
