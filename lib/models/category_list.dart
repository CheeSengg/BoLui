import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'combined_model.dart';

class CategoryList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CategoryListState();
  }
}

class _CategoryListState extends State<CategoryList> {
  Map<String, double> categories = Map();
  final List<String> entries = <String>['Entertainment', 'Food', 'Grocery', 'Transport', 'Others'];
  final List<IconData> icons = <IconData>[
    Icons.shopping_basket,
    Icons.fastfood,
    Icons.local_grocery_store,
    Icons.directions_transit,
    Icons.shopping_cart,

  ];

  _generateList(BuildContext context) {
    var category = Provider.of<List<Entry>>(context) ?? List();
    for(int i = 0; i < entries.length; i++){
      double amount = 0.0;
      var list = category.where((p) => p.category == entries[i]);
      list.forEach((n) => amount += n.amount);
      categories[entries[i]] = amount;
    }
  }


  @override
  Widget build(BuildContext context) {
    _generateList(context);

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(icons[index]),
          title: Text(entries[index]),
          trailing: Text(categories[entries[index]].toString()),
        );
      },
    );
  }
}
