import 'package:canalendar/enumerations/session_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FloatingActionBar extends StatelessWidget {
  FloatingActionBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          createButton(SessionType.joint)
        ],
      )
    );
  }

  ButtonStyleButton createButton(SessionType type) {
    return FilledButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(16.0), // Set the padding of the button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0), // Set the border radius of the button
          ),
          side: const BorderSide(width: 0, color: Colors.transparent), // Set the border properties
        ),
        child: SvgPicture.asset(
          'icons/joint-hollow.svg',
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          width: 30,
          height: 30,
        ),
    );
    /*return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SvgPicture.asset(
        'icons/joint-hollow.svg',
        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        width: 30,
        height: 30,
      ),
    );*/
  }
}