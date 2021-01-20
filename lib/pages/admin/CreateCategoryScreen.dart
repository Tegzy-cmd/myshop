import 'package:flutter/material.dart';
import 'package:myshop/components/MyDialog.dart';
import 'package:myshop/helpers/category.dart';

class CreateCategoryScreen extends StatefulWidget {
  @override
  _CreateCategoryScreenState createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final TextEditingController _titleController = TextEditingController();
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: "Title",
                  ),
                  maxLength: 60,
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () {
                    if (_titleController.text.length > 0) {
                      createCategory(_titleController.text).then((v) {
                        Navigator.pop(context, "added");
                      }).catchError((e) => print(e));
                    } else {
                      showMyDialog(
                        context: context,
                        title: "oops",
                        description: "Provide Category title",
                      );
                    }
                  },
                  child: Text("ADD"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
