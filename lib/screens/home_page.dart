// ignore_for_file: prefer_const_constructors

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
  bool? _hasData;

  @override
  void initState() {
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller!.addListener(_scrollListener);
    _fetchArticles();
    _hasData = true;
    super.initState();
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
        child: SingleChildScrollView(
          controller: _controller,
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
                      bottom: index == issueProvider.issueList.length ? 10 : 5,
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
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                issueProvider.issueList[index].title ?? '',
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
                                issueProvider.issueList[index].body ?? '',
                              ),
                              Visibility(
                                visible: issueProvider
                                    .issueList[index].labels!.isNotEmpty,
                                child: ListView.builder(
                                  itemCount: issueProvider
                                      .issueList[index].labels!.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Chip(label: Text('data'));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('MM/dd/yyyy').format(
                                  issueProvider.issueList[index].createdAt!,
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
                                issueProvider
                                        .issueList[index].authorAssociation ??
                                    '',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
