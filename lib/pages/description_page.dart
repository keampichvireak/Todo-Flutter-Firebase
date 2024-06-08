// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors
import 'package:authflutter/models/todomodel/todo_model.dart';
import 'package:authflutter/pages/category_page.dart';
import 'package:authflutter/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DescriptionPage extends StatefulWidget {
  final Todo todo;
  const DescriptionPage({required this.todo});

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  int _selectedIndex = 2;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else if (index == 1) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CategoryPage()));
      }
    });
  }

  Color softSkyBlue = const Color(0xFFB3E5FC);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
        backgroundColor: Color.fromARGB(255, 255, 249, 199),
      ),
      backgroundColor: Color.fromARGB(255, 255, 249, 199),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.category,
            ),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            label: 'Details',
          ),
          // Add more BottomNavigationBarItem if needed
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue.shade100,
        onTap: _onItemTapped,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 400, // Specific width for the container
            height: 300,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 240, 224, 86),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centers vertically
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Task: ${widget.todo.task}',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 14,
                ),
                Text(
                  'Completed:${widget.todo.isDone ? "Yes" : "No"}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 14,
                ),
                Text(
                  'Created On:${DateFormat("dd-MM-yyyy h:mm a").format(widget.todo.updatedOn.toDate())}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 14,
                ),
                Text(
                  'Description : ${widget.todo.description}',
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  height: 14,
                ),
                RichText(
                    text: TextSpan(
                        text: 'Level: ',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                      TextSpan(
                          text: widget.todo.level,
                          style: TextStyle(
                            color: widget.todo.level == 'Mandantory'
                                ? Colors.red
                                : widget.todo.level == 'Important'
                                    ? Colors.orange
                                    : Colors.green,
                          ))
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
