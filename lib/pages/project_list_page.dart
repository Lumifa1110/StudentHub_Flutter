import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/components/customprojectitem.dart';
import 'package:studenthub/components/searchbar.dart';
import 'package:studenthub/utils/colors.dart';

import 'package:studenthub/utils/mock_data.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({Key? key}) : super(key: key);

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  String searchQuery = '';

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
                        onPressed: () {},
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
                        // Handle onTap action for the project
                        // For example, navigate to a project detail page
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
