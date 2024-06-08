// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'package:authflutter/models/todomodel/todo_model.dart';
import 'package:authflutter/pages/description_page.dart';
import 'package:authflutter/pages/home_page.dart';
import 'package:authflutter/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final DatabaseService _databaseService = DatabaseService();
  int _selectedIndex = 1; // Current index for BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
        backgroundColor: Color.fromARGB(255, 255, 249, 199),
      ),
      backgroundColor: Color.fromARGB(255, 255, 249, 199),
      body: Center(
        child: _buildUI(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          // Add more BottomNavigationBarItem if needed
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue.shade100,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildUI() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            _buildCategoryList('Mandantory'),
            _buildCategoryList('Important'),
            _buildCategoryList('Optional'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(String categoryList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoryList,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width * 0.8,
            child: StreamBuilder(
              stream: _databaseService.getTodosByCategory(categoryList),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("Empty"),
                  );
                }

                List todos = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    Todo todo = todos[index].data();
                    String todoId = todos[index].id;
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Slidable(
                        endActionPane:
                            ActionPane(motion: StretchMotion(), children: [
                          SlidableAction(
                            onPressed: (context) {},
                            icon: Icons.delete,
                            backgroundColor: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          )
                        ]),
                        child: Container(
                          decoration: BoxDecoration(
                            color: todo.level == "Mandantory"
                                ? Color.fromARGB(255, 243, 128, 128)
                                : todo.level == "Important"
                                    ? Color.fromARGB(255, 243, 250, 146)
                                    : Color.fromARGB(255, 133, 245, 142),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            title: Column(
                              children: [
                                Text(
                                  "Task :" + todo.task,
                                  style: TextStyle(
                                    decoration: todo.isDone
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  'Updated On: ' +
                                      DateFormat("dd-MM-yyyy")
                                          .format(todo.updatedOn.toDate()),
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                            trailing: Checkbox(
                              value: todo.isDone,
                              onChanged: (value) {
                                Todo updatedTodo = todo.copyWith(
                                  isDone: !todo.isDone,
                                  updatedOn: Timestamp.now(),
                                );
                                _databaseService.updateTodo(
                                  todoId,
                                  updatedTodo,
                                );
                              },
                            ),
                            onLongPress: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DescriptionPage(todo: todo),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
