import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/components/customprojectitem.dart';
import 'package:studenthub/components/bottomsheet_customsearchbar.dart';
import 'package:studenthub/components/radiolist_projectlength.dart';
import 'package:studenthub/components/textfield/textfield_label_v2.dart';
import 'package:studenthub/config/config.dart';
import 'package:studenthub/enums/project_scope.dart';
import 'package:studenthub/models/company_model.dart';
import 'package:studenthub/screens/shared/project_detail_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:studenthub/utils/font.dart';

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
  final TextEditingController _studentsNeededController = TextEditingController();
  final TextEditingController _proposalsController = TextEditingController();
  late http.Client _httpClient;
  late ScrollController _scrollController;
  late int _page;
  late int _perPage;
  bool _loadingMore = false;
  bool isStudent = false;
  bool isLoading = true;

  @override
  void dispose() {
    // _isMounted = false;
    _httpClient.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _searchQuery = widget.searchQuery;
    });
    _page = 2;
    _perPage = 10;
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _httpClient = http.Client();
    // Initialize filteredProjects with all projects initially
    _loadScreen(_searchQuery);
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

  Future<void> _loadScreen(String searchText) async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final role = _prefs.getInt('current_role');
      final studentProfile = _prefs.getString('student_profile');
      final token = _prefs.getString('token');

      if (role == 0) {
        if (studentProfile == 'null') {
          if (mounted) Navigator.pushReplacementNamed(context, '/student');
          return; // Stop execution if navigating away
        }
        setState(() {
          isStudent = true;
        });
      } else {
        setState(() {
          isStudent = false;
        });
      }
      _searchQuery = searchText;
      await _loadFilteredProject(token!);

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

  void clearFilter() {
    setState(() {
      _studentsNeededController.clear();
      _proposalsController.clear();
      selectedProjectScope = null;
      _searchQuery = '';
      _loadScreen(_searchQuery);
      Navigator.pop(context);
    });
  }

  Future<void> _loadFilteredProject(String token) async {
    Map<String, dynamic> queryParams = {
      if (_searchQuery.isNotEmpty) 'title': _searchQuery,
      if (selectedProjectScope != null) 'projectScopeFlag': selectedProjectScope!.index.toString(),
      if (_studentsNeededController.text.isNotEmpty)
        'numberOfStudents': _studentsNeededController.text.trim(),
      if (_proposalsController.text.isNotEmpty)
        'proposalsLessThan': _proposalsController.text.trim(),
    };
    try {
      final uri = Uri.https('api.studenthub.dev', '/api/project', queryParams);
      final response = await _httpClient.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (mounted) {
        if (response.statusCode == 200) {
          final List<dynamic> responseData = jsonDecode(response.body)['result'];
          setState(() {
            filteredProjects = responseData.map((json) => Project.fromJson(json)).toList();
          });
        } else {
          print('Error: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _loadNext() async {
    Map<String, dynamic> queryParams = {
      if (_searchQuery.isNotEmpty) 'title': _searchQuery,
      if (selectedProjectScope != null) 'projectScopeFlag': selectedProjectScope!.index.toString(),
      if (_studentsNeededController.text.isNotEmpty)
        'numberOfStudents': _studentsNeededController.text.trim(),
      if (_proposalsController.text.isNotEmpty)
        'proposalsLessThan': _proposalsController.text.trim(),
      'page': _page.toString(),
      'perPage': _perPage.toString(),
    };
    try {
      _prefs = await SharedPreferences.getInstance();
      final token = _prefs.getString('token');
      final uri = Uri.https('api.studenthub.dev', '/api/project', queryParams);
      final response = await _httpClient.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> responseData = jsonDecode(response.body)['result'];
        print(responseData);
        if (mounted) {
          setState(() {
            filteredProjects.addAll(responseData.map((json) => Project.fromJson(json)).toList());
            _page++;
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
            for (var project in filteredProjects) {
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
      final response = await http.patch(
        Uri.parse('$uriBase/api/favoriteProject/$studentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Specify the content type as JSON
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

  bool isFavoriteProject(Project project) {
    return myFavoriteProjects
        .where((favoriteProject) => favoriteProject.projectId == project.projectId)
        .isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthAppBar(
        canBack: true,
        title: 'Project Search',
        onRoleChanged: (result) {
          setState(() {
            isLoading = true;
          });
          _loadScreen('');
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
                    () => _searchQuery = query.toLowerCase(),
                  ),
                  onSubmitted: (query) => {
                    Navigator.pop(context, true),
                    setState(() {
                      isLoading = true;
                    }),
                    _loadScreen(query),
                  },
                  searchText: _searchQuery,
                ),
                Container(
                  width: 50,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            final double screenHeight = MediaQuery.of(context).size.height;
                            final double appBarHeight = AppBar().preferredSize.height;
                            final double bottomSheetHeight = screenHeight - (appBarHeight * 3);
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
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context).colorScheme.surface,
                                            border: Border.all(
                                              color: Theme.of(context).colorScheme.onSurface,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Center(
                                              child: Icon(
                                                Icons.close,
                                                size: 18,
                                                color: Theme.of(context).colorScheme.onSurface,
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
                                    Text(
                                      'Filter by',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Divider(
                                      height: 1.0,
                                      thickness: 2.0,
                                      color: Theme.of(context).colorScheme.onSurface,
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
                                    Text(
                                      'Project length',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).colorScheme.onSurface),
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
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 180,
                                          height: 40,
                                          padding: const EdgeInsets.all(0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Theme.of(context).colorScheme.onSurface,
                                                width: 2.0),
                                            color: Theme.of(context).colorScheme.surface,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context).colorScheme.shadow,
                                                offset: const Offset(2, 3),
                                              ),
                                            ],
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              clearFilter();
                                            },
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                                const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.zero),
                                              ),
                                            ),
                                            child: Text(
                                              'Clear filters',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context).colorScheme.onSurface,
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
                                                color: Theme.of(context).colorScheme.onSurface,
                                                width: 2.0),
                                            color: Theme.of(context).colorScheme.surface,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context).colorScheme.shadow,
                                                offset: const Offset(2, 3),
                                              ),
                                            ],
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              _loadScreen('');
                                              Navigator.pop(context);
                                            },
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                                const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.zero),
                                              ),
                                            ),
                                            child: Text(
                                              'Apply',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context).colorScheme.onSurface,
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
                      icon: Icon(Icons.filter_alt,
                          size: 30, color: Theme.of(context).colorScheme.onSurface),
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredProjects.isEmpty
                      ? Center(
                          child: Text(
                            'Could Not Find',
                            style: TextStyle(
                              fontSize: AppFonts.h2FontSize,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: filteredProjects.length + (_loadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == filteredProjects.length && _loadingMore) {
                              // Loading indicator for pagination
                              return const Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            } else {
                              final project = filteredProjects[index];
                              return CustomProjectItem(
                                project: project,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProjectDetailScreen(
                                        project: project,
                                      ),
                                    ),
                                  );
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
