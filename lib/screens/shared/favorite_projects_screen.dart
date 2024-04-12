import 'package:flutter/material.dart';

import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/components/customprojectitem.dart';
import 'package:studenthub/models/company_model.dart';
import 'package:studenthub/screens/shared/project_detail_screen.dart';

class FavoriteProjectsScreen extends StatelessWidget {
  final List<Project> favoriteList;
  final Function(Project) onRemoveProject;

  const FavoriteProjectsScreen({
    super.key,
    required this.favoriteList,
    required this.onRemoveProject,
  });

  void removeFromFavorites(Project project) {
    print(project.projectId);

    favoriteList.remove(project);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(canBack: true),
      body: favoriteList.isEmpty
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
                      itemCount: favoriteList.length,
                      itemBuilder: (context, index) {
                        final project = favoriteList[index];
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
                          isFavorite: favoriteList.contains(project),
                          onFavoriteToggle: (isFavorite) {
                            onRemoveProject(project);
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
