import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/components/customprojectitem.dart';
import 'package:studenthub/components/bottomsheet_customsearchbar.dart';
import 'package:studenthub/config/config.dart';
import 'package:studenthub/models/company_model.dart';
import 'package:studenthub/screens/shared/favorite_projects_screen.dart';
import 'package:studenthub/screens/shared/project_detail_screen.dart';
import 'package:studenthub/screens/shared/search_list_screen.dart';
import 'package:studenthub/utils/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  String searchQuery = '';
  List<Project> allProject = [];
  List<Project> myFavoriteProjects = [];
  List<String> errorMessages = [];
  late SharedPreferences _prefs;

  Future<void> _loadProjects() async {
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse('${uriBase}/api/project'),
        headers: {'Authorization': 'Bearer $token'},
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body)['result'];
        setState(() {
          allProject =
              responseData.map((json) => Project.fromJson(json)).toList();
        });
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _loadFavoriteProjects() async {
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    final studentprofile = _prefs.getString('studentprofile');
    try {
      final response = await http.get(
        Uri.parse('${uriBase}/api/favoriteProject/{studentId}'),
        headers: {'Authorization': 'Bearer $token'},
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body)['result'];
        setState(() {
          allProject =
              responseData.map((json) => Project.fromJson(json)).toList();
        });
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadProjects();
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
                itemCount: allProject.length,
                itemBuilder: (context, index) {
                  final project = allProject[index];
                  return CustomProjectItem(
                    project: project,
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         ProjectDetailScreen(itemId: project.projectId),
                      //   ),
                      // );
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
