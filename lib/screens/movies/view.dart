import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../movies_details/view.dart';
import 'controller.dart';
import 'model.dart';

class MoviesScreen extends StatefulWidget {
  MoviesScreen({Key? key}) : super(key: key);

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final controller = MoviesController();
  String initialValueText = "Action";
  int genre = 28;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
              future: controller.getGeneresData(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const CircularProgressIndicator();
                }
                var model = snapshot.data as MovieGenres;
                return DropdownButton<String>(
                    value: initialValueText,
                    items: List.generate(
                        model.genres.length,
                        (index) => DropdownMenuItem(
                              value: model.genres[index].name,
                              onTap: () {
                                genre = model.genres[index].id;
                                setState(() {});
                              },
                              child: Text(model.genres[index].name),
                            )),
                    onChanged: (val) {
                      initialValueText = val!;
                      setState(() {});
                    });
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: controller.getData(genre: genre),
                builder: (context, snap) {
                  if (snap.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    var model = snap.data as MyMoviesDetails;
                    return ListView.builder(
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          print(model.results[index].id.toString());
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailsScreen(
                                    id: model.results[index].id),
                              ));
                        },
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          height: 200,
                          margin:const EdgeInsets.only(left: 15, right: 15, top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Stack(
                            children: [
                              InteractiveViewer(
                                onInteractionEnd: (c) {},
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://image.tmdb.org/t/p/original" +
                                          model.results[index].backdropPath,
                                  height: 200,
                                  fit: BoxFit.fill,
                                  progressIndicatorBuilder:
                                      (context, url, progress) {
                                    if (progress.progress != null) {
                                      double present = progress.progress! * 100;
                                      return Center(
                                          child: LinearProgressIndicator(
                                        value: progress.progress!,
                                      ));
                                    } else {
                                      return const Center(
                                          child: Text("Image Loaded"));
                                    }
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white54.withOpacity(.9),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                   const Icon(
                                      Icons.star_border_outlined,
                                      color: Colors.orangeAccent,
                                    ),
                                    const  SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      model.results[index].voteAverage
                                          .toString(),
                                      style:const TextStyle(color: Colors.black54),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                      padding:const EdgeInsets.all(8),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white54.withOpacity(.9),
                                      ),
                                      child: Text(
                                        model.results[index].title.length > 20
                                            ? model.results[index].title
                                                .substring(0, 20)
                                            : model.results[index].title,
                                        style:const TextStyle(
                                            color: Colors.black54, fontSize: 25),
                                        textAlign: TextAlign.center,
                                      ))),
                            ],
                          ),
                        ),
                      ),
                      itemCount: model.results.length,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
