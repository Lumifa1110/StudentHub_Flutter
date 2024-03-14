import 'package:flutter/material.dart';
import 'package:studenthub/utils/colors.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String z) onChanged;

  const CustomSearchBar({Key? key, required this.onChanged}) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            final double screenHeight = MediaQuery.of(context).size.height;
            final double appBarHeight = AppBar().preferredSize.height;
            final double bottomSheetHeight = screenHeight - appBarHeight - 50;
            return Container(
              // Customize the bottom sheet content as needed
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
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 45,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 13),
                    decoration: BoxDecoration(
                      color: whiteTextColor,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: blackTextColor, width: 2.0), // Add border
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search), // Prefix icon
                        Expanded(
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            controller: _searchController,
                            onChanged: widget.onChanged,
                            style: const TextStyle(
                              color: blackTextColor,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Search for projects',
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
                  // Add your search results here
                ],
              ),
            );
          },
        );
      },
      child: Container(
        width: 325,
        height: 45,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: whiteTextColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: blackTextColor, width: 2.0),
        ),
        child: const Row(
          children: [
            Icon(Icons.search),
            SizedBox(width: 10),
            Text(
              'Search for projects',
              style: TextStyle(color: blackTextColor, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
