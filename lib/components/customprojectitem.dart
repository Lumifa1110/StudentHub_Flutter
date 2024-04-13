import 'package:flutter/material.dart';
import 'package:studenthub/enums/project_scope.dart';
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
  late bool isFavorite;

  String checkProjectScope(int? scope) {
    switch (scope) {
      case 0:
        return 'less than 1 month';
      case 1:
        return '1 To 3 months';
      case 2:
        return '3 To 6 months';
      case 3:
        return 'more than 6 months';
      default:
        return 'Unknown';
    }
  }

  String checkCountProposal(int? count) {
    if (count == null || count < 0) {
      return 'Unknown';
    } else if (count == 0) {
      return 'No one';
    } else if (count == 1) {
      return 'Only one';
    } else if (count > 1 && count < 5) {
      return 'less than 5';
    } else {
      return '$count';
    }
  }

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite; // Set initial favorite status
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 196,
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
                      style: const TextStyle(
                          fontSize: AppFonts.h4FontSize, color: lightgrayColor),
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
                      'Time: ${checkProjectScope(widget.project.projectScopeFlag)}, ${widget.project.numberOfStudents} students needed',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: AppFonts.h4FontSize, color: lightgrayColor),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Text(
                      maxLines: 3,
                      widget.project.description!,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 15, color: blackTextColor),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      'Proposals: ${checkCountProposal(widget.project.countProposals)}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: AppFonts.h4FontSize, color: lightgrayColor),
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
                  widget.onFavoriteToggle(isFavorite);
                });
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
