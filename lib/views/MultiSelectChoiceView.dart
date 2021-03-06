import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> skillsList;
  final Function(List<String>) onSelectionChanged;
  final List<String> selectedChoices;
  MultiSelectChip(this.skillsList,this.selectedChoices, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState(this.selectedChoices);
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  List<String> selectedChoices = List();
  _MultiSelectChipState(this.selectedChoices);

  _buildChoiceList() {
    List<Widget> choices = List();

    widget.skillsList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );}
  }