import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/components/customprojectitem.dart';
import 'package:studenthub/components/bottomsheet_customsearchbar.dart';
import 'package:studenthub/components/radiolist_projectlength.dart';
import 'package:studenthub/components/textfield_label_v2.dart';
import 'package:studenthub/config/config.dart';
import 'package:studenthub/enums/project_scope.dart';
import 'package:studenthub/models/company_model.dart';
import 'package:studenthub/screens/shared/project_detail_screen.dart';
import 'package:studenthub/utils/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchListScreen extends StatefulWidget {
  final String searchQuery;

  const SearchListScreen({
    super.key,
    required this.searchQuery,
  });

  @override
  State<SearchListScreen> createState() => _SearchListScreenState();
}

class _SearchListScreenState extends State<SearchListScreen> {
  late SharedPreferences _prefs;
  String _searchQuery = '';
  List<Project> myFavoriteProjects = [];
  List<Project> filteredProjects = [];
  ProjectScopeFlag? selectedProjectScope;
  // final TextEditingController _searchController = TextEditingController();
  final TextEditingController _studentsNeededController =
      TextEditingController();
  final TextEditingController _proposalsController = TextEditingController();

  Future<void> _patchFavoriteProject(int projectId, int disableFlag) async {
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    final studentprofile = _prefs.getString('studentprofile');
    final studentId = jsonDecode(studentprofile!)['id'];

    try {
      final response = await http.patch(
        Uri.parse('$uriBase/api/favoriteProject/$studentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':
              'application/json', // Specify the content type as JSON
        },
        body: jsonEncode({
          'projectId': projectId,
          'disableFlag': disableFlag,
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Favorite projects updated successfully');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void clearFilter() {
    setState(() {
      _studentsNeededController.clear();
      _proposalsController.clear();
      selectedProjectScope = null;
      _loadFilteredProject();
      Navigator.pop(context);
    });
  }

  Future<void> _loadFilteredProject() async {
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');

    _searchQuery = widget.searchQuery;

    Map<String, dynamic> queryParams = {
      if (_searchQuery.isNotEmpty) 'title': _searchQuery,
      if (selectedProjectScope != null)
        'projectScopeFlag': selectedProjectScope!.index.toString(),
      if (_studentsNeededController.text.isNotEmpty)
        'numberOfStudents': _studentsNeededController.text.trim(),
      if (_proposalsController.text.isNotEmpty)
        'proposalsLessThan': _proposalsController.text.trim(),
    };

    try {
      final uri = Uri.https('api.studenthub.dev', '/api/project', queryParams);
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body)['result'];
        setState(() {
          filteredProjects =
              responseData.map((json) => Project.fromJson(json)).toList();
        });
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
      print(filteredProjects);
    } catch (e) {
      print('Error: $e');
    }
  }

  void updateFavoriteProject(Project project, bool isFavorite) {
    if (isFavorite) {
      _patchFavoriteProject(project.projectId, 0);
      setState(() {
        myFavoriteProjects.add(project);
      });
    } else {
      _patchFavoriteProject(project.projectId, 1);
      setState(() {
        myFavoriteProjects.remove(project);
      });
    }
  }

  void filterProjects(String query) {
    print(query);
    setState(() {
      _searchQuery = query.toLowerCase();

      if (_searchQuery.isNotEmpty) {
        filteredProjects = myFavoriteProjects.where((project) {
          return project.title.toLowerCase().contains(_searchQuery) ||
              project.description!.toLowerCase().contains(_searchQuery);
        }).toList();
      } else {
        // If searchQuery is empty, display all projects
        filteredProjects = List.from(filteredProjects);
      }
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.searchQuery;
    // Initialize filteredProjects with all projects initially
    _loadFilteredProject();
  }

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
                    () => _searchQuery = query.toLowerCase(),
                  ),
                  onSubmitted: (query) => _loadFilteredProject(),
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
                                      selectedLength: selectedProjectScope,
                                      onLengthSelected: (value) {
                                        setState(() {
                                          selectedProjectScope = value;
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
                                            onPressed: () {
                                              clearFilter();
                                            },
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
                                            onPressed: () {
                                              _loadFilteredProject();
                                              Navigator.pop(context);
                                            },
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
                  final project = filteredProjects[index];
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
                      updateFavoriteProject(project, isFavorite);
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
