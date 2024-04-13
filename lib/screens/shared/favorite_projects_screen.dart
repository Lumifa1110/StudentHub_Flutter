import 'package:flutter/material.dart';

import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/components/customprojectitem.dart';
import 'package:studenthub/models/company_model.dart';
import 'package:studenthub/screens/shared/project_detail_screen.dart';

class FavoriteProjectsScreen extends StatefulWidget {
  final List<Project> favoriteList;
  final Function(Project, bool) onRemoveProject;

  const FavoriteProjectsScreen({
    super.key,
    required this.favoriteList,
    required this.onRemoveProject,
  });

  @override
  State<FavoriteProjectsScreen> createState() => _FavoriteProjectsScreenState();
}

class _FavoriteProjectsScreenState extends State<FavoriteProjectsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(
        canBack: true,
        title: 'My Favorites',
      ),
      body: widget.favoriteList.isEmpty
          ? const Center(
              child: Text(
                "You don't have any favorites.",
                style: TextStyle(fontSize: 20),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: ListView.builder(
                      itemCount: widget.favoriteList.length,
                      itemBuilder: (context, index) {
                        final project = widget.favoriteList[index];
                        return CustomProjectItem(
                          project: project,
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => ProjectDetailScreen(
                            //         itemId: project.projectId),
                            //   ),
                            // );
                          },
                          isFavorite: widget.favoriteList.contains(project),
                          onFavoriteToggle: (isFavorite) {
                            widget.onRemoveProject(project, isFavorite);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: const CustomBottomNavBar(
        initialIndex: 0,
      ),
    );
  }
}
