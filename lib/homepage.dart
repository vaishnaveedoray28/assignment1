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
      
      backgroundColor: const Color.fromARGB(255, 255, 252, 240), 
      appBar: AppBar(
        title: const Text('UUM GPA Calculator', style: TextStyle(color: Color.fromARGB(255, 254, 254, 254),fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 96, 37, 37),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/images/logo.png', height: 100),
              const SizedBox(height: 30),
              
              // 2. TEXT STYLE COLOR
              Text(
                "Dynamic Performance Tracker",
                style: GoogleFonts.robotoSlab(
                  fontSize: 22, 
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0), 
                ),
              ),
              const Divider(height: 60),

              for (int i = 0; i < gradeControllers.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: _buildSubjectRow(
                    "Subject ${i + 1}" ,
                    gradeControllers[i], 
                    creditControllers[i],
                  ),
                ),

              const SizedBox(height: 20),

              TextButton.icon(
                onPressed: _addNewSubject,
                icon: const Icon(Icons.add, color: Colors.teal),
                label: const Text("Add Another Subject", style: TextStyle(color: Colors.teal)),
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 212, 234, 179),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),

              const SizedBox(height: 20),
              
              ElevatedButton(
                onPressed: calculateTotalGPA,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('Calculate GPA'),
              ),

              const Divider(height: 60, thickness: 2),

              Text(
                "Overall GPA: ${totalGPA.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal[900]),
              ),
              Text(
                "Status: $status",
                style: TextStyle(fontSize: 18, color: Colors.grey[700], fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 5. THE ROW AND CONTAINER SECTION
  Widget _buildSubjectRow(String label, TextEditingController gController, TextEditingController cController) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
        ),
        
        // GRADE INPUT BOX
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // FILL COLOR
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.teal.shade200), // BORDER COLOR
            ),
            child: TextField(
              controller: gController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Grade',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: InputBorder.none, // Hides the default line
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 10),

        // CREDIT INPUT BOX
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // FILL COLOR
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.teal.shade200), // BORDER COLOR
            ),
            child: TextField(
              controller: cController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Credit',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: InputBorder.none, // Hides the default line
              ),
            ),
          ),
        ),
      ],
    );
  }
}