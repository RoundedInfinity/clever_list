import 'dart:math';

import 'package:flutter/material.dart';

import 'package:clever_list/clever_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CleverList Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // data object used to build the list.
  var persons = <Person>[
    Person(name: 'Bert', age: 64),
    Person(name: 'Martin', age: 43),
    Person(name: 'John', age: 29),
    Person(name: 'Albert', age: 25),
    Person(name: 'Mike', age: 15),
    Person(name: 'Mohammed', age: 54),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CleverList'),
        actions: [
          IconButton(
            onPressed: () {
              // Add an item to the list.
              setState(() {
                final list = List<Person>.from(persons);
                list.add(Person(name: 'peter', age: Random().nextInt(200)));
                persons = list;
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: CleverList<Person>(
        items: persons,
        builder: (context, value) {
          return ListTile(
            title: Text(
              value.name,
            ),
            onTap: () {
              setState(() {
                final list = List<Person>.from(persons);

                list.remove(value);
                persons = list;
              });
            },
          );
        },
      ),
    );
  }
}

class Person {
  final String name;
  final int age;

  Person({required this.name, required this.age});

  @override
  bool operator ==(covariant Person other) {
    if (identical(this, other)) return true;

    return other.name == name && other.age == age;
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode;

  @override
  String toString() => 'Person(name: $name, age: $age)';
}
