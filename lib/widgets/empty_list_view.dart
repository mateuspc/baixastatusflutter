import 'package:flutter/material.dart';

class EmptyListView extends StatelessWidget {
  const EmptyListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty, size: 36,),
          SizedBox(height: 10),
          Text('Lista vazia')
        ],
      ),
    );
  }
}