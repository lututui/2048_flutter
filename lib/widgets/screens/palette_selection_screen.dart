import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/settings_provider.dart';
import 'package:flutter_2048/types/tile_color.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:provider/provider.dart';

class PaletteSelectionScreen extends StatelessWidget {
  const PaletteSelectionScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            title: Text('Game palette'),
            pinned: true,
            primary: false,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              buildGamePaletteWidget,
              childCount: Palette.gamePalettes.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGamePaletteWidget(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          final isSelected = settings.palette == Palette.gamePalettes[index];

          return FlatButton(
            onPressed: () {
              if (isSelected) return;

              settings.palette = Palette.gamePalettes[index];
            },
            child: Card(
              elevation: isSelected ? 6.0 : 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
              color: isSelected
                  ? Theme.of(context).colorScheme.secondaryVariant
                  : Theme.of(context).colorScheme.primaryVariant,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                height: isSelected ? 150.0 : 120.0,
                child: child,
              ),
            ),
          );
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
              child: Row(
                children: <Widget>[
                  Text(
                    Palette.gamePalettes[index].name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
            Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Row(
                  children: Palette.gamePalettes[index].tileColors.map(
                    (TileColor tile) {
                      return Expanded(
                        child: Container(color: tile.backgroundColor),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
