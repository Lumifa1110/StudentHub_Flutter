import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/utils/font.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final String searchText;

  const CustomSearchBar({
    Key? key,
    required this.onChanged,
    required this.onSubmitted,
    this.searchText = '',
  }) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  late List<String> history = [];

  Future<void> saveSearchHistory(String searchText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('searchHistory') ?? [];

    if (history.contains(searchText) || searchText.isEmpty) {
      // If search text already exists, do nothing
      return;
    }

    // Add the new search text to the beginning of the list
    history.insert(0, searchText);

    // Ensure the length of history does not exceed 10
    if (history.length > 10) {
      // Remove the last element if the length exceeds 10
      history.removeLast();
    }

    // Save the updated search history to SharedPreferences
    prefs.setStringList('searchHistory', history);
  }

  void _onSubmitted(String searchText) {
    print(searchText);
    saveSearchHistory(searchText);
    widget.onSubmitted(searchText);
  }

  Future<void> getHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    history = prefs.getStringList('searchHistory') ?? [];
  }

  Future<void> showSearchHistory(BuildContext context) async {
    await getHistory();
    if (context.mounted) {
      showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          final double screenHeight = MediaQuery.of(context).size.height;
          final double appBarHeight = AppBar().preferredSize.height;
          final double bottomSheetHeight = screenHeight - appBarHeight - 40;
          return Container(
            height: bottomSheetHeight,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 36,
                      width: 36,
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
                          _searchController.clear();
                          Navigator.pop(context, true);
                        },
                        icon: Icon(
                          Icons.close,
                          size: 18,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 13),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Theme.of(context).colorScheme.onSurface, width: 2.0),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      Expanded(
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          controller: _searchController,
                          onChanged: widget.onChanged,
                          onSubmitted: _onSubmitted,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search for projects',
                            hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: AppFonts.h2FontSize,
                                fontWeight: FontWeight.w400),
                            border: InputBorder.none,
                            isCollapsed: true,
                          ),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            // Clear the text when the 'x' button is pressed
                            _searchController.clear();
                            widget.onChanged('');
                          },
                        ),
                    ],
                  ),
                ),
                //Display search history results here
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: ListTile(
                          title: Text(
                            history[index],
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: AppFonts.h2FontSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onTap: () {
                            _searchController.text = history[index];
                            _onSubmitted(_searchController.text);
                            // Navigator.pop(context, true); // Close the bottom sheet
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
    // Load search history before displaying
  }

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchText;
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showSearchHistory(context);
      },
      child: Container(
        width: 325,
        height: 45,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2.0),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 10),
            Text(
              'Search for projects',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
