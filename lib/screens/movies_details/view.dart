import 'package:flutter/material.dart';

import 'controller.dart';
import 'model.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int id;

  MovieDetailsScreen({Key? key, required this.id}) : super(key: key);

  final controller = MovieDtController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: controller.getData(id: id),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const CircularProgressIndicator();
            }
            var model = snapshot.data as MovieDtModel;
            return ListView(
              children: [
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      ),
                  child: Image.network(
                    "https://image.tmdb.org/t/p/original" + model.backdropPath,
                    height: 400,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          model.originalTitle,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        padding: const EdgeInsets.all(20),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Text(
                          model.overview,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        padding: const EdgeInsets.all(20),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
