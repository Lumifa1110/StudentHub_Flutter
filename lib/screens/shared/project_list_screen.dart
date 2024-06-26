import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/components/customprojectitem.dart';
import 'package:studenthub/components/bottomsheet_customsearchbar.dart';
import 'package:studenthub/config/config.dart';
import 'package:studenthub/models/company_model.dart';
import 'package:studenthub/screens/index.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late SharedPreferences _prefs;
  String searchQuery = '';
  List<Project> allProject = [];
  List<Project> myFavoriteProjects = [];
  List<String> errorMessages = [];
  late ScrollController _scrollController;
  late int _page;
  late int _perPage;
  bool _loadingMore = false;
  bool isStudent = false;
  bool isLoading = true;
  // bool _isMounted = false;
  late http.Client _httpClient;

  @override
  void dispose() {
    // _isMounted = false;
    _httpClient.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _page = 2;
    _perPage = 10;
    _scrollController = ScrollController();
    _httpClient = http.Client();
    _scrollController.addListener(_scrollListener);
    // _isMounted = true;
    _loadScreen();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !_loadingMore) {
      // At the bottom of the list, load more projects
      setState(() {
        _loadingMore = true;
      });
      _loadNext();
    }
  }

  Future<void> _loadScreen() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final role = _prefs.getInt('current_role');
      final studentProfile = _prefs.getString('student_profile');
      final companyProfile = _prefs.getString('company_profile');
      final token = _prefs.getString('token');

      // Check role and profile,
      if (role == 0) {
        if (studentProfile == 'null') {
          if (mounted) Navigator.pushReplacementNamed(context, '/student');
          return;
        }
        setState(() {
          isStudent = true;
        });
      } else {
        if (companyProfile == 'null') {
          if (mounted) Navigator.pushReplacementNamed(context, '/company');
          return;
        }
        setState(() {
          isStudent = false;
        });
      }

      await _loadProjects(token!);

      if (isStudent) {
        await _loadFavoriteProjects(token, studentProfile!);
      }

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      // Handle error
    }
  }

  Future<void> _loadProjects(String token) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$uriBase/api/project'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body)['result'];
        if (mounted) {
          setState(() {
            allProject = responseData.map((json) => Project.fromJson(json)).toList();
          });
        }
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is TimeoutException) {
        // Handle timeout error
        print('Network timeout error: $e');
      } else {
        // Handle other errors
        print('Error: $e');
      }
    }
  }

  Future<void> _loadNext() async {
    try {
      final token = _prefs.getString('token');
      final response = await _httpClient.get(
        Uri.parse('$uriBase/api/project?page=$_page&perPage=$_perPage'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body)['result'];
        if (mounted) {
          setState(() {
            allProject.addAll(responseData.map((json) => Project.fromJson(json)).toList());
            _page++; // Increment page number for next load
            _loadingMore = false;
          });
        }
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _loadFavoriteProjects(String token, String studentProfile) async {
    try {
      final studentId = jsonDecode(studentProfile)['id'];
      final response = await _httpClient.get(
        Uri.parse('$uriBase/api/favoriteProject/$studentId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body)['result'];
        if (mounted) {
          setState(() {
            myFavoriteProjects.clear();
            for (var project in allProject) {
              final isFavorite = responseData
                  .any((item) => Project.fromJson(item['project']).projectId == project.projectId);
              if (isFavorite) {
                myFavoriteProjects.add(project);
              }
            }
          });
        }
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
    final studentProfile = _prefs.getString('student_profile');
    final studentId = jsonDecode(studentProfile!)['id'];

    try {
      final response = await _httpClient.patch(
        Uri.parse('$uriBase/api/favoriteProject/$studentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
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
        .where((favoriteProject) => favoriteProject.projectId == project.projectId)
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

  void handleSearchSubmitted(String query) async {
    searchQuery = query;
    // print(query);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchListScreen(
          searchQuery: searchQuery,
        ),
      ),
    );
    print(result);
    if (result != null && result is bool && result) {
      setState(() {
        isLoading = true;
      });
      if (mounted) Navigator.pop(context, true);
      _loadScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AuthAppBar(
        canBack: false,
        onRoleChanged: (result) {
          setState(() {
            isLoading = true;
          });
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FavoriteProjectsScreen(
                                favoriteList: myFavoriteProjects,
                                onRemoveProject: updateFavoriteProject,
                              ),
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              isLoading = true;
                            });
                            _loadScreen();
                          }
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.solidHeart,
                          color: Theme.of(context).colorScheme.onSurface,
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: allProject.length + (_loadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == allProject.length && _loadingMore) {
                          // Loading indicator for pagination
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 15.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          final project = allProject[index];
                          return CustomProjectItem(
                            project: project,
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProjectDetailScreen(
                                    project: project,
                                  ),
                                ),
                              );

                              if (result == true) {
                                setState(() {
                                  isLoading = true;
                                });
                                _loadScreen();
                              }
                            },
                            canFavorite: isStudent,
                            isFavorite: isFavoriteProject(project),
                            onFavoriteToggle: (isFavorite) {
                              updateFavoriteProject(project, isFavorite);
                            },
                          );
                        }
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
