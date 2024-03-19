import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/components/customprojectitem.dart';
import 'package:studenthub/components/customsearchbar.dart';
import 'package:studenthub/pages/favorite_projects_page.dart';
import 'package:studenthub/pages/search_list_page.dart';
import 'package:studenthub/utils/colors.dart';

import 'package:studenthub/utils/mock_data.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({Key? key}) : super(key: key);

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  String searchQuery = '';
  List<Project> myFavoriteProjects = [];

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
          builder: (context) => SearchListPage(
            seachQuery: searchQuery,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                              builder: (context) => FavoriteProjectsPage(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: ListView.builder(
                  itemCount: mockProjects.length,
                  itemBuilder: (context, index) {
                    final project = mockProjects[index];
                    return CustomProjectItem(
                      project: project,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: project.projectId,
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
      ),
    );
  }
}
