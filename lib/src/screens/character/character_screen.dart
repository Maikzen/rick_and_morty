import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/bloc/character/character_bloc.dart';
import 'package:rick_and_morty/src/models/DTO/character.dart';
import 'package:rick_and_morty/src/providers/colors.dart';
import 'package:rick_and_morty/src/providers/constants.dart';
import 'package:rick_and_morty/src/screens/home/widgets/card_character.dart';
import 'package:rick_and_morty/src/screens/home/widgets/favourite_widget.dart';
import 'package:rick_and_morty/src/services/characters/characters_http_service.dart';
import 'package:rick_and_morty/src/services/episodes/episodes_http_service.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({Key? key, required this.character}) : super(key: key);

  final Character character;

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  late CharacterBloc characterBloc;

  final double _paddingH = 20;
  final double _favWidth = 70;
  final double _paddingFav = 10;
  final double _factorImg = 0.2;

  @override
  void initState() {
    characterBloc = CharacterBloc(
        charactersHttpService: CharactersHttpService(),
        episodesHttpService: EpisodesHttpService(),
        character: widget.character);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                _buildContent(context),
                _buildBottom(),
              ],
            ),
          )),
    );
  }

  Widget _buildHeader(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.5,
      color: ColorsApp.colorPrimary,
      child: Stack(
        children: [
          Container(
            height: size.height * 0.25,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Constants.imgCharacterBackground),
                  colorFilter:
                      ColorFilter.mode(Colors.black26, BlendMode.multiply),
                  fit: BoxFit.cover),
            ),
          ),
          Column(
            children: [
              Expanded(flex: 3, child: Container()),
              Expanded(
                  flex: 4,
                  child: ClipOval(
                    child: Hero(
                      tag: 'img' + widget.character.id.toString(),
                      child: Container(
                        height: size.height * _factorImg,
                        width: size.height * _factorImg,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          image: DecorationImage(
                            image: NetworkImage(widget.character.image!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  )),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: _favWidth / 2 - _paddingFav,
                    ),
                    _buildStatus(),
                    Text(
                      widget.character.name!,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white),
                    ),
                    Text(
                      widget.character.species!.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: size.height / 4 +
                size.height * _factorImg / 2 -
                _favWidth / 2 +
                _paddingFav,
            left: size.width / 2 - _favWidth / 2,
            child: const FavouriteWidget(
              selected: true,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ClipOval(
            child: Container(
              height: 10,
              width: 10,
              color: widget.character.status!.toLowerCase() == Status.alive.name
                  ? Colors.green
                  : (widget.character.status!.toLowerCase() == Status.dead.name
                      ? Colors.red
                      : Colors.grey),
            ),
          ),
        ),
        Text(
          widget.character.status.toString().toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: _paddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfo(context),
          SizedBox(height: _paddingH),
          _buildEpisodes(context),
          SizedBox(height: _paddingH),
          _buildInterestingCharacters(context),
          SizedBox(height: _paddingH),
          _buildButtonShare()
        ],
      ),
    );
  }

  Widget _buildEpisodes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Episodios',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: _paddingH),
        AnimatedBuilder(
            animation: characterBloc,
            builder: (context, _) {
              return Wrap(
                  spacing: _paddingH,
                  runSpacing: _paddingH / 2,
                  children: characterBloc.listEpisodes
                      .map((e) => _buildCardInfo(
                          context, e.name.toString(), e.episode.toString(),
                          moreInfo: e.dateFormated()))
                      .toList());
            }),
        widget.character.episode!.length > 4
            ? Center(
                child: TextButton(
                    child: const Text(
                      'Ver más',
                      style: TextStyle(
                          color: ColorsApp.colorSecundary,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: characterBloc.showMore),
              )
            : const SizedBox.shrink()
      ],
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Información',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: _paddingH),
        Wrap(
          spacing: _paddingH,
          runSpacing: _paddingH / 2,
          children: [
            _buildCardInfo(context, 'Gender:',
                widget.character.gender.toString().toUpperCase(),
                icon: Icons.info),
            _buildCardInfo(
                context, 'Origin:', widget.character.origin!.name.toString(),
                icon: Icons.info),
            _buildCardInfo(
                context,
                'Type:',
                widget.character.type.toString().isEmpty
                    ? 'Unknown'
                    : widget.character.type.toString(),
                icon: Icons.info)
          ],
        ),
      ],
    );
  }

  Widget _buildInterestingCharacters(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personajes Interesantes',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: _paddingH),
        AnimatedBuilder(
            animation: characterBloc,
            builder: (context, _) {
              return Column(
                children: characterBloc.listInterestingCharacters
                    .map((e) => CardCharacter(
                          character: e,
                        ))
                    .toList(),
              );
            })
      ],
    );
  }

  Widget _buildCardInfo(BuildContext context, String title, String subtitle,
      {IconData? icon, String? moreInfo}) {
    return Container(
      width: (MediaQuery.of(context).size.width - _paddingH * 3) / 2,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon != null
                ? Row(
                    children: [
                      Icon(
                        icon,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(title)
                    ],
                  )
                : Text(title, maxLines: 1, overflow: TextOverflow.clip),
            Text(
              subtitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            moreInfo != null
                ? Text(
                    moreInfo,
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Widget _buildBottom() {
    return Container(
      height: 150,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Constants.imgBackground),
          fit: BoxFit.none,
          scale: 1,
          alignment: Alignment(0.05, 0.7),
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.multiply),
        ),
      ),
    );
  }

  Widget _buildButtonShare() {
    return Center(
      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Compartir personaje',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white),
          ),
        ),
        onPressed: () {},
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          )),
          backgroundColor: MaterialStateProperty.all(ColorsApp.colorSecundary),
        ),
      ),
    );
  }
}
