import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_mobile/models/object_model.dart';
import 'package:rekreacija_mobile/providers/object_provider.dart';
import 'package:rekreacija_mobile/routes.dart';
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

  @override
  void initState() {
    super.initState();
    _objectProvider = context.read<ObjectProvider>();
    fetchObjects();
  }

  Future<void> fetchObjects() async {
    try {
      var objectList = await _objectProvider.Get();
      setState(() {
        objects = objectList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch data: ${3}')));
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
                                Navigator.pushNamed(context, '/hallDetails');
                              },
                              child: HallCard(
                                hallAdress: popularHalls.name ?? '',
                                hallName: popularHalls.address ?? '',
                                image: popularHalls.objectImage != null
                                    ? imageFromString(popularHalls.objectImage!)
                                    : Image.asset(
                                        "assets/image/RekreacijaDefault.jpg"),
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
                                Navigator.pushNamed(context, '/hallDetails');
                              },
                              child: HallCard(
                                hallAdress: nearYou.name ?? '',
                                hallName: nearYou.address ?? '',
                                image: nearYou.objectImage != null
                                    ? imageFromString(nearYou.objectImage!)
                                    : Image.asset(
                                        "assets/image/RekreacijaDefault.jpg"),
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
                                Navigator.pushNamed(context, '/hallDetails');
                              },
                              child: HallCard(
                                hallAdress: nearYou.name ?? '',
                                hallName: nearYou.address ?? '',
                                image: nearYou.objectImage != null
                                    ? imageFromString(nearYou.objectImage!)
                                    : Image.asset(
                                        "assets/image/RekreacijaDefault.jpg"),
                              ),
                            ),
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