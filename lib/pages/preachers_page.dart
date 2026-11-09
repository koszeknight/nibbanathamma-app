import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/widgets/preacher_card.dart';
import '../model/preacher_data.dart';
import '../services/preacher_service.dart';

class PreacherPage extends StatefulWidget {
  const PreacherPage({super.key});

  @override
  State<PreacherPage> createState() => _PreacherPageState();
}

class _PreacherPageState extends State<PreacherPage> {
  final PreacherService _preacherService = PreacherService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        title: const Text(
          "දේශකයන් වහන්සේලා",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepOrange.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepOrange.shade700,
                Colors.orange.shade600,
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<Preacher>>(
        stream: _preacherService.getPreachers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading preachers: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading preachers...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_off,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No preachers found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final preachers = snapshot.data!;

          // Simple SingleChildScrollView version
          return SingleChildScrollView(
            child: Column(
              children: [
                // Hero Header Section
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.deepOrange.shade700,
                        Colors.orange.shade500,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepOrange.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "ධර්ම දේශකයන් වහන්සේලා ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "සද්ධර්මය දේශනා කරන උත්තමයන් වහන්සේලා පිළිබද විස්තර",
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Preachers List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: preachers.map((preacher) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Preachercard(
                          title: preacher.name,
                          imagePath: preacher.imageUrl,
                          description: preacher.description,
                          bgColor: Colors.white,
                          placeUrl: preacher.link ?? preacher.dharmasanaUrl,
                          showExpandableSection: false,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Footer
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Divider(color: Colors.grey[300], thickness: 1),
                      const SizedBox(height: 16),
                      Text(
                        " දේශකයන් වහන්සේලාට උපහාරය",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "සාධු! සාධු! සාධු!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


