import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_mobile/models/object_model.dart';
import 'package:rekreacija_mobile/providers/object_provider.dart';
import 'package:rekreacija_mobile/routes.dart';
import 'package:rekreacija_mobile/screens/hall_details_screen.dart';
import 'package:rekreacija_mobile/utils/utils.dart';
import 'package:rekreacija_mobile/widgets/custom_decoration.dart';
import 'package:rekreacija_mobile/widgets/hall_card.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageScreen();
}

class _HomePageScreen extends State<HomePageScreen> {
  late ObjectProvider _objectProvider;
  List<ObjectModel> objects = [];
  List<ObjectModel> favoritesObject = [];
  static String? baseUrl = "http://10.0.2.2:5246";

  @override
  void initState() {
    super.initState();
    _objectProvider = context.read<ObjectProvider>();
    fetchObjects();
  }

  Future<void> fetchObjects() async {
    try {
      var objectList = await _objectProvider.Get();
      var favorites = await _objectProvider.getFavoritesObjectOfUser();
      setState(() {
        objects = objectList;
        favoritesObject = favorites;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to fetch data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: customDecoration,
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 50.0),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Home',
                    style: GoogleFonts.suezOne(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: IconButton(
                    icon: const Icon(Icons.message),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.messages);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_none),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.nottification);
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15.0),
                    Row(
                      children: [
                        const Padding(padding: EdgeInsets.all(5.0)),
                        Text(
                          'Popular Objects',
                          style: GoogleFonts.suezOne(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.local_fire_department_outlined,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 250.0,
                      child: PageView.builder(
                        controller: PageController(
                          viewportFraction: 1.0,
                          initialPage: 0,
                        ),
                        itemCount: objects.length,
                        itemBuilder: (context, index) {
                          final popularHalls = objects[index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HallDetailsScreen(
                                            object: popularHalls)));
                              },
                              child: HallCard(
                                hallName: popularHalls.name ?? '',
                                hallAdress: popularHalls.address ?? '',
                                rating: formatNumber(popularHalls.rating!),
                                image: popularHalls.imagePath != null
                                    ? Image.network(
                                        '$baseUrl${popularHalls.imagePath!}')
                                    : Image.asset(
                                        "assets/images/RekreacijaDefault.jpg"),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      children: [
                        const Padding(padding: EdgeInsets.all(5.0)),
                        Text(
                          'Halls Near You',
                          style: GoogleFonts.suezOne(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 250.0,
                      child: PageView.builder(
                        controller: PageController(
                          viewportFraction: 1.0,
                          initialPage: 0,
                        ),
                        itemCount: objects.length,
                        itemBuilder: (context, index) {
                          final nearYou = objects[index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HallDetailsScreen(
                                            object: nearYou)));
                              },
                              child: HallCard(
                                hallName: nearYou.name ?? '',
                                hallAdress: nearYou.address ?? '',
                                rating: formatNumber(nearYou.rating!),
                                image: nearYou.imagePath != null
                                    ? Image.network(
                                        '$baseUrl${nearYou.imagePath!}')
                                    : Image.asset(
                                        "assets/images/RekreacijaDefault.jpg"),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    favoritesObject.isNotEmpty?                    
                    Row(
                      children: [
                        const Padding(padding: EdgeInsets.all(5.0)),
                        Text(
                          'Favorite objects',
                          style: GoogleFonts.suezOne(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      ],
                    ):const Text(""),
                    favoritesObject.isNotEmpty?
                   SizedBox(
                            height: 250.0,
                            child: PageView.builder(
                              controller: PageController(
                                viewportFraction: 1.0,
                                initialPage: 0,
                              ),
                              itemCount: favoritesObject.length,
                              itemBuilder: (context, index) {
                                final yourFavorites = favoritesObject[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HallDetailsScreen(
                                                      object: yourFavorites)));
                                    },
                                    child: HallCard(
                                      hallName: yourFavorites.name ?? '',
                                      hallAdress: yourFavorites.address ?? '',
                                      rating:
                                          formatNumber(yourFavorites.rating!),
                                      image: yourFavorites.imagePath != null
                                          ? Image.network(
                                              '$baseUrl${yourFavorites.imagePath!}')
                                          : Image.asset(
                                              "assets/images/RekreacijaDefault.jpg"),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ):const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "You don't have any favorite objects yet",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                      
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
