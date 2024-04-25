import 'package:flutter/material.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class BoxSkillset extends StatefulWidget {
  final int id;
  final String text;
  final Function(int) onDelete;
  final bool hideDelete;

  const BoxSkillset({
    super.key,
    required this.id,
    required this.text,
    required this.onDelete,
    this.hideDelete = false,
  });

  @override
  State<BoxSkillset> createState() => _BoxSkillsetState();
}

class _BoxSkillsetState extends State<BoxSkillset> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.hideDelete
          ? const EdgeInsets.symmetric(vertical: 6, horizontal: 20)
          : const EdgeInsets.only(left: 8, top: 3, bottom: 3),
      decoration: BoxDecoration(
        border: Border.all(color: lightgrayColor),
        borderRadius: BorderRadius.circular(9),
        color: mainColor,
      ),
      child: widget.hideDelete
          ? Text(
              widget.text,
              style: const TextStyle(
                  color: whiteTextColor, fontSize: AppFonts.h2FontSize),
            )
          : Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  widget.text,
                  style: const TextStyle(
                      color: whiteTextColor, fontSize: AppFonts.h2FontSize),
                ),
                SizedBox(
                  height: 36,
                  width: 36,
                  child: IconButton(
                    padding: const EdgeInsets.all(3.0),
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                    iconSize: 16,
                    onPressed: () {
                      setState(() {
                        widget.onDelete(widget.id);
                      });
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
