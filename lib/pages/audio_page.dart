import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/model/audio_data2.dart';
import 'package:nibbana_dhamma/widgets/deshana_card.dart';
import 'package:nibbana_dhamma/services/deshana_data_service.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
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
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            children: [
              // Search Bar
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

              Expanded(
                child: TabBarView(
                  children: [
                    // Basic Teachings Tab with StreamBuilder
                    _buildStreamDeshanaTab(
                      deshanaType: 'basic',
                      sectionTitle: "මූලික දේශනා",
                      bgColor: const Color.fromARGB(255, 194, 184, 154),
                      cardColor: Colors.orange[100]!,
                    ),

                    // Advanced Teachings Tab with StreamBuilder
                    _buildStreamDeshanaTab(
                      deshanaType: 'advanced',
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

  Widget _buildStreamDeshanaTab({
    required String deshanaType,
    required String sectionTitle,
    required Color bgColor,
    required Color cardColor,
  }) {
    return StreamBuilder<List<Map<String, String>>>(
      stream: deshanaType == 'basic'
          ? AudioStreamService.getBasicDeshanasStream()
          : AudioStreamService.getAdvancedDeshanasStream(),
      builder: (context, snapshot) {
        // Check if we have data (even if there was an error previously)
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final filteredDeshanas = _filterDeshanas(snapshot.data!);
          return _buildDeshanaContent(
            deshanas: filteredDeshanas,
            sectionTitle: sectionTitle,
            bgColor: bgColor,
            cardColor: cardColor,
            isFallback: false,
          );
        }

        // Show loading indicator only for the first time
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasError) {
          return _buildLoadingIndicator();
        }

        // If we have error or no data, use fallback data
        final fallbackDeshanas = _getFallbackData(sectionTitle);
        final filteredDeshanas = _filterDeshanas(fallbackDeshanas);

        // Show error banner only if there was an actual error
        if (snapshot.hasError) {
          return Column(
            children: [
              // Error banner
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange[800]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Using offline data',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[800],
                              ),
                            ),
                            Text(
                              'Connection issue: ${snapshot.error.toString().length > 50 ? '${snapshot.error.toString().substring(0, 50)}...' : snapshot.error.toString()}',
                              style: TextStyle(
                                  color: Colors.orange[800], fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Content with fallback data
              Expanded(
                child: _buildDeshanaContent(
                  deshanas: filteredDeshanas,
                  sectionTitle: sectionTitle,
                  bgColor: bgColor,
                  cardColor: cardColor,
                  isFallback: true,
                ),
              ),
            ],
          );
        }

        // If no data and no error (empty collection), show fallback data without error banner
        return _buildDeshanaContent(
          deshanas: filteredDeshanas,
          sectionTitle: sectionTitle,
          bgColor: bgColor,
          cardColor: cardColor,
          isFallback: true,
        );
      },
    );
  }

  List<Map<String, String>> _getFallbackData(String sectionTitle) {
    return sectionTitle == "මූලික දේශනා"
        ? AudioData.basicDeshanas
        : AudioData.advancedDeshanas;
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading audio data...'),
        ],
      ),
    );
  }

  Widget _buildDeshanaContent({
    required List<Map<String, String>> deshanas,
    required String sectionTitle,
    required Color bgColor,
    required Color cardColor,
    required bool isFallback,
  }) {
    if (deshanas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.audiotrack, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No deshanas found',
              style: TextStyle(color: Colors.grey[600]),
            ),
            if (isFallback) const SizedBox(height: 8),
            if (isFallback)
              Text(
                'Try checking your connection',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Fallback indicator
          if (isFallback)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Offline Mode',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),

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
