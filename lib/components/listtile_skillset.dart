import 'package:flutter/material.dart';

class ListTileSkillset extends StatefulWidget {
  final String itemName;
  final bool isChecked;
  final Function(String) addSkillset;
  final Function(String) removeSkillset;

  const ListTileSkillset({
    super.key, 
    required this.itemName,
    required this.isChecked,
    required this.addSkillset,
    required this.removeSkillset
  });

  @override
  State<ListTileSkillset> createState() => _ListTileSkillsetState();
}

class _ListTileSkillsetState extends State<ListTileSkillset> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          if (isSelected) {
            widget.addSkillset(widget.itemName);
          }
          else {
            widget.removeSkillset(widget.itemName);
          }
        });
      },
      child: ListTile(
        title: Text(
          widget.itemName,
          style: TextStyle(
            color: isSelected ? Colors.green : Colors.black45,
            fontWeight: FontWeight.w500
          )
        ),
        trailing: isSelected ? const Icon(Icons.check) : null,
      ),
    );
  }
}
