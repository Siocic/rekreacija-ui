import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_mobile/models/object_model.dart';
import 'package:rekreacija_mobile/providers/object_provider.dart';
import 'package:rekreacija_mobile/screens/hall_details_screen.dart';
import 'package:rekreacija_mobile/utils/utils.dart';
import 'package:rekreacija_mobile/widgets/custom_decoration.dart';
import 'package:rekreacija_mobile/widgets/hall_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  static String? baseUrl =
      String.fromEnvironment("BASE_URL", defaultValue: "http://10.0.2.2:5246/");
  late ObjectProvider _objectProvider;
  List<ObjectModel> favoritesObject = [];

  @override
  void initState() {
    super.initState();
    _objectProvider = context.read<ObjectProvider>();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    try {
      var favorites = await _objectProvider.getFavoritesObjectOfUser();
      setState(() {
        favoritesObject = favorites;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to fetch data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My favorites", style: GoogleFonts.ultra(fontSize: 22)),
        backgroundColor: const Color.fromARGB(225, 29, 29, 29),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: customDecoration,
        child: favoritesObject.isEmpty
            ? const Center(
                child: Text(
                  "You don't have any favorite object yet",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: favoritesObject.length,
                itemBuilder: (context, index) {
                  final myFavorites = favoritesObject[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HallDetailsScreen(object: myFavorites)),
                        );
                      },
                      child: HallCard(
                        hallName: myFavorites.name ?? '',
                        hallAdress: myFavorites.address ?? '',
                        rating: formatNumber(myFavorites.rating!),
                        image: myFavorites.imagePath != null
                            ? Image.network('$baseUrl${myFavorites.imagePath!}')
                            : Image.asset("assets/images/RekreacijaDefault.jpg"),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
