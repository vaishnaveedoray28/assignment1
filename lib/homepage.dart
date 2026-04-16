import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

class GPAHome extends StatefulWidget {
  const GPAHome({super.key});

  @override
  State<GPAHome> createState() => _GPAHomeState();
}

class _GPAHomeState extends State<GPAHome> {
  // 1. INPUT: Controllers to capture Grade Points and Credit Hours
  final TextEditingController sub1Grade = TextEditingController();
  final TextEditingController sub1Credit = TextEditingController();
  final TextEditingController sub2Grade = TextEditingController();
  final TextEditingController sub2Credit = TextEditingController();
  final TextEditingController sub3Grade = TextEditingController();
  final TextEditingController sub3Credit = TextEditingController();
  
  final player = AudioPlayer();
  double totalGPA = 0.0;
  String status = "Enter results to calculate";

  // 2. PROCESS: Cumulative GPA Calculation Logic
  void calculateTotalGPA() {
    // Parsing user inputs safely
    double g1 = double.tryParse(sub1Grade.text) ?? 0.0;
    double c1 = double.tryParse(sub1Credit.text) ?? 0.0;
    double g2 = double.tryParse(sub2Grade.text) ?? 0.0;
    double c2 = double.tryParse(sub2Credit.text) ?? 0.0;
    double g3 = double.tryParse(sub3Grade.text) ?? 0.0;
    double c3 = double.tryParse(sub3Credit.text) ?? 0.0;

    setState(() {
      double totalPoints = (g1 * c1) + (g2 * c2) + (g3 * c3);
      double totalCredits = c1 + c2 + c3;

      if (totalCredits > 0) {
        totalGPA = totalPoints / totalCredits;
        
        // Logical conditions for performance status
        if (totalGPA >= 3.75) {
          status = "Excellent (Dean's List)!";
        } else if (totalGPA >= 2.0) {
          status = "Good Standing";
        } else {
          status = "Needs Improvement";
        }
      } else {
        totalGPA = 0.0;
        status = "Invalid Input";
      }
    });

    // Asset Integration: Play success sound
    player.play(AssetSource('audios/success.wav'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UUM GPA Calculator'),
        backgroundColor: Colors.tealAccent.shade400,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column( 
            children: [
              // UUM Branding
              Image.asset('assets/images/logo.png', height: 120),
              
              const SizedBox(height: 10),
              Text(
                "Check Your Performance",
                style: GoogleFonts.playwriteAr(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              
              const Divider(height: 30, thickness: 1),

              // Subject Inputs using a Helper Method for clean code
              _buildSubjectRow("Subject 1", sub1Grade, sub1Credit),
              const SizedBox(height: 15),
              _buildSubjectRow("Subject 2", sub2Grade, sub2Credit),
              const SizedBox(height: 15),
              _buildSubjectRow("Subject 3", sub3Grade, sub3Credit),

              const SizedBox(height: 30),

              // Calculation Button
              ElevatedButton.icon(
                onPressed: calculateTotalGPA,
                icon: const Icon(Icons.calculate),
                label: const Text('Calculate Overall GPA'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),

              const SizedBox(height: 30),
              const Divider(thickness: 2),
              
              // 3. OUTPUT: Results Display
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

  // Helper Widget to create side-by-side Input Fields
  Widget _buildSubjectRow(String label, TextEditingController gController, TextEditingController cController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Row(
          children: [
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
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: TextField(
                controller: cController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Credits',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}