

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Feature_box extends StatelessWidget{
  final Color color;
  final String head_text;
  final String des_text;
  const Feature_box({super.key, required this.color, required this.head_text, required this.des_text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 15
      ).copyWith(right: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20,bottom: 20,left: 15,right: 15),
        child: Column(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text(head_text,style: const TextStyle(fontFamily: 'Bebas',fontWeight: FontWeight.w800,color: Colors.black,fontSize: 20),)),
            Text(des_text,style: const TextStyle(fontFamily: 'Bebas',color: Colors.black,fontSize: 17),),
          ],
        ),
      ),
    );
  }

}
