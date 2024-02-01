// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:issue_listing_app/providers/issue_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController? _controller;
  int page = 1;

  @override
  void initState() {
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller!.addListener(_scrollListener);

    super.initState();
    _fetchArticles();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  Future _fetchArticles() async {
    IssueProvider issueProvider = context.read<IssueProvider>();
    Future.microtask(() async {
      await issueProvider.resetPage();
      await issueProvider.clearIssueList();
      await issueProvider.getIssuesData();
    });
  }

  _scrollListener() async {
    IssueProvider issueProvider = context.read<IssueProvider>();
    var isEnd = _controller!.offset >= _controller!.position.maxScrollExtent &&
        !_controller!.position.outOfRange;
    if (isEnd && issueProvider.issueList.isNotEmpty) {
      await issueProvider.setPage().then(
            (value) => issueProvider.getIssuesData().then(
                  (_) {},
                ),
          );
    }
  }

  Future _onRefresh() async {
    IssueProvider issueProvider = context.read<IssueProvider>();
    await issueProvider.clearIssueList();
    await issueProvider.getIssuesData();
  }

  @override
  Widget build(BuildContext context) {
    IssueProvider issueProvider = context.watch<IssueProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: Text(
          'Issues',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _controller,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 90),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: issueProvider.issueList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(
                                top: 5,
                                bottom: index == issueProvider.issueList.length
                                    ? 10
                                    : 5,
                                left: 20,
                                right: 20,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                  color: Colors.grey,
                                )),
                                // borderRadius: BorderRadius.circular(10),
                              ),
                              width: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${index + 1}. ${issueProvider.issueList[index].title ?? ''}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          issueProvider.issueList[index].body ??
                                              '',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Visibility(
                                          visible: issueProvider
                                              .issueList[index]
                                              .labels!
                                              .isNotEmpty,
                                          child: ListView.builder(
                                            itemCount: issueProvider
                                                .issueList[index]
                                                .labels!
                                                .length,
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Chip(label: Text('data'));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat('MM/dd/yyyy').format(
                                            issueProvider
                                                .issueList[index].createdAt!,
                                          ),
                                          style: TextStyle(
                                            fontSize: 16,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          issueProvider.issueList[index].user!
                                                  .login ??
                                              '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Visibility(
                          visible: issueProvider.isLoading,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.grey,
                                strokeWidth: 3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(maxHeight: 90),
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Issues List',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 5, top: 5),
                        child: Icon(
                          CupertinoIcons.search,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
