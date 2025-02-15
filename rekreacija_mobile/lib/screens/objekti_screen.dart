import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_mobile/models/sport_category.dart';
import 'package:rekreacija_mobile/providers/sport_category_provider.dart';
import 'package:rekreacija_mobile/widgets/custom_decoration.dart';
import 'package:rekreacija_mobile/widgets/sport_section.dart';

class ObjektiScreen extends StatefulWidget {
  const ObjektiScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ObjektiScreenState();
}

class _ObjektiScreenState extends State<ObjektiScreen> {
  final TextEditingController _searchController = TextEditingController();
  late SportCategoryProvider _sportCategoryProvider;
  bool isLoadingSports = true;
  List<SportCategory> sports = [];
  SportCategory? selectedSport;
  final List<Map<String, String>> halls = [
    {
      'name': 'Univerzitetska dvorana',
      'address': 'Univerzitetska 1',
    },
    {
      'name': 'Tusanj',
      'address': 'Rudarska bb',
    },
    {
      'name': 'Mejdan',
      'address': 'Bosne Srebrene',
    },
    {
      'name': 'Mejdan',
      'address': 'Bosne Srebrene',
    },
    {
      'name': 'Mejdan',
      'address': 'Bosne Srebrene',
    },
    {
      'name': 'Mejdan',
      'address': 'Bosne Srebrene',
    },
    {
      'name': 'Mejdan',
      'address': 'Bosne Srebrene',
    },
    {
      'name': 'Mejdan',
      'address': 'Bosne Srebrene',
    },
    {
      'name': 'Mejdan',
      'address': 'Bosne Srebrene',
    },
    {
      'name': 'Mejdan',
      'address': 'Bosne Srebrene',
    },
    {
      'name': 'Mejdan',
      'address': 'Bosne Srebrene',
    },
    {
      'name': 'Mejdan',
      'address': 'Bosne Srebrene',
    },
    {
      'name': 'Mejdan',
      'address': 'Bosne Srebrene',
    },
    {
      'name': 'Univerzitetska dvorana',
      'address': 'Univerzitetska 1',
    },
    {
      'name': 'Tusanj',
      'address': 'Rudarska bb',
    },
    {
      'name': 'Univerzitetska dvorana',
      'address': 'Univerzitetska 1',
    },
    {
      'name': 'Tusanj',
      'address': 'Rudarska bb',
    },
  ];

  List<Map<String, String>> _filteredHalls = [];
  @override
  void initState() {
    super.initState();
    _sportCategoryProvider = context.read<SportCategoryProvider>();
    _filteredHalls = halls;
    _loadSports();
  }

  void _filterHalls(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredHalls = halls;
      } else {
        _filteredHalls = halls
            .where((hall) =>
                hall['name']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _loadSports() async {
    try {
      final categories = await _sportCategoryProvider.Get();
      setState(() {
        sports = categories;
        if (sports.isNotEmpty) {
          selectedSport = sports.first;
        }
        isLoadingSports = false;
      });
    } catch (e) {
      setState(() {
        isLoadingSports = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load sports: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: customDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Text(
                    'Objects',
                    style: GoogleFonts.suezOne(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.map_sharp,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: _filterHalls,
                    decoration: InputDecoration(
                      fillColor: const Color.fromRGBO(49, 49, 49, 0.8),
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      hintText: 'Search for a objects...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: sports.map((sport) {
                  final isSelected = sport == selectedSport;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedSport = sport;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: isSelected
                            ? const Color.fromRGBO(14, 119, 62, 1.0)
                            : Colors.white,
                        foregroundColor:
                            isSelected ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          side: const BorderSide(color: Colors.white),
                        ),
                      ),
                      child: Text(
                        sport.name ?? "",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _filteredHalls.length,
                        itemBuilder: (context, index) {
                          final hall = _filteredHalls[index];
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/hallDetails');
                            },
                            child: SportSection(
                                hallAdress: hall['name'] ?? '',
                                hallName: hall['address'] ?? '',
                                onFavoritePressed: () {}),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
