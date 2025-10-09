import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/widgets/preacherCard.dart';
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
      appBar: AppBar(title: const Text("දේශකයන් වහන්සේලා")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 107, 83, 3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      "දේශකයකයන් වහන්සේලා",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Dynamic Preachers List from Firebase
                    StreamBuilder<List<Preacher>>(
                      stream: _preacherService.getPreachers(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Error loading preachers: ${snapshot.error}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No preachers found',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        final preachers = snapshot.data!;

                        return Column(
                          children: preachers.map((preacher) {
                            return Column(
                              children: [
                                Preachercard(
                                  title: preacher.name,
                                  imagePath: preacher.imageUrl,
                                  description: preacher.description,
                                  bgColor:
                                      const Color.fromARGB(255, 243, 236, 170),
                                  placeUrl:
                                      preacher.link ?? preacher.dharmasanaUrl,
                                  showExpandableSection: false,
                                ),
                                const SizedBox(height: 10),
                              ],
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Location Section with Image
          ],
        ),
      ),
    );
  }
}
