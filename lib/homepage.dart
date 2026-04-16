import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

class GPAHome extends StatefulWidget {
  const GPAHome({super.key});

  @override
  State<GPAHome> createState() => _GPAHomeState();
}

class _GPAHomeState extends State<GPAHome> {
  List<TextEditingController> gradeControllers = [TextEditingController()];
  List<TextEditingController> creditControllers = [TextEditingController()];
  
  final player = AudioPlayer();
  double totalGPA = 0.0;
  String status = "Add subjects to begin";

  void _addNewSubject() {
    setState(() {
      gradeControllers.add(TextEditingController());
      creditControllers.add(TextEditingController());
    });
  }

  void calculateTotalGPA() {
    double totalPoints = 0.0;
    double totalCredits = 0.0;

    for (int i = 0; i < gradeControllers.length; i++) {
      double g = double.tryParse(gradeControllers[i].text) ?? 0.0;
      double c = double.tryParse(creditControllers[i].text) ?? 0.0;
      totalPoints += (g * c);
      totalCredits += c;
    }

    setState(() {
      if (totalCredits > 0) {
        totalGPA = totalPoints / totalCredits;
        
        if (totalGPA >= 3.75) {
          status = "Excellent (Dean's List)!";
        } else if (totalGPA >= 2.0) {
          status = "Good Standing";
        } else {
          status = "Needs Improvement";
        }
      } else {
        totalGPA = 0.0;
        status = "Please enter valid credits";
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UUM GPA Calculator'),
        backgroundColor: const Color.fromARGB(255, 113, 165, 238),
        centerTitle: true,
        
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox (height: 20),
              Image.asset('assets/images/logo.png', height: 100),
              const SizedBox(height: 30),
              Text(
                "Dynamic Performance Tracker",
                style: GoogleFonts.robotoSlab(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 60),

              ...List.generate(gradeControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildSubjectRow(
                    "Subject ${index + 1}", 
                    gradeControllers[index], 
                    creditControllers[index]
                  ),
                );
              }),

              // Visual Plus Button
              TextButton.icon(
                onPressed: _addNewSubject,
                icon: const Icon(Icons.add, color: Colors.teal),
                label: const Text("Add Another Subject", style: TextStyle(color: Colors.teal)),
                style:TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor: const Color.fromARGB(255, 171, 226, 88),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),

              const SizedBox(height: 20),
              
              ElevatedButton.icon(
                onPressed: calculateTotalGPA,
                icon: const Icon(Icons.calculate),
                label: const Text('Calculate Overall GPA'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),

              const SizedBox(height: 30),
              const Divider(thickness: 2),
              
              Text(
                "Overall GPA: ${totalGPA.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                "Status: $status",
                style: TextStyle(fontSize: 18, color: Colors.blueGrey.shade800, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectRow(String label, TextEditingController gController, TextEditingController cController) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 2,
          child: TextField(
            controller: gController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Grade Pt',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: TextField(
            controller: cController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Credit',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}