import 'package:flutter/material.dart';

class FavouriteWidget extends StatelessWidget {
  const FavouriteWidget({Key? key, this.color = Colors.black12})
      : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipOval(
        child: Container(
          height: 50,
          width: 50,
          color: color,
          child: const FittedBox(
              child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(
              Icons.star,
              color: Colors.black26,
            ),
          )),
        ),
      ),
    );
  }
}
