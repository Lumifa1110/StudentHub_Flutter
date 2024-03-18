import 'package:flutter/material.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/components/customprojectitem.dart';
import 'package:studenthub/components/customsearchbar.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/mock_data.dart';

class SearchListPage extends StatefulWidget {
  final String seachQuery;

  const SearchListPage({
    Key? key,
    required this.seachQuery,
  }) : super(key: key);

  @override
  State<SearchListPage> createState() => _SearchListPageState();
}

class _SearchListPageState extends State<SearchListPage> {
  String searchQuery = '';
  List<Project> myFavoriteProjects = [];
  List<Project> filteredProjects = [];

  @override
  void initState() {
    super.initState();
    // Initialize filteredProjects with all projects initially
    filteredProjects = mockProjects;
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

  void filterProjects(String query) {
    print(query);
    setState(() {
      // Update the searchQuery
      searchQuery = query.toLowerCase();

      // Filter the projects based on searchQuery
      if (searchQuery.isNotEmpty) {
        // If searchQuery is not empty, filter projects
        filteredProjects = mockProjects.where((project) {
          return project.titleOfJob.toLowerCase().contains(searchQuery) ||
              project.projectDetail.toLowerCase().contains(searchQuery);
        }).toList();
      } else {
        // If searchQuery is empty, display all projects
        filteredProjects = List.from(mockProjects);
      }
    });
  }

  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const AuthAppBar(),
        body: Column(
          children: [
            const SizedBox(
              height: 25,
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
                    onSubmitted: (query) => filterProjects(query),
                  ),
                  Container(
                    width: 45,
                    height: 45,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: whiteTextColor,
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              final double screenHeight =
                                  MediaQuery.of(context).size.height;
                              final double appBarHeight =
                                  AppBar().preferredSize.height;
                              final double bottomSheetHeight =
                                  screenHeight - (appBarHeight * 3);
                              return Container(
                                height: bottomSheetHeight,
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 36,
                                          width: 36,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: whiteTextColor,
                                            border: Border.all(
                                              color: blackTextColor,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              size: 20,
                                            ),
                                            color: blackTextColor,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Add search results here
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.filter_alt,
                          size: 30,
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
                  itemCount: filteredProjects.length,
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
