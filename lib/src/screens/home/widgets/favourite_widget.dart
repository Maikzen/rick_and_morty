import 'package:flutter/material.dart';

class FavouriteWidget extends StatelessWidget {
  const FavouriteWidget(
      {Key? key,
      this.color = Colors.black12,
      this.onTap,
      required this.selected})
      : super(key: key);

  final Color color;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: onTap,
        child: ClipOval(
          child: Container(
            height: 50,
            width: 50,
            color: color,
            child: FittedBox(
                child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.star,
                color: selected ? Colors.yellow : Colors.black26,
              ),
            )),
          ),
        ),
      ),
    );
  }
}
