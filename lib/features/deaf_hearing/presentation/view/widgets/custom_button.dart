import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key, required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            Color(0xff582FFF),
          ),
        ),
        onPressed: () { },
        child: const Text('Deaf'),
      ),
    );
  }
}