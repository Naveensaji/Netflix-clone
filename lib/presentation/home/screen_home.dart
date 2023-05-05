import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netflix_clone/application/home/home_bloc.dart';
import 'package:netflix_clone/core/colors/colors.dart';
import 'package:netflix_clone/core/constants.dart';
import 'package:netflix_clone/presentation/home/widget/background_card.dart';
import 'package:netflix_clone/presentation/home/widget/custom_button_widget.dart';
import 'package:netflix_clone/presentation/home/widget/number_card.dart';
import 'package:netflix_clone/presentation/widgets/main_card.dart';
import 'package:netflix_clone/presentation/widgets/main_title.dart';
import 'package:netflix_clone/presentation/widgets/main_title_card.dart';

import 'widget/number_title_card.dart';

ValueNotifier<bool> scrollNotifier = ValueNotifier(true);

class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        BlocProvider.of<HomeBloc>(context).add(const GetHomeScreenData());
      },
    );

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: scrollNotifier,
        builder: (BuildContext context, index, _) {
          return NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              final ScrollDirection direction = notification.direction;
              print(direction);
              if (direction == ScrollDirection.reverse) {
                scrollNotifier.value == false;
              } else if (direction == ScrollDirection.forward) {
                scrollNotifier.value == true;
              }
              return true;
            },
            child: Stack(
              children: [
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      );
                    }
                    // else if (state.hasError) {
                    //   return const Center(
                    //     child: Text(
                    //       'Error while getting data',
                    //       style: TextStyle(color: kWhitecolor),
                    //     ),
                    //   );
                    // }

                    //released pastYear
                    final _releasedPastYear = state.pastYearMovieList.map(
                      (m) {
                        return '$imageAppendUrl${m.posterPath}';
                      },
                    ).toList();

                    //trending
                    final _trending = state.trendingMovieList.map(
                      (m) {
                        return '$imageAppendUrl${m.posterPath}';
                      },
                    ).toList();

                    //trends drama
                    final _trendsDrama = state.tenseDramaMovieList.map(
                      (m) {
                        return '$imageAppendUrl${m.posterPath}';
                      },
                    ).toList();

                    //Sounth inndian movies
                    final _southIndianMovies = state.southIndianMovieList.map(
                      (m) {
                        return '$imageAppendUrl${m.posterPath}';
                      },
                    ).toList();
                    _southIndianMovies.shuffle();

                    //top10 tv shows
                    final _top10TvShows = state.trendingTvList.map(
                      (t) {
                        return '$imageAppendUrl${t.posterPath}';
                      },
                    ).toList();

                    _top10TvShows.shuffle();

                    print(_top10TvShows.length);

                    //listView------->
                    return ListView(
                      children: [
                        const BackgroundCard(),
                        if (_releasedPastYear.length >= 10)
                          MainTitleCard(
                            title: 'Released in the past year',
                            posterList: _releasedPastYear.sublist(0, 10),
                          ),
                        kHeight,
                        if (_trending.length >= 10)
                          MainTitleCard(
                            title: 'Trending Now',
                            posterList: _trending.sublist(0, 10),
                          ),
                        kHeight,
                        NumberTitleCard(
                          postersList: _top10TvShows.sublist(0, 10),
                        ),
                        if (_trendsDrama.length >= 10)
                          MainTitleCard(
                            title: 'Trends Drama',
                            posterList: _trendsDrama.sublist(0, 10),
                          ),
                        kHeight,
                        if (_southIndianMovies.length >= 10)
                          MainTitleCard(
                            title: 'South Indian Cinema',
                            posterList: _southIndianMovies.sublist(0, 10),
                          ),
                        kHeight,
                      ],
                    );
                  },
                ),
                scrollNotifier.value == true
                    ? AnimatedContainer(
                        duration: const Duration(milliseconds: 1000),
                        width: double.infinity,
                        height: 80,
                        color: Colors.black.withOpacity(0.5),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  "https://cdn-images-1.medium.com/max/1200/1*ty4NvNrGg4ReETxqU2N3Og.png",
                                  width: 60,
                                  height: 60,
                                ),
                                const Spacer(),
                                const Icon(Icons.cast, color: Colors.white),
                                kwidth,
                                Container(
                                  width: 30,
                                  height: 30,
                                  color: Colors.blue,
                                ),
                                kwidth,
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('TV Shows', style: KHomeTitleText),
                                Text('Movies', style: KHomeTitleText),
                                Text('Categories', style: KHomeTitleText)
                              ],
                            )
                          ],
                        ),
                      )
                    : kHeight
              ],
            ),
          );
        },
      ),
    );
  }
}
