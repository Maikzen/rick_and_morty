import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/models/DTO/character.dart';
import 'package:rick_and_morty/src/providers/colors.dart';
import 'package:rick_and_morty/src/providers/constants.dart';

class CharacterScreen extends StatelessWidget {
  const CharacterScreen({Key? key, required this.character}) : super(key: key);

  final Character character;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopContent(context),
            _buildInfo(context),
            _buildBottomContent(),
          ],
        ),
      )),
    );
  }

  Widget _buildTopContent(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.5,
      color: ColorsApp.colorBackground,
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
                    child: Container(
                      height: size.height * 0.2,
                      width: size.height * 0.2,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 5),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        image: DecorationImage(
                          image: NetworkImage(character.image!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatus(),
                    Text(
                      character.name!,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white),
                    ),
                    Text(
                      character.species!.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          )
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
              color: character.status!.toLowerCase() == Status.alive.name
                  ? Colors.green
                  : (character.status!.toLowerCase() == Status.dead.name
                      ? Colors.red
                      : Colors.grey),
            ),
          ),
        ),
        Text(
          character.status.toString().toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildInfo(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
    );
  }

  Widget _buildBottomContent() {
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
}
