import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/bloc/home/home_bloc.dart';
import 'package:rick_and_morty/src/providers/colors.dart';
import 'package:rick_and_morty/src/providers/constants.dart';
import 'package:rick_and_morty/src/screens/home/widgets/card_character.dart';
import 'package:rick_and_morty/src/screens/home/widgets/favourite_widget.dart';
import 'package:rick_and_morty/src/services/characters/characters_http_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc homeBloc;

  @override
  void initState() {
    homeBloc = HomeBloc(charactersHttpService: CharactersHttpService());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: HomeApp(
        homeBloc: homeBloc,
        child: Scaffold(
            body: CustomScrollView(
          slivers: <Widget>[
            _buildAppBar(context),
            _buildFavourites(context),
            _buildListContent(),
            _buildPagination(),
            _buildBottomContent(),
          ],
        )),
      ),
    );
  }

  Widget _buildListContent() {
    return AnimatedBuilder(
        animation: homeBloc,
        builder: (context, _) {
          if (homeBloc.loading) {
            return _buildLoading(context);
          } else if (homeBloc.characters != null) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return CardCharacter(
                    character: homeBloc.characters![index],
                  );
                },
                childCount: homeBloc.characters!.length,
              ),
            );
          } else {
            return _buildError(context);
          }
        });
  }

  Widget _buildPagination() {
    return AnimatedBuilder(
        animation: homeBloc,
        builder: (context, _) {
          if (homeBloc.characters != null) {
            return SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                      child: homeBloc.currentPage > 1
                          ? TextButton(
                              onPressed: homeBloc.prevPage,
                              child: const Text('Anterior'))
                          : const SizedBox.shrink()),
                  Expanded(
                      child: Text(
                    homeBloc.currentPage.toString() +
                        '/' +
                        homeBloc.totalPages.toString(),
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: homeBloc.currentPage < homeBloc.totalPages
                          ? TextButton(
                              onPressed: homeBloc.nextPage,
                              child: const Text('Siguiente'))
                          : const SizedBox.shrink()),
                ],
              ),
            ));
          } else {
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }
        });
  }

  Widget _buildLoading(BuildContext context) {
    return SliverToBoxAdapter(
        child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Align(
          alignment: Alignment.topCenter,
          child: Image.asset(
            Constants.imgLoading,
            height: MediaQuery.of(context).size.height * 0.3,
          )),
    ));
  }

  Widget _buildError(BuildContext context) {
    return SliverToBoxAdapter(
        child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: const Align(alignment: Alignment.topCenter, child: Text('Error')),
    ));
  }

  Widget _buildFavourites(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(children: [
        Text('Mostrar favoritos:',
            style: Theme.of(context).textTheme.titleMedium),
        AnimatedBuilder(
            animation: homeBloc,
            builder: (context, _) {
              return FavouriteWidget(
                selected: homeBloc.showFavourites,
                onTap: () {
                  homeBloc.changeShowFavourites();
                },
              );
            }),
      ]),
    ));
  }

  Widget _buildBottomContent() {
    return SliverToBoxAdapter(
        child: Container(
      height: 150,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(Constants.imgBackground),
            fit: BoxFit.none,
            scale: 1,
            alignment: Alignment(0.05, 0.7),
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.multiply)),
      ),
    ));
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: false,
      expandedHeight: 250.0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        background: _buildBackgroundAppbar(context),
        title: Container(
          color: ColorsApp.colorPrimary,
          height: kToolbarHeight + 20,
          child: Row(children: [
            Expanded(
              child: _buildTextField(),
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ))
          ]),
        ),
      ),
    );
  }

  Widget _buildBackgroundAppbar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(Constants.imgBackground),
            fit: BoxFit.none,
            scale: 1.2,
            alignment: Alignment(-0.8, 0.2),
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.multiply)),
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Image.asset(Constants.imgLogo,
            width: MediaQuery.of(context).size.width * 0.7),
      ),
    );
  }

  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          hintText: 'Buscar personaje...',
          hintStyle: TextStyle(color: Colors.white, fontSize: 14),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          contentPadding: EdgeInsets.zero,
        ),
        style: const TextStyle(color: Colors.white),
        onChanged: (text) {
          if (text.length >= 3 && homeBloc.lastSearch != text) {
            homeBloc.lastSearch = text;
            homeBloc.searchCharacter();
          }
        },
      ),
    );
  }
}

class HomeApp extends InheritedWidget {
  final Widget child;
  final HomeBloc homeBloc;

  const HomeApp({Key? key, required this.child, required this.homeBloc})
      : super(key: key, child: child);

  static HomeApp? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HomeApp>();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
