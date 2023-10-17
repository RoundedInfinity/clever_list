// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:example/movable.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MovableListPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var persons = <Person>[
    Person(name: 'Bert', age: 12),
    Person(name: 'Martin', age: 43),
    Person(name: 'Albedrt', age: 25),
    Person(name: 'Albert', age: 25),
    Person(name: 'AAA', age: 15),
    Person(name: 'eeaeaa', age: 14),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                final list = List<Person>.from(persons);

                list.add(Person(name: 'peter', age: Random().nextInt(200)));
                persons = list;
              });
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                setState(() {
                  persons = <Person>[
                    Person(name: 'Albedrt', age: 25),
                    Person(name: 'Martin the cool moving thing', age: 43),
                    Person(name: 'Bert', age: 12),
                    Person(name: 'Albert', age: 25),
                    Person(name: 'AAA', age: 15),
                    Person(name: 'eeaeaa', age: 14),
                  ];
                });
              });
            },
            icon: const Icon(Icons.move_down_rounded),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                persons = <Person>[
                  Person(name: 'Albedrt', age: 25),
                  Person(name: 'Bert', age: 12),
                  Person(name: 'Albert', age: 25),
                  Person(name: 'AAA', age: 15),
                  Person(name: 'Martin the cool moving thing', age: 43),
                  Person(name: 'eeaeaa', age: 14),
                ];
              });
            },
            icon: const Icon(Icons.move_down_rounded),
          ),
        ],
      ),
      body: SizedBox(
        height: 800,
        child: MovableCleverList<Person>(
          scrollDirection: Axis.vertical,
          items: persons,
          equalityChecker: (a, b) => a.name == b.name,
          itemIdEquality: (a, b) => a.age == b.age,
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
          insertDuration: const Duration(milliseconds: 500),
          removeDuration: const Duration(milliseconds: 300),
        ),
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
