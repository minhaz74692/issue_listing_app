import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:issue_listing_app/data/models/issue_model.dart';
import 'package:issue_listing_app/data/repository/issue_data_repo.dart';

class IssueProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading() {
    _isLoading = !isLoading;
    notifyListeners();
  }

  int _page = 1;
  int get page => _page;

  Future setPage() async {
    _page += 1;
    notifyListeners();
    return null;
  }

  resetPage() {
    _page = 1;
    notifyListeners();
  }

  int _issueCount = 10;
  int get issueCount => _issueCount;

  List<IssueModel> _issueList = [];
  List<IssueModel> get issueList => _issueList;

  Future clearIssueList() async {
    _issueList.clear();
    notifyListeners();
    return null;
  }

  Future getIssuesData() async {
    setLoading();
    var response = await IssueDataRepo.fetchIssueData(
      'https://api.github.com/repos/octocat/Spoon-Knife/issues?page=$_page&per_page=$_issueCount',
    );
    var responseBody = response.body;
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(responseBody);
      for (var i = 0; i < jsonData.length; i++) {
        _issueList.add(IssueModel.fromJson(jsonData[i]));
      }
    } else {
      Fluttertoast.showToast(
          msg:
              'Date Loading Error: ${response.statusCode} ${jsonDecode(responseBody)['message'] ?? ''}');
    }
    debugPrint(_issueList.toString());
    notifyListeners();
    setLoading();
    return _issueList;
  }
}
