import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/models/DTO/character.dart';
import 'package:rick_and_morty/src/screens/character/character_screen.dart';
import 'package:rick_and_morty/src/screens/home/widgets/favourite_widget.dart';

class CardCharacter extends StatelessWidget {
  const CardCharacter({Key? key, required this.character}) : super(key: key);

  final Character character;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CharacterScreen(
                    character: character,
                  )),
        );
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.black38,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                      image: DecorationImage(
                          image: NetworkImage(character.image!),
                          fit: BoxFit.cover),
                    ),
                    child: const Align(
                      alignment: Alignment(1, 0.9),
                      child: FavouriteWidget(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 10, right: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTileStatus(),
                        _buildTile(
                            'Last know location:', character.location!.name!),
                        _buildTile('First seen in:', character.origin!.name!),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTile(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Text(
          subtitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTileStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            Expanded(child: Text(character.getInfo())),
          ],
        ),
        Text(
          character.name!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
