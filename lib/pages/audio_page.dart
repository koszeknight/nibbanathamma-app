import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/model/audio_data.dart';
import 'package:nibbana_dhamma/widgets/deshana_card.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  // Now using the data from AudioData class
  final List<Map<String, String>> basicDeshanas = AudioData.basicDeshanas;
  final List<Map<String, String>> advancedDeshanas = AudioData.advancedDeshanas;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_updateSearchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateSearchQuery() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  List<Map<String, String>> _filterDeshanas(
      List<Map<String, String>> deshanas) {
    if (_searchQuery.isEmpty) return deshanas;
    return deshanas
        .where((item) => item["title"]!.toLowerCase().contains(_searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Audio Dheshana"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "මූලික දේශනා"),
              Tab(text: "සූත්‍ර දේශනා"),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 12.0), // Added top padding instead of Column
          child: Column(
            children: [
              // Search Bar - moved outside of TabBarView
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search deshanas...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded( // This Expanded wraps the TabBarView
                child: TabBarView(
                  children: [
                    // Basic Teachings Tab
                    _buildDeshanaTab(
                      deshanas: _filterDeshanas(basicDeshanas),
                      sectionTitle: "මූලික දේශනා",
                      bgColor: const Color.fromARGB(255, 194, 184, 154),
                      cardColor: Colors.orange[100]!,
                    ),

                    // Advanced Teachings Tab
                    _buildDeshanaTab(
                      deshanas: _filterDeshanas(advancedDeshanas),
                      sectionTitle: "සූත්‍ර දේශනා",
                      bgColor: const Color.fromARGB(255, 184, 194, 154),
                      cardColor: Colors.green[100]!,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeshanaTab({
    required List<Map<String, String>> deshanas,
    required String sectionTitle,
    required Color bgColor,
    required Color cardColor,
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: bgColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      sectionTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 24, 20, 19),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Column(
                      children: deshanas
                          .map((item) => AudioPageCard(
                                title: item["title"]!,
                                audioUrl: item["url"]!,
                                bgColor: cardColor,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}