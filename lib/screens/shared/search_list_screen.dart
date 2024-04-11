import 'package:flutter/material.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/components/customprojectitem.dart';
import 'package:studenthub/components/bottomsheet_customsearchbar.dart';
import 'package:studenthub/components/radiolist_projectlength.dart';
import 'package:studenthub/components/textfield_label_v2.dart';
import 'package:studenthub/screens/shared/project_detail_screen.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/mock_data.dart';

class SearchListScreen extends StatefulWidget {
  final String seachQuery;

  const SearchListScreen({
    super.key,
    required this.seachQuery,
  });

  @override
  State<SearchListScreen> createState() => _SearchListScreenState();
}

class _SearchListScreenState extends State<SearchListScreen> {
  String searchQuery = '';
  List<Project> myFavoriteProjects = [];
  List<Project> filteredProjects = [];
  String? selectedProjectLength = 'less than one';

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
      searchQuery = query.toLowerCase();

      if (searchQuery.isNotEmpty) {
        filteredProjects = mockProjects.where((project) {
          return project.titleOfJob.toLowerCase().contains(searchQuery) ||
              project.projectDetail.toLowerCase().contains(searchQuery);
        }).toList();
      } else {
        // If searchQuery is empty, display all projects
        filteredProjects = List.from(mockProjects);
      }
      Navigator.pop(context);
    });
  }

  // final TextEditingController _searchController = TextEditingController();
  final TextEditingController _studentsNeededController =
      TextEditingController();
  final TextEditingController _proposalsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(
        canBack: true,
        title: 'Project Search',
      ),
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
                            return SingleChildScrollView(
                              reverse: true,
                              child: Container(
                                height: bottomSheetHeight,
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: whiteTextColor,
                                            border: Border.all(
                                              color: blackTextColor,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const Center(
                                              child: Icon(
                                                Icons.close,
                                                size: 18,
                                                color: blackTextColor,
                                                weight: 5.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'Filter by',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: blackTextColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Divider(
                                      height: 1.0,
                                      thickness: 2.0,
                                      color: blackTextColor,
                                    ),
                                    TextFieldWithLabel2(
                                      label: 'Students needed',
                                      controller: _studentsNeededController,
                                    ),
                                    TextFieldWithLabel2(
                                      label: 'Proposals less than',
                                      controller: _proposalsController,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      'Project length',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: blackTextColor),
                                    ),
                                    RadioListProjectLength(
                                      selectedLength: selectedProjectLength,
                                      onLengthSelected: (value) {
                                        setState(() {
                                          selectedProjectLength = value;
                                        });
                                      },
                                    ),
                                    const Spacer(),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 180,
                                          height: 40,
                                          padding: const EdgeInsets.all(0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: blackTextColor,
                                                width: 2.0),
                                            color: whiteTextColor,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: blackTextColor,
                                                offset: Offset(2, 3),
                                              ),
                                            ],
                                          ),
                                          child: TextButton(
                                            onPressed: () {},
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                  OutlinedBorder>(
                                                const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.zero),
                                              ),
                                            ),
                                            child: const Text(
                                              'Clear filters',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: blackTextColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 180,
                                          height: 40,
                                          padding: const EdgeInsets.all(0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: blackTextColor,
                                                width: 2.0),
                                            color: whiteTextColor,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: blackTextColor,
                                                offset: Offset(2, 3),
                                              ),
                                            ],
                                          ),
                                          child: TextButton(
                                            onPressed: () {},
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                  OutlinedBorder>(
                                                const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.zero),
                                              ),
                                            ),
                                            child: const Text(
                                              'Apply',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: blackTextColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ListView.builder(
                itemCount: filteredProjects.length,
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
