import 'package:flutter/material.dart';

class HomeCell extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeCellState();
  }
}

class HomeCellState extends State<HomeCell> {
  TextEditingController nameController = TextEditingController();
  String UserName = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Australian Dollar'),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                color: Colors.green,
                width: 100,
                child: InkWell(
                  child: Row(
                    children: [
                      Text(
                        'AUD',
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                        size: 45.0,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                  onChanged: (text) {
                    setState(
                      () {
                        UserName = text;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
