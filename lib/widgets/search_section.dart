// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:issue_listing_app/providers/issue_provider.dart';
import 'package:provider/provider.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({
    super.key,
  });

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  FocusNode searchFocus = FocusNode();

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    IssueProvider issueProvider = context.watch<IssueProvider>();
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: issueProvider.searchList.isNotEmpty ? 115 : 90,
      ),
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Issues List',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextFormField(
            controller: _controller,
            focusNode: searchFocus,
            decoration: InputDecoration(
              hintText: 'Search here',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 0,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 5, top: 5),
                child: Icon(
                  CupertinoIcons.search,
                  size: 26,
                ),
              ),
            ),
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (value) async {
              FocusScope.of(context).unfocus();

              if (_controller.text.isNotEmpty) {
                await issueProvider.addSearch(_controller.text);
                await issueProvider.clearIssueList();
                await issueProvider.getIssuesData();
              }
            },
          ),
          // Container(
          //   color: Colors.red,
          //   height: 20,
          //   width: double.infinity,
          // )
          Container(
            padding: EdgeInsets.only(top: 4),
            height: issueProvider.searchList.isNotEmpty ? 28 : 0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: issueProvider.searchList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () => issueProvider
                      .deleteSearch(issueProvider.searchList[index]),
                  child: Container(
                    padding: EdgeInsets.only(left: 6, right: 2),
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 223, 222, 222),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 22,
                    // width: 30,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          issueProvider.searchList[index],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.close,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
