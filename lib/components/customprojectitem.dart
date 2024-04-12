import 'package:flutter/material.dart';
import 'package:studenthub/models/company_model.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';
import 'package:studenthub/utils/timer.dart';

class CustomProjectItem extends StatefulWidget {
  final Project project;
  final VoidCallback onTap;
  final bool isFavorite; // New parameter
  final Function(bool) onFavoriteToggle;

  const CustomProjectItem({
    Key? key,
    required this.project,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  State<CustomProjectItem> createState() => _CustomProjectItemState();
}

class _CustomProjectItemState extends State<CustomProjectItem> {
  late bool isFavorite; // Declare isFavorite as instance variable

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite; // Set initial favorite status
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 166,
      child: Stack(
        children: [
          const Divider(
            color: blackTextColor,
            thickness: 2.0,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: InkWell(
              onTap: widget.onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    child: Text(
                      'Created ${f_timeSinceCreated(widget.project.createdAt)}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: AppFonts.h4FontSize),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      widget.project.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: AppFonts.h2FontSize,
                          fontWeight: FontWeight.w500,
                          color: AppColor.tertiary),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '${widget.project.projectScopeFlag}, ${widget.project.numberOfStudents} needed',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Text(
                      widget.project.description!,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      widget.project.countProposals.toString(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 0,
            child: IconButton(
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
                widget.onFavoriteToggle(isFavorite);
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 30,
              ),
              color: mainColor,
            ),
          ),
        ],
      ),
    );
  }
}
