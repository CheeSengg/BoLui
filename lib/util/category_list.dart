import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bolui/models/combined_model.dart';

class CategoryList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CategoryListState();
  }
}

class _CategoryListState extends State<CategoryList> {
  double expenditure = 0;
  List<Tiles> tiles = List<Tiles>();
  final List<String> categories = <String>[
    'Entertainment',
    'Food',
    'Grocery',
    'Transport',
    'Others'
  ];
  final List<IconData> icons = <IconData>[
    Icons.shopping_basket,
    Icons.fastfood,
    Icons.local_grocery_store,
    Icons.directions_transit,
    Icons.shopping_cart,
  ];

  _generateCategoryTiles(List<Entry> category) {
    for (int i = 0; i < categories.length; i++) {
      Tiles eachCategory = Tiles(categories[i], 0.0);
      eachCategory.icon = icons[i];
      var list = category.where((p) => p.category == categories[i]);
      list.forEach((n) {
        //Expansion tile works in recurrance? Created a tile with basic amount, name and a list of other tiles.
        //This function maps the category to a tile, then adds the same details to show to the list of tiles under that category
        Tiles eachEntry = Tiles(n.description, n.amount);
        eachCategory.amount += n.amount;
        eachCategory.entries.add(eachEntry);
      });
      tiles.add(eachCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    tiles = List();
    var category = Provider.of<List<Entry>>(context);
    _generateCategoryTiles(category);

    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildTiles(tiles[index]);
      },
      itemCount: tiles.length,
    );
  }

  Widget _buildTiles(Tiles root) {
    if (root.entries.isEmpty) {
      return ListTile(
        leading: Icon(root.icon),
        title: Text(root.title),
        trailing: Text(root.amount.toStringAsFixed(2)),
      );
    }

    return ExpansionTile(
      title: Text(root.title),
      leading: Icon(root.icon),
      trailing: Text(root.amount.toStringAsFixed(2)),
      children: <Widget>[
        Divider(),
        ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(root.entries[index].title),
              trailing: Text(root.entries[index].amount.toStringAsFixed(2)),
            );
          },
          separatorBuilder: (context, index) => new Divider(),
          itemCount: root.entries.length,
        )
      ],
    );
  }
}


class Tiles {
  String title;
  double amount;
  List<Tiles> entries = List<Tiles>();
  IconData icon;

  Tiles(this.title, this.amount);
}
