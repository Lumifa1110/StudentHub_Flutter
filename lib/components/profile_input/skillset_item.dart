import 'package:flutter/material.dart';
import 'package:studenthub/models/index.dart';

class SkillsetItem extends StatefulWidget {
  final SkillSet skillset;
  final bool isChecked;
  final Function(int) addSkillset;
  final Function(int) removeSkillset;
  
  const SkillsetItem({
    super.key,
    required this.skillset,
    required this.isChecked,
    required this.addSkillset,
    required this.removeSkillset,
  });

  @override
  SkillsetItemState createState() => SkillsetItemState();
}

class SkillsetItemState extends State<SkillsetItem> {
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
            widget.addSkillset(widget.skillset.id);
          } else {
            widget.removeSkillset(widget.skillset.id);
          }
        });
      },
      child: ListTile(
        title: Text(
          widget.skillset.name,
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
