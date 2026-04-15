import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

class GPAHome extends StatefulWidget {
  const GPAHome({super.key});

  @override
  State<GPAHome> createState() => _GPAHomeState();
}

class _GPAHomeState extends State<GPAHome> {

  final TextEditingController gradeController = TextEditingController();
  final player = AudioPlayer();
  
  double gpaResult = 0.0;
  String status = "Enter your grade point :";

  void calculateGPA() {
    double grade = double.tryParse(gradeController.text) ?? 0.0;
    
    setState(() {
      gpaResult = grade; 
      if (gpaResult >= 3.75) {
        status = "Excellent!";
      } else if (gpaResult >= 2.0) {
        status = "Good Standing";
      } else {
        status = "Needs Improvement";
      }
    });

    // Asset Integration: Play sound after calculation [cite: 32, 91]
    //player.play(AssetSource('audios/success.wav'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UUM GPA Calculator'),
        backgroundColor: Colors.tealAccent.shade400, 
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column( 
            children: [
        
              Image.asset('assets/images/logo.png', height: 150),
              
              const SizedBox(height: 20),
              Text(
                "Check Your Performance",
                style: GoogleFonts.playwriteAr(fontSize: 20), 
              ),

              const SizedBox(height: 20),
              
              TextField(
                controller: gradeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  hintText: 'Enter your Grade Point (e.g. 4.0)',
                ),
              ),

              const SizedBox(height: 20),
              
              ElevatedButton(
                onPressed: calculateGPA,
                child: const Text('Calculate GPA'),
              ),

              const SizedBox(height: 30),
              const Divider(thickness: 2),
              
              Text(
                "GPA: ${gpaResult.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "Status: $status",
                style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}