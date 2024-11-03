import 'package:flutter/material.dart';

class SmallCircle extends StatelessWidget {

  final bool isWorking;

  const SmallCircle({Key? key, required this.isWorking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0), // Adiciona padding de 8 pixels em todos os lados
          child: isWorking ? _workingCircle() : _standardCircle(),
        ),
      ],
    );
  }

  Widget _standardCircle(){
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _workingCircle(){
    return Container(
      width: 25,
      height: 25,
      decoration: const BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
    );
  }
}