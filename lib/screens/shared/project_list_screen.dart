import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/components/customprojectitem.dart';
import 'package:studenthub/components/bottomsheet_customsearchbar.dart';
import 'package:studenthub/config/config.dart';
import 'package:studenthub/models/company_model.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  late SharedPreferences _prefs;
  String searchQuery = '';
  List<Project> allProject = [];
  List<Project> myFavoriteProjects = [];
  List<String> errorMessages = [];
  bool isStudent = false;

  Future<void> _loadScreen() async {
    allProject.clear;
    myFavoriteProjects.clear();
    _prefs = await SharedPreferences.getInstance();
    final role = _prefs.getInt('current_role');
    final studentprofile = _prefs.getString('studentprofile');
    if (role == 0) {
      if (studentprofile == 'null') {
        Navigator.pushReplacementNamed(context, '/student');
      }
      _loadFavoriteProjects();
      setState(() {
        isStudent = true;
      });
    } else {
      setState(() {
        isStudent = false;
      });
    }
  }

  Future<void> _loadProjects() async {
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse('$uriBase/api/project'),
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
    final studentId = jsonDecode(studentprofile!)['id'];

    try {
      final response = await http.get(
        Uri.parse('$uriBase/api/favoriteProject/$studentId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      print('res favorite: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body)['result'];

        setState(() {
          // Clear existing favorite projects
          myFavoriteProjects.clear();
          // Parse each item in the response and extract the project object
          for (var item in responseData) {
            final project = Project.fromJson(item['project']);
            myFavoriteProjects.add(project);
          }
        });
      } else {
        // Handle error
        print('Error load: ${response.statusCode}');
        print('Error load: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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
        // Successfully patched favorite projects
        print('Favorite projects updated successfully');
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  bool isFavoriteProject(Project project) {
    return myFavoriteProjects
        .where(
            (favoriteProject) => favoriteProject.projectId == project.projectId)
        .isNotEmpty;
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

  void handleSearchSubmitted(String query) {
    setState(() {
      searchQuery = query;
      print(query);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchListScreen(
            searchQuery: searchQuery,
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadScreen();
    _loadProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthAppBar(
        canBack: false,
        onRoleChanged: (result) {
          _loadScreen();
        },
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
                  onSubmitted: handleSearchSubmitted,
                ),
                if (isStudent)
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
                                onRemoveProject: updateFavoriteProject,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProjectDetailScreen(itemId: project.projectId),
                        ),
                      );
                    },
                    isFavorite: isFavoriteProject(project),
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
