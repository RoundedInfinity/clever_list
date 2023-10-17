import 'package:clever_list/clever_list.dart';
import 'package:flutter/material.dart';

class MovableListPage extends StatefulWidget {
  const MovableListPage({super.key});

  @override
  State<MovableListPage> createState() => _MovableListPageState();
}

class _MovableListPageState extends State<MovableListPage> {
  List<int> items = [0, 1, 2, 3];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movable List'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                items = [0, 1, 2, 3];
              });
            },
            icon: const Icon(Icons.move_down_rounded),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                items = [0, 1, 3, 2];
              });
            },
            icon: const Icon(Icons.move_up_rounded),
          ),
        ],
      ),
      body: MovableCleverList(
        items: items,
        builder: (context, value) {
          return ListTile(
            title: Text('Item $value'),
          );
        },
      ),
    );
  }
}
