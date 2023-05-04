import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Description extends StatelessWidget {
  const Description({Key? key,required this.title,required this.description}) : super(key: key);

  final String title, description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Description"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title,style: GoogleFonts.roboto(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.purple),),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(description,style: GoogleFonts.roboto(fontSize: 14,fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    );
  }
}
