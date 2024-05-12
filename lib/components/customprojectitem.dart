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
  final bool canFavorite;

  const CustomProjectItem({
    Key? key,
    required this.project,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.canFavorite = true,
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
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
      padding: const EdgeInsets.all(10),
      height: 215,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(9)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
            spreadRadius: 2.0,
            blurRadius: 2.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: widget.onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: Text(
                    widget.project.title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: AppFonts.h0FontSize,
                      fontWeight: FontWeight.w600,
                      color: mainColor,
                    ),
                  ),
                ),
                Text(
                  widget.project.companyName ?? 'Unknown',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFonts.h2FontSize,
                    fontWeight: FontWeight.w500,
                    color: mainColor.withOpacity(0.8),
                  ),
                ),
                Text(
                  'Created ${timeSinceCreated(widget.project.createdAt)}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFonts.h4FontSize,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),

                // Flexible(
                //   flex: 1,
                //   child: Text(
                //     'Time: ${checkProjectScope(widget.project.projectScopeFlag)}, ${widget.project.numberOfStudents} students needed',
                //     overflow: TextOverflow.ellipsis,
                //     style: TextStyle(
                //       fontSize: AppFonts.h3FontSize,
                //       color: Theme.of(context).colorScheme.onSurface,
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 5,
                ),

                Flexible(
                  flex: 4,
                  child: SizedBox(
                    height: 100,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Time: ',
                              style: TextStyle(
                                fontSize: AppFonts.h3FontSize,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              checkProjectScope(widget.project.projectScopeFlag),
                              style: TextStyle(
                                fontSize: AppFonts.h3FontSize,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Need: ',
                              style: TextStyle(
                                fontSize: AppFonts.h3FontSize,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              '${widget.project.numberOfStudents}',
                              style: TextStyle(
                                fontSize: AppFonts.h3FontSize,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Description: ',
                              style: TextStyle(
                                fontSize: AppFonts.h3FontSize,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${widget.project.description}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: AppFonts.h3FontSize,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Proposals: ',
                              style: TextStyle(
                                fontSize: AppFonts.h3FontSize,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              checkCountProposal(widget.project.countProposals),
                              style: TextStyle(
                                fontSize: AppFonts.h3FontSize,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -10,
            right: 0,
            child: widget.canFavorite
                ? IconButton(
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
                    color: Theme.of(context).colorScheme.primary,
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
