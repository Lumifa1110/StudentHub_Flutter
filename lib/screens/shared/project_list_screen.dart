import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/components/customprojectitem.dart';
import 'package:studenthub/components/bottomsheet_customsearchbar.dart';
import 'package:studenthub/screens/shared/favorite_projects_screen.dart';
import 'package:studenthub/screens/shared/project_detail_screen.dart';
import 'package:studenthub/screens/shared/search_list_screen.dart';
import 'package:studenthub/utils/colors.dart';

import 'package:studenthub/utils/mock_data.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  String searchQuery = '';
  List<Project> allProject = [];
  List<Project> myFavoriteProjects = [];

  Future<void> _loadProjects() async {}

  void removeFromFavorites(Project project) {
    setState(() {
      myFavoriteProjects.remove(project);
    });
  }

  void updateFavoriteStatus(Project project, bool isFavorite) {
    setState(() {
      if (isFavorite) {
        myFavoriteProjects.add(project);
      } else {
        myFavoriteProjects.remove(project);
      }
    });
  }

  void handleSearchSubmitted(String query) {
    setState(() {
      searchQuery = query;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchListScreen(
            seachQuery: searchQuery,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(canBack: false),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomSearchBar(
                  onChanged: (query) => setState(
                    () => searchQuery = query.toLowerCase(),
                  ),
                  onSubmitted: handleSearchSubmitted,
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: blackTextColor,
                  ),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FavoriteProjectsScreen(
                              favoriteList: myFavoriteProjects,
                              onRemoveProject: (project) {
                                updateFavoriteStatus(project, false);
                              },
                            ),
                          ),
                        );
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.solidHeart,
                        color: whiteTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ListView.builder(
                itemCount: mockProjects.length,
                itemBuilder: (context, index) {
                  final project = mockProjects[index];
                  return CustomProjectItem(
                    project: project,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProjectDetailScreen(itemId: project.projectId),
                        ),
                      );
                    },
                    isFavorite: myFavoriteProjects.contains(project),
                    onFavoriteToggle: (isFavorite) {
                      updateFavoriteStatus(project, isFavorite);
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
