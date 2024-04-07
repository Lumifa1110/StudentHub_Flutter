import 'package:flutter/material.dart';

class ListTileSkillset extends StatefulWidget {
  final String itemName;
  final int itemId;
  final bool isChecked;
  final Function(int) addSkillset;
  final Function(int) removeSkillset;

  const ListTileSkillset({
    Key? key,
    required this.itemName,
    required this.itemId,
    required this.isChecked,
    required this.addSkillset,
    required this.removeSkillset,
  }) : super(key: key);

  @override
  _ListTileSkillsetState createState() => _ListTileSkillsetState();
}

class _ListTileSkillsetState extends State<ListTileSkillset> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isChecked;
    print(isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          if (isSelected) {
            widget
                .addSkillset(widget.itemId); // Pass itemId instead of itemName
          } else {
            widget.removeSkillset(
                widget.itemId); // Pass itemId instead of itemName
          }
        });
      },
      child: ListTile(
        title: Text(
          widget.itemName,
          style: TextStyle(
            color: widget.isChecked ? Colors.green : Colors.black45,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: widget.isChecked ? const Icon(Icons.check) : null,
      ),
    );
  }
}
