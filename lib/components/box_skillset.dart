import 'package:flutter/material.dart';
import 'package:studenthub/models/index.dart';

class BoxSkillset extends StatefulWidget {
  final int id;
  final String text;
  final Function(int) onDelete;

  const BoxSkillset({
    super.key,
    required this.id,
    required this.text,
    required this.onDelete,
  });

  @override
  State<BoxSkillset> createState() => _BoxSkillsetState();
}

class _BoxSkillsetState extends State<BoxSkillset> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        padding: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(widget.text,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
              IconButton(
                icon: const Icon(Icons.close),
                color: Colors.white,
                iconSize: 16,
                onPressed: () {
                  setState(() {
                    widget.onDelete(widget.id);
                  });
                },
              ),
            ]));
  }
}
