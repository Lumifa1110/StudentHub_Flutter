import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/components/customprojectitem.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/mock_data.dart';

class FavoriteProjectsPage extends StatelessWidget {
  final List<Project> favoriteList;
  final Function(Project) onRemoveProject;

  const FavoriteProjectsPage({
    Key? key,
    required this.favoriteList,
    required this.onRemoveProject,
  }) : super(key: key);

  void removeFromFavorites(Project project) {
    print(project.projectId);

    favoriteList.remove(project);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 5.0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFF4169E1),
          ),
          backgroundColor: mainColor,
          title: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Student',
                style: TextStyle(
                  color: whiteTextColor,
                  fontSize: 26,
                ),
              ),
              Text(
                'Hub',
                style: TextStyle(
                  color: blackTextColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.person,
                size: 26,
                color: blackTextColor,
              ),
            )
          ],
        ),
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
                              Navigator.pushNamed(
                                context,
                                '/detail',
                                arguments: project.projectId,
                              );
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
      ),
    );
  }
}
