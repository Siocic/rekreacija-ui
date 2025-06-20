import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_mobile/models/favorites_model.dart';
import 'package:rekreacija_mobile/models/object_model.dart';
import 'package:rekreacija_mobile/models/sport_category.dart';
import 'package:rekreacija_mobile/providers/favorites_provider.dart';
import 'package:rekreacija_mobile/providers/object_provider.dart';
import 'package:rekreacija_mobile/providers/sport_category_provider.dart';
import 'package:rekreacija_mobile/screens/hall_details_screen.dart';
import 'package:rekreacija_mobile/utils/utils.dart';
import 'package:rekreacija_mobile/widgets/custom_decoration.dart';
import 'package:rekreacija_mobile/widgets/expired_dialog.dart';
import 'package:rekreacija_mobile/widgets/sport_section.dart';

class ObjektiScreen extends StatefulWidget {
  const ObjektiScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ObjektiScreenState();
}

class _ObjektiScreenState extends State<ObjektiScreen> {
  final TextEditingController _searchController = TextEditingController();
  late SportCategoryProvider _sportCategoryProvider;
  late FavoritesProvider _favoritesProvider;
  bool isLoadingSports = true;
  List<SportCategory> sports = [];
  SportCategory? selectedSport;
  late ObjectProvider _objectProvider;
  List<ObjectModel> objects = [];
  List<ObjectModel> filteredObjects = [];
  String userId = '';
  static String? baseUrl = String.fromEnvironment("BASE_URL",defaultValue:"http://10.0.2.2:5246/");

  @override
  void initState() {
    super.initState();
    _sportCategoryProvider = context.read<SportCategoryProvider>();
    _objectProvider = context.read<ObjectProvider>();
    _favoritesProvider = context.read<FavoritesProvider>();
    _searchController.addListener(() {
      fetchObjects(name: _searchController.text); // Call API when text changes
    });
    _loadSports();
    getIdOfUser();
  }

  Future<void> _loadSports() async {
    try {
      final categories = await _sportCategoryProvider.Get();
      setState(() {
        sports = categories;
        if (sports.isNotEmpty) {
          selectedSport = sports.first;
          fetchObjects();
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

  Future<void> fetchObjects({String? name}) async {
    try {
      var objectList =
          await _objectProvider.getObjects(selectedSport!.id!, name: name);
      setState(() {
        objects = objectList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to fetch data: $e')));
    }
  }

  Future<void> getIdOfUser() async {
    try {
      final idOfUser = await getUserId();
      setState(() {
        userId = idOfUser;
      });
    } catch (e) {
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
                      onPressed: () async {
                        bool isExpired = await isTokenExpired();
                        if (isExpired) {
                          showTokenExpiredDialog(context);
                          return;
                        }

                        final objectsByCategory =
                            await _objectProvider.getObjects(sport.id!);
                        setState(() {
                          selectedSport = sport;
                          objects = objectsByCategory;
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
                        itemCount: objects.length,
                        itemBuilder: (context, index) {
                          final hall = objects[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HallDetailsScreen(object: hall)));
                            },
                            child: SportSection(
                                hallName: hall.name ?? '',
                                hallAdress: hall.address ?? '',
                                isFavorite: hall.isFavorites!,
                                image: hall.imagePath != null
                                    ? Image.network(
                                        '$baseUrl${hall.imagePath!}')
                                    : Image.asset(
                                        "assets/images/RekreacijaDefault.jpg"),
                                onFavoritePressed: () async {
                                  bool isExpired = await isTokenExpired();
                                  if (isExpired) {
                                    showTokenExpiredDialog(context);
                                    return;
                                  }

                                  try {
                                    FavoritesModel requestInsert =
                                        FavoritesModel(hall.id, userId);
                                    await _favoritesProvider.Insert(
                                        requestInsert);

                                    await _loadSports();
                                  } catch (e) {
                                    String errorMessage = e.toString();

                                    if (errorMessage.startsWith("Exception:")) {
                                      errorMessage = errorMessage
                                          .replaceFirst("Exception:", "")
                                          .trim();
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(errorMessage)),
                                    );
                                  }
                                }),
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
