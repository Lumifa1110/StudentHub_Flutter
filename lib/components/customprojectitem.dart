import 'package:flutter/material.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/mock_data.dart';

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
      height: 164,
      child: Stack(
        children: [
          const Divider(
            color: blackTextColor,
            thickness: 2.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: InkWell(
              onTap: widget.onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      widget.project.timeCreated,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      widget.project.titleOfJob,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '${widget.project.projectScope}, ${widget.project.requireStudents} needed',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Text(
                      widget.project.studentGain,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      widget.project.numOfProposals,
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
